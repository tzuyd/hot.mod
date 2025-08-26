
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
end rem

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

Global M_PI:Float = ACos(-1.0)

Function NeverCollide:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object)
    Return False
End Function

Function UpdateSpace(space:CPSpace, dt:Double)
    Local steps:Int = 1
    dt = 1.0 / 60.0 / Double(steps)
    
    For Local i:Int = 0 Until steps
		space.DoStep(dt)
    Next
End Function

Function InitSpace:CPSpace()
	init()
    space.SetIterations(5)
    space.SetDamping(0.1)
    
    space.SetDefaultCollisionPairFunc(Null, Null, NeverCollide, Null, Null)
    
    Local mass:Double
    Local Length:Double
    Local a:CPVect
    Local b:CPVect
    Local body:CPBody
    Local shape:CPCircleShape
    
    ' Segment shape 1
    mass = 1.0
    length = 100.0
    a = Vec2(-Length / 2.0, 0.0)
    b = Vec2(Length / 2.0, 0.0)
	body = New CPBody.Create(mass, MomentForSegment(mass, a, b))
    space.AddBody(body)
    body.SetPosition(Vec2(-160.0, 80.0))
	Local segshap:CPSegmentShape = New CPSegmentShape.Create(body, a, b, 30.0)
    space.AddShape(segshap)
    
    ' Segment shape 2
    mass = 1.0
    length = 100.0
    a = Vec2(-Length / 2.0, 0.0)
    b = Vec2(Length / 2.0, 0.0)
	body = New CPBody.Create(mass, MomentForSegment(mass, a, b))
    space.AddBody(body)
    body.SetPosition(Vec2(-160.0, -80.0))
	segshap = New CPSegmentShape.Create(body, a, b, 20.0)
    space.AddShape(segshap)
    
    ' Pentagon shape
    mass = 1.0
    Local NUM_VERTS:Int = 5
    Local verts:CPVect[NUM_VERTS]
    For Local i:Int = 0 Until NUM_VERTS
        Local angle:Double = -2.0 * M_PI * i / Double(NUM_VERTS)
'        Local angle:Double = 360 / NUM_VERTS * (4 - i)
        verts[i] = Vec2(40 * Cos(angle), -(40 * Sin(angle)))
    Next
	body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(-0.0, 80.0))
	Local polyshap:CPPolyShape = New CPPolyShape.Create(body, verts, CPVZero)
    space.AddShape(polyshap)
    
    ' Rectangle shape
    mass = 1.0
    NUM_VERTS = 4
    For Local i:Int = 0 Until NUM_VERTS
        Local angle:Double = -2.0 * M_PI * i / Double(NUM_VERTS)
'        Local angle:Double = 360 / NUM_VERTS * (4 - i)
        verts[i] = Vec2(60 * Cos(angle), -(60 * Sin(angle)))
    Next
	body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(-0.0, -80.0))
	polyshap = New CPPolyShape.Create(body, verts, CPVZero)
    space.AddShape(polyshap)
    
    ' Circle shape 1
    mass = 1.0
    Local r:Double = 60.0
	body = New CPBody.Create(mass, INFINITY)
    space.AddBody(body)
    body.SetPosition(Vec2(160.0, 80.0))
	shape = New CPCircleShape.Create(body, r, CPVZero)
    space.AddShape(shape)
    
    ' Circle shape 2
    mass = 1.0
    r = 40.0
	body = New CPBody.Create(mass, INFINITY)
    space.AddBody(body)
    body.SetPosition(Vec2(160.0, -80.0))
	shape = New CPCircleShape.Create(body, r, CPVZero)
    space.AddShape(shape)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
   	space.Free()
	CleanUp()
End Function

Local ContactPoints:ChipmunkDemo = New ChipmunkDemo( ..
	"ContactPoints",  ..
	 1.0 / 60.0,  ..
	 InitSpace,  ..
	 UpdateSpace,  ..
	 ChipmunkDemoDefaultDrawImpl,  ..
	 DestroySpace ..
, 31)
	
    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
