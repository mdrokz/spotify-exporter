import sys.io.Process;
import Mpris.Mpris;
import Mpris.Dbus;
import Mpris.Player;

class Main {
	static public function main():Void {
		var spotify_songs_list_length = Sys.args()[0];

		if (spotify_songs_list_length == null) {
			trace("provide the number of songs from your playlist or liked songs - ./spotify-expoter 100");
		}

		trace(spotify_songs_list_length);

		var spotify_player_metadata = new Mpris([Dbus.GetProperties, Player.Name, Player.MetaData]);

		// trace(spotify_player_metadata._stdout);
        spotify_player_metadata.parsePlayerMetaData();

		spotify_player_metadata.close();
	}
}
