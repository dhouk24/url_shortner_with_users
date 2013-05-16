use Rack::Session::Cookie, :user_id => nil,
                           :secret => 'in times of distress look no further than a box of teddy grahams',
                           :expire_after => 1800

get '/' do
  erb :index
end

post '/' do
  @user = User.authenticate(params[:email],params[:password])
  if @user
    session[:user_id] = @user.id
  else
    if params[:name]
      @user = User.create!(:name => params[:name], :email => params[:email],
               :password => params[:password])
      session[:user_id] = @user.id
    end
  end

  if params[:url]
    long_url = params[:url]
    short_url = rand(36**6).to_s(36)
    @link = Link.new(:long_url => long_url, :short_url => short_url,
                           :click_count => 0)
    if @link.save
      @short_link = "http://localhost:9393/" + @link[:short_url]
    end 
    if session[:user_id]
      id = session[:user_id]
      Link.update(@link.id, :user_id => id)
    end
  end

  if params[:long_url] && params[:long_url] != "0" && session[:user_id]
    link = Link.where(:long_url => params[:long_url]).first
    Link.update(link.id, :user_id => session[:user_id])
  end

  erb :index
end

get '/:short_url' do
  link = Link.where(:short_url => params[:short_url]).first
  count = link[:click_count]
  Link.update(link[:id], :click_count => count + 1)
  redirect "http://#{link[:long_url]}"
end


post '/create_user' do
  @long_url = params[:long_url] 
  erb :create_user
end

