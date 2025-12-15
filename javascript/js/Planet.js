Planet = function(texture, x, y) {
	this.Init(texture, x, y);
}

Planet.prototype = new Obstacle();
Planet.prototype.constructor = Planet;
Planet.parent = Obstacle.prototype;
Planet.inheritFrom(Obstacle);

Planet.prototype.Init = function(texture, x, y) {
	Planet.parent.Init.call(this, texture, x, y, 0.47);
}
