package com.luboslenco.test;

import fox.core.IUpdateable;
import fox.core.Trait;
import fox.math.Helper;
import fox.math.Quat;
import fox.math.Box3;
import fox.math.Ray;
import fox.Root;
import fox.trait.Input;
import fox.trait.Transform;
import fox.trait.SceneRenderer;
import fox.trait.RigidBody;

class CubeController extends Trait implements IUpdateable {

    @inject
    var transform:Transform;

    @inject
    var input:Input;

    @inject({asc:true,sibl:true})
    var scene:SceneRenderer;

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
                body.body.position.z = startZ + 0.05;
                body.body.isStatic = false;
            }
            picked = false;
            picking = false;
        }


        if (picked) {

            var v = getIntersect(boardTransform);

            if (v != null) {
                body.body.orientation.init(orient.w, orient.x, orient.y, orient.z);
                body.body.position.init(v.x, v.y, v.z + 5);
                body.body.isStatic = true;
            }
        }
    }

    function getIntersect(transform:Transform):fox.math.Vector3 {
        ray = Helper.getRay(input.x, input.y, scene.camera);

        var t = transform;
        var c = new fox.math.Vector3(t.absx, t.absy, t.absz);
        var s = new fox.math.Vector3(t.size.x * 2, t.size.y * 2, t.size.z);

        box.setFromCenterAndSize(c, s);

        return ray.intersectBox(box);
    }
}
