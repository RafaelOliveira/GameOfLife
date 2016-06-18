package;

import kha.System;

#if sys_windows
import kha.Display;
import kha.WindowOptions.Mode;
#end

#if (sys_html5 || sys_debug_html5)
import kha.math.Vector2i;
import js.Browser;
import js.html.CanvasElement;
#end

class Main 
{
	public static var desktopWidth:Int;
	public static var desktopHeight:Int;
	
	// size of the cell
	public static var size:Int;
	
	// 1: g1, 2: g2
	// 0: g1 with size 1 and g2 with size bigger than 1
	public static var renderMethod:Int;
	
	public static var fps:Int;
	
	public static function main() 
	{
		setupParameters();
		
		#if (sys_html5 || sys_debug_html5)		
		var size = setupCanvas();
		desktopWidth = size.x;
		desktopHeight = size.y;
		#else
		desktopWidth = System.windowWidth();
		desktopHeight = System.windowHeight();
		#end
		
		#if (sys_windows || sys_linux || sys_osx)
		System.initEx('Game of Life', [{ width: desktopWidth, height: desktopHeight, mode: Mode.BorderlessWindow }], windowCallback, function() 		
		{
			new Project();
		});
		#else
		System.init({ title: 'Game of Life', width: desktopWidth, height: desktopHeight }, function()
		{
			new Project();
		});
		#end		
	}
	
	static function windowCallback(id:Int):Void {}
	
	static function setupParameters():Void
	{
		#if (sys_html5 || sys_debug_html5)
		size = -1;
		renderMethod = -1;
		fps = -1;
		
		var data = Browser.location.search;
		// remove the '?'
		if (data.length > 0)
			data = data.substr(1);
		
		var paramList = data.split('&');
		if (paramList.length == 0 && data.length > 0)
			paramList.push(data);
		
		for (param in paramList)
		{
			var vars = param.split('=');
			if (vars[0] != null && vars[1] != null)
			{
				switch(vars[0])
				{
					case 'size':						
						var test = Std.parseInt(vars[1]);
						if (test != null && test > 0)
							size = test;
						else
							size = 3;
					
					case 'render':
						if (vars[1] == 'g1')
							renderMethod = 1;
						else if (vars[1] == 'g2')
							renderMethod = 2;
						else
							renderMethod = 0;
					
					case 'fps':
						var test = Std.parseInt(vars[1]);
						if (test != null && test > 0)
							fps = test;
						else
							fps = 60;
				}
			}
		}
		
		if (size == -1)
			size = 3;
			
		if (renderMethod == -1)
			renderMethod = 0;
			
		if (fps == -1)
			fps = 60;
		
		#else
		size = 3;
		renderMethod = 0;
		fps = 60;
		#end
	}
	
	#if (sys_html5 || sys_debug_html5)	
	static function setupCanvas():Vector2i
	{
		var body = Browser.document.body;
		body.style.margin = '0';
		body.style.padding = '0';
		body.style.height = '100%';
		body.style.overflow = 'hidden';
		
		var canvas:CanvasElement = cast Browser.document.getElementById('khanvas');
		var w:Int = Browser.window.innerWidth;
		var h:Int = Browser.window.innerHeight;
		
		canvas.style.width = '${w}px';
		canvas.style.height = '${h}px';
		canvas.width = w;
		canvas.height = h;
		
		return new Vector2i(w, h);
	}
	#end
}
