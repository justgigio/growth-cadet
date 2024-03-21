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
require 'rails_helper'

RSpec.describe Dns::Record, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
