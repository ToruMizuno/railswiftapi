class AddColumnToPost < ActiveRecord::Migration[5.1]
  def change
    # 削除
    remove_column :api_posts, :user_id, :integer
    # 追加
    add_column :api_posts, :web_user_id, :integer
  end
end
