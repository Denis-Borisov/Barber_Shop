#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'



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
	)'
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'	
	db.results_as_hash = true
	return db
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

get '/something' do
	erb :something
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




	@title = "Спасибо!"
	@message = "Дорогой #{@imy}, будем вас ждать #{@vremy}, парикмахер #{@barb}, окрашивание в цвет #{@color}"


	erb :visit

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
  erb "Hello World"
end