class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    #sessionhelperのメソッドを全てのクラス(＝applicationクラスを継承しているクラスで使うため)
    include SessionsHelper

    private 

    def logged_in_user
        unless logged_in?
          store_location 
          flash[:danger] = "Please log in."
          redirect_to root_url
        end
      end
end
