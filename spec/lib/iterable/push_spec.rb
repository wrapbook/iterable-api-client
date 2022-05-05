require 'spec_helper'

RSpec.describe Iterable::Push, :vcr do
  describe 'target' do
    let(:email) { 'user@example.com' }
    let(:campaign_id) { 4_183_582 }
    let(:res) { subject.target campaign_id, recipientEmail: email }

    context 'when bad campaign_id' do
      let(:campaign_id) { 42 }

      it 'is not successful' do
        expect(res).not_to be_success
      end

      it 'returns error code' do
        expect(res.code).to eq('400')
      end
    end

    context 'when successful' do
      it 'responds with success' do
        expect(res).to be_success
      end

      it 'returns success code' do
        expect(res.body['code']).to match(/success/i)
      end

      it 'returns msg' do
        expect(res.body['msg']).to match(/Campaign #{campaign_id} - Sent triggered message to: #{email}/)
      end
    end
  end
end
