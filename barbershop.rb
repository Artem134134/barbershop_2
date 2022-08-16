require 'sinatra'
require 'sinatra/reloader'


get '/' do
	  erb :index
end

post '/' do

	@hairdresser = params[:hairdresser]
	@user_name = params[:user_name]
	@phone = params[:phone]
	@date_time = params[:date_time]

	@title = 'Thank you!'
	@message = "Dear visitor: #{@user_name},
	 your hairdresser: #{@hairdresser}, 
	we'll be waiting for you at #{@date_time}."

	
	f = File.open("./public/users.txt", "a")
	f.write "Hairdresser: #{@hairdresser}
	  User: #{@user_name}
	  Phone: #{@phone}
	  Date and time: #{@date_time}\n"
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
    @message = 'Thank you for being with us!'
    @log = File.read("./public/users.txt")          
    erb :logfile 
end


