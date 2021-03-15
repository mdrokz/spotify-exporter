#if cpp
import sys.io.Process;
#end
#if js
import js.node.ChildProcess.spawnSync;
#end

enum abstract Dbus(String) to String {
	final GetProperties = "org.freedesktop.DBus.Properties.Get";
}

enum abstract Player(String) to String {
	final Name = "string:org.mpris.MediaPlayer2.Player";
	final Next = "org.mpris.MediaPlayer2.Player.Next";
	final MetaData = "string:Metadata";
}

@:keep
@:structInit class PlayerMetaData {
	public var url:String;
	public var title:String;
	public var trackNumber:Int;
	public var discNumber:Int;
	public var autoRating:Float;
	public var album:String;
	public var albumArtist:String;

	public function new() {}
}

interface MprisBase {
	private final base_cmd:String;
	private final base_args:Array<String>;
	public function parsePlayerMetaData():PlayerMetaData;
	public function command(args:Array<String>):Int;
}

#if js
class MprisJs implements MprisBase {
	final base_cmd = "dbus-send";

	final base_args = [
		"--print-reply",
		"--dest=org.mpris.MediaPlayer2.spotify",
		"/org/mpris/MediaPlayer2"
	];

	var _stdout:String = "";

	public function new(args:Array<String>) {
		var copy_args = base_args.copy();
		[for (arg in args) copy_args.push(arg)];

		_stdout = (cast spawnSync(base_cmd, copy_args).stdout).toString();
	}

	public function parsePlayerMetaData():PlayerMetaData {
		var allFields = Type.getInstanceFields(Type.resolveClass("PlayerMetaData"));

		var metadata:PlayerMetaData = {};

		var data = this._stdout;

		for (field in allFields) {
			var extractedData = data.substring(data.indexOf("xesam:" + field)).split("\"")[2];
			Reflect.setProperty(metadata, field, extractedData);
		}

		return metadata;
	}

	public function command(args:Array<String>):Int {
		var copy_args = base_args.copy();

		[for (arg in args) copy_args.push(arg)];

		var result = spawnSync(base_cmd, copy_args);

		return result.status;
	}
}
#else
class Mpris extends Process implements MprisBase {
	final base_cmd = "dbus-send";

	public var _stdout(get, null):String;

	final base_args = [
		"--print-reply",
		"--dest=org.mpris.MediaPlayer2.spotify",
		"/org/mpris/MediaPlayer2"
	];

	public function new(args:Array<String>) {
		var copy_args = base_args.copy();
		[for (arg in args) copy_args.push(arg)];
		super(base_cmd, copy_args);
	}

	private function get__stdout():String {
		return this.stdout.readAll().toString();
	}

	public function parsePlayerMetaData():PlayerMetaData {
		var allFields = Type.getInstanceFields(Type.resolveClass("PlayerMetaData"));

		var metadata:PlayerMetaData = {};

		var data = this._stdout;

		for (field in allFields) {
			var extractedData = data.substring(data.indexOf("xesam:" + field)).split("\"")[2];
			Reflect.setProperty(metadata, field, extractedData);
		}

		return metadata;
	}

	public function command(args:Array<String>):Int {
		var copy_args = base_args.copy();

		[for (arg in args) copy_args.push(arg)];

		return Sys.command(base_cmd, copy_args);
	}
}
#end