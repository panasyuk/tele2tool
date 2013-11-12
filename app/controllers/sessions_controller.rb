class SessionsController < ApplicationController

  def new
    # генерируем случайный state
    srand
    session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
    # и URL страницы авторизации
    @vk_url = VkontakteApi.authorization_url(scope: [:friends, :offline], state: session[:state])
  end

  def callback
    # проверка state
    if session[:state].present? && session[:state] != params[:state]
      redirect_to root_url, alert: 'Ошибка авторизации, попробуйте войти еще раз.' and return
    end

    # получение токена
    @vk = VkontakteApi.authorize(code: params[:code])
    # и сохранение его в сессии
    session[:token] = @vk.token
    # также сохраним id пользователя на ВКонтакте - он тоже пригодится
    session[:vk_id] = @vk.user_id

    redirect_to root_url
  end

  def destroy
    session[:token] = nil
    session[:vk_id] = nil

    redirect_to root_url
  end

end
