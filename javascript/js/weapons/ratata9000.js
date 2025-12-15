function Ratata9000(positionOffsetX, positionOffsetY, sender, bFriendly) {
	this.Init(positionOffsetX, positionOffsetY, sender, bFriendly);
}

Ratata9000.prototype = new Weapon();
Ratata9000.prototype.constructor = Ratata9000;
Ratata9000.parent = Weapon.prototype;
Ratata9000.inheritFrom(Weapon);

Ratata9000.prototype.Init = function(positionOffsetX, positionOffsetY, sender, bFriendly) {
	Ratata9000.parent.Init.call(this, imgRatataWeapon, new ratataProjectile(0, 0, bFriendly), sender, positionOffsetX, positionOffsetY ,[new Point2D(-6,0),new Point2D(6,0)], 4);
}

Ratata9000.prototype.Update = function(){
	if(this.currentCoolDown <= 0) {
		this.bCanFire = true;
	}
	else {
		this.currentCoolDown--;
	}
	if(this.projectile.bFriendly && !inputState.bToggleFireOnEnabled) {
		this.Fire(true);
	}
	
}

Ratata9000.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new ratataProjectile(this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
				this.sender.y + this.sender.weaponMountPoint.y + this.gunPositions[i].y - this.projectile.texture.height/2,
				this.projectile.bFriendly);
			}
		
		this.bCanFire = false;
		if(!bFriendly)
		this.currentCoolDown = this.coolDownTime*3;
		else
		this.currentCoolDown = this.coolDownTime;
	}
	


	
}