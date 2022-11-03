# ShapeCast
ShapeCast is an experimental project that is implemented to provide amazing performance packed with simple interface that follows data-oriented design patterns.

To understand why I started ShapeCast as a research/experimental project, it is important to know the mistakes that I made in BoxCast which forged it into something I am not entirely proud of.

First of all, the first mistake is that in the latest update of BoxCast I provided a way for user-code to rebuild box casters, which initially seemed an efficient way for many use cases, however, it opened a gate for  mutability hell.

Secomd of all, since BoxCast was designed with OOP, it greatly limited me to reuse code ***since behavior and data are packed as singular object, limiting me to use generic behavior***. Thankfully, this is solved by using dop instead of oop.

So, ShapeCast was created to find solutions for generic shape casting on Roblox. It was designed with data-oriented programming which means that ShapeCast has a function creating a table explaining the structure of a shape, and another one for casting, and additionally, both behavior and data are completely detached from each other, allowing for custom code to interact with shapes freely.

**td;lr I got overwhelmed from the evil object oriented programming and decided to use ShapeCast as an excuse for trying out data oriented programming!**

## Performance
ShapeCast's creating/casting shape performance is amazingly *fast*. Currently, shape creating is ~20us, and thats for the stress test - while with casting, it averaged 4ms for the stress test.

The only bottleneck for casting shapes ***according to my tests*** is completely attached to the raycast system as a whole due to ShapeCast practically doing nothing but registering hits and origin calculation.

***benchmark code can be found in `benchmarks` folder***.