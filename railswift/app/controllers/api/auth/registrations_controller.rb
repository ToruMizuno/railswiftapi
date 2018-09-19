module Api
  module Auth
    class RegistrationsController < DeviseTokenAuth::RegistrationsController

      private
      # nicnameやaddressなど新しく項目を付け足せる(マイグレーションでカラムを付け足さないと使えない)
      # DeviseTokenAuthでアカウント作成の際、必要となるパラメーターをここに定義
      # パラメーターを追加することもできる
      def sign_up_params
        params.permit(:user_name, :email, :password, :password_confirmation)
      end
      
      # def create
      #   build_resource(sign_up_params)
      #   resource.skip_confirmation!
      # end

      # DeviseTokenAuthでアカウント情報の中でupdateできるものを定義
      def account_update_params
        params.permit(:user_name, :email)
      end
    end
  end
end
