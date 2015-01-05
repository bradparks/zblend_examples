package com.luboslenco.test;

import fox.core.Trait;
import fox.core.IUpdateable;
import fox.math.Math;
import fox.math.Vec3;
import fox.trait.Transform;
import fox.trait.RigidBody;
import fox.Root;

class BallController extends Trait implements IUpdateable {
    
    @inject
    var transform:Transform;

    @inject
    var body:RigidBody;

    public function new() {
        super();
        
        Root.registerInit(resetBall);
    }
    
    function resetBall() {
        transform.pos.set(0, 0, 0);

        var forceX = Std.random(2) == 0 ? -10 : 10;
        var forceY = Std.random(100) / 10 - 5;
        body.setImpulse(transform.pos, new Vec3(forceX, forceY, 0));
    }
    
    public function update() {

        if (body.collided) {
            var vel = body.body.linearVelocity;
            vel.x *= 5;
            vel.y *= 5;
            
            vel.x = Math.clamp(vel.x, -20, 20);
            vel.y = Math.clamp(vel.y, -20, 20);
        }
        
        // Out of screen
        if (transform.x < -15 || transform.x > 15 ||
            transform.y < -15 || transform.y > 15) resetBall();
    }
}
