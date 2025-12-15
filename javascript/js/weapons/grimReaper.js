function GrimReaper(positionOffsetX, positionOffsetY, sender, bFriendly) {
	this.Init(positionOffsetX, positionOffsetY, sender, bFriendly);
}

GrimReaper.prototype = new Weapon();
GrimReaper.prototype.constructor = GrimReaper;
GrimReaper.parent = Weapon.prototype;
GrimReaper.inheritFrom(Weapon);

GrimReaper.prototype.Init = function(positionOffsetX, positionOffsetY, sender, bFriendly) {
	GrimReaper.parent.Init.call(this, imgGrimWeapon, new grimProjectile(0, 0, bFriendly), sender, positionOffsetX, positionOffsetY ,[new Point2D(0,0)], 2500/40);
}

GrimReaper.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new grimProjectile(this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
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