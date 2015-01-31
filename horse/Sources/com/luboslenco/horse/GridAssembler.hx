package com.luboslenco.horse;

import fox.core.Trait;
import fox.trait.Transform;
import fox.Root;

class GridAssembler extends Trait {

    @inject
    var controller:GridController;

    public var transforms:Array<Transform> = [];
    var horseTransform:Transform;

    public var size:Int;
    var step:Float;
    var offset:Float;

    public function new() {
        super();

        Root.registerInit(init);
    }

    function init() {
        // Spawn boxes
        var node = Root.gameScene.getNode(".Box");

        size = 8;
        step = 2.0;
        offset = Std.int(size / 2) * step - step / 2;

        for (i in 0...size) {
            for (j in 0...size) {
                var o = Root.gameScene.createNode(node);
                o.transform.y = i * step - offset;
                o.transform.x = j * step - offset;
                o.addTrait(new TileData(j, i));
                transforms.push(o.transform);

                if ((i % 2 == 0 && j % 2 == 1) ||
                    (i % 2 == 1 && j % 2 == 0)) {
                    o.getTrait(fox.trait.MeshRenderer).color.set(0.8, 0.8, 0.8);
                }
            }
        }

        // Spawn horse
        var horseNode = Root.gameScene.getNode(".Horse");
        var horse = Root.gameScene.createNode(horseNode);
        horseTransform = horse.transform;

        controller.start();
    }

    public function setHorsePostion(x:Int, y:Int) {
        horseTransform.x = x * step - offset;
        horseTransform.y = y * step - offset;
    }

    public function tweenHorsePostion(x:Int, y:Int) {
        motion.Actuate.tween(horseTransform, 0.3, {x:x * step - offset, y:y * step - offset});
    }

    public function destroyTile(ti:Int) {
        motion.Actuate.tween(transforms[ti], 10.0, {z:-100}).onComplete(transforms[ti].owner.remove);
    }
}
