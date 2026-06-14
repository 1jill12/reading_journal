class SettingsController < ApplicationController
  def edit; end

  def update
    if params[:section] == 'account'
      update_account
    else
      update_profile
    end
  end

  private

  def update_profile
    if current_user.update(profile_params)
      redirect_to settings_path, notice: "Settings saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_account
    if params[:user][:password].present?
      # Password change — requires current_password
      if current_user.update_with_password(account_params)
        bypass_sign_in(current_user)
        redirect_to settings_path, notice: "Account updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # Email-only change — requires current_password for confirmation
      if current_user.valid_password?(params[:user][:current_password])
        if current_user.update(email: params[:user][:email])
          redirect_to settings_path, notice: "Email updated."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        current_user.errors.add(:current_password, "is incorrect")
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def profile_params
    params.require(:user).permit(:username, :theme, :private_profile)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
