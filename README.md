Optic Workbench
===

Optic Workbench is an application on OS X that lets you play with simple optic toys. You have light sources, lenses, flat and curved mirrors, beam splitters, and obstacles. It is especially useful for understanding [how light field cameras work](http://www.bridgermaxwell.com/index.php/blog/optic-workbench-light-field-capture/) (like [Lytro](https://www.lytro.com)). 

I spent a lot of time making sure it was easy to manipulate the tools on the workbench. Drag a new one from the library in the bottom left. You can move it by dragging near the center of the tool. You can rotate it by dragging on the purple circle. You can resize by stretching the tool. You can modify the focal length of a lens or parabolic mirror by a simple drag. Click on light sources to change their color.

The simulation is very straightforward. It works like this:

* First, each tool on the board has a chance to emit "starting rays". These are added to a list of active rays. Each ray has a starting position (x,y), an angle, and a color.
* Now the simulation enters a loop. One of the active rays is chosen and removed from the list. The distance to each tool is computed, and the closest intersecting tool is chosen. A line is drawn from the origin to the intersection point.
* The tool that the ray hits then has a chance to "transform" the ray, and return an array of new rays. For example, a mirror will return a new ray starting on the mirror, and with the reflected angle. A beam splitter returns two rays. One is reflected, and one continues on the same path. Each is half the intensity of the original ray. These transformed rays are added to the list of active rays, and the loop continues until all active rays are gone.

The application requires OS X Lion (10.7) to run.

The code is released under the MIT license.
