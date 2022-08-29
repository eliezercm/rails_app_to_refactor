# frozen_string_literal: true

class Users::RegistrationsController < ApplicationController
  def create
    User::RegisterAndSendWelcomeEmail
      .call(params: params)
      .on_success {|result| render_json(201, user: result.data[:user])}
      .on_failure(:blank_password_or_confirmation) {|data| render_json(422, user: data[:user])}
      .on_failure(:wrong_password_confirmation) {|data| render_json(422, user: data[:user])}
      .on_failure(:invalid_attributes) {|data| render_json(422, user: data[:user])}
      .on_failure(:missing_parameter) {|data| render_json(422, user: data[:user])}
  end
end
