Trespasser = function(x, y) {
	this.Init(x, y);
}

Trespasser.prototype = new Enemy();
Trespasser.prototype.constructor = Trespasser;
Trespasser.parent = Enemy.prototype;
Trespasser.inheritFrom(Enemy);

Trespasser.prototype.Init = function(x, y) {
	Trespasser.parent.Init.call(this, imgTrespasserShip, x, y, 30, 1.53, 13, 35);
	this.minSpeed = this.speed - 0.09;
	this.maxSpeed = this.speed + 0.07;
	this.weaponMountPoint = null;
	this.currentWeapon = null;
}


Trespasser.prototype.Update = function() {
	if(this.y > mainScreen.height) {
		this.bActive = false;
	}
	this.y += this.speed;
}

Trespasser.prototype.Draw = function() {
	this.drawContext.drawImage(this.texture, 0, 0, this.texture.width, this.texture.height, this.x, this.y, this.texture.width, this.texture.height);
}