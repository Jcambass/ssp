InputState = function() {
	this.Init();
}

InputState.prototype.Init = function() {
	//Movement
	this.bLeftPressed = false;
	this.bRightPressed = false;
	this.bUpPressed = false;
	this.bDownPressed = false;
	
	this.bOnePressed = false;
	this.bTwoPressed = false;
	this.bThreePressed = false;
	this.bFourPressed = false;
	this.bFivePressed = false;
	
	this.bFireToggled = false;
	this.bToggleFireOnEnabled = true;
	
	this.bEscPressed = false;
	this.bToggleEscOnEnabled = true;
	
	document.addEventListener('keydown', this.OnKeyDown, false);
	document.addEventListener('keyup', this.OnKeyUp, false);
}


InputState.prototype.OnKeyDown = function(e){
	var keyID = e.keyCode || e.which;
    if (/*keyID === 38 ||*/ keyID === 87) { // 38 = Up, 87 = W
        inputState.bUpPressed = true;
		stopDefault();
    }
    if (/*keyID === 39 ||*/ keyID === 68) { // 38 = Right, 87 = D
        inputState.bRightPressed = true;
		stopDefault();
    }
    if (/*keyID === 40 ||*/ keyID === 83) { // 38 = Down, 87 = S
        inputState.bDownPressed = true;
		stopDefault();
		
    }
    if (/*keyID === 37 ||*/ keyID === 65) { // 38 = Left, 87 = A
        inputState.bLeftPressed = true;
		stopDefault();
    }
	if (keyID === 49) { //1
        inputState.bOnePressed = true;
		stopDefault();
    }
	if (keyID === 50) { //2
        inputState.bTwoPressed = true;
		stopDefault();
    }
	if (keyID === 51) { //3
        inputState.bThreePressed = true;
		stopDefault();
    }
	if (keyID === 52) { //4
        inputState.bFourPressed = true;
		stopDefault();
    }
	if (keyID === 53) { //5
        inputState.bFivePressed = true;
		stopDefault();
    }
	if (keyID === 74) { // 106 = J
		inputState.bFireToggled = false;
		if(inputState.bToggleFireOnEnabled) {
			inputState.bFireToggled = true;
			inputState.bToggleFireOnEnabled = false;
			//player.currentWeapon.Fire();
		}
		stopDefault();
    }
	if(keyID === 27) { // 27 = Esc
		inputState.bEscPressed = false;
		if(inputState.bToggleEscOnEnabled) {
			inputState.bEscPressed = true;
		}
			//Pausing and resuming has to be handled right in the event, 
			//because a paused game won't update and check, if the ESC-key was pressed again.
			if(inputState.bEscPressed) {
				if(bPlaying) {
					PauseGame();
				}
				else {
					ResumeGame();
				}
			}
		stopDefault();
	}
	return false;
}

InputState.prototype.OnKeyUp = function(e){
	//Determine keyCode
    var keyID = e.keyCode || e.which;
    if (/*keyID === 38 ||*/ keyID === 87) { // 38 = Up, 87 = W
        inputState.bUpPressed = false;
		stopDefault();
    }
    if (/*keyID === 39 ||*/ keyID === 68) { // 38 = Right, 87 = D
        inputState.bRightPressed = false;
		stopDefault();
    }
    if (/*keyID === 40 ||*/ keyID === 83) { // 38 = Down, 87 = S
        inputState.bDownPressed = false;
		stopDefault();
    }
    if (/*keyID === 37 ||*/ keyID === 65) { // 38 = Left, 87 = A
        inputState.bLeftPressed = false;
		stopDefault();
    }
	if (keyID === 49) { //1
        inputState.bOnePressed = false;
		stopDefault();
    }
	if (keyID === 50) { //2
        inputState.bTwoPressed = false;
		stopDefault();
    }
	if (keyID === 51) { //3
        inputState.bThreePressed = false;
		stopDefault();
    }
	if (keyID === 52) { //4
        inputState.bFourPressed = false;
		stopDefault();
    }
	if (keyID === 53) { //5
        inputState.bFivePressed = false;
		stopDefault();
    }
	if (keyID === 74) { // 106 = J
		inputState.bFireToggled = false;
		inputState.bToggleFireOnEnabled = true;
		stopDefault();
    }
	if(keyID === 27) { // 27 = Esc
		inputState.bEscPressed = false;
		inputState.bToggleEscOnEnabled = true;
		stopDefault();
	}
	return false;
}

InputState.prototype.Reset = function() {
	this.bFireToggled = false;
	this.bEscPressed = false;
}


