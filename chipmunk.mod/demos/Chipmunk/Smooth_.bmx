
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

Function initSpace:CPSpace()
    space:CPSpace = New CPSpace.Create()
    space.SetIterations(5)
    space.SetDamping(0.1)
    
    space.SetDefaultCollisionPairFunc(Null, Null, DrawContacts, Null, Null)
    
    Local mass:Double = 1.0
    Local Length:Double = 100.0
    Local a:CPVect = Vec2(-Length / 2.0, 0.0), b:CPVect = Vec2(Length / 2.0, 0.0)
    
	Local body:CPBody = New CPBody.Create(mass, MomentForSegment(mass, a, b))
    space.AddBody(body)
    body.SetPosition(Vec2(-160.0, -80.0))
    
    space.AddShape(New CPSegmentShape.Create(body, a, b, 30.0))
    
    Local NUM_VERTS:Int = 5
    Local verts:CPVect[NUM_VERTS]
    For Local i:Int = 0 Until NUM_VERTS
        Local angle:Double = 360 / NUM_VERTS * (4 - i)
        verts[i] = Vec2(40 * Cos(angle), -(40 * Sin(angle)))
    Next
    
	body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(0.0, -80.0))
    
    space.AddShape(New CPPolyShape.Create(body, verts, CPVZero))
    
    Local r:Double = 60.0
    
	body = New CPBody.Create(mass, INFINITY)
    space.AddBody(body)
    body.SetPosition(Vec2(160.0, -80.0))
    
    space.AddShape(New CPCircleShape.Create(body, r, CPVZero))
    
    Local staticBody:CPBody = Space.GetStaticBody()
    
    Local terrain:CPVect[] = [Vec2(-320, 200), Vec2(-200, 100), Vec2(0, 200), Vec2(200, 100), Vec2(320, 200)]
    Local terrainCount:Int = terrain.Length
    
    For Local i:Int = 1 Until 5
        Local v0:CPVect = terrain[Max(i - 2, 0)]
        Local v1:CPVect = terrain[i - 1]
        Local v2:CPVect = terrain[i]
        Local v3:CPVect = terrain[Min(i + 1, terrainCount - 1)]
        
		Local seg:CPSegmentShape = New CPSegmentShape.Create(staticBody, v1, v2, 10.0)
        space.AddShape(seg)
        seg.SetNeighbors(v0, v3)
    Next
    
	init()
    Return space
End Function

Function updateSpace(space:CPSpace, dt:Double)
    Local steps:Int = 1
    dt = 1.0 / 60.0 / Double(steps)
    
    For Local i:Int = 0 Until steps
		space.DoStep(dt)
    Next
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp()
End Function

Function DrawContacts:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object)
    For Local i:Int = 0 Until contacts.Length
        Local contact:CPContact = contacts[i]
        Local p:CPVect = contact.GetPosition()
        Local normal:CPVect = contact.GetNormal()
        
        bmx_drawdot(6.0, p, New SColor8(255, 0, 0, 255))
        bmx_drawsegment(p, p.Add(normal.Mult(10.0)), New SColor8(255, 0, 0, 255))
    Next
    
    Return False
'	Return True
End Function

Global Smooth:ChipmunkDemo = New ChipmunkDemo( ..
	"Smooth",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
)
	
    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
