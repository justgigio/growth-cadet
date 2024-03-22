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
require 'rails_helper'

RSpec.describe Dns::Address, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
