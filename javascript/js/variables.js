//BEGIN Globals
var mainScreen;
var ctxMain;

var score = 0;
var earthHealth = 5000;

//Images
var imgBackground = new Image();
var imgPlayer = new Image();
var imgExplosion = new Image();

//Ships
var imgBigShip = new Image();
var imgSpaceCrusaderShip = new Image();
var imgDarkLordShip = new Image();
var imgTrespasserShip = new Image();
var imgHeavyCarrierShip = new Image();

//Projectiles
var imgRatataProjectileUp = new Image();
var imgStompProjectileUp = new Image();
var imgBlasterProjectileUp = new Image();
var imgGrimProjectileUp = new Image();
var imgHammerProjectileUp = new Image();

var imgRatataProjectileDown = new Image();
var imgStompProjectileDown = new Image();
var imgBlasterProjectileDown = new Image();
var imgGrimProjectileDown = new Image();
var imgHammerProjectileDown = new Image();

//Weapons
var imgGrimWeapon = new Image();
var imgRatataWeapon = new Image();
var imgStompWeapon = new Image();
var imgHammerWeapon = new Image();
var imgBlasterWeapon = new Image();

//Obstacles
var imgStar = new Image();
var imgPlanet01 = new Image();
var imgPlanet02 = new Image();
var imgPlanet03 = new Image();
var imgPlanet04 = new Image();

var bGamePaused = false;
var bGameOver = false;
var bPlaying = false;

var nextEnemySpawn;
var minEnemySpawnDelay = 1000;
var maxEnemySpawnDelay = 5500;

var nextStarSpawn;
var minStarSpawnDelay = 1000;
var maxStarSpawnDelay = 2400;

var nextPlanetSpawn;
var minPlanetSpawnDelay = 80000;
var maxPlanetSpawnDelay = 240000;


//Ships N Stuff
var player;
var obstacles = [];
var enemies = [];
var projectiles = [];
var animations = [];

//Rectangles for Collision
var playerRect;
var enemyRect;
var projectileRect;

//Intervals
var starSpawnInterval;
var planetSpawnInterval;
var updateInterval;
var enemySpawnInterval;

//Input
var inputState;

//Message-System
var msgDisplayTimeLeft = 0;
var message;
