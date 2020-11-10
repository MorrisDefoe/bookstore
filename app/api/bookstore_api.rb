module BookstoreApi
  class ApiV1 < Grape::API
    prefix :api
    version 'v2'
    format :json

    resource :users do
      # # api/v2/users/active
      desc 'Show list of active users. Users who have one ore more orders'
      get 'active' do
        users = UsersOrder.select(:user_id).distinct
        users.as_json(only: [:user_id], include: [{ user: { only: %i[email first_name address] } }])
      end

      # api/v2/user/:id
      desc 'Get user`s info by id`'
      params do
        requires :id, type: Integer, desc: 'user`s id`'
      end
      get do
        user = User.find_by(id: params[:id])
        if user.present?
          user.as_json(only: %i[email first_name last_name address])
        else
          { error: 'User not found' }
        end
      end

      # api/v2/users/create
      desc 'Create a new user'
      params do
        requires :email, type: String, desc: 'user`s email`'
        requires :first_name, type: String, desc: 'user`s first_name`'
        requires :last_name, type: String, desc: 'user`s last_name`'
        requires :address, type: String, desc: 'user`s address`'
      end
      post 'create' do
        user = User.new(email: params[:email],first_name: params[:first_name], last_name: params[:last_name], address: params[:address])
        if user.save
          { message: 'User has been created' }
        else
          { error: 'User has not been created' }
        end
      end

      desc 'change user`s status to admin'
      params do
        requires :email, type: String, desc: 'user`s email'
      end
      put 'makeAdmin' do
        user = User.find_by(email: params[:email])
        user.status=('admin')
        user.save
        { message: 'user`s status changed to admin' }
      end

    end

    resources :books do
      # api/v2/books/addBook
      desc 'Add book to the store. Only admin has rights to add a book'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :author, type: String, desc: 'author of a book'
        requires :title, type: String, desc: 'book title'
        requires :genre, type: String, desc: 'genre of a book'
        optional :quantity, type: Integer, desc: 'quantity of  book'
      end
      post 'addBook' do
        user = User.find_by(email: params[:email])
        if user.present?
          book = Book.find_by(author: params[:author], title: params[:title], genre: params[:genre])
          if book.present?
            book.change_books_quantity(params[:quantity].nil? ? 1 : params[:quantity])
            { message: 'Book added' }
          else
            book = Book.new(author: params[:author], title: params[:title], genre: params[:genre], quantity: params[:quantity].nil? ? 1 : params[:quantity])
            if book.save
              { message: 'Book added' }
            else
              { error: 'Book isn`t added' }
            end
          end
        else
          { message: 'You have no rights to add a book' }
        end
      end
      
      # api/v2/books/findByGenre
      desc 'Find books by id. There should be more then 0 books in store'
      params do
        requires :genre, type: String, desc: 'genre of a book'
      end
      get 'findByGenre' do
        books = Book.where('quantity > 0 and genre = ?', params[:genre])
        books
      end

      def book_params
        params.permit(:author, :title, :genre, :quantity).to_h
      end
    end

    resources :order do
      # api/v2/order/orderBook
      desc 'Order book'
      params do
        requires :email, type: String, desc: 'user`s email who orders a book`'
        requires :book_id, type: String, desc: 'id of a book'
      end
      post 'orderBook' do
        user = User.find_by(email: params[:email])
        book = Book.find_by(id: params[:book_id])
        if book.present? && user.present? && book.quantity.positive?
          UsersOrder.create(user_id: user.id, book_id: book.id)
          book.decrease_quantity
          { message: 'Order accepted' }

        else
          { error: 'Out of stock' }
        end
      end

      # # api/v2/order/showOrders
      desc 'Show all orders by status'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :status, type: String, desc: 'order status to find with. there are two types of order : "ordered", "delivered"'
      end
      get 'showOrders' do
        user = User.find_by(email: params[:email])
        if user.present?
          orders = UsersOrder.joins(:user, :book).where(status: params[:status]).order('created_at ASC')
          orders
        else
          { error: 'User not found' }
        end
      end

      # api/v2/order/changeStatus
      desc 'Change order status'
      params do
        requires :email, type: String, desc: 'user`s email to check access rights'
        requires :order_id, type: Integer, desc: ' Id of "ordered" status'
      end
      put 'changeStatus' do
        user = User.find_by(email: params[:email])
        if user.present?
          order = UsersOrder.find_by(id: params[:order_id])
          order.change_status
          render json: { message: 'Status changed to delivered' }, status: 200
        else
          render json: { error: 'User not found' }, status: 400
        end
      end
    end
    add_swagger_documentation
  end
end
