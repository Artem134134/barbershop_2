require 'sinatra'

get '/' do
	erb :index
end

post '/' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]

	@title = 'Thank you!'
	@message = "Dear visitor:#{@user_name} 
	we'll be waiting for you at #{@date_time}"

	f = File.open 'users.txt', 'a'

	f.write "User: #{@user_name},
	  Phone: #{@phone},
	  Date and time: #{@date_time}"
	f.close

	erb :message
end

get '/admin' do
  erb :welcome
end

post '/admin' do
	@login = params[:login]
	@password = params[:password]

	if @login == 'admin' and @password == 'secret' 
		@message = 'Hi, admin!'
		erb :welcome
	else			
		@message = 'Access denied!'
		erb :welcome
    end
end

