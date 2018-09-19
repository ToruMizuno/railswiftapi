class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change

    # 削除
    remove_column :users, :username, :string
    # 追加
    add_column :users, :user_name, :string

  end
end
