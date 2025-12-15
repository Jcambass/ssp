function Weapon(texture, projectile, sender, positionOffsetX, positionOffsetY ,gunPositions, coolDownTime) {
	this.Init(texture, projectile, sender, positionOffsetX, positionOffsetY ,gunPositions, coolDownTime);
}

Weapon.prototype.Init = function(texture, projectile, sender, positionOffsetX, positionOffsetY ,gunPositions, coolDownTime) {
	this.texture = texture;
	this.projectile = projectile;
	
	this.sender = sender;
	
	this.positionOffsetX = positionOffsetX;
	this.positionOffsetY = positionOffsetY;
	
	this.gunPositions = gunPositions; //Array of Point2D (Y U NO HAVE TYPE SAFETY?!?!?)
	this.coolDownTime = coolDownTime;
	
	this.currentCoolDown = 0;
}

Weapon.prototype.texture;

Weapon.prototype.projectile;

Weapon.prototype.sender;
	
Weapon.prototype.positionOffsetX;
Weapon.prototype.positionOffsetY;
	
Weapon.prototype.gunPositions;
Weapon.prototype.coolDownTime;
	
Weapon.prototype.currentCoolDown;
Weapon.prototype.bCanFire;

Weapon.prototype.Update = function(){
	if(this.currentCoolDown <= 0) {
		this.bCanFire = true;
	}
	else {
		this.currentCoolDown--;
	}
}

Weapon.prototype.Fire = function(bFriendly) {
	if(this.bCanFire) {
			for(var i = 0; i < this.gunPositions.length; ++i) {
				projectiles[projectiles.length] = new Projectile(this.projectile.texture,
				this.sender.x + this.sender.weaponMountPoint.x + this.gunPositions[i].x - this.projectile.texture.width/2,
				this.sender.y + this.sender.weaponMountPoint.y + this.gunPositions[i].y - this.projectile.texture.height/2,
				this.projectile.speed, this.projectile.damage, bFriendly); 
			}
		
		this.bCanFire = false;
		if(!bFriendly)
		this.currentCoolDown = this.coolDownTime*2;
		else
		this.currentCoolDown = this.coolDownTime;
	}
	
}

