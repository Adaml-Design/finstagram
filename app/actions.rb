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

get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:"finstagram_posts/new")
end

post '/finstagram_posts' do
    # params.to_s
    photo_url = params[:photo_url]

    @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

    if @finstagram_post.save
        redirect(to('/'))
    else
        erb(:"finstagram_posts/new")
    end
end

get '/finstagram_posts/:id' do
    @finstagram_post = FinstagramPost.find(params[:id])   # find the finstagram post with the ID from the URL
    # escape_html @finstagram_post.inspect        # print to the screen for now
    erb(:"finstagram_posts/show")  # render app/views/finstagram_posts/show.erb
end

post '/comments' do
    # point values from params to variables
    text = params[:text]
    finstagram_post_id = params[:finstagram_post_id]

    # instantiate a comment with those values & assign the comment to the `current_user`
    comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })

    # save the comment
    comment.save

    # `redirect` back to wherever we came from
    redirect(back)
end

post '/likes' do
    finstagram_post_id = params[:finstagram_post_id]

    like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })
    like.save

    redirect(back)
end

delete '/likes/:id' do
    like = Like.find(params[:id])
    like.destroy
    redirect(back)
end