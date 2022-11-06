# ShapeCast
ShapeCast is an experimental project that is being worked on to provide amazing performance packed with a simple interface that follows data-oriented design patterns. 

When I finished BoxCast (another library of mine), I found that the code had the potential of providing depth for casters, or in other words, supporting a shape like a sphere; however, due to it being strictly limited to box casting, it wasn't really possible without it feeling a bit out of place. 

BoxCast was fine, and I'm proud of it, although it allowed mutation through rebuilding, which was really a bad idea since mutation for this kind of stuff isn't generally preferred, and the "performance increase" that was gained from this only worked if you just rebuilt a specific type of data, and adding onto that, the increase itself was minimal, so this type of addition was kind of unneeded since there was no excuse for its existence. 

In addition to mutation, I needed a generic library with a generic data structure so that I don't need dozens of mini-libraries just for different-shape casting, and OOP wasn't really the ideal paradigm for the job. I also want user code and even utility code to apply optimizations on the "Shape" structure as they please as long as they don't mess up everything, or to completely have custom caster functions that read the said structure and apply some tricks, or in other words, I wanted ShapeCast to be flexible and be a gateway for a lot of possibilities, and packing/merging everything definitely doesn't help.

**tl;dr - OOP wasn't really the best choice for the job, so I designed a library with data-oriented programming to fit into what I believe to be a generic, fast and efficient solution standard.**

## Features
The current features in ShapeCast are:

1. Flexible Shape Contruction - In other words, shapes are made up of planes, and each plane is made up of steps, and each step is made up of points - this structure makes it very easy to have a generic structure for shapes.
2. Advancements - They allow you to determine how dense your shape is, either increasing the number of planes within a shape, or the points within a step.
3. Centering - ShapeCast automatically centers shapes for you so that you don't need to worry about shapes being positioned incorrectly.
4.  Distances - They allow you to determine the distance either between your points, or your planes.
5. *(To be implemented)* Depth - Allow for generic projection of 3D shapes *(spheres)*