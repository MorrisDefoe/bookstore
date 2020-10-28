module BookstoreApi
  class ApiV1 < Grape::API
    prefix :api
    version 'v1'
    format :json

    resource :users do
      # api/v1/users/active
      desc 'Show list of active users. Users who have one ore more orders'
      get 'active' do
        user = User.find_by_sql ['select * from users where id IN (select distinct user_id from users_orders)']
        user
      end

      # api/v1/users/:id
      desc 'Get user`s info by id`'
      params do
        requires :id, type: Integer, desc: 'user`s id`'
      end
      get do
        user = User.where(id: params[:id]).first
        if user != nil
           user
        else
          { error: 'User not found' }
        end
      end

      # api/v1/users/create
      desc 'Create a new user'
      params do
        requires :email, type: String, desc: 'user`s email`'
        requires :first_name, type: String, desc: 'user`s first_name`'
        requires :last_name, type: String, desc: 'user`s last_name`'
        requires :address, type: String, desc: 'user`s address`'
      end
      post 'create' do
        user = User.new(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], address: params[:address])
        user.save
        user
      end
    end

    resources :books do
      # api/v1/books/addBook
      desc 'Add book to the store. Only admin has rights to add a book'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :author, type: String, desc: 'author of a book'
        requires :title, type: String, desc: 'book title'
        requires :genre, type: String, desc: 'genre of a book'
        requires :quantity, type: Integer, desc: 'quantity of  book'
      end
      post 'addBook' do
        user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
        if user.count != 0
          books = Book.find_by_sql ['select * from books where author = ? and title = ? and genre = ?', params[:author], params[:title], params[:genre]]
          if !books.empty?
            books[0].change_books_quantity(params[:quantity])
          else
            book = Book.new(author: params[:author], title: params[:title], genre: params[:genre], quantity: params[:quantity] != nil ? params[:quantity] : 1)
            book.save
            { message: 'Book added' }
          end
        else
          { message: 'You have no rights to add a book' }
        end
      end
      # api/v1/books/findByGenre
      desc 'Find books by id. There should be more then 0 books in store'
      params do
        requires :genre, type: String, desc: 'genre of a book'
      end
      get 'findByGenre' do
        book = Book.find_by_sql ['select * from books where genre LIKE ? and books.quantity > 0', params[:genre]]
        book
      end
    end

    resources :order do
      # api/v1/order/orderBook
      desc 'Order book'
      params do
        requires :email, type: String, desc: 'user`s email who orders a book`'
        requires :book_id, type: String, desc: 'id of a book'
      end
      post 'orderBook' do
        begin
          user = User.where('email = ?', params[:email])[0].id_in_database
          book = Book.where('id = ?', params[:book_id])
          if !book.nil? && !user.nil? && book[0].quantity_in_database > 0
            UsersOrder.create(user_id: user, book_id: book[0].id_in_database)
            book[0].decrement

            { message: 'Order accepted' }

          else
            { error: 'Out of stock' }
          end
        rescue NoMethodError
          { error: 'Wrong data' }
        end
      end

      # api/v1/order/showOrders
      desc 'Show all orders by status'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :status, type: String, desc: 'order status to find with. there are two types of order : "ordered", "delivered"'
      end
      get 'showOrders' do
        user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
        if user.count != 0
          orders = UsersOrder.find_by_sql ["select users_orders.id, users.email, books.title, books.genre from users_orders
      LEFT JOIN users ON users_orders.user_id = users.id
      LEFT JOIN books ON users_orders.book_id = books.id where users_orders.status = ? ORDER BY users_orders.created_at ASC", params[:status]]
        end
      end

      # api/v1/order/changeStatus
      desc 'Change order status'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :order_id, type: Integer, desc: ' Id of "ordered" status'
      end
      put 'changeStatus' do
        user = User.find_by_sql ["select * from users where email = ? and users.status = 'admin'", params[:email]]
        if user.count != 0
          order = UsersOrder.where('id = ?', params[:order_id])
          order[0].change_status
          { message: 'Status changed to delivered' }
        end
      end
    end
    add_swagger_documentation
  end
end
