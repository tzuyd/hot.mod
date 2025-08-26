
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
Global shape1:CPPolyShape, shape2:CPSegmentShape

' Function to update the space
Function updateSpace(space:cpSpace, dt:Double)
	space.DoStep(dt)
End Function

' Function to draw the space
Function drawSpace(space:cpSpace)
    ChipmunkDemoDefaultDrawImpl(space)
'    Local arr.cpContact[CP_MAX_CONTACTS_PER_ARBITER]
'/ / cpCollideShapes(shape1, shape2, (cpCollisionID[]) {0}, arr) ;
'    Local info:cpCollisionInfo = cpCollideShapes(shape2, shape1, 0x00000000, arr)
End Function

' Function to initialize the space
Function initSpace:CPSpace()
    ' Create a new space
	space = New CPSpace.Create()
    space.SetIterations(5)
    space.SetDamping 0.1

    ' Define mass
    Local mass:Double = 1.0

    ' Create shape1 (box)
    Local Size:Double = 100.0
    Local body:CPBody = New CPBody.Create(mass, MomentForBox(mass, Size, Size))
	space.AddBody(body)
    body.SetPosition(Vec2(100.0, -50.0))
	shape1 = New CPBoxShape.Create(body, Size, Size, 0.0)
    space.AddShape(shape1)
    shape1.SetGroup 1
	shape1.SetCollisionType 1

    ' Create shape2 (rotated box)
    Size = 100.0
	body = New CPBody.Create(mass, MomentForBox(mass, Size, Size))
    space.AddBody(body)
    body.SetPosition(Vec2(120.0, 40.0))
    body.SetAngle(1E-2)
	shape1 = New CPBoxShape.Create(body, Size, Size, 0.0)
    space.AddShape(shape1)
    shape1.SetGroup 1
	shape1.SetCollisionType 2

		 Size = 100.0
	 Local NUM_VERTS:Int = 5
		
		Local verts:CPVect[NUM_VERTS]
		For Local i:Int = 0 To NUM_VERTS - 1
			Local angle:Double = -2 * ACos(-1.0) * i / (Double(NUM_VERTS))
			verts[i] = Vec2(Size / 2.0 * Cos(angle), -(Size / 2.0 * Sin(angle)))
		Next
		
		body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
		space.AddBody(body)
		body.SetPosition(Vec2(100.0, -50.0))
		
		shape1 = New CPPolyShape.Create(body, verts, CPVZero)
		space.AddShape(shape1)
		shape1.SetGroup 1
		shape1.SetCollisionType 1
		Size = 100.0
		NUM_VERTS = 4

		verts = New CPVect[NUM_VERTS]
		For Local i:Int = 0 To NUM_VERTS - 1
			Local angle:Double = -2 * ACos(-1.0) * i / (Double(NUM_VERTS))
	 verts[i] = Vec2(Size / 2.0 * Cos(angle), -(Size / 2.0 * Sin(angle)))
 Next
		
 		body = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
		space.AddBody(body)
		body.SetPosition(Vec2(100.0, 50.0))
		
		shape1 = New CPPolyShape.Create(body, verts, CPVZero)
		space.AddShape(shape1)
		shape1.SetGroup 1
		shape1.SetCollisionType 2
	
		 Size = 150.0
		Local radius:Double = 25.0
		
		Local a:CPVect = Vec2(Size / 2.0, 0.0)
		Local b:CPVect = Vec2(-Size / 2.0, 0.0)
		body = New CPBody.Create(mass, MomentForSegment(mass, a, b))
		space.AddBody(body)
		body.SetPosition(Vec2(0, -25))
		
		shape2 = New CPSegmentShape.Create(body, a, b, radius)
		space.AddShape(shape2)
		shape2.SetGroup 1
		shape2.SetCollisionType 1
		radius = 50.0
		
		body = New CPBody.Create(mass, MomentForCircle(mass, 0.0, radius, CPVZero))
		space.AddBody(body)
		body.SetPosition(Vec2(0, 25))
		
		Local shape:CPCircleShape = New CPCircleShape.Create(body, radius, CPVZero)
		space.AddShape(shape)
		shape.SetGroup 1
		shape.SetCollisionType 2

    Return space
End Function

' Function to destroy the space
Function destroySpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
End Function

' Initialize the ChipmunkDemo
Global GJK:ChipmunkDemo = New ChipmunkDemo( ..
    "GJK",  ..
    1.0 / 60.0,  ..
	..
    initSpace,  ..
    updateSpace,  ..
    drawSpace,  ..
    destroySpace ..
, 30)
