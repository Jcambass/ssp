function StompOMatic(positionOffsetX, positionOffsetY, sender, bFriendly) {
	this.Init(positionOffsetX, positionOffsetY, sender, bFriendly);
}

StompOMatic.prototype = new Weapon();
StompOMatic.prototype.constructor = StompOMatic;
StompOMatic.parent = Weapon.prototype;
StompOMatic.inheritFrom(Weapon);

StompOMatic.prototype.Init = function(positionOffsetX, positionOffsetY, sender, bFriendly) {
	StompOMatic.parent.Init.call(this, imgStompWeapon, new stompProjectile(0, 0, bFriendly), sender, positionOffsetX, positionOffsetY ,[new Point2D(0,0)], 5);
}

StompOMatic.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new stompProjectile(this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
				this.sender.y + this.sender.weaponMountPoint.y + this.gunPositions[i].y - this.projectile.texture.height/2,
				this.projectile.bFriendly);
			}
		
		this.bCanFire = false;
		if(!bFriendly)
		this.currentCoolDown = this.coolDownTime*4;
		else
		this.currentCoolDown = this.coolDownTime;
	}
	
}