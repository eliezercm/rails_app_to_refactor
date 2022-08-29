require 'date'

RSpec.describe Todo::Create do
  let(:user) { User.create(name: 'test', email: 'test_list@mail.com', token: SecureRandom.uuid, password_digest: Digest::SHA256.hexdigest('1234')) }

  context '.call' do
    context 'without todo param' do
      it 'returns a failure' do
        params = ActionController::Parameters.new()

        result = described_class.call(params: params, current_user: user)

        expect(result).to be_a_failure
        expect(result.type).to eq(:missing_parameter)
      end
    end

    context 'with invalid or blank attributes' do
      it 'returns a failure' do
        params = ActionController::Parameters.new(
          todo: {
            :foo => 'bar'
          }
        )

        result = described_class.call(params: params, current_user: user)

        expect(result).to be_a_failure
        expect(result.type).to eq(:invalid_attributes)
      end
    end

    context 'with valid attributes' do
      it 'returns a success with todo data' do
        params = ActionController::Parameters.new(
          todo: {
            :title => 'task #1'
          }
        )

        result = described_class.call(params: params, current_user: user)

        expect(result).to be_a_success
        expect(result.data[:todo].keys).to match_array(['id', 'title', 'due_at', 'completed_at', 'created_at', 'updated_at', 'status'])
      end
    end
  end
end