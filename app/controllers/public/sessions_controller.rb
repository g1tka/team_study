class Public::SessionsController < Devise::SessionsController
  before_action :customer_state, only: [:create]

  # before_action :authenticate_customer!, only: [:destroy]
  # before_action :configure_sign_in_params, only: [:create]


  private

  def customer_state
    # 【処理内容1】 入力されたemailからアカウントを1件取得
    customer = Customer.find_by(email: params[:customer][:email])
    # 【処理内容2】 アカウントを取得できなかった場合、このメソッドを終了する
    return if customer.nil?
    # 【処理内容3】 取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
    return unless customer.valid_password?(params[:customer][:password])

    # 【処理内容4】 アクティブでない会員に対する処理
    unless customer.is_active
      flash[:alert] = "このアカウントは退会済みです。"
      redirect_to new_customer_registration_path
    end
  end
end