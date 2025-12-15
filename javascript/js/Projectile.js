Projectile = function(texture, x, y, speed, damage, bFriendly) {
	this.Init(texture, x, y, speed, damage, bFriendly);
}

Projectile.prototype = new Actor();
Projectile.prototype.constructor = Projectile;
Projectile.parent = Actor.prototype;
Projectile.inheritFrom(Actor);

Projectile.prototype.damage = 5;
Projectile.prototype.lastX;
Projectile.prototype.lastY;

Projectile.prototype.Init = function(texture, x, y, speed, damage, bFriendly) {
	Projectile.parent.Init.call(this, texture, x, y);
	this.bFriendly = bFriendly;
	this.health = 0;
	this.damage = damage;
	this.speed = speed; //20.whatever
	this.bActive = true;
	this.lastX = x;
	this.lastY = y;
}

Projectile.prototype.Update = function() {
		this.lastX = this.x;
		this.lastY = this.y;
		if(!(this.y > mainScreen.height || this.y <= 0)) {
			if(this.bFriendly) {
				this.y -= this.speed;
				
				for (var i = enemies.length - 1; i >= 0; --i) {
					enemyRect = new Rectangle(enemies[i].x, enemies[i].y, enemies[i].texture.width, enemies[i].texture.height);			
					projectileRect = new Rectangle(this.lastX, this.lastY,
											(this.x - this.lastX) + this.texture.width,
											(this.y - this.lastY) + this.texture.height);
					if (enemyRect.Intersects(projectileRect)) {
						enemies[i].health -= this.damage;
						this.bActive = false;
					}
				}
			}
			else {
				this.y += this.speed;
					
				projectileRect = new Rectangle(this.lastX, this.lastY,
											(this.x - this.lastX) + this.texture.width,
											(this.y - this.lastY) + this.texture.height);
				playerRect = new Rectangle(player.x, player.y, player.texture.width, player.texture.height);								
			
				if (playerRect.Intersects(projectileRect)) {
					player.health -= this.damage;
					this.bActive = false;
				}
			}
		}
		else {
			this.bActive = false;
		}
}
