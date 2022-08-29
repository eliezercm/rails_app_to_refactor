class Todo::Update < Micro::Case
  attributes :params, :current_user, :id

  def call!
    todo_params = params.require(:todo).permit(:title, :due_at)

    todo = current_user.todos.find(id)
    
    todo.update(todo_params)

    if todo.valid?
      Success result: { todo: todo.serialize_as_json }
    else
      Failure :invalid_attributes, result: { todo: todo.errors.as_json }
    end

  rescue  ActionController::ParameterMissing => e
    Failure :missing_parameter, result: { todo: e.message }

  rescue ActiveRecord::RecordNotFound => e
    Failure :not_found, result: { todo: e.message }
  end
end