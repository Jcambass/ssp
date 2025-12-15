function UpdateCollision() {
	
	playerRect = new Rectangle(player.x, player.y, player.texture.width, player.texture.height);
    for (var i = enemies.length - 1; i >= 0; --i) {
        enemyRect = new Rectangle(enemies[i].x, enemies[i].y, enemies[i].texture.width, enemies[i].texture.height);
        if (playerRect.Intersects(enemyRect)) {
            player.health -= enemies[i].collisionDamage;
			enemies[i].health = 0;
            enemies[i].bActive = false;
        }
    }
}

function UpdateProjectiles(){
	for (var i = projectiles.length-1; i >= 0; --i) {
		if(!projectiles[i].bActive) {
			projectiles.splice(i, 1);
		}
		else {
			projectiles[i].Update();
		}
    }
}

function UpdateAnimations(){
	for(var i = animations.length-1; i >= 0; --i) {
		if(!animations[i].bActive){
			animations.splice(i,1);
		}
		else{
			animations[i].Update();
		}
	}
}

function UpdateEnemies() {
    for (var i = enemies.length-1; i >= 0; --i) {
		enemies[i].Update();
		if(enemies[i].health <= 0) {
			score += enemies[i].bounty;
			enemies[i].bActive = false;
			animations[animations.length] = new Animation(imgExplosion, ((enemies[i].x)+enemies[i].texture.width/2)-((imgExplosion.width/12)/2), ((enemies[i].y)+enemies[i].texture.height/2)-((imgExplosion.height)/2), 1, 12, false);
		}
		if(!enemies[i].bActive && enemies[i].health > 0) {
			enemies.splice(i, 1);
			earthHealth -= enemies[i].collisionDamage*3;
		}
		else if(!enemies[i].bActive) {
			enemies.splice(i, 1);
		}
    }
}

function UpdateObstacles() {
	for(var i = obstacles.length-1; i >= 0; --i) {
		obstacles[i].Update();
		if(!obstacles[i].bActive) {
			obstacles.splice(i, 1);
		}
	}	
}