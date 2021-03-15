import Mpris.Player;
import Mpris.Dbus;
import Mpris.PlayerMetaData;
import Mpris.MprisJs;

@:expose
class Export {
	public static function export(spotify_songs_list_length:Int):Array<PlayerMetaData> {
		if (spotify_songs_list_length == null) {
			trace("provide the number of songs from your playlist or liked songs - ./spotify-expoter 100");
		}

		var spotify_metadata_list:Array<PlayerMetaData> = [];

		for (i in 0...spotify_songs_list_length + 1) {
			if (i != 0) {
				var spotify_player = new MprisJs([Dbus.GetProperties, Player.Name, Player.MetaData]);
				spotify_metadata_list.push(spotify_player.parsePlayerMetaData());
				Sys.sleep(0.1);
				spotify_player.command([Player.Next]);
			} else {
				new MprisJs([Player.Next]);
			}
		}

		return spotify_metadata_list;
	}
}
