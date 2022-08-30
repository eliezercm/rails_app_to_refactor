class Todo::Complete < Micro::Case
  attributes :current_user, :id

  def call!
    todo = current_user.todos.find(id)

    todo.completed_at = Time.current if todo.completed_at.nil?
    todo.save if todo.completed_at_changed?

    Success result: { todo: todo.serialize_as_json }

  rescue ActiveRecord::RecordNotFound => e
    Failure :not_found, result: { todo: e.message }
  end
end