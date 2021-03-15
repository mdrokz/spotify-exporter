import sys.io.File;
import haxe.Json;
import Mpris.PlayerMetaData;
import Mpris.Mpris;
import Mpris.Dbus;
import Mpris.Player;

class Main {
	static public function main():Void {
		var spotify_songs_list_length = Std.parseInt(Sys.args()[0]);

		if (spotify_songs_list_length == null) {
			trace("provide the number of songs from your playlist or liked songs - ./spotify-expoter 100");
		}

		var spotify_metadata_list:Array<PlayerMetaData> = [];

		for (i in 0...spotify_songs_list_length+1) {
			if (i != 0) {
				var spotify_player = new Mpris([Dbus.GetProperties, Player.Name, Player.MetaData]);
				spotify_metadata_list.push(spotify_player.parsePlayerMetaData());
				spotify_player.close();
				Sys.sleep(0.1);
				spotify_player.command([Player.Next]);
			} else {
				new Mpris([Player.Next]).close();
			}
		}

		var handle = File.write('./exported_songs.json');
		handle.writeString(Json.stringify(spotify_metadata_list));
		handle.flush();
		handle.close();
	}
}
