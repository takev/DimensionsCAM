# DimensionsCAM
A multi-axis tool path generator for a milling machine

## Strategies
- Indexed roughing, rough the model at a set of fixed angels.
- Rough leftovers bits of material at more exotic angles.
- Smooth surface with end mill by visiting all surface voxels at right angels to the surface.
- Smooth surface with ball mill by visiting all surface voxels at different angels.

## Indexed roughing.

- Create a CSG model of leftover material to mill from:
  - The CSG model of the material
  - minus The CSG model of the finished object
  - minus the set of previous milled volumes
- Rotate the model around the A- and B-axis
- Convert the CSG model to Voxel Space (in machine space)
- Convert the Voxel Space into a Height Field
- Convert Height field into layers of mill volume (mostly rectangular with rounded corners), used in next iterations when subtracting from material.
- Convert mill volume into G-code.
- Repeat for a few angles

## Rough left overs
- Find left over material clumb
- Find nearest surface to the clumb.
- Raycast outward through the CSG models until a good angel is found (use normal and tangent of the nearest surface as guide)
- Convert to voxel space -> Height Field -> Mill volume -> G-code
- Repeat until all lumbs are gone or visited.

## Coordinate system
The coordinate system is based on the coordinate system of G-code for CNC machines, which has the Z-axis going upward from
the part being machined.

```
 Z

 ^       Y
 |      /
 |     /
 |    /
 |   /
 |  /
 | /
 |/
 +----------> X

```

### Oct tree
The coordinate system as described above is the same in the Oct Tree of the voxels.
Each node Oct Tree is split into 8 sub-nodes, each subnode is described by a letter.

```
Bottom Level z = -
 Y
 ^
 |
 +---+---+
 | C | D |
 +---+---+
 | A | B |
 +---+---+---> X
 
Top level Z = +

 Y
 ^
 |
 +---+---+
 | G | H |
 +---+---+
 | E | F |
 +---+---+---> X
```



