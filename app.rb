require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
also_reload('lib/**/*.rb')

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
