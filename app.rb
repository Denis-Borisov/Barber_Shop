#encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def is_barb? db, name
	db.execute('select * from Barbers where name=?',[name]).length > 0
end

def seed_db db, aaa

	aaa.each do |barber|
		if !is_barb? db, barber
			db.execute 'Insert into Barbers (name) values (?)',[barber] 
		end
	end
end



def get_db
	db = SQLite3::Database.new 'barbershop.db'	
	db.results_as_hash = true
	return db
end


before do 
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	"Users"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"imy" TEXT,
		"telefon" TEXT,
		"vremy" TEXT,
		"barb" TEXT,
		"color" TEXT
	);'


	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Barbers" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		);'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gas Fring', 'Mike Ehrmantraut']	
 

end





get '/' do
	erb :barber
end

post '/' do
	
	@login = params[:login]
	@password = params[:password]
	@a = "Неправильный login или password"

	if @login == "admin" && @password == "321654qw"

		erb :barber1     		       	
	else					
		erb :barber
	end
end	


get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end	

get '/contacts' do
	erb :contacts
end

get '/guests' do
	erb :guests
end	

post "/visit" do
	@imy = params[:username]
	@telefon = params[:phone]
	@vremy = params[:time]
	@barb = params[:barber]
	@color = params[:colorpicker]

	# делаем хеш
	hh = {  :username => "Введите имя",
			:phone => 'Введите телефон',
			:time => 'Введите дату и время'}	

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")		

	if @error != ''
		return erb :visit			
	end	


	db = get_db
	db.execute 'insert into
	Users
	(
		 imy,
		 telefon,
		 vremy,
		 barb,
		 color
	)
	values
	(?, ?, ?, ?, ?)', [@imy, @telefon, @vremy, @barb, @color]
	

	erb "<h2>Спасибо, вы записались!</h2>"

end


post "/contacts" do
	@mail = params[:email]
	@text = params[:message]
	

	kont = {  :email => "Введите email",
			:message => 'Введите сообщение'}	

	@error = kont.select {|key,_| params[key] == ""}.values.join(", ")		

	if @error != ''
		return erb :contacts			
	end	

	File.open "./public/contacts.txt", "a" do |w| 
		w.puts "Email: #{@mail}"  
		w.puts "Mess: #{@text}"
		w.close
	end

	erb :contacts

end




post "/guests" do
	
	@login = params[:login]
	@password = params[:password]
	@a = "Неправильный login или password"

	if @login == "aaa" && @password == "123"

        
        	File.open "./public/Users.txt" do |f|
 
				f.each do |r|
					puts r
				end
			end
	else
		erb :guests		
	end




end

get '/showusers' do
	db = get_db

	@result = db.execute 'select * from Users order by id desc'
	
	erb :showusers
end



