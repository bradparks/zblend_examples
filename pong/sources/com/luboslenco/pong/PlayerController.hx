package com.luboslenco.pong;

import fox.core.Trait;
import fox.core.IUpdateable;
import fox.math.Math;
import fox.trait.Input;
import fox.trait.Transform;
import fox.Root;

class PlayerController extends Trait implements IUpdateable {

    @inject
    var input:Input;
    
    @inject
    var transform:Transform;

    public function new() {
        super();
    }
    
    public function update() {
        transform.y = (-(input.y / Root.h) * 2 + 1) * 8;
        transform.y = Math.clamp(transform.y, -6, 6);
    }
}
