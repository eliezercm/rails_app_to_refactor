RSpec.describe Todo::Find do
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
      it 'returns success with todo as result' do
        Todo.delete_all

        todo_id = 1
        user.todos.create(title: 'task #1')

        result = described_class.call(id: todo_id, current_user: user)

        expect(result).to be_a_success
        expect(result.data[:todo]).to have_attributes(:id => 1, title: 'task #1')
      end
    end
  end
end