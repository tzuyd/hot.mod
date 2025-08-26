
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

' Declare global variables
Global KinematicBoxBody:CPBody = New CPBody.CreateKinematic()

' Function to update the space
Function updateSpace(space:cpSpace, dt:Double)
	space.DoStep(dt)
End Function

' Function to add a box shape to the space
Function AddBox(space:CPSpace, Pos:CPVect, mass:Double, Width:Double, Height:Double)
	Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Width, Height))
    space.AddBody(body)
    Body.SetPosition(Pos)
    
	Local shape:CPPolyShape = New CPboxShape.Create(body, Width, Height, 0.0)
    space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
End Function

' Function to add a segment shape to the space
Function AddSegment(space:CPSpace, Pos:CPVect, mass:Double, Width:Double, Height:Double)
	Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Width, Height))
    space.AddBody(body)
    Body.SetPosition(Pos)
    
	Local shape:CPSegmentShape = New CPSegmentShape.Create(body, Vec2(0.0, -((Height - Width) / 2.0)), Vec2(0.0, -((Width - Height) / 2.0)), Width / 2.0)
    space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
End Function

' Function to add a circle shape to the space
Function AddCircle(space:CPSpace, Pos:CPVect, mass:Double, radius:Double)
	Local body:CPBody = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
    space.AddBody(body)
    Body.SetPosition(Pos)
    
	Local shape:CPCircleShape = New CPCircleShape.Create(body, radius, CPVZero)
    space.AddShape(shape)
    Shape.SetElasticity(0.0)
    Shape.SetFriction(0.7)
End Function

' Function to initialize the space
Function initSpace:CPSpace()
	init()
    ' Create a new space
    space.SetGravity(Vec2(0, 600))
    
    ' Set up the static box
    Local shape:CPSegmentShape
    space.AddBody(KinematicBoxBody)
    KinematicBoxBody.SetAngularVelocity(0.4)
    
    Local a:CPVect = Vec2(-200, 200)
    Local b:CPVect = Vec2(-200, -200)
    Local c:CPVect = Vec2(200, -200)
    Local d:CPVect = Vec2(200, 200)
    
	shape = New CPSegmentShape.Create(KinematicBoxBody, a, b, 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)

	shape = New CPSegmentShape.Create(KinematicBoxBody, b, c, 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)

	shape = New CPSegmentShape.Create(KinematicBoxBody, c, d, 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)

	shape = New CPSegmentShape.Create(KinematicBoxBody, d, a, 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    
    Local mass:Double = 1
    Local Width:Double = 30
    Local Height:Double = Width * 2
    
    ' Add the bricks
    For Local i:Int = 0 To 6
        For Local j:Int = 0 To 2
            Local Pos:CPVect = Vec2(i * Width - 150, -(j * Height - 150))
            Local shapeType:Int = Rand(3)
            
            If shapeType = 1 Then
                AddBox(space, pos, mass, width, height)
            ElseIf shapeType = 2 Then
                AddSegment(space, pos, mass, width, height)
            Else
                AddCircle(space, Pos.Add(Vec2(0.0, -((Height - Width) / 2.0))), mass, Width / 2.0)
                AddCircle(space, Pos.Add(Vec2(0.0, -((Width - Height) / 2.0))), mass, Width / 2.0)
            End If
        Next
    Next
    
    Return space
End Function

' Function to destroy the space
Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

' Initialize the ChipmunkDemo
Global Tumble:ChipmunkDemo = New ChipmunkDemo( ..
    "Tumble",  ..
    1.0 / 180.0,  ..
    initSpace,  ..
    updateSpace,  ..
    ChipmunkDemoDefaultDrawImpl,  ..
    destroySpace ..
, 4)

' Start the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
