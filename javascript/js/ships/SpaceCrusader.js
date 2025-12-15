SpaceCrusader = function(x, y) {
	this.Init(x, y);
}

SpaceCrusader.prototype = new Enemy();
SpaceCrusader.prototype.constructor = SpaceCrusader;
SpaceCrusader.parent = Enemy.prototype;
SpaceCrusader.inheritFrom(Enemy);

SpaceCrusader.prototype.Init = function(x, y) {
	SpaceCrusader.parent.Init.call(this, imgSpaceCrusaderShip, x, y, 80, 1.001, 55, 180);
	this.minSpeed = this.speed - 0.04;
	this.maxSpeed = this.speed + 0.03;
	this.weaponMountPoint = new Point2D((imgSpaceCrusaderShip.width/2) ,(imgSpaceCrusaderShip.height/2));
	this.currentWeapon = new SpaceHammer(imgHammerWeapon.width/2, imgHammerWeapon.height/2, this, false); 
}
