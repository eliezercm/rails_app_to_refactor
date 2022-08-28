RSpec.describe User::Register do
  context '.call' do
    context 'with invalid user params' do
      context 'without user params' do
        it 'returns a failure' do
          params = ActionController::Parameters.new()
  
          result = described_class.call(params: params)
  
          expect(result).to be_a_failure
          expect(result.type).to be :missing_parameter
        end
      end

      context 'with empty user params' do
        it 'returns a failure' do
          params = ActionController::Parameters.new(user: { :foo => 'bar' })
  
          result = described_class.call(params: params)
  
          expect(result).to be_a_failure
          expect(result.type).to be :blank_password_or_confirmation
          
          expect(result.data[:user][:password]).to match_array ["can't be blank"]
          expect(result.data[:user][:password_confirmation]).to match_array ["can't be blank"]
        end
      end
  
      context 'with different password and password confirmation' do
        it 'returns a failure' do
          params = ActionController::Parameters.new(
            user: {
              :password => '1234',
              :password_confirmation => '123'
            }
          )
  
          result = described_class.call(params: params)
  
          expect(result).to be_a_failure
          expect(result.type).to be :wrong_password_confirmation
          expect(result.data[:user][:password_confirmation]).to match_array ["doesn't match password"]
        end
      end
  
      context 'with invalid name or email' do
        it 'returns a failure' do
          params = ActionController::Parameters.new(
            user: {
              :name => nil,
              :email => '123',
              :password => '1234',
              :password_confirmation => '1234'
            }
          )
  
          result = described_class.call(params: params)
  
          expect(result).to be_a_failure
          expect(result.type).to be :invalid_parameters
        end
      end
    end

    context 'with valid params' do
      it 'returns a success with a user as result' do
        params = ActionController::Parameters.new(
          user: {
            :name => 'tester',
            :email => '123@gmail.com',
            :password => '1234',
            :password_confirmation => '1234'
          }
        )

        result = described_class.call(params: params)

        expect(result).to be_a_success
        expect(result.data[:user].keys).to match_array(["id", "name", "token"])
      end
    end
  end
end