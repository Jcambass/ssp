Obstacle = function(texture, x, y, speed) {
	this.Init(texture, x, y, speed);
}

Obstacle.prototype = new Actor();
Obstacle.prototype.constructor = Obstacle;
Obstacle.parent = Actor.prototype;
Obstacle.inheritFrom(Actor);

Obstacle.prototype.Init = function(texture, x, y, speed) {
	Obstacle.parent.Init.call(this, texture, x, y);
	this.speed = speed;
	this.health = 0;
}

Obstacle.prototype.Update = function() {
	if(this.y < mainScreen.height)
		this.y += this.speed;
	else
		this.bActive =  false;
}