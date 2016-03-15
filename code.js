
var clicked = false;

var timr;
	
var canvas = document.getElementById("colorPicker");
var context = canvas.getContext('2d');
	
canvas.addEventListener("mousedown", down);
canvas.addEventListener("touchstart", down);
canvas.addEventListener("mouseup", up);
canvas.addEventListener("touchend", up);
canvas.addEventListener("mouseleave", up);
canvas.addEventListener("touchleaveleave", up);
canvas.addEventListener("mousemove", changeColor);
canvas.addEventListener("touchmove", changeColor);

function resizeCanvas()
{
	canvas = document.getElementById("colorPicker");
	canvas.width = window.innerWidth*0.250;
	canvas.height = window.innerWidth*0.250;
	draw();
}

function draw(){	
	
	var centerX = canvas.width / 2;
	var centerY = canvas.height / 2;
	var innerRadius = canvas.width / 5;
	var outerRadius = (canvas.width - 10) / 2

	context.beginPath();
	context.arc(centerX, centerY, outerRadius, 0, 2 * Math.PI, false);
	context.lineWidth = 4;
	context.strokeStyle = '#000000';
	context.stroke();
	context.closePath();

	for (var angle = 0; angle <= 360; angle += 1) {
		var startAngle = (angle - 2) * Math.PI / 180;
		var endAngle = angle * Math.PI / 180;
		context.beginPath();
		context.moveTo(centerX, centerY);
		context.arc(centerX, centerY, outerRadius, startAngle, endAngle, false);
		context.closePath();
		context.fillStyle = 'hsl(' + angle + ', 100%, 50%)';
		context.fill();
		context.closePath();
	}

	context.beginPath();
	context.arc(centerX, centerY, innerRadius, 0, 2 * Math.PI, false);
	context.fillStyle = 'white';
	context.fill();

	context.lineWidth = 2;
	context.strokeStyle = '#000000';
	context.stroke();
	context.closePath();
}

function changeColor(event) {
    if(clicked){
		var pos = getPos(event);
		var color = context.getImageData(pos.x, pos.y, 1, 1).data;
		var colordata = {r: color[0],g: color[1],b: color[2]}
		clearTimeout(timr);
		timr = setTimeout(function() { sendCol(colordata); }, 50);    	
	}    
}

function getColorVal(){
	var color_rgb = hexToRgb(document.getElementById("CP").value);
	sendCol(color_rgb)
}

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}


function sendCol(colordata){
	var request = new XMLHttpRequest();
	///color?r=255&g=255&b=255
	var url = "/color?" + "r=" +  colordata.r + "&g=" + colordata.g + "&b=" + colordata.b;
	request.open('GET', url , true);
	request.send(null);
}

function down(event) {
	clicked = true;
	changeColor(event);
}

function up(event) {
	clicked = false;
}

function getPos(evt){
	var rect = canvas.getBoundingClientRect();
	var out = {x:0, y:0};
	if(
		evt.type == 'touchstart' ||
		evt.type == 'touchmove' ||
		evt.type == 'touchend' ||
		evt.type == 'touchcancel'){

		var touch = evt.originalEvent.touches[0] || evt.originalEvent.changedTouches[0];
		out.x = touch.pageX - rect.left;
		out.y = touch.pageY - rect.top;
	} else if (
		evt.type == 'mousedown' || 
		evt.type == 'mouseup' || 
		evt.type == 'mousemove' || 
		evt.type == 'mouseover' || 
		evt.type=='mouseout' ||
		evt.type=='mouseenter' ||
		evt.type=='mouseleave') {

		out.x = evt.pageX - rect.left;
		out.y = evt.pageY - rect.top;
	}
	return out;
}

function LedOFF(){
	var colordata = {r: 0,g: 0,b: 0}
    sendCol(colordata);
}

resizeCanvas();