
Rem Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
End Rem

SuperStrict

' Import required modules
Framework brl.d3d9max2d
'Import brl.StandardIO
'Import brl.Max2D
'Import brl.random
'Import brl.math
'Import brl.Color

' Import Chipmunk library
Import hot.chipmunk

Import "ChipmunkDemo.bmx"

Global DENSITY:Double = 1.0 / 10000.0
Global shape:CPPolyShape

Function updateSpace(space:CPSpace, dt:Double)
    Local tolerance:Double = 2.0
    
    If ChipmunkDemoRightClick And (shape.PointQuery(ChipmunkDemoMouse, Null) > tolerance) Then
        Local body:CPBody = Shape.GetBody()
        Local Count:Int = Shape.GetCount()

        ' Allocate the space for the new vertexes on the stack.
		Local verts:CPVect[]
		
        	verts = shape.GetVerts(Count + 1)

        verts[Count] = body.World2Local(ChipmunkDemoMouse)
        
        ' This function builds a convex hull for the vertexes.
        ' Because the result array is the same as verts, it will reduce it in place.
        Local hullCount:Int = ConvexHull(verts, verts, Null, tolerance)
        
        ' Figure out how much to shift the body by.
        Local centroid:CPVect = CentroidForPoly(verts)
        
        ' Recalculate the body properties to match the updated shape.
        Local mass:Double = AreaForPoly(verts, 0.0) * DENSITY
        body.SetMass(mass)
        body.SetMoment(MomentForPoly(mass, verts, centroid.Negate(), 0.0))
        body.SetPosition(body.Local2World(centroid))

		' Apply the transformation to each vertex
		For Local i:Int = 0 To hullCount - 1
		    verts[i] = New CPTransform.Point(New CPTransform.Translate(centroid.Negate()), verts[i])
		Next
		' Remove the old shape from the space
		shape.Free()
		' Create a new convex poly shape with the transformed vertices
		shape = New CPPolyShape.Create(body, verts, CPVZero)

		' Add the new shape to the space
		space.AddShape(shape)
		
		' Set other properties for the shape
		shape.SetFriction(0.6)

		ChipmunkDemoRightClick = False
    End If
    
	space.DoStep(dt)
End Function

Function initSpace:CPSpace()
	space = New CPSpace.Create()
    ChipmunkDemoMessageString = "Right click and drag to change the blocks's shape."
    
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 500))
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    Local body:CPBody
    Local staticBody:CPBody = Space.GetStaticBody()
    
    ' Create segments around the edge of the screen.
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
    space.AddShape(segshap)
    segshap.SetElasticity(1.0)
    segshap.SetFriction(1.0)
    segshap.setFilter(NOT_GRABBABLE_FILTER)
    
    Local width:Double = 50.0
    Local height:Double = 70.0
    Local mass:Double = width * height * DENSITY
    Local moment:Double = MomentForBox(mass, width, height)
    
	body:CPBody = New CPBody.Create(mass, moment)
    space.AddBody(body)
    
		' Create a new poly shape
	shape = New CPBoxShape.Create(body, width, height, 0.0)

		' Add the new shape to the space
    space.AddShape(shape)

		' Set other properties for the shape
    shape.SetFriction(0.6)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global Convex:ChipmunkDemo = New ChipmunkDemo( ..
	"Convex.",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 20)
