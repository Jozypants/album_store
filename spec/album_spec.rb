require 'rspec'
require 'album'
require 'song'
# require 'artist'
require 'pry'
require('spec_helper')

describe '#Album' do


  describe('#save') do
    it("saves an album") do
      album = Album.new({ :name => "Giant Steps", :id => nil, :artist => "John Coltrane", :genre => "Jazz", :year => 1959})
      album.save()
      album2 = Album.new({:name => "Blue",:id => nil,:artist => "rando",:genre => "Folk-Pop",:year => 2003})
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end
  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Album.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({:name => "Giant Steps",:id => nil,:artist => "John Coltrane", :genre => "Jazz", :year => "1959"})
      album.save()
      album2 = Album.new({:name => "Blue", :id  => nil, :artist => "rando", :genre => "Folk-Pop", :year => "2003"})
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album = Album.new({:name => "Giant Steps", :id => nil, :artist => "John Coltrane", :genre => "Jazz", :year => "1959"})
      album2 = Album.new({:name => "Giant Steps", :id => nil, :artist => "John Coltrane", :genre => "Jazz", :year => "1959"})
      expect(album).to(eq(album2))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({:name => "Giant Steps",:id => nil,:artist => "John Coltrane",:genre => "Jazz",:year => "1959"})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil, :artist => "rando", :genre => "Folk-Pop", :year => "2003"})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end
  
  describe('#update') do
    it("updates an album by id") do
      album = Album.new({:name => "Giant Steps", :id =>nil, :artist => "John Coltrane", :genre => "Jazz",:year => "1959"})
      album.save()
      album.update("A Love Supreme")
      expect(album.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new({:name => "Giant Steps", :id => nil, :artist =>"John Coltrane",:genre =>"Jazz", :year =>"1959"})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil, :artist => "rando", :genre => "Folk-Pop", :year => "2003"})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('initialize') do
    it('') do
      album = Album.new({:name => "Giant Steps",:id =>  nil, :artist => "John Coltrane",:genre => "Jazz",:year => "1959"})
      album.save()
      expect(album.name).to(eq("Giant Steps"))
      expect(album.artist).to(eq("John Coltrane"))
      expect(album.genre).to(eq("Jazz"))
      expect(album.year).to(eq("1959"))
    end
  end

  describe('.search') do
    it('will search through all albums and return all albums that contain a matching name') do
      album = Album.new({:name => "Giant Steps",:id =>  nil, :artist => "John Coltrane",:genre => "Jazz",:year => "1959"})
      album.save()
      album1 = Album.new({:name => "Little Giant", :id => nil, :artist => "Johnny Cash", :genre => "Jazz", :year => "1959"})
      album1.save()
      expect(Album.search("Giant")).to(eq([album, album1]))
    end
  end
  
  describe('.sort') do
    it('will sort all albums alphabetically') do
      album = Album.new({:name => "Giant Steps", :id => nil, :artist => "John Coltrane",:genre => "Jazz", :year => "1959"})
      album.save()
      album2 = Album.new({:name => "A Big", :id => nil, :artist => "Johnny Cash", :genre => "Jazz", :year => "1959"})
      album2.save()
      album1 = Album.new({:name => "Little Giant", :id => nil, :artist => "Johnny Griffin", :genre => "Jazz", :year =>"1959"})
      album1.save()
      expect(Album.sort()).to(eq([album2, album, album1]))
    end
  end

  describe('#sold') do
    it('will remove album from Album.all & put into @@sold_albums ') do
      album = Album.new({:name =>"Giant Steps",:id => nil,:artist => "John Coltrane",:genre=> "Jazz", :year=>"1959"})
      album.save()
      album2 = Album.new({:name => "A Big", :id => nil, :artist => "Johnny Cash", :genre => "Jazz", :year => "1959"})
      album2.save()
      album1 = Album.new({:name => "Little Giant", :id => nil, :artist => "Johnny Griffin", :genre => "Jazz", :year => "1959"})
      album1.save()
      album2.sold()
      expect((Album.find(album2.id)).in_inventory).to(eq("f"))
    end
  end

  describe('#songs') do
    it("returns an album's songs") do
      album = Album.new({:name => "Giant Steps", :id => nil,:artist => "John Coltrane",:genre=> "Jazz", :year => "1959"})
      album.save()
      song = Song.new(name: "Naima", album_id: album.id,id: nil)
      song.save()
      song2 = Song.new(name: "Cousin Mary",album_id: album.id, id: nil)
      song2.save()
      expect(album.songs).to(eq([song, song2]))
    end
  end

end