package com.luboslenco.chess;

import fox.core.IUpdateable;
import fox.core.Trait;
import fox.trait.Input;
import fox.trait.Camera;
import fox.math.Vec3;

class CameraRotator extends Trait implements IUpdateable {

    @inject
    var camera:Camera;

    @inject
    var input:Input;

    public function new() {
        super();
    }

    public function update() {

        if (input.touch && !CubeController.picking) {

            var origin = new Vec3();
            var dist = fox.math.Helper.distance3d(camera.transform.pos, origin);

            camera.moveForward(dist);
            camera.pitch(fox.math.Math.degToRad(40));

            camera.roll(-input.deltaX / 200);

            camera.pitch(fox.math.Math.degToRad(-40));
            
            camera.moveForward(-dist);

            camera.moveForward(input.deltaY / 50);
        }

        /*if (input.touch) {

            camera.moveForward(fox.sys.Time.delta * 2);

            camera.roll(-input.deltaX / 200);
            camera.pitch(-input.deltaY / 200);
        }*/
    }
}
