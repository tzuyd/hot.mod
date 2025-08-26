
Rem
    Copyright (c) 2007 Scott Lembcke
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
Endrem

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

Global image_width:Int = 188
Global image_height:Int = 35
Global image_row_length:Int = 24

Global IMAGE_BITMAP:Int[] = [ ..
	15, -16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, -64, 15, 63, -32, -2, 0, 0, 0, 0, 0, 0, 0,  ..
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, -64, 15, 127, -125, -1, -128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  ..
	0, 0, 0, 127, -64, 15, 127, 15, -1, -64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -64, 15, -2,  ..
	31, -1, -64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -64, 0, -4, 63, -1, -32, 0, 0, 0, 0, 0, 0,  ..
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, -64, 15, -8, 127, -1, -32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  ..
	1, -1, -64, 0, -8, -15, -1, -32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -31, -1, -64, 15, -8, -32,  ..
	- 1, -32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, -15, -1, -64, 9, -15, -32, -1, -32, 0, 0, 0, 0, 0,  ..
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, -15, -1, -64, 0, -15, -32, -1, -32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  ..
	0, 0, 63, -7, -1, -64, 9, -29, -32, 127, -61, -16, 63, 15, -61, -1, -8, 31, -16, 15, -8, 126, 7, -31,  ..
	- 8, 31, -65, -7, -1, -64, 9, -29, -32, 0, 7, -8, 127, -97, -25, -1, -2, 63, -8, 31, -4, -1, 15, -13,  ..
	- 4, 63, -1, -3, -1, -64, 9, -29, -32, 0, 7, -8, 127, -97, -25, -1, -2, 63, -8, 31, -4, -1, 15, -13,  ..
	- 2, 63, -1, -3, -1, -64, 9, -29, -32, 0, 7, -8, 127, -97, -25, -1, -1, 63, -4, 63, -4, -1, 15, -13,  ..
	- 2, 63, -33, -1, -1, -32, 9, -25, -32, 0, 7, -8, 127, -97, -25, -1, -1, 63, -4, 63, -4, -1, 15, -13,  ..
	- 1, 63, -33, -1, -1, -16, 9, -25, -32, 0, 7, -8, 127, -97, -25, -1, -1, 63, -4, 63, -4, -1, 15, -13,  ..
	- 1, 63, -49, -1, -1, -8, 9, -57, -32, 0, 7, -8, 127, -97, -25, -8, -1, 63, -2, 127, -4, -1, 15, -13,  ..
	- 1, -65, -49, -1, -1, -4, 9, -57, -32, 0, 7, -8, 127, -97, -25, -8, -1, 63, -2, 127, -4, -1, 15, -13,  ..
	- 1, -65, -57, -1, -1, -2, 9, -57, -32, 0, 7, -8, 127, -97, -25, -8, -1, 63, -2, 127, -4, -1, 15, -13,  ..
	- 1, -1, -57, -1, -1, -1, 9, -57, -32, 0, 7, -1, -1, -97, -25, -8, -1, 63, -1, -1, -4, -1, 15, -13, -1,  ..
	- 1, -61, -1, -1, -1, -119, -57, -32, 0, 7, -1, -1, -97, -25, -8, -1, 63, -1, -1, -4, -1, 15, -13, -1,  ..
	- 1, -61, -1, -1, -1, -55, -49, -32, 0, 7, -1, -1, -97, -25, -8, -1, 63, -1, -1, -4, -1, 15, -13, -1,  ..
	- 1, -63, -1, -1, -1, -23, -49, -32, 127, -57, -1, -1, -97, -25, -1, -1, 63, -1, -1, -4, -1, 15, -13,  ..
	- 1, -1, -63, -1, -1, -1, -16, -49, -32, -1, -25, -1, -1, -97, -25, -1, -1, 63, -33, -5, -4, -1, 15,  ..
	- 13, -1, -1, -64, -1, -9, -1, -7, -49, -32, -1, -25, -8, 127, -97, -25, -1, -1, 63, -33, -5, -4, -1,  ..
	15, -13, -1, -1, -64, -1, -13, -1, -32, -49, -32, -1, -25, -8, 127, -97, -25, -1, -2, 63, -49, -13,  ..
	- 4, -1, 15, -13, -1, -1, -64, 127, -7, -1, -119, -17, -15, -1, -25, -8, 127, -97, -25, -1, -2, 63,  ..
	- 49, -13, -4, -1, 15, -13, -3, -1, -64, 127, -8, -2, 15, -17, -1, -1, -25, -8, 127, -97, -25, -1,  ..
	- 8, 63, -49, -13, -4, -1, 15, -13, -3, -1, -64, 63, -4, 120, 0, -17, -1, -1, -25, -8, 127, -97, -25,  ..
	- 8, 0, 63, -57, -29, -4, -1, 15, -13, -4, -1, -64, 63, -4, 0, 15, -17, -1, -1, -25, -8, 127, -97,  ..
	- 25, -8, 0, 63, -57, -29, -4, -1, -1, -13, -4, -1, -64, 31, -2, 0, 0, 103, -1, -1, -57, -8, 127, -97,  ..
	- 25, -8, 0, 63, -57, -29, -4, -1, -1, -13, -4, 127, -64, 31, -2, 0, 15, 103, -1, -1, -57, -8, 127,  ..
	- 97, -25, -8, 0, 63, -61, -61, -4, 127, -1, -29, -4, 127, -64, 15, -8, 0, 0, 55, -1, -1, -121, -8,  ..
	127, -97, -25, -8, 0, 63, -61, -61, -4, 127, -1, -29, -4, 63, -64, 15, -32, 0, 0, 23, -1, -2, 3, -16,  ..
	63, 15, -61, -16, 0, 31, -127, -127, -8, 31, -1, -127, -8, 31, -128, 7, -128, 0, 0 ..
]

Function get_pixel:Int(x:Int, y:Int) inline
	Return (IMAGE_BITMAP[(x Shr 3) + y * image_row_length] Shr (~x & $7)) & 1
End Function

Global BodyCount:Int = 0

Function updateSpace(space:CPSpace, dt:Double)
	space.DoStep(dt)
End Function

Function DrawDot(body:Object, unused:Object)
	bmx_drawdot(3.5 / bmx_drawpointlinescale, CPBody(body).GetPosition(), New scolor8($ee, $e8, $d5, 255))
End Function

Function drawSpace(space:CPSpace)
	space.EachBody(DrawDot, Null)

    Local drawOptions:bmx_drawoptions = New bmx_drawoptions
    drawOptions.Flags = bmx_DRAW_COLLISION_POINTS
	
    drawOptions.collisionPointColor = New SColor8(255, 0, 0, 255)	' Collision point color
    
    bmx_draw(space, drawOptions)
End Function

Function make_ball:CPCircleShape(x:Double, y:Double)
	Local body:CPBody = New CPBody.Create(1.0, INFINITY)
	body.SetPosition(Vec2(x, y))
	
	Local shape:CPCircleShape = New CPCircleShape.Create(body, 0.95, CPVZero)
	shape.SetElasticity(0.0)
	shape.SetFriction(0.0)
	
	Return shape
End Function

Function initSpace:CPSpace()
	space = New CPSpace.Create()
	space.SetIterations(1)
	
'	The space will contain a very large number of similarly sized objects.
'	This is the perfect candidate for using the spatial hash.
'	Generally you will never need to do this.
	space.UseSpatialHash(2, 10000)
	
	BodyCount = 0
	
	Local body:cpBody
	Local shape:CPCircleShape
	
	For Local y:Int = 0 Until image_height
		For Local x:Int = 0 Until image_width
		Local tmp:Int = get_pixel(x, y)
			If Not get_pixel(x, y) Then Continue
			
			Local x_jitter:Double = 0.05 * Rnd()
			Local y_jitter:Double = 0.05 * Rnd()
			
			shape = make_ball(2 * (x - image_width / 2 + x_jitter), -(2 * (image_height / 2 - y + y_jitter)))
			space.AddBody(Shape.GetBody())
			space.AddShape(shape)
			
			BodyCount :+ 1
		Next
	Next
	
	Body = New CPBody.Create(1e9, INFINITY)
	space.AddBody(body)
	Body.SetPosition(Vec2(-1000, 10))
	Body.SetVelocity(Vec2(400, 0))
	
	shape = New CPCircleShape.Create(body, 8.0, CPVZero)
	space.AddShape(shape)
	Shape.SetElasticity(0.0)
	Shape.SetFriction(0.0)
	Shape.setFilter(NOT_GRABBABLE_FILTER)
	
	BodyCount :+ 1
	
	Return space
End Function

Function destroySpace(space:CPSpace)
	ChipmunkDemoFreeSpaceChildren(space)
	space.Free()
End Function

Global LogoSmash:ChipmunkDemo = New ChipmunkDemo( ..
	"Logo Smash",  ..
	1.0 / 60.0,  ..
	..
	initSpace,  ..
	updateSpace,  ..
	drawSpace,  ..
	destroySpace ..
, 0)
