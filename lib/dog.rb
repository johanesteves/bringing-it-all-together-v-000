class Dog
  attr_accessor :id, :name, :breed

  def initialize (id:, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXIST dogs (
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


end
