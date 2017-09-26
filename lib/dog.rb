class Dog
  attr_accessor :id, :name, :breed

  def initialize (id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create (name:, breed:)
    binding.pry
    new_dog = Dog.new(name: name, breed: breed).tap {|dog| dog.save}
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

  def self.new_from_db(row) #row will be an Array [id, name, breed]
    sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES (?, ?)
    )
    SQL

    DB[:conn].execute(sql, row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql,name).each {|row| self.new_from_db(row)}
  end

  def update #instance method
    sql = <<-SQL
    UPDATE dogs SET name = ?, breed = ?
    WHERE id = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql,self.name, self.breed, self.id)
  end

  def save
    #binding.pry
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql,self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
      self
    end
  end


end
