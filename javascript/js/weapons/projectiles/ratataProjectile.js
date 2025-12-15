ratataProjectile = function(x, y, bFriendly) {
	this.Init(x, y, bFriendly);
}

ratataProjectile.prototype = new Projectile();
ratataProjectile.prototype.constructor = ratataProjectile;
ratataProjectile.parent = Projectile.prototype;
ratataProjectile.inheritFrom(Projectile);

ratataProjectile.prototype.damage = 3;

ratataProjectile.prototype.Init = function(x, y, bFriendly) {
	if(bFriendly)
		ratataProjectile.parent.Init.call(this, imgRatataProjectileUp, x, y, 15, 3, bFriendly);
	else
		ratataProjectile.parent.Init.call(this, imgRatataProjectileDown, x, y, 12, 3, bFriendly);
}