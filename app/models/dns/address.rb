# == Schema Information
#
# Table name: dns_addresses
#
#  id         :bigint           not null, primary key
#  ipv4       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_dns_addresses_on_ipv4  (ipv4)
#
require 'resolv'

class Dns::Address < ApplicationRecord
  validates :ipv4, presence: true, format: { with: Resolv::IPv4::Regex, message: "Invalid IPv4 format" }

  has_and_belongs_to_many :records, join_table: :dns_addresses_records,
                          foreign_key: :dns_address_id, association_foreign_key: :dns_record_id
end
