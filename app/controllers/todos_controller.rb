# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :authenticate_user

  before_action :set_todo, only: %i[show destroy update complete uncomplete]

  rescue_from ActiveRecord::RecordNotFound do
    render_json(404, todo: { id: 'not found' })
  end

  def index
    Todo::List
      .call(status: params[:status], current_user: current_user)
      .on_success {|result| render_json(200, todos: result.data[:todos])}
  end

  def create
    Todo::Create
      .call(params: params, current_user: current_user)
      .on_success {|result| render_json(201, todo: result.data[:todo])}
      .on_failure(:missing_parameter) {|data| render_json(422, todo: data[:todo])}
      .on_failure(:invalid_attributes) {|data| render_json(422, todo: data[:todo])}
  end

  def show
    Todo::Find
      .call(id: params[:id], current_user: current_user)
      .on_success {|result| render_json(200, todo: result.data[:todo])}
      .on_failure(:not_found) {|data| render_json(404, todo: data[:todo])}
  end

  def destroy
    Todo::Destroy
      .call(id: params[:id], current_user: current_user)
      .on_success {|result| render_json(200, todo: result.data[:todo])}
      .on_failure(:not_found) {|data| render_json(404, todo: data[:todo])}
  end

  def update
    Todo::Update
      .call(params: params, current_user: current_user, id: params[:id])
      .on_success {|result| render_json(200, todo: result.data[:todo])}
      .on_failure(:missing_parameter) {|data| render_json(422, todo: data[:todo])}
      .on_failure(:invalid_attributes) {|data| render_json(422, todo: data[:todo])}
  end

  def complete
    Todo::Complete
      .call(id: params[:id], current_user: current_user)
      .on_success {|result| render_json(200, todo: result.data[:todo])}
      .on_failure(:not_found) {|data| render_json(404, todo: data[:todo])}
  end

  def uncomplete
    @todo.uncomplete!

    render_json(200, todo: @todo.serialize_as_json)
  end

  private

    def todo_params
      params.require(:todo).permit(:title, :due_at)
    end

    def set_todo
      @todo = current_user.todos.find(params[:id])
    end
end
