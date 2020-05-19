require 'pry'

class Artist

  attr_accessor :id, :name
  # :artist, :genre, :year, :in_inventory


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    # @artist = attributes.fetch(:artist)
    # @genre = attributes.fetch(:genre)
    # @year = attributes.fetch(:year)
    # @in_inventory = attributes.fetch(:in_inventory, true)    
  end

  def self.all
    returned_artists = DB.exec("SELECT * FROM artists;")
    artists = []
    returned_artists.each() do |artist|
      name = artist.fetch("name")
      id = artist.fetch("id").to_i
      # artist = artist.fetch("artist")
      # genre = artist.fetch("genre")
      # year = artist.fetch("year").to_i
      # in_inventory = artist.fetch("in_inventory")
      artists.push(Artist.new({name: name, id:id}))
    end
    artists
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(artist_to_compare)
    self.name() == artist_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    name = album.fetch("name")
    id = album.fetch("id").to_i
    # artist = album.fetch("artist")
    # genre = album.fetch("genre")
    # year = album.fetch("year").to_i
    # in_inventory = album.fetch("in_inventory")
    Artist.new({ name: name, id: id})
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:album_name)) && (attributes.fetch(:album_name) != nil)
      album_name = attributes.fetch(:album_name)
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
    if album != nil
      DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
    album
  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def self.search(name)
    artist_names = Artist.all.map {|a| a.name }
    result = []
    names = aritst_names.grep(/#{name}/)
    names.each do |n| 
      display_artist = Artist.all.select {|a| a.name == n}
      result.concat(display_artist)
    end
    result
  end

  def self.sort()
    artists = self.all
    sorted_artists = artists.sort_by{ |name| name.name }
    sorted_artists
  end
 
def albums
  albums = []
  results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
  results.each() do |result|
    album_id = result.fetch("album_id").to_i()
    album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};")
    name = album.first().fetch("name")
    artist = album.first().fetch("artist")
    genre = album.first().fetch("genre")
    year = album.first().fetch("year")
    albums.push(Album.new({:name => name, :id => album_id, :artist => artist, :genre => genre, :year => year}))
  end
  albums
end

  # def sold()
  #   @in_inventory = false
  #   DB.exec("UPDATE albums SET in_inventory = '#{@in_inventory}' WHERE ID = #{@id};")
  # end

  # def songs
  #   Song.find_by_album(self.id)
  
end