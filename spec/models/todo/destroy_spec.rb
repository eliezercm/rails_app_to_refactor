RSpec.describe Todo::Destroy do
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

    context 'with a existent todo id' do
      it 'delete todo and returns success' do
        Todo.delete_all

        todo_id = 1
        user.todos.create(title: 'task #1')

        result = described_class.call(id: todo_id, current_user: user)

        expect(result).to be_a_success
        expect(user.todos.count).to eq(0)

        expect(result.data[:todo]['title']).to eq('task #1')
        expect(result.data[:todo]['id']).to eq(1)
      end
    end
  end
end