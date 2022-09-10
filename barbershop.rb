require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_hairdresser_exists? db, name 
	db.execute('select * from Hairdressers where name=?'
		        ,[name]).size > 0
	
# Method connect with database
def get_db
	@db = SQLite3::Database.new 'b_shop2.sqlite'
	# display result in hash from db
	@db.results_as_hash = true
	return @db 
end

# Configure application
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

  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS "Contacts"(
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Email"	TEXT,
	"Comment"	TEXT
)'

db.execute 'CREATE TABLE IF NOT EXISTS "Hairdressers"(
	"Id"	INTEGER PRIMARY KEY AUTOINCREMENT,
	"Name"	TEXT
)'

 db.close
end

# Method save form data to database
def save_form_data_to_database
  db = get_db
  db.execute 'INSERT INTO Users 
    (Name,Phone,Datestamp,Hairdresser,Color)
  VALUES (?, ?, ?, ?, ?)',
  [@name, @phone, @datestamp,
   @hairdresser, @color]
  db.close
end

# Method save form data to database
def save_form_data_to_database1
  db = get_db
  db.execute 'INSERT INTO Contacts(Email, Comment)
  VALUES (?, ?)',
  [@email, @comment]
  db.close
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
	db.close

	erb :showusers
end

get '/showcontacts' do
	db = get_db
	@results = db.execute 'select * from Contacts order by id desc'
	db.close

	erb :showcontacts
end

# Index page with form
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

# method call to save to database table users
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

# method call to save to database table contacts
save_form_data_to_database1

	  erb :message
end


