class Album
  attr_accessor :name, :year, :genre, :artist, :id
  def initialize(name, year = nil, genre = nil, artist = nil, id = nil)
    @name = name
    @year = year
    @genre = genre
    @artist = artist
    @id = id || @@total_rows += 1
  end

  def save
    @@albums[self.id] = self
  end

  def update(new_vals)
    new_vals.each { |(key, val)| send("#{key}=".to_sym, (val == "") ? send(key) : val ) }
  end

  def delete
    @@albums.delete(@id)
  end

  def sell
    delete
    @@sold_albums[@id] = Album.new(@name, @id)
  end

  def songs
    Song.find_by_album(self.id)
  end

  #class methods
  @@albums = {}
  @@sold_albums = {}
  @@total_rows = 0

  def self.all
    @@albums.values
  end
  def self.sold
    @@sold_albums.values
  end

  def self.clear
    @@albums = {}
    @@total_rows = 0
  end

  def self.find(id)
    @@albums[id]
  end

  def self.search(type, term)
    @@albums.merge(@@sold_albums).values.select {|al| al.send(type).to_s.downcase.include? term.downcase}[0]
  end

  def self.sort()
    @@albums.values.sort {|a, b| a.name <=> b.name}
  end

  #does something maybe
  def ==(album_to_compare)
    @name == album_to_compare.name
  end
end
