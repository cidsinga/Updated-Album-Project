require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
also_reload('lib/**/*.rb')
require('./lib/song')

get('/') do
    @albums = Album.all
    @sold = Album.sold
    erb(:albums)
end

get('/albums') do
    @albums = Album.all
    @sold = Album.sold
    erb(:albums)
end
post('/albums') do
    @album = Album.new(*params.values).save
    @albums = Album.all
    @sold = Album.sold
    erb(:albums)
end
patch('/albums') do
    @album = Album.search(:id, params[:buyme])
    @album.sell
    @sold = Album.sold
    @albums = Album.all
    erb(:albums)
end

get('/albums/new') { erb(:albums_new) }

get('/albums/:id') do
    @album = Album.search(:id, params[:id])
    erb(:albums_ID)
end
patch('/albums/:id') do
    @album = Album.search(:id, params[:id])
    params.delete(:_method)
    params.delete(:id)
    @album.update(params)
    @album.save
    @albums = Album.all
    @sold = Album.sold
    erb(:albums)
end
delete('/albums/:id') do
    @album = Album.find(params[:id].to_i())
    @album.delete
    @albums = Album.all
    @sold = Album.sold
    erb(:albums)
end

get('/albums/:id/edit') do
    @album = Album.search(:id, params[:id])
    erb(:albums_ID_edit)
end


# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:albums_ID)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:albums_ID)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:albums_ID)
end
