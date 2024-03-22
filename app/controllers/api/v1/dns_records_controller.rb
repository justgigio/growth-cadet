module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        # must come from config
        records_per_page = 10

        query_string = params.permit(:page, :included, :excluded)
        page = query_string.require(:page)

        addresses_query = Dns::Address.joins(:records)
        included = []
        excluded = []

        if query_string[:included].present?
          included = query_string[:included].split(',')
          addresses_query = addresses_query.where(records: { hostname: included })
          addresses_query = addresses_query.group('dns_addresses.id').having('COUNT(dns_addresses.id) >= ?', included.length)
        end

        if query_string[:excluded].present?
          excluded = query_string[:excluded].split(',')
          excluded_ids = Dns::Address.joins(:records).where(records: { hostname: excluded }).pluck(:id)
          addresses_query = addresses_query.where.not(dns_addresses: { id: excluded_ids })
        end

        count = addresses_query.distinct(:id).count.count

        limit = records_per_page
        offset = records_per_page * (page.to_i - 1)

        addresses_query = addresses_query.limit(limit).offset(offset)

        records = []

        addresses_query.each do |address|
          records << { id: address.id, ip_address: address.ipv4 }
        end

        records_query = Dns::Record.joins(:addresses).where(addresses: {id: addresses_query.pluck(:id)})

        related_hostnames = {}
        queried_hostnames = included + excluded

        records_query.each do |record|
          unless queried_hostnames.include?(record.hostname)
            related_hostnames[record.hostname] ||= { hostname: record.hostname, count: 0 }
            related_hostnames[record.hostname][:count] += 1
          end
        end

        json_response = {
          total_records: count,
          records: records,
          related_hostnames: related_hostnames.values
        }
        render json: json_response
      end

      # POST /dns_records
      def create
        payload = params.require(:dns_records).permit(:ip, hostnames_attributes: [:hostname])

        hostnames = payload[:hostnames_attributes].map { |hn| Dns::Record.find_or_initialize_by(*hn) }
        address = Dns::Address.find_or_initialize_by(ipv4: payload[:ip])

        if address.valid? and hostnames.all?(&:valid?)
          Dns::Address.transaction do
            address.records << hostnames.difference(address.records)
            address.save
          end

          json_response = {id: address.id}
          render json: json_response
        else
          json_response = {errors: {
            dns_records: address.errors,
            hostnames_attributes: hostnames.map(&:errors)
          }}
          render json: json_response, status: :unprocessable_entity
        end
      end
    end
  end
end
