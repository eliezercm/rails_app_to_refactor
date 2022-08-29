class Todo::List < Micro::Case
  attributes :status, :current_user

  def call!
    todos =
      case status&.strip&.downcase
        when 'overdue' then Todo.overdue
        when 'completed' then Todo.completed
        when 'uncompleted' then Todo.uncompleted
        else Todo.all
      end

    todos_as_json = todos.where(user_id: current_user.id).map(&:serialize_as_json)

    Success result: { todos: todos_as_json }
  end
end