//Initialisation
onload = function () {
	//Get the mainScreen canvas and its context
    mainScreen = document.getElementById('mainScreen');
    ctxMain = mainScreen.getContext('2d');

    //Load Image Ressources
	imgBackground.src = 'images/background.png';
    imgPlayer.src = 'images/player.png';
	imgExplosion.src = 'images/explosion.png';

	//Ships
	imgBigShip.src = 'images/ships/bigShip.png';
	imgSpaceCrusaderShip.src = 'images/ships/spaceCrusader.png';
	imgDarkLordShip.src = 'images/ships/darkLord.png';
	imgTrespasserShip.src = 'images/ships/trespasser.png';
	imgHeavyCarrierShip.src = 'images/ships/heavyCarrier.png';

	//Projectiles
	imgRatataProjectileUp.src = 'images/projectiles/ratataUp.png';
	imgStompProjectileUp.src = 'images/projectiles/stompUp.png';
	imgBlasterProjectileUp.src = 'images/projectiles/blasterUp.png';
	imgGrimProjectileUp.src = 'images/projectiles/grimUp.png';
	imgHammerProjectileUp.src = 'images/projectiles/hammerUp.png';

	imgRatataProjectileDown.src = 'images/projectiles/ratataDown.png';
	imgStompProjectileDown.src = 'images/projectiles/stompDown.png';
	imgBlasterProjectileDown.src = 'images/projectiles/blasterDown.png';
	imgGrimProjectileDown.src = 'images/projectiles/grimDown.png';
	imgHammerProjectileDown.src = 'images/projectiles/hammerDown.png';

	//Weapons
	imgGrimWeapon.src = 'images/weapons/grimReaper.png';
	imgRatataWeapon.src = 'images/weapons/grimReaper.png';
	imgStompWeapon.src = 'images/weapons/stompOMatic.png';
	imgHammerWeapon.src = 'images/weapons/spaceHammer.png';
	imgBlasterWeapon.src = 'images/weapons/spaceBlaster.png';

	//Obstacles
	imgStar.src = 'images/obstacles/star.png';
	imgPlanet01.src = 'images/obstacles/planet01.png';
	imgPlanet02.src = 'images/obstacles/planet02.png';
	imgPlanet03.src = 'images/obstacles/planet03.png';
	imgPlanet04.src = 'images/obstacles/planet04.png';

    //Create new Player
    player = new Player(imgPlayer, mainScreen.width / 2 - imgPlayer.width / 2, mainScreen.height - imgPlayer.height - 30);

	//New InputState
	inputState = new InputState();

	//Defining styles
    ctxMain.font = '32px Impact';
    ctxMain.fillStyle = "white";

	//Add some stars
	for(var i = 0; i < 30; ++i) {
		obstacles[obstacles.length] = new Obstacle(imgStar, Math.floor(Math.random() * (mainScreen.width - imgStar.width)), Math.floor(Math.random() * (mainScreen.height)), 0.43);
	}

	msgDisplayTimeLeft = 170;
	message = 'PROTECT EARTH AS LONG AS YOU CAN!!!';

	//Start the actual game
    StartLoop();
}

//BEGIN FPS DISPLAY!!!
var filterStrength = 20;
var frameTime = 0, lastLoop = new Date, thisLoop;
//END FPS DISPLAY!!!

//GameLoop
function StartLoop(){
	bPlaying = true;

	//Set the updateInterval to 40fps
	updateInterval = setInterval(Update, 1000/40);
	enemySpawnInterval = setInterval(AddEnemy, nextEnemySpawn);
	starSpawnInterval = setInterval(AddStar, nextStarSpawn);
	planetSpawnInterval = setInterval(AddPlanet, nextPlanetSpawn);

	//Execute the loop
	Loop();
}

function ResumeGame() {
	if(!bGameOver){
		bGamePaused = false;
		StartLoop();
	}
}

function PauseGame() {
	bGamePaused = true;
	if(!bGameOver) {
		message = "GAME PAUSED";
		msgDisplayTimeLeft = 2;
		Draw();
	}
	StopLoop();
}


function Loop() {
	if(bPlaying){
		UpdateAnimations(); //For better performance on animations (faster than updates -> ~60fps)
		Draw();
		RequestAnimationFrame(Loop);
	}
}


function DoGameOver() {
	bGameOver = true;
	PauseGame();
	Draw();
	ctxMain.font = '42px Impact';
	ctxMain.fillText('GAME OVER!',mainScreen.width/2-ctxMain.measureText('GAME OVER!').width/2,250);
	ctxMain.fillText('YOUR SCORE: '+score,mainScreen.width/2-ctxMain.measureText('YOUR SCORE'+score).width/2,290);
}

function DoWinGame() {
	bGameOver = true;
	PauseGame();
	Draw();
	ctxMain.font = '42px Impact';
	ctxMain.fillText('VICTORY - YOU HAVE SUCCESSFULLY PROTECTED EARTH!!!',mainScreen.width/2-ctxMain.measureText('VICTORY!!! YOU HAVE SUCCESSFULLY PROTECTED EARTH!').width/2,250);
	ctxMain.fillText('YOUR SCORE: '+score,mainScreen.width/2-ctxMain.measureText('YOUR SCORE'+score).width/2,290);
	ctxMain.fillText('YOUR FINAL SCORE: '+(score+earthHealth+player.health),mainScreen.width/2-ctxMain.measureText('YOUR FINAL SCORE: '+(score+earthHealth+player.health)).width/2,330);
}

function DoLevelUp() {
	if(player.level < 5) {
		player.level++;
		msgDisplayTimeLeft = 120;
		message = 'LEVEL UP! New weapon in slot ' + player.level + ' unlocked.';
	}
}


function StopLoop() {
	bPlaying = false;
	clearInterval(enemySpawnInterval);
	clearInterval(starSpawnInterval);
	clearInterval(planetSpawnInterval);
	clearInterval(updateInterval);
}
//END GameLoop


//BEGIN Update & Draw
function Update() {

	//UPDATE ALL THE STUFF!
	UpdateObstacles();
    UpdateEnemies();
	player.Update();
	UpdateProjectiles();
	UpdateCollision();

	inputState.Reset();

	if(msgDisplayTimeLeft > 0)
		--msgDisplayTimeLeft;

	//Check if the player has already won
	if(score >= 8000)
		DoWinGame();

	//FPS Stuff
	var thisFrameTime = (thisLoop=new Date) - lastLoop;
	frameTime+= (thisFrameTime - frameTime) / filterStrength;
	lastLoop = thisLoop;
}
function Draw() {
    //Clear everything
    ctxMain.clearRect(0, 0, mainScreen.width, mainScreen.height);

    //Background
	ctxMain.drawImage(imgBackground, 0, 0, imgBackground.width, imgBackground.height, 0, 0, imgBackground.width, imgBackground.height);

	//Obstacles
	for(var i = 0; i < obstacles.length; ++i) {
		if (obstacles[i].speed <= 0.45)
		obstacles[i].Draw();
	}
	for(var i = 0; i < obstacles.length; ++i) {
		if (obstacles[i].speed >= 0.45)
		obstacles[i].Draw();
	}

	//Enemies
    for(var i = 0; i < enemies.length; ++i) {
        enemies[i].Draw();
    }

	//Projectiles
	for(var i = 0; i < projectiles.length; ++i) {
        projectiles[i].Draw();
    }

    //The player
    player.Draw();

	//Animations
	for(var i = 0; i < animations.length; ++i) {
        animations[i].Draw();
    }

	//Basic HUD. !VERY! basic
    ctxMain.fillText('Health: ' + player.health, mainScreen.width/2 - ctxMain.measureText('Health: ' + player.health).width/2, mainScreen.height - 12);
    ctxMain.fillText('Score: ' + score,10, 32+4);
	ctxMain.fillText('Earth Health: ' + earthHealth, mainScreen.width/2 - ctxMain.measureText('Earth Health: ' + earthHealth).width/2, 4+32);

	//Display message if available
	if(msgDisplayTimeLeft > 0) {
		ctxMain.fillText(message, mainScreen.width/2-ctxMain.measureText(message).width/2,270);
	}
}
//END Update & Draw


//Function, which adds a new enemy to the enemies
function AddEnemy() {
	var tmpEnemy;

	var nextEnemyType = Math.floor(Math.random() * 100);
	if(nextEnemyType < 45) {
		tmpEnemy = new Trespasser(Math.floor(Math.random() * (mainScreen.width - imgTrespasserShip.width)), -imgTrespasserShip.height);
	}
	else if(nextEnemyType < 70) {
		tmpEnemy = new SpaceCrusader(Math.floor(Math.random() * (mainScreen.width - imgHeavyCarrierShip.width)), -imgHeavyCarrierShip.height);
	}
	else if(nextEnemyType < 95) {
		tmpEnemy = new BigShip(Math.floor(Math.random() * (mainScreen.width - imgBigShip.width)), -imgBigShip.height);
	}
	else {
		tmpEnemy = new DarkLord(Math.floor(Math.random() * (mainScreen.width - imgDarkLordShip.width)), -imgDarkLordShip.height);
	}

	//Assign a new random speed between the min and max speed of the enemy
	var randomSpeed = Math.floor(Math.random() * tmpEnemy.maxSpeed);
    if (randomSpeed > tmpEnemy.minSpeed)
        tmpEnemy.speed = randomSpeed;
    else
        tmpEnemy.speed = tmpEnemy.minSpeed;

	//Set the enemys weaponPositionOffset centered
	if(tmpEnemy.currentWeapon != null) {
		tmpEnemy.currentWeapon.positionOffsetX = tmpEnemy.currentWeapon.texture.width/2;
		tmpEnemy.currentWeapon.positionOffsetY = tmpEnemy.currentWeapon.texture.height/2;
	}

	//Add the new enemy to the list
    enemies[enemies.length] = tmpEnemy;

    //Setting a new random time for the next enemy spawning
    clearInterval(enemySpawnInterval);
    nextEnemySpawn = Math.floor(Math.random() * maxEnemySpawnDelay);
    if (nextEnemySpawn > minEnemySpawnDelay)
        enemySpawnInterval = setInterval(AddEnemy, nextEnemySpawn);
    else
        enemySpawnInterval = setInterval(AddEnemy, minEnemySpawnDelay);
}

function AddStar() {
	var tmpStar = new Star(Math.floor(Math.random() * (mainScreen.width - imgStar.width)), -imgStar.height);

	obstacles[obstacles.length] = tmpStar;

	//Set the next spawn interval
	clearInterval(starSpawnInterval);
    nextStarSpawn = Math.floor(Math.random() * maxStarSpawnDelay);
    if (nextStarSpawn > minStarSpawnDelay)
        starSpawnInterval = setInterval(AddStar, nextStarSpawn);
    else
        starSpawnInterval = setInterval(AddStar, minStarSpawnDelay);
}

function AddPlanet() {
	var tmpPlanet;
	var planetType = Math.floor(Math.random() * 4);

	if(planetType == 1) {
		tmpPlanet = new Planet(imgPlanet01, Math.floor(Math.random() * (mainScreen.width - imgPlanet01.width)), -imgPlanet01.height);
	}
	else if(planetType == 2) {
		tmpPlanet = new Planet(imgPlanet02, Math.floor(Math.random() * (mainScreen.width - imgPlanet02.width)), -imgPlanet02.height);
	}
	else if(planetType == 3) {
		tmpPlanet = new Planet(imgPlanet03, Math.floor(Math.random() * (mainScreen.width - imgPlanet03.width)), -imgPlanet03.height);
	}
	else {
		tmpPlanet = new Planet(imgPlanet04, Math.floor(Math.random() * (mainScreen.width - imgPlanet04.width)), -imgPlanet04.height);
	}
	obstacles[obstacles.length] = tmpPlanet;

	//Set the next spawn interval
	clearInterval(planetSpawnInterval);
    nextPlanetSpawn = Math.floor(Math.random() * maxPlanetSpawnDelay);
    if (nextPlanetSpawn > minPlanetSpawnDelay)
        planetSpawnInterval = setInterval(AddPlanet, nextPlanetSpawn);
    else
        planetSpawnInterval = setInterval(AddPlanet, minPlanetSpawnDelay);
}





