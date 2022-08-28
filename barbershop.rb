require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

db = SQLite3::Database.new 'my_base.sqlite'

get '/' do
	  erb :index
end

post '/' do

	@hairdresser = params[:hairdresser]
	@haircolor = params[:haircolor]
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]

 		   # hash for parameter validation
   hh = {:username => 'Enter your name',
         :phone => 'Enter your phone',
         :datetime => 'Enter datetime'}

# error output when parameter[key] is empty 
@error = hh.select {|key,_| params[key] == ''}.values.join(", ")

# if parameter is empty
if @error != ''

	# return view
  return erb :index
end

	@title = 'Thank you!'
	@message = "Dear visitor: #{@username},
	 your hairdresser: #{@hairdresser}, haircolor:#{@haircolor}
	we'll be waiting for you at #{@datetime}."
	
	f = File.open("./public/users.txt", "a")
	f.write "Hairdresser: #{@hairdresser}
	  Haircolor: #{@haircolor}
	  User: #{@username}
	  Phone: #{@phone}
	  Date and time: #{@datetime}\n"
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


