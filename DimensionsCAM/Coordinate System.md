# Coordinate System

## The grid
Each point in the system is rounded to grid coordinates. The grid has the following properties:
- The grid uses the physical dimension and limitations of a CNC machine.
- A box of 4×4×4 m in size.
- Origin is in the center of the box.
- Precission is 1 µm

## Grid identifier
A grid coordinate can be converted to a grid identifier, which are three 21 bit signed integers concatonated
into a 64 bit integer. Each 21 bit signed integer corrosponds with an axis; from least significant bit to
most significat bit: x, y, z. Each 21 bit signed integer represents the distance in µm from the origin.

The grid identifier of a centroid of an vertex, edge, triangle or tetrhedron can be used to uniqly identify such
an object in hash tables. All four types of object will have a unique id in a well-formed-mesh.

## Right handed
The coordinate system is right handed, see the following diagram.

```
Z
^
|    Y
|   /
|  /
| /
|/
 -----> X
```

## Counter Clockwise Winding
Triangles and Tetrahedron are winded counter clockwise; in the order A, B, C, (D).
Edges of a triangle opposite of a vertex will have the equivilant lower case character.
Triangles of a tetrahedron opposite of a vertex will have the equivilant lower case character.

```
               A
              / \
             /   \
            /     \
           /       \
          /         \
        c/           \b
        /             \
       /               \
      /                 \
     /                   \
    /                     \
   /                       \
  /                         \
B --------------------------- C
               a
```

```
               A
              /.\
             / . \
            /  .  \
           /   .   \
          /    .    \
         /     .     \
        /  c   .   b  \
       /     . D .     \
      /    .       .    \
     /   .           .   \
    /  .       a       .  \
   / .                   . \
  /.                       .\
B --------------------------- C
```