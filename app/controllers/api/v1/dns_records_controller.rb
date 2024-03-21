module Api
  module V1
    class DnsRecordsController < ApplicationController
      # GET /dns_records
      def index
        # TODO: Implement this action
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
