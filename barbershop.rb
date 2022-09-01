require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do 
  @db = SQLite3::Database.new 'b_shop2.sqlite'
  @db.execute 'CREATE TABLE IF NOT EXISTS "Users" (
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Username"	TEXT,
	"Phone"	TEXT,
	"Datestamp"	TEXT,
	"Hairdresser"	TEXT,
	"Haircolor"	TEXT
    )'
@db.close
end

get '/' do
	  erb :index
end

post '/' do

	@hairdresser =  params[:hairdresser]
	@haircolor =    params[:haircolor]
	@username =     params[:username]
	@phone =        params[:phone]
	@datestamp =    params[:datestamp]

 		   # hash for parameter validation
   hh = {:username => 'Enter your name',
         :phone => 'Enter your phone',
         :datestamp => 'Enter datestamp'}

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
	we'll be waiting for you at #{@datestamp}."
	
	f = File.open("./public/users.txt", "a")
	f.write "Hairdresser: #{@hairdresser}
	  Haircolor: #{@haircolor}
	  User: #{@username}
	  Phone: #{@phone}
	  Date and time: #{@datestamp}\n"
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


