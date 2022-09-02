require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'b_shop2.sqlite'
end

configure do 
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"(
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Name"	TEXT,
	"Phone"	TEXT,
	"Datestamp"	TEXT,
	"Hairdresser"	TEXT,
	"Color"	TEXT
  )'
 db.close
end

configure do 
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS "Contacts"(
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Email"	TEXT,
	"Comment"	TEXT
)'
 db.close
end

def save_form_data_to_database
  db = get_db
  db.execute 'INSERT INTO Users 
    (Name,Phone,Datestamp,Hairdresser,Color)
  VALUES (?, ?, ?, ?, ?)',
  [@name, @phone, @datestamp,
   @hairdresser, @color]
  db.close
end

def save_form_data_to_database1
  db = get_db
  db.execute 'INSERT INTO Contacts(Email, Comment)
  VALUES (?, ?)',
  [@email, @comment]
  db.close
end

get '/' do
  erb :index
end


post '/' do
	@hairdresser = params[:hairdresser]
	@name        = params[:name]
    @phone       = params[:phone]
	@datestamp   = params[:datestamp]
	@color       = params[:color]

	@title = "Thank you, #{@name.capitalize}
	          your message has been sent."

	# hash for parameter validation
hh = {:name => 'Enter your name',
      :phone => 'Enter your phone',
      :datestamp => 'Enter datestamp'}

# for each key-value pair
hh.each do |key, value|
  # if parameter is empty
  if params[key] == ''
    # переменной @error присвоить value из хеша hh
    @error = hh[key]

    # вернуть представление
    return  erb :index
  end
end

save_form_data_to_database

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

get '/contacts' do
	erb :contacts		
end

post '/contacts' do
	@email =   params[:email]
  @comment = params[:comment]
	
	@title = "Thank you! #{@email}"

	# hash for parameter validation
hh = {:email =>'Enter your email',
	    :comment => 'Write your comment'}

# for each key-value pair
hh.each do |key, value|
  # if parameter is empty
  if params[key] == ''
    # переменной @error присвоить value из хеша hh
    @error = hh[key]

    # вернуть представление
    return  erb :contacts
  end
end

save_form_data_to_database1

	  erb :message
end


