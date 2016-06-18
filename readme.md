The code was made using the rules without seeing others implementations, so maybe it can be optimized. I'm still need to check if the implementation is correct.

You can check the html5 version here:  
www.sudoestegames.com/exp/gameoflife

There is some parameters you can pass in the url:  
size: the size of the cell in pixels. The default is 3.  
render: it can be g1 or g2. In g1 the cell size is forced to 1, because g1 only deals with pixels. But you can use g2 with a size of 1, to test different render methods. The default is use g1 for a size of 1, and g2 for a size bigger than 1.  
fps: The fps to run the game. The default is 60.

Example:  
www.sudoestegames.com/exp/gameoflife?size=10&fps=30
