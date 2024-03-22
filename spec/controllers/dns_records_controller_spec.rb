require 'rails_helper'

RSpec.describe Api::V1::DnsRecordsController, type: :controller do
  let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }

  let(:page) { 1 }

  let(:ip1) { '1.1.1.1' }
  let(:ip2) { '2.2.2.2' }
  let(:ip3) { '3.3.3.3' }
  let(:ip4) { '4.4.4.4' }
  let(:ip5) { '5.5.5.5' }
  let(:bad_ip1) { '1.1.1.256' }
  let(:bad_ip2) { 'noipatall' }
  let(:bad_ip3) { 'a.a.a.a' }
  let(:bad_ip4) { '1.1.1' }
  let(:bad_ip5) { '' }
  let(:lorem) { 'lorem.com' }
  let(:ipsum) { 'ipsum.com' }
  let(:dolor) { 'dolor.com' }
  let(:amet) { 'amet.com' }
  let(:sit) { 'sit.com' }
  let(:custom) { 'www.custom.com' }
  let(:bad_hostname1) { 'bad__host.com' }
  let(:bad_hostname2) { 'http://nouriallowed.com' }
  let(:bad_hostname3) { '' }

  let(:invalid_ip_message) { 'Invalid IPv4 format' }
  let(:invalid_hostname_message) { 'Invalid hostname format' }
  let(:cant_be_blank_message) { 'can\'t be blank' }

  let(:payload1) do
    {
      dns_records: {
        ip: ip1,
        hostnames_attributes: [
          {
            hostname: lorem
          },
          {
            hostname: ipsum
          },
          {
            hostname: dolor
          },
          {
            hostname: amet
          }
        ]
      }
    }.to_json
  end

  let(:payload2) do
    {
      dns_records: {
        ip: ip2,
        hostnames_attributes: [
          {
            hostname: ipsum
          }
        ]
      }
    }.to_json
  end

  let(:payload3) do
    {
      dns_records: {
        ip: ip3,
        hostnames_attributes: [
          {
            hostname: ipsum
          },
          {
            hostname: dolor
          },
          {
            hostname: amet
          }
        ]
      }
    }.to_json
  end

  let(:payload4) do
    {
      dns_records: {
        ip: ip4,
        hostnames_attributes: [
          {
            hostname: ipsum
          },
          {
            hostname: dolor
          },
          {
            hostname: sit
          },
          {
            hostname: amet
          }
        ]
      }
    }.to_json
  end

  let(:payload5) do
    {
      dns_records: {
        ip: ip5,
        hostnames_attributes: [
          {
            hostname: dolor
          },
          {
            hostname: sit
          }
        ]
      }
    }.to_json
  end

  let(:payload6) do
    {
      dns_records: {
        ip: ip1,
        hostnames_attributes: [
          {
            hostname: custom
          },
          {
            hostname: dolor
          },
          {
            hostname: sit
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload1) do
    {
      dns_records: {
        ip: bad_ip1,
        hostnames_attributes: [
          {
            hostname: custom
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload2) do
    {
      dns_records: {
        ip: bad_ip2,
        hostnames_attributes: [
          {
            hostname: lorem
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload3) do
    {
      dns_records: {
        ip: bad_ip3,
        hostnames_attributes: [
          {
            hostname: ipsum
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload4) do
    {
      dns_records: {
        ip: bad_ip4,
        hostnames_attributes: [
          {
            hostname: dolor
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload5) do
    {
      dns_records: {
        ip: bad_ip5,
        hostnames_attributes: [
          {
            hostname: amet
          }
        ]
      }
    }.to_json
  end

  let(:bad_payload6) do
    {
      dns_records: {
        ip: ip1,
        hostnames_attributes: [
          {
            hostname: custom
          },
          {
            hostname: bad_hostname1
          },
          {
            hostname: bad_hostname2
          },
          {
            hostname: bad_hostname3
          },
        ]
      }
    }.to_json
  end

  let(:invalid_ip_response) do
    {
      errors: {
        dns_records: {
          ipv4: [invalid_ip_message]
        },
        hostnames_attributes: [
          {}
        ]
      },
    }
  end

  describe '#index' do
    context 'with the required page param' do

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'

        post(:create, body: payload1, format: :json)
        post(:create, body: payload2, format: :json)
        post(:create, body: payload3, format: :json)
        post(:create, body: payload4, format: :json)
        post(:create, body: payload5, format: :json)
      end

      context 'without included and excluded optional params' do
        let(:expected_response) do
          {
            total_records: 5,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 2,
                ip_address: ip2
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              },
              {
                id: 5,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 4,
                hostname: ipsum
              },
              {
                count: 4,
                hostname: dolor
              },
              {
                count: 3,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns all dns records with all hostnames' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with the included optional param' do
        let(:included) { [ipsum, dolor].join(',') }

        let(:expected_response) do
          {
            total_records: 3,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 3,
                hostname: amet
              },
              {
                count: 1,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the included dns records without a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with the excluded optional param' do
        let(:excluded) { [lorem].join(',') }

        let(:expected_response) do
          {
            total_records: 4,
            records: [
              {
                id: 2,
                ip_address: ip2
              },
              {
                id: 3,
                ip_address: ip3
              },
              {
                id: 4,
                ip_address: ip4
              },
              {
                id: 5,
                ip_address: ip5
              }
            ],
            related_hostnames: [
              {
                count: 3,
                hostname: ipsum
              },
              {
                count: 3,
                hostname: dolor
              },
              {
                count: 2,
                hostname: amet
              },
              {
                count: 2,
                hostname: sit
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the non-excluded dns records with a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'with both included and excluded optional params' do
        let(:included) { [ipsum, dolor].join(',') }
        let(:excluded) { [sit].join(',') }

        let(:expected_response) do
          {
            total_records: 2,
            records: [
              {
                id: 1,
                ip_address: ip1
              },
              {
                id: 3,
                ip_address: ip3
              }
            ],
            related_hostnames: [
              {
                count: 1,
                hostname: lorem
              },
              {
                count: 2,
                hostname: amet
              }
            ]
          }
        end

        before :each do
          get(:index, params: { page: page, included: included, excluded: excluded })
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns only the non-excluded dns records with a related hostname' do
          expect(parsed_body).to eq expected_response
        end
      end
    end

    context 'without the required page param' do
      before :each do
        get(:index)
      end

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#create' do
    context 'with all good params' do

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'
      end

      context 'all new values' do
        let(:expected_response) do
          {
            id: 1,
          }
        end

        before :each do
          post(:create, body: payload1, format: :json)
        end

        it 'responds with valid response' do
          expect(response).to have_http_status(:created)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'repeated address with new hosts' do

        before do
          post(:create, body: payload1, format: :json)
        end

        context 'when creating' do
          let(:expected_response) do
            {
              id: 1,
            }
          end

          before :each do
            post(:create, body: payload6, format: :json)
          end

          it 'responds with valid response' do
            expect(response).to have_http_status(:created)
          end

          it 'returns same record id' do
            expect(parsed_body).to eq expected_response
          end
        end

        context 'when listing' do
          let(:included) { [lorem, ipsum, dolor, amet].join(',') }

          let(:expected_response) do
            {
              total_records: 1,
              records: [
                {
                  id: 1,
                  ip_address: ip1
                }
              ],
              related_hostnames: [
                {
                  count: 1,
                  hostname: custom
                },
                {
                  count: 1,
                  hostname: sit
                }
              ]
            }
          end

          before :each do
            post(:create, body: payload6, format: :json)
            get(:index, params: { page: page, included: included })
          end

          it 'responds with valid response' do
            expect(response).to have_http_status(:ok)
          end

          it 'returns only the dns records with the new related hostname' do
            expect(parsed_body).to eq expected_response
          end
        end
      end

    end

    context 'with bad params' do

      before do
        request.accept = 'application/json'
        request.content_type = 'application/json'
      end

      context 'out of range address' do
        let(:expected_response) { invalid_ip_response }

        before :each do
          post(:create, body: bad_payload1, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'address is any string' do
        let(:expected_response) { invalid_ip_response }

        before :each do
          post(:create, body: bad_payload2, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'address with chars instead of numbers' do
        let(:expected_response) { invalid_ip_response }

        before :each do
          post(:create, body: bad_payload3, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'address with just three groups' do
        let(:expected_response) { invalid_ip_response }

        before :each do
          post(:create, body: bad_payload4, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'address is empty' do
        let(:expected_response) do
          {
            errors: {
              dns_records: {
                ipv4: [cant_be_blank_message, invalid_ip_message]
              },
              hostnames_attributes: [
                {}
              ]
            },
          }
        end

        before :each do
          post(:create, body: bad_payload5, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end

      context 'bad hostnames' do
        let(:expected_response) do
          {
            errors: {
              dns_records: {},
              hostnames_attributes: [
                {},
                {
                  hostname: [invalid_hostname_message]
                },
                {
                  hostname: [invalid_hostname_message]
                },
                {
                  hostname: [cant_be_blank_message, invalid_hostname_message]
                },
              ]
            },
          }
        end

        before :each do
          post(:create, body: bad_payload6, format: :json)
        end

        it 'responds with error response' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns created record id' do
          expect(parsed_body).to eq expected_response
        end
      end
    end
  end
end
