Actor = function(texture, x, y) {
	this.Init(texture, x, y);
}

Actor.prototype.health = 100;
Actor.prototype.bActive = true; //If false: delete me!

Actor.prototype.Init = function(texture, x, y) {
	if(this.drawContext === undefined) {
		Actor.prototype.drawContext = document.getElementById('mainScreen').getContext('2d');
	}
	this.texture = texture;
	this.x = x;
	this.y = y;
	this.bActive = true;
}


Actor.prototype.Update = function(){
	return false;
}

Actor.prototype.Draw = function () {
        this.drawContext.drawImage(this.texture, 0, 0, this.texture.width, this.texture.height, this.x, this.y, this.texture.width, this.texture.height);
}