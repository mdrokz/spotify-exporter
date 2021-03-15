import haxe.Int32;
import sys.io.Process;

enum abstract Dbus(String) to String {
	final GetProperties = "org.freedesktop.DBus.Properties.Get";
}

enum abstract Player(String) to String {
	final Name = "string:org.mpris.MediaPlayer2.Player";
	final Next = "org.mpris.MediaPlayer2.Player.Next";
	final MetaData = "string:Metadata";
}

class PlayerMetaData {
	public var url:String;
	public var title:String;
	public var trackNumber:Int;
	public var discNumber:Int;
	public var autoRating:Float;
	public var album:String;
	public var albumArtist:String;

	public function new() {}
}

class Mpris extends Process {
	final base_cmd = "dbus-send";

	public var _stdout(get, null):String;

	final base_args = [
		"--print-reply",
		"--dest=org.mpris.MediaPlayer2.spotify",
		"/org/mpris/MediaPlayer2"
	];

	public function new(args:Array<String>) {
		[for (arg in args) base_args.push(arg)];
		super(base_cmd, base_args);
	}

	private function get__stdout():String {
		return this.stdout.readAll().toString();
	}

	public override function close() {
		super.close();
	}

	public function parsePlayerMetaData():PlayerMetaData {
		var allFields = Type.getInstanceFields(Type.resolveClass("PlayerMetaData"));

		var metadata = new PlayerMetaData();

		var data = this._stdout;

		for (field in allFields) {
			var extractedData = data.substring(data.indexOf("xesam:" + field)).split("\"")[2];
			Reflect.setProperty(metadata, "url", "hahahaha");
		}

		trace(metadata.url);

		var a = data.substring(data.indexOf("xesam:albumArtist"));

		var title = a.split("\"")[2];

		// trace(data);

		return null;
	}
}
