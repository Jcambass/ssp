stompProjectile = function(x, y, bFriendly) {
	this.Init(x, y, bFriendly);
}

stompProjectile.prototype = new Projectile();
stompProjectile.prototype.constructor = stompProjectile;
stompProjectile.parent = Projectile.prototype;
stompProjectile.inheritFrom(Projectile);

stompProjectile.prototype.damage = 4;

stompProjectile.prototype.Init = function(x, y, bFriendly) {
	if(bFriendly)
		stompProjectile.parent.Init.call(this, imgStompProjectileUp, x, y, 13, 6, bFriendly);
	else
		stompProjectile.parent.Init.call(this, imgStompProjectileDown, x, y, 10, 6, bFriendly);
}