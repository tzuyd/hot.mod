
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

Global planetBody:CPBody = New CPBody

Global gravityStrength:Double = 5.0e6

Function UpdateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function PlanetGravityVelocityFunc(body:CPBody, gravity:CPVect, damping:Double, dt:Double)
    Local p:CPVect = body.GetPosition()
    Local sqdist:Double = p.LengthSq()
    Local g:CPVect = p.Mult(-gravityStrength / (sqdist * Sqr(sqdist)))

    body.UpdateVelocity(g, damping, dt)
End Function

Function RandPos:CPVect(radius:Double)
    Local v:CPVect
    Repeat
        v = Vec2(Rnd() * (640 - 2 * radius) - (320 - radius), -(Rnd() * (480 - 2 * radius) - (240 - radius)))
    Until v.Length() >= 85.0
    
    Return v
End Function

Function AddBox(space:CPSpace)
    Local Size:Double = 10.0
    Local mass:Double = 1.0
    
    Local verts:CPVect[] = [ ..
        Vec2(-Size, Size),  ..
        Vec2(-Size, -Size),  ..
        Vec2(Size, -Size),  ..
        Vec2(Size, Size) ..
    ]

    Local radius:Double = Vec2(Size, -Size).Length()
    Local Pos:CPVect = RandPos(radius)
    
    Local body:CPBody = New CPBody.Create(mass, MomentForPoly(mass, verts, CPVZero))
	space.AddBody(body)
    body.SetVelocityFunction(PlanetGravityVelocityFunc)
    Body.SetPosition(Pos)
    
	' // Set the box's velocity to put it into a circular orbit from its
	' // starting position.
    Local r:Double = Pos.Length()
    Local v:Double = Sqr(gravityStrength / r) / r
    body.SetVelocity(Pos.Perp().Mult(v).Negate())
    
	' // Set the box's angular velocity to match its orbital period and
	' // align its initial angle with its position.
    body.SetAngularVelocity(v)
    body.SetAngle(ATan2(Pos.y, Pos.x))

	Local offset:CPVect = CPVZero ' Assuming no offset initially

	' Calculate the centroid of the polygon
	For Local i:Int = 0 Until verts.Length
	    offset = offset.Add(verts[i])
	Next
	offset = offset.Mult(1.0 / verts.Length) ' Average the sum to get the centroid
	
	' Now you can pass the offset to cpPolyShapeNew
	Local shape:CPPolyShape = New CPPolyShape.Create(body, verts, offset)
	space.AddShape(shape)
    shape.SetElasticity(0.0)
    shape.SetFriction(0.7)
End Function

Function InitSpace:CPSpace()
	init()
	space = New CPSpace.Create()
    space.SetIterations(20)
    
	planetBody = planetBody.CreateKinematic()
    space.AddBody(planetBody)
    planetBody.SetAngularVelocity(-0.2)
    
    For Local i:Int = 1 Until 31
        AddBox(space)
    Next

    Local shape:CPCircleShape = New CPCircleShape
	shape = shape.Create(planetBody, 70.0, CPVZero)
	space.AddShape(shape)
    shape.SetElasticity(1.0)
    shape.SetFriction(1.0)
    shape.setFilter(NOT_GRABBABLE_FILTER)
    Return space
End Function

Function CleanUpSpace(space:CPSpace)
    space.Free()
	CleanUp
End Function
	
    ' Initialize the demo
Local PlanetDemo:ChipmunkDemo = New ChipmunkDemo( ..
	"Planet",  ..
	1.0 / 60,  ..
	..
	InitSpace,  ..
	UpdateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	CleanUpSpace ..
, 6)
