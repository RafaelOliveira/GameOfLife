package;

import kha.Assets;
import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.Key;
import kha.input.Mouse;

typedef Matrix = Array<Array<Bool>>;

class Project 
{	
	var table1:Matrix;
	var table2:Matrix;
	var activeTable:Matrix;
	var otherTable:Matrix;
	var indexActive:Int;
	
	public var cols:Int;
	public var lines:Int;
	
	var liveCells:Int;	
	public var cellSize:Int;
	public var ups:Int;	
	
	public var pause:Bool;
	var updateTaskId:Int;	
		
	var fps:FramesPerSecond;
	
	var panel:Panel;
	
	public function new() 
	{		
		Assets.loadEverything(loadingFinished);
	}
	
	function loadingFinished():Void
	{
		panel = new Panel(this);
		
		pause = true;		
		cellSize = 3;		
		ups = 60;
		
		fps = new FramesPerSecond();
		
		System.notifyOnRender(render);
		Keyboard.get().notify(keyDown, null);		
			
		setupTables();
		createSeed();
		
		updateTaskId = Scheduler.addTimeTask(update, 0, 1 / ups);
	}
	
	public function updateUps():Void
	{
		Scheduler.removeTimeTask(updateTaskId);
		updateTaskId = Scheduler.addTimeTask(update, 0, 1 / ups);
	}
	
	function keyDown(key:Key, char: String):Void
	{
		if (key == Key.TAB)
			panel.show = !panel.show;
	}
	
	public function setupTables():Void
	{
		if (cellSize == 1)
		{
			cols = Main.desktopWidth;
			lines = Main.desktopHeight;			
		}
		else
		{
			cols = Std.int(Main.desktopWidth / cellSize);
			lines = Std.int(Main.desktopHeight / cellSize);
		}		
		
		table1 = new Matrix();
		table2 = new Matrix();
		
		for (y in 0...lines)
		{
			table1.push(new Array<Bool>());
			table2.push(new Array<Bool>());
			
			for (x in 0...cols)
			{
				table1[y].push(false);
				table2[y].push(false);
			}
		}
	}
	
	public function clearTables():Void
	{
		for (y in 0...lines)
		{
			for (x in 0...cols)
			{				
				table1[y][x] = false;
				table2[y][x] = false;
			}
		}
	}
		
	public function createSeed():Void
	{
		activeTable = table1;
		otherTable = table2;
		indexActive = 1;
		
		for (y in 0...lines)
		{
			for (x in 0...cols)
			{
				if (Math.random() > 0.8)
					activeTable[y][x] = true;
			}
		}		
	}

	function update(): Void 
	{
		if (!pause)
		{
			for (y in 0...lines)
			{
				for (x in 0...cols)
				{
					otherTable[y][x] = false;
					calculateLiveCells(x, y);
					
					// live cell
					if (activeTable[y][x])
					{
						if (liveCells == 2 || liveCells == 3)
							otherTable[y][x] = true;					
					}
					// dead cell
					else
					{
						if (liveCells == 3)
							otherTable[y][x] = true;
					}				
				}
			}
			
			if (indexActive == 1)
			{
				activeTable = table2;
				otherTable = table1;
				indexActive = 2;
			}
			else
			{
				activeTable = table1;
				otherTable = table2;
				indexActive = 1;
			}			
		}
		
		fps.update();
	}

	// Calculate the total of live neighbors cell
	function calculateLiveCells(x:Int, y:Int):Void
	{
		liveCells = 0;		
		
		// top
		if (y != 0 && activeTable[y - 1][x])
			liveCells++;
			
		// bottom
		if (y != (lines - 1) && activeTable[y + 1][x])
			liveCells++;
			
		// left
		if (x != 0 && activeTable[y][x - 1])
			liveCells++;
			
		// right
		if (x != (cols - 1) && activeTable[y][x + 1])
			liveCells++;
			
		// top left		
		if (x != 0 && y != 0 && activeTable[y - 1][x - 1])
			liveCells++;
			
		// top right
		if (x != (cols - 1) && y != 0 && activeTable[y - 1][x + 1])
			liveCells++;
			
		// bottom left		
		if (x != 0 && y != (lines - 1) && activeTable[y + 1][x - 1])
			liveCells++;
			
		// bottom right		
		if (x != (cols - 1) && y != (lines - 1) && activeTable[y + 1][x + 1])
			liveCells++;
	}

	function render(framebuffer:Framebuffer): Void 
	{		
		if (cellSize == 1)
		{
			framebuffer.g1.begin();
		
			for (y in 0...lines)
			{
				for (x in 0...cols)
				{
					if (activeTable[y][x])
						framebuffer.g1.setPixel(x, y, Color.White);
				}
			}
			
			framebuffer.g1.end();
		}
		else
		{
			framebuffer.g2.begin();		
			
			for (y in 0...lines)
			{
				for (x in 0...cols)
				{
					if (activeTable[y][x])
						framebuffer.g2.fillRect(x * cellSize, y * cellSize, cellSize, cellSize);
				}
			}						
		}
		
		if (cellSize == 1)
			framebuffer.g2.begin(false);
		
		framebuffer.g2.color = Color.Black;
		framebuffer.g2.fillRect(0, 0, 90, 30);
		
		framebuffer.g2.color = Color.White;
		framebuffer.g2.font = Assets.fonts.Vera;
		framebuffer.g2.fontSize = 25;		
		framebuffer.g2.drawString('FPS: ${fps.fps}', 1, 3);		
		
		framebuffer.g2.end();
		
		if (panel.show)
			panel.render(framebuffer.g2);
		
		fps.calcFrames();
	}
}