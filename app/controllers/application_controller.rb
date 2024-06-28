class ApplicationController < ActionController::Base
  
  # include Devise::Controllers::Helpers
  # 本来はdeviseインストール時に記述され、以下四点を定義します。
  # ・authenticate_user!	認証されているかどうかを確認し、認証されていない場合は認証失敗時のアクションを行う
  #  （例:トップページにリダイレクトする）
  # ・user_signed_in?	認証されているかどうか
  # ・current_user	認証されているモデルのインスタンスを取得する
  # ・user_session	認証用モデルのセッション情報にアクセスする
  # しかしこのinclude～が無くとも、deviseの中の定義方法によりcurrent_customerなどが使えてしまいます。

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_path
    when Customer
      root_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    my_page_customers_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :last_name, :first_name, :last_name_kana, :first_name_kana, :post_code, :address, :telephone_number] )
  end
end
