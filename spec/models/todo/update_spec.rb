RSpec.describe Todo::Update do
  let(:user) { User.create(name: 'test', email: 'find@mail.com', token: SecureRandom.uuid, password_digest: Digest::SHA256.hexdigest('1234')) }

  context '.call' do

    context 'with invalid attributes' do
      context 'without todo param' do
        it 'returns a failure' do
          id = 321

          params = ActionController::Parameters.new()

          result = described_class.call(id: id, current_user: user, params: params)

          expect(result).to be_a_failure
          expect(result.type).to eq(:missing_parameter)
        end
      end
    end

    context 'with valid attributes' do
      context 'with a nonexistent todo id' do
        it 'returns a not found failure' do
          id = 321

          params = ActionController::Parameters.new(
            todo: {
              :title => 'task #1 modified',
              :due_at => '20220829'
            }
          )
  
          result = described_class.call(id: id, current_user: user, params: params)
  
          expect(result).to be_a_failure
          expect(result.type).to eq(:not_found)
        end
      end

      context 'with an existent todo id' do
        it 'updates todo and return success' do
          Todo.delete_all
          
          id = 1
          user.todos.create(title: 'task #1')

          params = ActionController::Parameters.new(
            todo: {
              :title => 'task #1 modified',
              :due_at => '20220829'
            }
          )
  
          result = described_class.call(id: id, current_user: user, params: params)
  
          expect(result).to be_a_success
  
          expect(result.data[:todo]['title']).to eq('task #1 modified')
          expect(result.data[:todo]['id']).to eq(1)
        end
      end
    end
  end
end