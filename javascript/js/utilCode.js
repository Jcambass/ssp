Function.prototype.inheritFrom = function(object){
	for(var property in object.prototype){
		this.prototype[property] = object.prototype[property];
	}
}

//Wrapper für preventDefault und window.event.returnValue
function stopDefault(evt) {
    if (evt && evt.preventDefault) {
        evt.preventDefault();
    } else if (window.event && window.event.returnValue) {
        window.event.returnValue = false;
    }
}

//API-call für flüssigw Animationswiedergabe
var RequestAnimationFrame = window.requestAnimationFrame ||
							window.webkitRequestAnimationFrame ||
							window.mozRequestAnimationFrame ||
							window.msRequestAnimationFrame ||
							window.oRequestAnimationFrame;