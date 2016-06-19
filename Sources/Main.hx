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
	
	public static function main() 
	{		
		#if (sys_windows || sys_linux || sys_osx)
		desktopWidth = Display.width(0);
		desktopHeight = Display.height(0);
		#elseif (sys_html5 || sys_debug_html5)		
		var size = setupCanvas();
		desktopWidth = size.x;
		desktopHeight = size.y;
		#else
		desktopWidth = System.windowWidth();
		desktopHeight = System.windowHeight();
		#end
		
		trace('game size: ${desktopWidth}x${desktopHeight}');
		
		#if (sys_windows || sys_linux || sys_osx)
		System.initEx('Game of Life', [{ width: desktopWidth, height: desktopHeight, mode: Mode.BorderlessWindow, 
			windowedModeOptions: { resizable: false } }], windowCallback, function() 		
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