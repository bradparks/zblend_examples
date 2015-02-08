package com.luboslenco.chess;

import fox.core.IUpdateable;
import fox.core.Trait;
import fox.math.Helper;
import fox.math.Quat;
import fox.math.Box3;
import fox.math.Ray;
import fox.math.Vec3;
import fox.Root;
import fox.trait.Input;
import fox.trait.Transform;
import fox.trait.GameScene;
import fox.trait.RigidBody;

class CubeController extends Trait implements IUpdateable {

    @inject
    var transform:Transform;

    @inject
    var input:Input;

    @inject({asc:true,sibl:true})
    var scene:GameScene;

    @inject
    var body:RigidBody;

    static var boardTransform:Transform = null;

    public static var picking = false;
    var picked = false;

    var startZ:Float;
    var orient:Quat;

    var ray:Ray;
    var box:Box3;

    public function new() {
        super();

        orient = new Quat();
        box = new Box3();
    }

    public function update() {

        if (boardTransform == null) {
            boardTransform = Root.getChild("Board").getTrait(Transform);
        }

        if (input.started && !picking) {

            if (getIntersect(transform) != null) {
                picked = true;
                picking = true;
                startZ = transform.z;
                orient.set(transform.rot.x, transform.rot.y, transform.rot.z, transform.rot.w);
            }
        }
        else if (input.released) {
            
            if (picked) {
                transform.pos.z = startZ + 0.05;
                body.body.isStatic = false;
            }
            picked = false;
            picking = false;
        }


        if (picked) {
            var v = getIntersect(boardTransform, 2);

            if (v != null) {
                transform.rot.set(orient.x, orient.y, orient.z, orient.w);
                transform.pos.set(v.x, v.y, v.z + 5);
                body.body.isStatic = true;
            }
        }
    }

    function getIntersect(transform:Transform, ext:Float = 1):Vec3 {
        ray = Helper.getRay(input.x, input.y, scene.camera);

        var t = transform;
        var c = new Vec3(t.absx, t.absy, t.absz);
        var s = new Vec3(t.size.x * ext, t.size.y * ext, t.size.z);

        box.setFromCenterAndSize(c, s);

        var r = ray.intersectBox(box);
        return r;
    }
}
