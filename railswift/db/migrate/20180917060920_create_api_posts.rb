class CreateApiPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :api_posts do |t|

      t.integer  :user_id
      t.string   :post_image# 画像保存はstring
      t.string  :title_name

      t.timestamps
    end
  end
end
