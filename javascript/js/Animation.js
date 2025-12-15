Animation = function(texture, x, y, fullAnimationTimeTime, frameCount, bLooping) {
	this.Init(texture, x, y, fullAnimationTimeTime, frameCount, bLooping);
}

Animation.prototype = new Actor();
Animation.prototype.constructor = Animation;
Animation.parent = Actor.prototype;
Animation.inheritFrom(Actor);

Animation.prototype.Init = function(texture, x, y, fullAnimationTimeTime, frameCount, bLooping) {
	this.frameCount = frameCount;
	this.bLooping = bLooping;
	this.fullAnimationTimeTime = fullAnimationTimeTime;
	this.currentFrameOffset = 0;
	this.singleFrameWidth = texture.width / frameCount;
	this.currentDisplayTime = 0;
	this.bActive = true;
	Animation.parent.Init.call(this, texture, x, y);
}

Animation.prototype.fullAnimationTimeTime;// = 1000/(40/frameCount);
Animation.prototype.currentDisplayTime = 0;
Animation.prototype.frameCount; //total frames
Animation.prototype.currentFrameOffset = 0; //0-7 if 8 frames
Animation.prototype.singleFrameWidth;
Animation.prototype.bActive;
Animation.prototype.bLooping = false;

Animation.prototype.Update = function(){
	if(this.fullAnimationTimeTime <= this.currentDisplayTime){
		this.currentDisplayTime = 0;
		
		if(this.currentFrameOffset >= this.frameCount-1){
			if(!this.bLooping){
				this.bActive = false; // Says: REMOVE ME!!!
			}
			this.currentFrameOffset = 0;
		}
		else{
			this.currentFrameOffset += 1;
		}
	}
	else{
		this.currentDisplayTime += 1;
	
	}
}

Animation.prototype.Draw = function(){
	this.drawContext.drawImage(this.texture, this.currentFrameOffset*this.singleFrameWidth, 0, this.texture.width / this.frameCount, this.texture.height, this.x, this.y, this.texture.width / this.frameCount, this.texture.height);
}
