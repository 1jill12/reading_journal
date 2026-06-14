class ThemesController < ApplicationController
  def update
    new_theme = current_user.theme == 'dark_academia' ? 'neutral' : 'dark_academia'
    current_user.update(theme: new_theme)
    redirect_back_or_to root_path
  end
end
