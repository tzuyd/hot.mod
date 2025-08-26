
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

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function initSpace:CPSpace()
	space = New CPSpace.Create()
	space = New CPSpace.Create()
    space.SetIterations(30)
    space.SetGravity(Vec2(0, 100))
    space.SetSleepTimeThreshold(0.5)
    space.SetCollisionSlop(0.5)
    
    Local body:CPBody
	Local staticBody:CPBody = Space.GetStaticBody()
    Local shape:CPShape
    
    ' Create segments around the edge of the screen.
	shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
	shape = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
	shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    ' Add lots of boxes.
    For Local i:Int = 0 Until 14
        For Local j:Int = 0 Until (i + 1)
			body = New CPBody.Create(1.0, MomentForBox(1.0, 30.0, 30.0))
            space.AddBody(body)
            body.SetPosition(Vec2(j * 32 - i * 16, -(300 - i * 32)))
            
			shape = New CPBoxShape.Create(body, 30.0, 30.0, 0.5)
            space.AddShape(shape)
            shape.SetElasticity(0.0)
            shape.SetFriction(0.8)
        Next
    Next
    
    ' Add a ball to make things more interesting.
    Local radius:Double = 15.0
	body = New CPBody.Create(10.0, MomentForCircle(10.0, 0.0, radius, CPVZero))
    space.AddBody(body)
    body.SetPosition(Vec2(0, -(-240 + radius + 5)))

	shape = New CPCircleShape.Create(body, radius, CPVZero)
    space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.9)
    
    Return space
End Function

Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

Global PyramidStack:ChipmunkDemo = New ChipmunkDemo( ..
	"Pyramid Stack",  ..
	1.0 / 180.0,  ..
..
	initSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, 1)
