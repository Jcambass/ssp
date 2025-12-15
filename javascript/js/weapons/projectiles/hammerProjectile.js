hammerProjectile = function(x, y, bFriendly) {
	this.Init(x, y, bFriendly);
}

hammerProjectile.prototype = new Projectile();
hammerProjectile.prototype.constructor = hammerProjectile;
hammerProjectile.parent = Projectile.prototype;
hammerProjectile.inheritFrom(Projectile);

hammerProjectile.prototype.damage = 4;

hammerProjectile.prototype.Init = function(x, y, bFriendly) {	
	if(bFriendly)
		hammerProjectile.parent.Init.call(this, imgHammerProjectileUp, x, y, 10, 4, bFriendly);
	else
		hammerProjectile.parent.Init.call(this, imgHammerProjectileDown, x, y, 7, 4, bFriendly);
}

hammerProjectile.prototype.Update = function() {
			hammerProjectile.parent.Update.call(this);
			if(this.bFriendly) {
				for (var i = enemies.length - 1; i >= 0; --i) {
					enemyRect = new Rectangle(enemies[i].x, enemies[i].y, enemies[i].texture.width, enemies[i].texture.height);			
					projectileRect = new Rectangle(this.lastX, this.lastY,
											(this.x - this.lastX) + this.texture.width,
											(this.y - this.lastY) + this.texture.height);
					if (enemyRect.Intersects(projectileRect)) {
						enemies[i].y -= 36;
					}
				}
			}
			else {
				projectileRect = new Rectangle(this.lastX, this.lastY,
											(this.x - this.lastX) + this.texture.width,
											(this.y - this.lastY) + this.texture.height);
				playerRect = new Rectangle(player.x, player.y, player.texture.width, player.texture.height);								
			
				if (playerRect.Intersects(projectileRect)) {
					player.y += 36;
				}
			}
		
}