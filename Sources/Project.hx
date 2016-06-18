package;

import kha.Color;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

typedef Matrix = Array<Array<Bool>>;

class Project 
{	
	var table1:Matrix;
	var table2:Matrix;
	var activeTable:Matrix;
	var otherTable:Matrix;
	var indexActive:Int;
	
	var cols:Int;
	var lines:Int;
	
	var liveCells:Int;	
	
	public function new() 
	{				
		// choose the method using the size
		if (Main.renderMethod == 0)
		{
			if (Main.size == 1)
				System.notifyOnRender(renderWithG1);
			else
				System.notifyOnRender(renderWithG2);
		}
		// use g1 and force size = 1
		else if (Main.renderMethod == 1)
		{
			Main.size = 1;
			System.notifyOnRender(renderWithG1);
		}
		// use g2
		else
			System.notifyOnRender(renderWithG2);
			
		cols = Std.int(Main.desktopWidth / Main.size);
		lines = Std.int(Main.desktopHeight / Main.size);
		
		setupTables();
		createFirstGen();
		
		Scheduler.addTimeTask(update, 0, 1 / Main.fps);
	}
	
	inline function setupTables():Void
	{
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
	
	inline function createFirstGen():Void
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

	function renderWithG2(framebuffer: Framebuffer): Void 
	{
		framebuffer.g2.begin();
		
		for (y in 0...lines)
		{
			for (x in 0...cols)
			{
				if (activeTable[y][x])
					framebuffer.g2.fillRect(x * Main.size, y * Main.size, Main.size, Main.size);
			}
		}
		
		framebuffer.g2.end();
	}
	
	function renderWithG1(framebuffer: Framebuffer): Void 
	{
		framebuffer.g2.begin();
		framebuffer.g2.end();
		
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
}