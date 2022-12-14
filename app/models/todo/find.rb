class Todo::Find < Micro::Case
  attributes :id, :current_user

  def call!
    todo = current_user.todos.find(id)
  
    Success result: { todo: todo.serialize_as_json }
    
  rescue  ActiveRecord::RecordNotFound => e
    Failure :not_found, result: { todo: e.message }
  end
end