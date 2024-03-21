class CreateAddressRecordJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :dns_addresses, :dns_records
    add_index :dns_addresses_records, [:dns_address_id, :dns_record_id], :unique => true
  end
end
