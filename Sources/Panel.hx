package;

import kha.Assets;
import kha.graphics2.Graphics;
import zui.Zui;
import zui.Ext;
import zui.Id;

class Panel
{
	var ui:Zui;
	public var show:Bool;	
	
	var cellSizeF:Float;
	var nextCellSize:Int;
	var sizeUpdated:Bool;
	
	var upsF:Float;
	var upsUpdated:Bool;
	
	var tempFloat:Float;
	
	var project:Project;
	
	public function new(project:Project) 
	{
		this.project = project;
		
		ui = new Zui(Assets.fonts.Vera);
		
		show = true;
		
		cellSizeF = project.cellSize;
		nextCellSize = 0;
		sizeUpdated = false;
		
		upsF = project.ups;		
		upsUpdated = false;
	}
	
	public function render(g:Graphics):Void
	{
		ui.begin(g);
		
		if (ui.window(Id.window(), 0, 30, 250, 600)) 
		{
			if (ui.node(Id.node(), 'Config Panel', 0, true)) 
			{				
				tempFloat = ui.slider(Id.slider(), 'Cell size', 1, 50, false, 1, 3);
				if (cellSizeF != tempFloat)
				{
					cellSizeF = tempFloat;
					nextCellSize = Std.int(cellSizeF);
					sizeUpdated = true;
				}
				
				tempFloat = ui.slider(Id.slider(), 'Updates per second', 1, 60, false, 1, 60);
				if (upsF != tempFloat)
				{
					upsF = tempFloat;
					project.ups = Std.int(upsF);
					upsUpdated = true;
				}
				
				ui.separator();				
				
				if (ui.button('Update parameters'))
					updateParameters();
				
				ui.text('Grid size: ${project.cols}x${project.lines}', Zui.ALIGN_CENTER);
				
				if (ui.button(project.pause ? 'Run' : 'Pause'))
					project.pause = !project.pause;
				
				ui.text('Press TAB to show/hide the panel', Zui.ALIGN_CENTER);
			}
		}
		
		ui.end();
	}
	
	function updateParameters():Void
	{
		if (sizeUpdated)
		{
			project.cellSize = nextCellSize;
			project.setupTables();
			sizeUpdated = false;
		}
		else
			project.clearTables();
			
		if (upsUpdated)
		{			
			project.updateUps();
			upsUpdated = false;
		}
		
		project.createSeed();
		project.pause = true;		
	}
}