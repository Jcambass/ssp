function SpaceBlaster(positionOffsetX, positionOffsetY, sender, bFriendly) {
	this.Init(positionOffsetX, positionOffsetY, sender, bFriendly);
}

SpaceBlaster.prototype = new Weapon();
SpaceBlaster.prototype.constructor = SpaceBlaster;
SpaceBlaster.parent = Weapon.prototype;
SpaceBlaster.inheritFrom(Weapon);

SpaceBlaster.prototype.Init = function(positionOffsetX, positionOffsetY, sender, bFriendly) {
	SpaceBlaster.parent.Init.call(this, imgHammerWeapon, new blasterProjectile(0, 0, bFriendly), sender, positionOffsetX, positionOffsetY ,[new Point2D(0,0)], 2300/40);
}

SpaceBlaster.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new blasterProjectile(this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
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