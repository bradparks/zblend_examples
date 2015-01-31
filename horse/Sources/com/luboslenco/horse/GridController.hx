package com.luboslenco.horse;

import fox.math.Math;
import fox.core.Trait;
import fox.core.IUpdateable;
import fox.trait.Input;
import fox.trait.Transform;
import fox.Root;

class GridController extends Trait implements IUpdateable {

    @inject
    var input:Input;

    @inject
    var assembler:GridAssembler;

    var currentX:Int = 0;
    var currentY:Int = 0;
    var moves = 0;

    public function new() {
        super();
    }

    public function start() {
        currentX = Std.random(assembler.size);
        currentY = Std.random(assembler.size);

        assembler.setHorsePostion(currentX, currentY);

        highlightMoves();
    }

    public function update() {
        
        if (input.released) {
            var t = fox.math.Helper.getClosestIntersect(assembler.transforms, input.x, input.y, Root.gameScene.camera);
            if (t != null) {

                var tt = t.owner.getTrait(TileData);

                // Check L tap
                if (checkMove(currentX, currentY, tt.x, tt.y)) {
                    // Destroy old tile
                    var ti = currentX + currentY * assembler.size;
                    assembler.destroyTile(ti);
                    
                    // Move to new tile
                    currentX = tt.x;
                    currentY = tt.y;
                    assembler.tweenHorsePostion(currentX, currentY);
                    
                    highlightMoves();

                    // Update moves
                    GameUI.setMoves(++moves);
                }
            }
        }
    }

    function checkMove(x1:Int, y1:Int, x2:Int, y2:Int):Bool {

        if (Math.abs(x1 - x2) == 1 && Math.abs(y1 - y2) == 2) {
            return true;
        }
        else if (Math.abs(x1 - x2) == 2 && Math.abs(y1 - y2) == 1) {
            return true;
        }
        
        return false;
    }

    function highlightMoves() {
        for (t in assembler.transforms) {
            var tt = t.owner.getTrait(TileData);
            var mr = t.owner.getTrait(fox.trait.MeshRenderer);

            if (checkMove(tt.x, tt.y, currentX, currentY)) {
                motion.Actuate.tween(mr.color, 0.3, {x:1.0, y:0.85, z:0.45});
            }
            else {
                var tt = t.owner.getTrait(TileData);
                if ((tt.x % 2 == 0 && tt.y % 2 == 1) ||
                    (tt.x % 2 == 1 && tt.y % 2 == 0)) {
                    motion.Actuate.tween(mr.color, 0.3, {x:0.8, y:0.8, z:0.8});
                }
                else {
                    motion.Actuate.tween(mr.color, 0.3, {x:1.0, y:1.0, z:1.0});
                }
            }
        }
    }
}
