package com.luboslenco.horse;

import fox.core.Object;
import fox.Root;
import fox.sys.Assets;
import fox.trait2d.util.TapTrait;
import fox.trait2d.ImageRenderer;
import fox.trait2d.TextRenderer;

class GameUI {

    static var textRenderer:TextRenderer;

    public function new() {

        var scoreObject = new Object();
        textRenderer = new TextRenderer("0", Assets.getFont("font", 50), TextAlign.Left);
        scoreObject.addTrait(textRenderer);
        scoreObject.transform.x = 10;
        scoreObject.transform.y = 10;
        Root.addChild(scoreObject);

        var buttonObject = new Object();
        buttonObject.addTrait(new ImageRenderer(Assets.getImage("refresh")));
        buttonObject.addTrait(new TapTrait(onRefreshTap));
        buttonObject.transform.x = Root.w - buttonObject.transform.w - 10;
        buttonObject.transform.y = 10;
        Root.addChild(buttonObject);
    }

    public static function setMoves(moves:Int) {
        textRenderer.text = moves + "";
    }

    function onRefreshTap() {
        Root.setScene(Main.gameData.scene);
    }
}
