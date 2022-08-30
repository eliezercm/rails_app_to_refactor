RSpec.describe Todo::Uncomplete do
  let(:user) { User.create(name: 'test', email: 'find@mail.com', token: SecureRandom.uuid, password_digest: Digest::SHA256.hexdigest('1234')) }

  context '.call' do
    context 'with a nonexistent todo id' do
      it 'returns a not found failure' do
        id = 321

        result = described_class.call(id: id, current_user: user)

        expect(result).to be_a_failure
        expect(result.type).to eq(:not_found)
      end
    end

    context 'with an existent todo id' do
      it 'completes todo and return success' do
        Todo.delete_all
        
        id = 1
        
        todo = user.todos.create(title: 'task #1234')
        todo.completed_at = Time.current
        todo.save

        result = described_class.call(id: id, current_user: user)

        expect(result).to be_a_success

        expect(result.data[:todo]['id']).to eq(1)
        expect(result.data[:todo]['completed_at']).to be_nil
      end
    end
  end
end