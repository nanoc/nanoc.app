// IXF1.11 :: Image cross-fade 
// *****************************************************
// DOM scripting by brothercake -- http://www.brothercake.com/
//******************************************************
//global object
var ixf = { 'clock' : null, 'count' : 1 }
/*******************************************************



/*****************************************************************************
 List the images that need to be cached
*****************************************************************************/

ixf.imgs = [
	'/assets/images/slideshow/0.png',
	'/assets/images/slideshow/1.png',
	'/assets/images/slideshow/2.png',
	'/assets/images/slideshow/3.png'
	];

/*****************************************************************************
*****************************************************************************/



//cache the images
ixf.imgsLen = ixf.imgs.length;
ixf.cache = [];
for(var i=0; i<ixf.imgsLen; i++)
{
	ixf.cache[i] = new Image;
	ixf.cache[i].src = ixf.imgs[i];
}


//crossfade setup function
function crossfade()
{
	//if the timer is not already going
	if(ixf.clock == null)
	{
		//copy the image object 
		ixf.obj = arguments[0];
		
		//copy the image src argument 
		ixf.src = arguments[1];
		
		//store the supported form of opacity
		if(typeof ixf.obj.style.opacity != 'undefined')
		{
			ixf.type = 'w3c';
		}
		else if(typeof ixf.obj.style.MozOpacity != 'undefined')
		{
			ixf.type = 'moz';
		}
		else if(typeof ixf.obj.style.KhtmlOpacity != 'undefined')
		{
			ixf.type = 'khtml';
		}
		else if(typeof ixf.obj.filters == 'object')
		{
			//weed out win/ie5.0 by testing the length of the filters collection (where filters is an object with no data)
			//then weed out mac/ie5 by testing first the existence of the alpha object (to prevent errors in win/ie5.0)
			//then the returned value type, which should be a number, but in mac/ie5 is an empty string
			ixf.type = (ixf.obj.filters.length > 0 && typeof ixf.obj.filters.alpha == 'object' && typeof ixf.obj.filters.alpha.opacity == 'number') ? 'ie' : 'none';
		}
		else
		{
			ixf.type = 'none';
		}
		
		//change the image alt text if defined
		if(typeof arguments[3] != 'undefined' && arguments[3] != '')
		{
			ixf.obj.alt = arguments[3];
		}
		
		//if any kind of opacity is supported
		if(ixf.type != 'none')
		{
			//create a new image object and append it to body
			//detecting support for namespaced element creation, in case we're in the XML DOM
			ixf.newimg = document.getElementsByTagName('body')[0].appendChild((typeof document.createElementNS != 'undefined') ? document.createElementNS('http://www.w3.org/1999/xhtml', 'img') : document.createElement('img'));

			//set positioning classname
			ixf.newimg.className = 'idupe';
			
			//set src to new image src
			ixf.newimg.src = ixf.src

			//move it to superimpose original image
			ixf.newimg.style.left = ixf.getRealPosition(ixf.obj, 'x') + 'px';
			ixf.newimg.style.top = ixf.getRealPosition(ixf.obj, 'y') + 'px';
			
			//copy and convert fade duration argument 
			ixf.length = parseInt(arguments[2], 10) * 1000;
			
			//create fade resolution argument as 20 steps per transition
			ixf.resolution = parseInt(arguments[2], 10) * 20;
			
			//start the timer
			ixf.clock = setInterval('ixf.crossfade()', ixf.length/ixf.resolution);
		}
		
		//otherwise if opacity is not supported
		else
		{
			//just do the image swap
			ixf.obj.src = ixf.src;
		}
		
	}
};


//crossfade timer function
ixf.crossfade = function()
{
	//decrease the counter on a linear scale
	ixf.count -= (1 / ixf.resolution);
	
	//if the counter has reached the bottom
	if(ixf.count < (1 / ixf.resolution))
	{
		//clear the timer
		clearInterval(ixf.clock);
		ixf.clock = null;
		
		//reset the counter
		ixf.count = 1;
		
		//set the original image to the src of the new image
		ixf.obj.src = ixf.src;
	}
	
	//set new opacity value on both elements
	//using whatever method is supported
	switch(ixf.type)
	{
		case 'ie' :
			ixf.obj.filters.alpha.opacity = ixf.count * 100;
			ixf.newimg.filters.alpha.opacity = (1 - ixf.count) * 100;
			break;
			
		case 'khtml' :
			ixf.obj.style.KhtmlOpacity = ixf.count;
			ixf.newimg.style.KhtmlOpacity = (1 - ixf.count);
			break;
			
		case 'moz' : 
			//restrict max opacity to prevent a visual popping effect in firefox
			ixf.obj.style.MozOpacity = (ixf.count == 1 ? 0.9999999 : ixf.count);
			ixf.newimg.style.MozOpacity = (1 - ixf.count);
			break;
			
		default : 
			//restrict max opacity to prevent a visual popping effect in firefox
			ixf.obj.style.opacity = (ixf.count == 1 ? 0.9999999 : ixf.count);
			ixf.newimg.style.opacity = (1 - ixf.count);
	}
	
	//now that we've gone through one fade iteration 
	//we can show the image that's fading in
	ixf.newimg.style.visibility = 'visible';
	
	//keep new image in position with original image
	//in case text size changes mid transition or something
	ixf.newimg.style.left = ixf.getRealPosition(ixf.obj, 'x') + 'px';
	ixf.newimg.style.top = ixf.getRealPosition(ixf.obj, 'y') + 'px';
	
	//if the counter is at the top, which is just after the timer has finished
	if(ixf.count == 1)
	{
		//remove the duplicate image
		ixf.newimg.parentNode.removeChild(ixf.newimg);
	}
};



//get real position method
ixf.getRealPosition = function()
{
	this.pos = (arguments[1] == 'x') ? arguments[0].offsetLeft : arguments[0].offsetTop;
	this.tmp = arguments[0].offsetParent;
	while(this.tmp != null)
	{
		this.pos += (arguments[1] == 'x') ? this.tmp.offsetLeft : this.tmp.offsetTop;
		this.tmp = this.tmp.offsetParent;
	}
	
	return this.pos;
};
