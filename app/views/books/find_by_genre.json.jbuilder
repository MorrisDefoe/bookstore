json.books @books do |book|
  json.author book.author
  json.title book.title
  json.genre book.genre
end