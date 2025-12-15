grimProjectile = function(x, y, bFriendly) {
	this.Init(x, y, bFriendly);
}

grimProjectile.prototype = new Projectile();
grimProjectile.prototype.constructor = grimProjectile;
grimProjectile.parent = Projectile.prototype;
grimProjectile.inheritFrom(Projectile);

grimProjectile.prototype.damage = 40;

grimProjectile.prototype.Init = function(x, y, bFriendly) {
	if(bFriendly)
		grimProjectile.parent.Init.call(this, imgGrimProjectileUp, x, y, 5, 50, bFriendly);
	else
		grimProjectile.parent.Init.call(this, imgGrimProjectileDown, x, y, 4, 40, bFriendly);
}
