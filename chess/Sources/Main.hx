// Auto-generated
package ;
import kha.Starter;
import fox.Root;
import fox.trait.GameScene;
class Main {
	public static var gameData:TGameData;
	public static function main() {
		CompileTime.importPackage("fox.trait");
		CompileTime.importPackage("com.luboslenco.chess");
		var starter = new Starter();
		starter.start(new Root("Fox", "room1", Game, init));
	}
	public static function init() {
		//gameData = CompileTime.parseJsonFile("../assets/data.json");
		gameData = haxe.Json.parse(fox.sys.Assets.getString("data"));
		//if (gameData.orient == 1) kha.Sys.screenRotation = kha.ScreenRotation.Rotation90;
	}
}
class Game {
	public function new() {
		Root.setScene(Main.gameData.scene);
	}
}
