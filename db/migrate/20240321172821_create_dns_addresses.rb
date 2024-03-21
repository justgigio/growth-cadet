class CreateDnsAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_addresses do |t|
      t.string :ipv4

      t.timestamps
    end
    add_index :dns_addresses, :ipv4
  end
end
