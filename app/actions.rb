helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    # @current_user = User.find_by(id: session[:user_id])
    erb(:index)
end

get '/signup' do     # if a user navigates to the path "/signup",
  @user = User.new   # setup empty @user object
  erb(:signup)       # render "app/views/signup.erb"
end

get '/login' do    # when a GET request comes into /login
  erb(:login)      # render app/views/login.erb
end

get '/logout' do
    session[:user_id] = nil
    # "Logout successful!"
    redirect to('/')
end

post '/signup' do
    # "Form submitted!"
    # params.to_s
    
    # grab user input values from params
    email      = params[:email]
    avatar_url = params[:avatar_url]
    username   = params[:username]
    password   = params[:password]

    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

    if @user.save
        # "User #{username} saved!"
        redirect to('/login')
    else
        erb(:signup)
    end
end

# post '/login' do    # when a GET request comes into /login
#     # params.to_s  # just display the params for now to make sure it's working
#     username = params[:username]
#     password = params[:password]

#     # 1. find user by username
#     user = User.find_by(username: username)

#     # 2. if that user exists
#     if user

#         # check if that user's password matches the password input
#         # 3. if the passwords match
#         if user.password == password

#             # login (more to come here)
#             "Success!"
#         else
#             "Password doesn't match"
#         end
#     else
#         "No user"
#     end
# end

post '/login' do
  username = params[:username]
  password = params[:password]

  @user = User.find_by(username: username)

  if @user && @user.password == password
    session[:user_id] = @user.id
    # "Success! User with id #{session[:user_id]} is logged in!"
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end