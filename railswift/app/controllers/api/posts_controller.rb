class Api::PostsController < ApplicationController
  # before_action :set_api_post, only: [:show, :update, :destroy]
  before_action :set_api_post, only: [:update, :destroy]
  before_action :authenticate_api_user!# 認証制限

  # GET /api/posts
  # GET /api/posts.json
  def index
    @api_posts = Api::Post.all
    render 'index', :formats => [:json], :handlers => [:jbuilder]
  end

  # GET /api/posts/1
  # GET /api/posts/1.json
  def show
    @api_post = Api::Post.find_by(id: params[:id])
    render 'show', :formats => [:json], :handlers => [:jbuilder]
  end

  # POST /api/posts
  # POST /api/posts.json
  def create

    @api_post = Api::Post.new(create_params)

    begin
      Api::Post.transaction do
        @api_post.save!# save!で例外を出力する
      end
      # 正常に動作した場合の処理

    rescue ActiveRecord::RecordInvalid => e
      # 例外が発生した場合の処理
      @api_post = e.record
      
    end

    # @api_post = Api::Post.new(api_post_params)

    # if @api_post.save
    #   render :show, status: :created, location: @api_post
    # else
    #   render json: @api_post.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /api/posts/1
  # PATCH/PUT /api/posts/1.json
  def update
    if @api_post.update(api_post_params)
      render :show, status: :ok, location: @api_post
    else
      render json: @api_post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/posts/1
  # DELETE /api/posts/1.json
  def destroy
    @api_post.destroy
  end

  # updateはこれを使う
  def update_post_id
    # post_idで1つのレコードを検索して取って来てもらう
    post = Api::Post.find_by(id: params[:id])
    # 更新
    post.update_attributes(update_params)
  end

  # web_user_idを使って自分のpostのみを、全て取得する
  def my_post_show_web_user_id
    # webuseridで引っかかる全てのレコードを検索して取って来てもらうようにする
    @api_posts = Api::Post.where(web_user_id: params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_post
      @api_post = Api::Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_post_params
      params.fetch(:api_post, {})
    end

    # createで使用する
    # postを新規作成した場合、これだけのカラムを作ってくれる
    def create_params
      params.permit(
        :web_user_id,
        :post_image,# 画像しか作成しない。更新でデータ保存する
        :title_name,
      )
    end

    # update_post_idで使用する
    # postを更新する場合、これだけのカラムを更新する
    def update_params
      params.permit(
        :web_user_id,
        :post_image,
        :title_name
       )
    end
end
