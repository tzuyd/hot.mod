
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

Const NUM_VERTS:Int = 5
Global pentagon_mass:Double = 0.0
Global pentagon_moment:Double = 0.0

Function EachBody(body:Object, unused:Object)
    Local Pos:CPVect = CPBody(Body).GetPosition()
    If Pos.y > GraphicsHeight() / 2 Or Abs(Pos.x) > GraphicsWidth() / 2 Then
        Local x:Double = Rand(-320, 320)
        CPBody(body).SetPosition(Vec2(x, -(GraphicsHeight() / 2)))
    End If
End Function

Function updateSpace(space:CPSpace, dt:Double)
    If ChipmunkDemoRightDown Then
        Local nearest:CPShape = Space.PointQueryNearest(ChipmunkDemoMouse, 0.0, GRAB_FILTER, Null)
        If nearest <> Null Then
            Local body:CPBody = nearest.GetBody()
            If body.GetType() = CP_BODY_TYPE_STATIC Then
                body.SetType(CP_BODY_TYPE_DYNAMIC)
                body.SetMass(pentagon_mass)
                body.SetMoment(pentagon_moment)
            ElseIf body.GetType() = CP_BODY_TYPE_DYNAMIC Then
                body.SetType(CP_BODY_TYPE_STATIC)
            End If
        End If
    End If
    
    space.EachBody(EachBody, Null)
	space.DoStep(dt)
End Function

Function initSpace:CPSpace()
    ChipmunkDemoMessageString = "Right click to make pentagons static/dynamic."
    
    Local space:CPSpace = New CPSpace.Create()
    space.SetIterations(5)
    space.SetGravity(Vec2(0, 100))
    
    Local body:CPBody, staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPPolyShape
    
    ' Vertexes for a triangle shape.
    Local tris:CPVect[] = [Vec2(-15, 15), Vec2(0, -10), Vec2(15, 15)]
    
    ' Create the static triangles.
    For Local i:Int = 0 Until 9
        For Local j:Int = 0 Until 6
            Local stagger:Double = (j Mod 2) * 40
            Local offset:CPVect = Vec2(i * 80 - 320 + stagger, -(j * 70 - 240))
	        Local transformedTris:CPVect[3]
	        For Local k:Int = 0 Until 3
	            transformedTris[k] = tris[k].Add(offset)
	        Next
			shape = New CPPolyShape.Create(staticBody, transformedTris, CPVZero)
            space.AddShape(shape)
            shape.SetElasticity(1.0)
            shape.SetFriction(1.0)
            shape.setFilter(NOT_GRABBABLE_FILTER)
        Next
    Next
    
    ' Create vertexes for a pentagon shape.
    Local verts:CPVect[NUM_VERTS]
    For Local i:Int = 0 Until NUM_VERTS
		Local angle:Double = 360 / NUM_VERTS * (4 - i)
		verts[i] = Vec2(10 * Cos(angle), -(10 * Sin(angle)))
    Next
    
    pentagon_mass = 1.0
    pentagon_moment = MomentForPoly(1.0, verts, CPVZero, 0.0)
    
    ' Add lots of pentagons.
    For Local i:Int = 0 Until 300
		body = New CPBody.Create(pentagon_mass, pentagon_moment)
        space.AddBody(body)
        Local x:Double = Rand(-320, 320)
        body.SetPosition(Vec2(x, -350))
       
		shape = New CPPolyShape.Create(body, verts, CPVZero)
        space.AddShape(shape)
        shape.SetElasticity(0.0)
        shape.SetFriction(0.4)
    Next
    
	init()
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

Global Plink:ChipmunkDemo = New ChipmunkDemo( ..
	"Plink",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 2)

    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
