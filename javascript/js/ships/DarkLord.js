DarkLord = function(x, y) {
	this.Init(x, y);
}

DarkLord.prototype = new Enemy();
DarkLord.prototype.constructor = DarkLord;
DarkLord.parent = Enemy.prototype;
DarkLord.inheritFrom(Enemy);

DarkLord.prototype.Init = function(x, y) {
	DarkLord.parent.Init.call(this, imgDarkLordShip, x, y, 250, 0.63, 75, 250);
	this.minSpeed = this.speed - 0.03;
	this.maxSpeed = this.speed + 0.05;
	this.weaponMountPoint = new Point2D((imgDarkLordShip.width/2) ,(imgDarkLordShip.height/2));
	this.currentWeapon = new GrimReaper(imgGrimWeapon.width/2, imgGrimWeapon.height/2, this, false); 
}
