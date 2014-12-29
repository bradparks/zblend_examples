package com.luboslenco.test;

import fox.core.Trait;
import fox.core.IUpdateable;
import fox.math.Math;
import fox.sys.Time;
import fox.trait.Transform;
import fox.trait.RigidBody;
import fox.Root;

class AIController extends Trait implements IUpdateable {
    
    @inject
    var transform:Transform;
    var ballTransform:Transform;

    @inject
    var body:RigidBody;

    public function new() {
        super();

        Root.registerInit(init);
    }

    function init() {
        ballTransform = Root.getChild("Ball").getTrait(Transform);
    }
    
    public function update() {

        if (Math.abs(transform.y - ballTransform.y) > 0.1) {

            var side = (transform.y > ballTransform.y) ? -1 : 1;
            
            transform.y += 15 * Time.delta * side;
            transform.y = Math.clamp(transform.y, -6, 6);
            
            body.syncBody();
        }
    }
}
