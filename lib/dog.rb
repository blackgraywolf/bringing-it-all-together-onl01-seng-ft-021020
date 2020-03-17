class Dog
  attr_accessor :id, :name, :breed

  def initialize(attributes)
    #id: nil, name:, breed:
    attributes.each {|key, value| self.send(("#{key}="), value)}
    self.id ||= nil
  end
    def self.new_from_db(row)
    attributes_hash = {
      :id => row[0],
      :name => row[1],
      :breed => row[2]
    }
    self.new(attributes_hash)
  end

def saves
    sql = <<-SQL
      INSERT INTO dogs (name, breed) VALUES (?, ?)
      SQL

    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    self
  end
  
   def save
	 if self.id
	self.update
	 else
	 sql = <<-SQL
	 INSERT INTO dogs (name, breed)
	 VALUES (?, ?)
 SQL
	 DB[:conn].execute(sql, self.name, self.album)
	 @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
	 end
	 self
end
 
def self.create(attributes)
dog = Dog.new(attributes)
dog.save
dog
end
 
# def self.find_by_id(id)
# sql = "SELECT * FROM dogs WHERE id = ?"
# result = DB[:conn].execute(sql, id)[0]
# Dog.new(result[0], result[1], result[2])
# end
  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs WHERE id = ?
    SQL

    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end

	 def self.find_by_name(name)
	 sql = <<-SQL
	 SELECT *
	FROM dogs
	WHERE name = ?
	 LIMIT 1
SQL
	
	DB[:conn].execute(sql, name).map do |row|
	self.new_from_db(row)
	 end.first
 end
 
 
  def update
    sql = <<-SQL
      UPDATE dogs SET name = ?, breed = ? WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

def self.create_table	
	sql = <<-SQL
	CREATE TABLE IF NOT EXISTS dogs (
	id INTEGER PRIMARY KEY,
	name TEXT,
	breed TEXT
	)
SQL
	DB[:conn].execute(sql)
	end
	def self.drop_table
 sql = <<-SQL
	DROP TABLE dogs
 SQL
	DB[:conn].execute(sql)
	end
	
  def self.drop_table 
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end

# def self.find_or_create_by(name:, breed:)
# dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
# if !Dog.empty?
# dog_data = Dog[0]
# dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
# else
# dog = self.create(name: name, breed: breed)
# end
# dog
# end

def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ? AND breed = ?
      SQL


      dog = DB[:conn].execute(sql, name, breed).first

      if dog
        new_dog = self.new_from_db(dog)
      else
        new_dog = self.create({:name => name, :breed => breed})
      end
      new_dog
  end




 
end


# class Song
 
# attr_accessor :name, :album
# attr_reader :id
 
# def initialize(id=nil, name, album)
# @id = id
# @name = name
# @album = album
# end
 
# def save
# if self.id
# self.update
# else
# sql = <<-SQL
# INSERT INTO songs (name, album)
# VALUES (?, ?)
# SQL
 
# DB[:conn].execute(sql, self.name, self.album)
# @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
# end
# end
 
# def self.create(name:, album:)
# song = Song.new(name, album)
# song.save
# song
# end
 
# def self.find_by_id(id)
# sql = "SELECT * FROM songs WHERE id = ?"
# result = DB[:conn].execute(sql, id)[0]
# Song.new(result[0], result[1], result[2])
# end
 
# def update
# sql = "UPDATE songs SET name = ?, album = ? WHERE id = ?"
# DB[:conn].execute(sql, self.name, self.album, self.id)
# end

# #Let's build our #find_or_create_by method:

# def self.find_or_create_by(name:, album:)
# song = DB[:conn].execute("SELECT * FROM songs WHERE name = ? AND album = ?", name, album)
# if !song.empty?
# song_data = song[0]
# song = Song.new(song_data[0], song_data[1], song_data[2])
# else
# song = self.create(name: name, album: album)
# end
# song
# end

# end
