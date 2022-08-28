class User::Register < Micro::Case
  attributes :params

  def call!
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)

    password = user_params[:password].to_s.strip
    password_confirmation = user_params[:password_confirmation].to_s.strip

    errors = {}
    errors[:password] = ["can't be blank"] if password.blank?
    errors[:password_confirmation] = ["can't be blank"] if password_confirmation.blank?

    if errors.present?
      Failure :blank_password_or_confirmation, result: { user: errors }
    else
      if password != password_confirmation
        Failure :wrong_password_confirmation, result: { user: { password_confirmation: ["doesn't match password"] } }
      else
        password_digest = Digest::SHA256.hexdigest(password)

        user = User.new(
          name: user_params[:name],
          email: user_params[:email],
          token: SecureRandom.uuid,
          password_digest: password_digest
        )

        if user.save
          Success result: { user: user.as_json(only: [:id, :name, :token]) }
        else
          Failure :invalid_parameters, result: { user: user.errors.as_json }
        end
      end
    end

  rescue  ActionController::ParameterMissing => e
    Failure :missing_parameter, result: { user: e.message }
  end
end