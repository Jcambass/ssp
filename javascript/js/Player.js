Player = function(texture, x, y) {
	this.Init(texture, x, y);
}

Player.prototype = new Enemy();
Player.prototype.constructor = Player;
Player.parent = Enemy.prototype;
Player.inheritFrom(Enemy);

Player.prototype.weaponStomp;
Player.prototype.weaponBlaster;
Player.prototype.weaponGrim;
Player.prototype.weaponHammer;
Player.prototype.weaponRatata;
Player.prototype.level;

//I know this already exists in Enemy() and Actor(), BUT I LIKE IT MORE THIS WAY!!!
Player.prototype.health = 100;
Player.prototype.speed = 5.618;

Player.prototype.Init = function(texture, x, y) {
	Player.parent.Init.call(this, texture, x, y, this.health, this.speed, 0, 0);
	this.level = 1;
	
	this.weaponMountPoint = new Point2D((texture.width/2) ,(texture.height/2));
	
	this.weaponStomp = new StompOMatic(imgStompWeapon.width/2, imgStompWeapon.height/2, this, true);
	this.weaponBlaster = new SpaceBlaster(imgGrimWeapon.width/2, imgGrimWeapon.height/2, this, true);
	this.weaponGrim = new GrimReaper(imgGrimWeapon.width/2, imgGrimWeapon.height/2, this, true);
	this.weaponHammer = new SpaceHammer(imgGrimWeapon.width/2, imgGrimWeapon.height/2, this, true);
	this.weaponRatata = new Ratata9000(imgGrimWeapon.width/2, imgGrimWeapon.height/2, this, true);

	this.currentWeapon = this.weaponStomp;
}


Player.prototype.Update = function() {
		
		//Check for game over conditions
		if(this.health <= 0 || earthHealth <= 0)
			DoGameOver();
			
		if(player.level*1000 < score) {
			DoLevelUp();
		}
		
		
		this.currentWeapon.Update();
		if(this.health <= 0) {
			this.bActive = false;
		}
		if (inputState.bLeftPressed) {
			this.x -= this.speed;
		}
		if (inputState.bRightPressed) {
			this.x += this.speed;
		}
		if (inputState.bUpPressed) {
			this.y -= this.speed;
		}
		if (inputState.bDownPressed) {
			this.y += this.speed;
		}
		//Weapons
		if(inputState.bOnePressed) {
			if(this.currentWeapon != this.weaponStomp) {
				this.currentWeapon = this.weaponStomp;
				msgDisplayTimeLeft = 40;
				message = "Stomp O´ Matic equipped";
			}
		}
		else if(inputState.bTwoPressed && this.level >= 2) {
			if(this.currentWeapon != this.weaponBlaster) {
				this.currentWeapon = this.weaponBlaster;
				msgDisplayTimeLeft = 40;
				message = "Space Blaster equipped";
			}
		}
		else if(inputState.bThreePressed && this.level >= 3) {
			if(this.currentWeapon != this.weaponGrim) {
				this.currentWeapon = this.weaponGrim;
				msgDisplayTimeLeft = 40;
				message = "Grim Reaper equipped";
			}
		}
		else if(inputState.bFourPressed && this.level >= 4) {
			if(this.currentWeapon != this.weaponHammer) {
				this.currentWeapon = this.weaponHammer;
				msgDisplayTimeLeft = 40;
				message = "Space Hammer equipped";
			}
		}
		else if(inputState.bFivePressed && this.level >= 5) {
			if(this.currentWeapon != this.weaponRatata) {
				this.currentWeapon = this.weaponRatata;
				msgDisplayTimeLeft = 40;
				message = "Ratata 9000 equipped";
			}
		}
		
		if(inputState.bFireToggled) {
			this.currentWeapon.Fire(true, this);
		}

		//Adjust players position (borders)
		if (player.x > mainScreen.width - player.texture.width)
			player.x = mainScreen.width - player.texture.width;
		else if (player.x < 0)
			player.x = 0;

		if (player.y > mainScreen.height - player.texture.height)
			player.y = mainScreen.height - player.texture.height;
		else if (player.y < 0)
			player.y = 0;
}





