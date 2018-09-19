# json.array! @api_posts, partial: 'api_posts/api_post', as: :api_post
json.set! :posts do
  json.array! @api_posts, :id, :web_user_id, :post_image, :title_name
end