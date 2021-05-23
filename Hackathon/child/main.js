const mouse = {
	x: 0,
	y: 0,
}

const windim = {
	width: window.innerWidth,
	height: window.innerHeight,
}
const getWindowRatio = () => windim.width / windim.height;


window.addEventListener('resize', ev => {
	windim.width = window.innerWidth;
	windim.height = window.innerHeight;
	
	if (naturalRatio> getWindowRatio()) {
		// image too wide
		bg.style.height = `100vh`;
		bg.style.width = '';
		
	} else {
		// image too high
		bg.style.width = `100vw`;
		bg.style.height = '';
	}
})

/** @type {HTMLImageElement} */
const bg = document.querySelector("img#bg");

const {naturalHeight, naturalWidth} = bg;
const naturalRatio = naturalWidth / naturalHeight;
document.body.style.setProperty('--natural-ratio', naturalRatio)

if (naturalRatio > getWindowRatio()) {
	// image too wide
	bg.style.height = `100vh`;
	bg.style.width = '';
	
} else {
	// image too high
	bg.style.width = `100vw`;
	bg.style.height = '';
}

document.body.addEventListener("mousemove", ev => {
	mouse.x = ev.clientX;
	mouse.y = ev.clientY;
	
	if (naturalRatio > getWindowRatio()) {
		// image too wide
		const deltaX = naturalRatio * windim.height - windim.width;
		document.body.style.setProperty('--bg-left', `-${deltaX * mouse.x / windim.width}px`)
		document.body.style.setProperty('--bg-top', `0px`)
	} else {
		// image too high
		const deltaY = windim.width / naturalRatio - windim.height;
		document.body.style.setProperty('--bg-left', `0px`)
		document.body.style.setProperty('--bg-top', `-${deltaY * mouse.y / windim.height}px`)
	}
})