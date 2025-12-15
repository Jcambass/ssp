Enemy = function(texture, x, y, health, speed, collisionDamage, bounty) {
	this.Init(texture, x, y, health, speed, collisionDamage, bounty);
}

Enemy.prototype = new Actor();
Enemy.prototype.constructor = Enemy;
Enemy.parent = Actor.prototype;
Enemy.inheritFrom(Actor);

Enemy.prototype.speed = 3.731;
Enemy.prototype.collisionDamage;
Enemy.prototype.bounty;
Enemy.prototype.weaponMountPoint; //By default centered (for debugging purposes)

Enemy.prototype.Init = function(texture, x, y, health, speed, collisionDamage, bounty) {
	Enemy.parent.Init.call(this, texture, x, y);
	this.health = health;
	this.collisionDamage = collisionDamage;
	this.speed = speed
	this.bounty = bounty;

}

Enemy.prototype.currentWeapon;
Enemy.prototype.minSpeed;
Enemy.prototype.maxSpeed;

Enemy.prototype.Update = function() {
	if(this.y > mainScreen.height) {
		this.bActive = false;
	}
	this.y += this.speed;
	this.currentWeapon.Update();
	
	if(this.y - this.texture.height/2 + 12 > 0) {  
		playerRect = new Rectangle(player.x, player.y, player.texture.width, player.texture.height);
		var aimRect  = new Rectangle(this.x, this.y, this.texture.width, mainScreen.height);
	
		if(playerRect.Intersects(aimRect)) {
			this.currentWeapon.Fire(false);
		}
	}
}

Enemy.prototype.Draw = function() {
	//Weapon

	this.drawContext.drawImage(this.currentWeapon.texture, 0, 0, 
								this.currentWeapon.texture.width, this.currentWeapon.texture.height, 
								this.x + this.weaponMountPoint.x - this.currentWeapon.positionOffsetX,
								this.y + this.weaponMountPoint.y - this.currentWeapon.positionOffsetY,
								this.currentWeapon.texture.width, this.currentWeapon.texture.height);
	//Actor							
	this.drawContext.drawImage(this.texture, 0, 0, this.texture.width, this.texture.height, this.x, this.y, this.texture.width, this.texture.height);
}