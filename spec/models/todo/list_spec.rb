require 'date'

RSpec.describe Todo::List do
  let(:user) { User.create(name: 'test', email: 'test_list@mail.com', token: SecureRandom.uuid, password_digest: Digest::SHA256.hexdigest('1234')) }

  context '.call' do
    context 'without status filter' do
      it 'returns users todo list' do
        user.todos.create(title: 'task #1')
        user.todos.create(title: 'task #2')

        result = described_class.call(current_user: user)

        expect(result.data[:todos].count).to eq(2)
      end
    end

    context 'with completed status' do
      it 'returns completed todo list' do
        user.todos.create(title: 'task #1').complete!
        user.todos.create(title: 'task #2')
        user.todos.create(title: 'task #3').complete!

        status = 'completed'

        result = described_class.call(current_user: user, status: status)

        expect(result.data[:todos].count).to eq(2)
        expect(result.data[:todos][0]['title']).to eq('task #1')
        expect(result.data[:todos][1]['title']).to eq('task #3')
      end
    end

    context 'with uncompleted status' do
      it 'returns uncompleted todo list' do
        user.todos.create(title: 'task #2')
        user.todos.create(title: 'task #4').complete!
        user.todos.create(title: 'task #6')

        status = 'uncompleted'

        result = described_class.call(current_user: user, status: status)

        expect(result.data[:todos].count).to eq(2)
        expect(result.data[:todos][0]['title']).to eq('task #2')
        expect(result.data[:todos][1]['title']).to eq('task #6')
      end
    end

    context 'with overdue status' do
      it 'returns overdue todo list' do
        user.todos.create(title: 'task #1', due_at: Date.today.prev_day)
        user.todos.create(title: 'task #2', due_at: Date.today.next_month)
        user.todos.create(title: 'task #3', due_at: Date.today.prev_month)

        status = 'overdue'

        result = described_class.call(current_user: user, status: status)

        expect(result.data[:todos].count).to eq(2)
        expect(result.data[:todos][0]['title']).to eq('task #1')
        expect(result.data[:todos][1]['title']).to eq('task #3')
      end
    end
  end
end