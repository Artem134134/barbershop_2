require 'sinatra'

get '/' do
	  erb :index
end

post '/' do
	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]

	@title = 'Thank you!'
	@message = "Dear visitor: #{@user_name} 
	we'll be waiting for you at #{@date_time}."

	f = File.open("./public/users.txt", "a")

	f.write "User: #{@user_name},
	  Phone: #{@phone},
	  Date and time: #{@date_time}"
	f.close
	  erb :message
end

get '/admin' do
     erb :admin
end

post '/admin' do
	@login = params[:login]
	@password = params[:password]

	if @login == 'admin' and @password == 'secret' 
		@title = 'Access is allowed. Welcome'
		@message = "Hi, admin: \ 'Artem134134'\ "
		erb :protected
	else			
		@message = 'Access denied!'
		erb :admin
    end
end

get '/logfile' do
    @log = File.read("./public/users.txt")  
    @log.split        
    erb :logfile 
end


