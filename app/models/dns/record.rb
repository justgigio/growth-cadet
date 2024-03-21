# == Schema Information
#
# Table name: dns_records
#
#  id         :bigint           not null, primary key
#  hostname   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_dns_records_on_hostname  (hostname)
#
class Dns::Record < ApplicationRecord
  validates :hostname, presence: true
  validate :validate_hostname

  has_and_belongs_to_many :addresses, join_table: :dns_addresses_records,
                          foreign_key: :dns_record_id, association_foreign_key: :dns_address_id

  def validate_hostname
    valid = true
    begin
      uri = URI::Generic.build(host: hostname)
      valid = false if uri.host != hostname
    rescue URI::InvalidComponentError
      valid = false
    end
    errors.add(:hostname, "Invalid hostname format") unless valid
  end
end
