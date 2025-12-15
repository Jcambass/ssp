BigShip = function(x, y) {
	this.Init(x, y);
}

BigShip.prototype = new Enemy();
BigShip.prototype.constructor = BigShip;
BigShip.parent = Enemy.prototype;
BigShip.inheritFrom(Enemy);

//I know this already exists in Enemy() and Actor(), BUT I LIKE IT MORE THIS WAY!!!
BigShip.prototype.health = 100;
BigShip.prototype.speed = 0.971;

BigShip.prototype.Init = function(x, y) {
	BigShip.parent.Init.call(this, imgBigShip, x, y, this.health, this.speed, 35, 120);
	this.minSpeed = this.speed - 0.03;
	this.maxSpeed = this.speed + 0.03;
	this.weaponMountPoint = new Point2D((imgBigShip.width/2) ,(imgBigShip.height/2));
	this.currentWeapon = new StompOMatic(imgStompWeapon.width/2, imgStompWeapon.height/2, this, false);
}
