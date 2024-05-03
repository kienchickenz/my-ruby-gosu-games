require 'rubygems'
require 'gosu'

WIDTH = 980
HEIGHT = 500
TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
X_TRACKS = 585

module ZOrder
    BACKGROUND, PLAYER, UI = *0..2
end

class ArtWork
	attr_accessor :image, :dimension
	def initialize (file, left, top)
		@image = Gosu::Image.new(file)
        @dimension = Dimension.new(left, top, left + 150, top + 150)
	end
end
class Album
    attr_accessor :title, :artist, :tracks, :artwork
    def initialize (title, artist, artwork, tracks)
        @title = title
        @artist = artist
        @artwork = artwork
        @tracks = tracks
    end
end
class Track
	attr_reader :name, :location, :dimension
	def initialize (name, location, dimension)
		@name = name
		@location = location
        @dimension = dimension
	end
end
class Dimension
    attr_reader :left, :right, :top, :bottom
    def initialize(left, top, right, bottom)
        @left = left
        @top = top
        @right = right
        @bottom = bottom
    end
end

class MusicPlayer < Gosu::Window
	def initialize
	    super WIDTH, HEIGHT
	    self.caption = "Music Player"
        @font = Gosu::Font.new(24)
        # To load albums from a file
        @my_albums = read_albums
        # To follow the played track
        @album_playing = -1
        @track_playing = -1
	end

    # To load albums and tracks
    def read_albums
        a_file = File.new("input.txt","r")
        count = a_file.gets.chomp.to_i
        albums = []
        idx = 0
        while idx != count
            album = read_album(a_file, idx)
            albums.push album
            idx += 1
        end
        a_file.close
        return albums
    end
    def read_album(a_file, idx)
        album_title = a_file.gets.chomp.to_s
        album_artist = a_file.gets.chomp.to_s
        if idx % 3 == 0
            x_artwork = 30
        elsif idx % 3 == 1
            x_artwork = 30 + 150 + 30
        else
            x_artwork = 30 + 150 + 30 + 150 + 30
        end
        y_artwork = 30 + 150 * (idx / 3) + 30 * (idx / 3)
        album_artwork = ArtWork.new(a_file.gets.chomp.to_s, x_artwork, y_artwork)
        album_tracks = read_tracks(a_file)
        album = Album.new(album_title, album_artist, album_artwork, album_tracks)
        return album
    end
    def read_tracks(a_file)
        count = a_file.gets.chomp.to_i
        tracks = []
        i = 0
        while i != count
            track = read_track(a_file, i)
            tracks.push track
            i += 1
        end
        return tracks
    end
    def read_track(a_file, idx)
        track_name = a_file.gets.chomp.to_s
        track_location = a_file.gets.chomp.to_s
        left = X_TRACKS
        right = left + @font.text_width(track_name)
        top =  50 * idx + 30
        bottom = top + @font.height
        dimension = Dimension.new(left, top, right, bottom)
        track = Track.new(track_name, track_location, dimension)
        return track
    end

    # To draw albums and tracks
    def draw_albums(albums)
        albums.each do |album|
            album.artwork.image.draw(album.artwork.dimension.left, album.artwork.dimension.top, ZOrder::PLAYER, 0.5, 0.5)
        end
    end
    def draw_tracks(album)
        album.tracks.each do |track|
            draw_track(track)
        end
    end
    def draw_track(track)
        @font.draw(track.name, X_TRACKS, track.dimension.top, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
    end
    # To draw indicator of the current playing song
    def draw_current_playing(idx, album)
        draw_rect(album.tracks[idx].dimension.left - 25, album.tracks[idx].dimension.top, 5, @font.height, Gosu::Color::RED, ZOrder::PLAYER)
    end
    # To draw background
    def draw_background
        draw_quad(0,0,TOP_COLOR,0,HEIGHT,TOP_COLOR,WIDTH,0,BOTTOM_COLOR,WIDTH,HEIGHT,BOTTOM_COLOR,ZOrder::BACKGROUND)
    end
    def draw
        draw_background
        draw_albums(@my_albums)
        if @album_playing >= 0
            draw_tracks(@my_albums[@album_playing])
            draw_current_playing(@track_playing, @my_albums[@album_playing])
        end
    end

    # To play track from album
    def play_track(track_number, album)
        @song = Gosu::Song.new(album.tracks[track_number].location)
        # Passing the optional value ’false’ to the play() method 
        # so it doesn't play the song in a loop
        @song.play(false)
    end
    def update
        # To play the first track of the selected album automatically
        if @album_playing >= 0 and @song == nil
            @track_playing = 0
            play_track(@track_playing, @my_albums[@album_playing])
        end
        # To play the next track automatically
        if @album_playing >= 0 and @song != nil and !@song.playing?
            @track_playing = (@track_playing + 1) % @my_albums[@album_playing].tracks.length
            play_track(@track_playing, @my_albums[@album_playing])
        end
    end

    # To handle user's interaction
    def area_clicked(left, top, right, bottom)
        if mouse_x > left and mouse_x < right and mouse_y > top and mouse_y < bottom
            return true
        end
        return false
    end
    def button_down(id)
        if id == Gosu::MsLeft
            # To check which album is clicked on
            for i in 0..@my_albums.length - 1
                if area_clicked(@my_albums[i].artwork.dimension.left, @my_albums[i].artwork.dimension.top, @my_albums[i].artwork.dimension.right, @my_albums[i].artwork.dimension.bottom)
                    @album_playing = i
                    @song = nil
                    break
                end
            end
            # To check which track is clicked on
            if @album_playing >= 0
                for i in 0..@my_albums[@album_playing].tracks.length - 1
                    if area_clicked(@my_albums[@album_playing].tracks[i].dimension.left, @my_albums[@album_playing].tracks[i].dimension.top, @my_albums[@album_playing].tracks[i].dimension.right, @my_albums[@album_playing].tracks[i].dimension.bottom)
                        play_track(i, @my_albums[@album_playing])
                        @track_playing = i
                        break
                    end
                end
            end
        end
        if id == Gosu::KbEscape
            close
        end
    end
end

MusicPlayer.new.show if __FILE__ == $0