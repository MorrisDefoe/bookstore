json.orders @orders do |order|
  json.status order.status
  json.user do
    json.email order.user.email
    json.first_name order.user.first_name
    json.address order.user.address
  end
  json.book do
    json.author order.book.author
    json.title order.book.title
    json.genre order.book.genre
  end
end