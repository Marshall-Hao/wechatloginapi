class Api::V1::UsersController < Api::V1::BaseController
    URL = "https://api.weixin.qq.com/sns/jscode2session".freeze
    skip_before_action :verify_authenticity_token
    before_action :find_user, only: [:show, :update]

    def index 
        @users = User.all
    end

    def show
    end

    def find_user
        @user = User.find(params[:id])
        p "=============="
        p @user
        p "=============="
    end

    def login
        p "=========start logging========"
        open_id  = wechat_user.fetch('openid')
        p open_id

        @user = User.find_or_create_by(open_id: open_id)

        render json: {
            userId: @user.id,
            currentUser: @user
        }
    end

    def update
        user_info = params[:userInfo]
        @user.nickname = user_info[:nickName]
        @user.gender = user_info[:gender].to_s
        @user.avatar = user_info[:avatarUrl]
        @user.save!
        render json: { currentUser: @user }
    end

    private

    def wechat_user
        wechat_params = {
            appId: Rails.application.credentials[:wx_app_id],
            secret: Rails.application.credentials[:wx_secret_id],
            js_code: params[:code],
            grant_type: "authorization_code"
        }

        @wechat_response ||= RestClient.get(URL, params: wechat_params)
        p "================"
        p @wechat_response.body
        p "================"
        @wechat_user ||= JSON.parse(@wechat_response.body)
    end
end
