Star = function(x, y) {
	this.Init(x, y);
}

Star.prototype = new Obstacle();
Star.prototype.constructor = Star;
Star.parent = Obstacle.prototype;
Star.inheritFrom(Obstacle);

Star.prototype.Init = function(x, y) {
	Star.parent.Init.call(this, imgStar, x, y, 0.413);
}
