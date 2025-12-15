blasterProjectile = function(x, y, bFriendly) {
	this.Init(x, y, bFriendly);
}

blasterProjectile.prototype = new Projectile();
blasterProjectile.prototype.constructor = blasterProjectile;
blasterProjectile.parent = Projectile.prototype;
blasterProjectile.inheritFrom(Projectile);

blasterProjectile.prototype.damage = 15;

blasterProjectile.prototype.Init = function(x, y, bFriendly) {
	if(bFriendly)
		blasterProjectile.parent.Init.call(this, imgBlasterProjectileUp, x, y, 15, 12, bFriendly);
	else
		blasterProjectile.parent.Init.call(this, imgBlasterProjectileDown, x, y, 10, 12, bFriendly);
}

blasterProjectile.prototype.Update = function() {
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
						player.health += 2;
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