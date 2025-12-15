function SpaceHammer(positionOffsetX, positionOffsetY, sender, bFriendly) {
	this.Init(positionOffsetX, positionOffsetY, sender, bFriendly);
}

SpaceHammer.prototype = new Weapon();
SpaceHammer.prototype.constructor = SpaceHammer;
SpaceHammer.parent = Weapon.prototype;
SpaceHammer.inheritFrom(Weapon);

SpaceHammer.prototype.Init = function(positionOffsetX, positionOffsetY, sender, bFriendly) {
	SpaceHammer.parent.Init.call(this, imgHammerWeapon, new hammerProjectile(0, 0, bFriendly), sender, positionOffsetX, positionOffsetY ,[new Point2D(-24,0), new Point2D(0,0), new Point2D(24,0)], 2000/40);
}

SpaceHammer.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new hammerProjectile(this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
				this.sender.y + this.sender.weaponMountPoint.y + this.gunPositions[i].y - this.projectile.texture.height/2,
				this.projectile.bFriendly);
			}
		
		this.bCanFire = false;
		if(!bFriendly)
		this.currentCoolDown = this.coolDownTime*2;
		else
		this.currentCoolDown = this.coolDownTime;
	}
	
}