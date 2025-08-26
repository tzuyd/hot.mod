
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

Global PLAYER_VELOCITY:Int = 500

Global PLAYER_GROUND_ACCEL_TIME:Float = 0.1
Global PLAYER_GROUND_ACCEL:Float = PLAYER_VELOCITY / PLAYER_GROUND_ACCEL_TIME

Global PLAYER_AIR_ACCEL_TIME:Float = 0.25
Global PLAYER_AIR_ACCEL:Float = PLAYER_VELOCITY / PLAYER_AIR_ACCEL_TIME

Global JUMP_HEIGHT:Float = 50.0
Global JUMP_BOOST_HEIGHT:Float = 55.0
Global FALL_VELOCITY:Float = 900.0
Global GRAVITY:Float = 2000.0

Global playerBody:CPBody = Null
Global playerShape:CPPolyShape = Null

Global remainingBoost:Double = 0
Global grounded:Int = False
Global lastJumpState:Int = False

Global groundNormal:CPVect = CPVZero

Function SelectPlayerGroundNormal(body:Object, arb:Object, unused:Object)
    Local n:CPVect = cpArbiter(Arb).GetNormal().Negate()

    If n.y < groundNormal.y Then groundNormal = n
End Function

Function PlayerUpdateVelocity(body:CPBody, gravityv:CPVect, damping:Double, dt:Double)
    Local jumpState:Int = (ChipmunkDemoKeyboard.y < 0)

'	// Grab the grounding normal from last frame
	groundNormal = Vec2(0, 0)
    playerBody.EachArbiter(SelectPlayerGroundNormal)

    grounded = (groundNormal.y < 0)
    If groundNormal.y > 0 Then remainingBoost = 0.0

'	// Do a normal-ish update
    Local boost:Int = (jumpState And remainingBoost < 0.0)
    Local g:CPVect
	If boost Then g = CPVZero Else g = GRAVITYv
    playerBody.UpdateVelocity(g, damping, dt)

'	// Target horizontal speed for air/ground control
    Local target_vx:Double = PLAYER_VELOCITY * ChipmunkDemoKeyboard.x

'	// Update the surface velocity and friction
'	// Note that the "feet" move in the opposite direction of the player.
    Local surface_v:CPVect = Vec2(-target_vx, 0.0)
    playerShape.SetSurfaceVelocity(surface_v)
	If grounded Then playerShape.SetFriction(PLAYER_GROUND_ACCEL / GRAVITY) Else playerShape.SetFriction(0.0)

'	// Apply air control if not grounded
	Local bodyv:CPVect = playerBody.GetVelocity()
    If Not grounded Then bodyv.x = lerpconst(playerBody.GetVelocity().x, target_vx, PLAYER_AIR_ACCEL * dt) '	// Smoothly accelerate the velocity

    bodyv.y = Clamp(bodyv.y, -FALL_VELOCITY, INFINITY)
	playerBody.SetVelocity(bodyv)
End Function

Function PlayerUpdate(space:CPSpace, dt:Double)
    Local jumpState:Int = (ChipmunkDemoKeyboard.y < 0)

'	// If the jump key was just pressed this frame, jump!
    If jumpState And (Not lastJumpState) And grounded Then
        Local jump_v:Double = Sqr(2.0 * JUMP_HEIGHT * GRAVITY)
        playerBody.SetVelocity(playerBody.GetVelocity().Add(Vec2(0.0, -jump_v)))
 
        remainingBoost = JUMP_BOOST_HEIGHT / jump_v
    End If

'	// Step the space
	space.DoStep(dt)

    remainingBoost:+dt
    lastJumpState = jumpState
End Function

Function InitPlayerSpace:CPSpace()
	init()
    space.SetIterations(10)
    space.SetGravity(Vec2(0, GRAVITY))
'	space.setsleepTimeThreshold(1000)

    Local staticBody:CPBody = Space.GetStaticBody()
    Local body:CPBody
    Local shape:CPSegmentShape

'	// Create segments around the edge of the screen.
	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(-320, -240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
	shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(320, 240), Vec2(320, -240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
	shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320, 240), Vec2(320, 240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
	shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)

	Shape = New CPSegmentShape.Create(staticBody, Vec2(-320, -240), Vec2(320, -240), 0.0)
    space.AddShape(shape)
    shape.SetElasticity(1.0)
	shape.SetFriction(1.0)
    Shape.setFilter(NOT_GRABBABLE_FILTER)
	
'	// Set up the player
	playerBody = New CPBody.Create(1.0, INFINITY)
    space.AddBody(playerBody)
    playerBody.SetPosition(Vec2(0, 200))
    playerBody.SetVelocityFunction(PlayerUpdateVelocity)

	playerShape = New CPBoxShape.Create(playerBody, New CPBB.Create(-15.0, 27.5, 15.0, -27.5), 10.0)
'	Local radius:Double = 10.0
'    playerShape = New CPSegmentShape.Create(playerBody, CPVZero, Vec2(0, -radius), radius)
	space.AddShape(playerShape)
	playerShape.SetElasticity(0.0)
	playerShape.SetFriction(0.0)
	playerShape.SetCollisionType(1)
	
	' Add some boxes to jump on
	For Local i:Int = 0 Until 6
	    For Local j:Int = 0 Until 3
			body = New CPBody.Create(4.0, INFINITY)
	        space.AddBody(body)
	        body.SetPosition(Vec2(100 + j * 60, -(-200 + i * 60)))
	        
			Local polyshap:CPPolyShape = New CPboxShape.Create(body, 50, 50, 0.0)
	        space.AddShape(polyshap)
	        polyshap.SetElasticity(0.0)
			polyshap.SetFriction(0.7)
	    Next
	Next

    Return space
End Function

Function DestroyPlayerSpace(space:CPSpace)
    ChipmunkDemoFreeSpaceChildren(space)
    space.Free()
	CleanUp
End Function

Global PlayerDemo:ChipmunkDemo = New ChipmunkDemo( ..
	"Platformer Player Controls",  ..
	1.0 / 180.0,  ..
	..
	InitPlayerSpace,  ..
	PlayerUpdate,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	DestroyPlayerSpace ..
, 18)

    ' Initialize the demo
    RunDemo(demo_index)

While Not KeyDown(KEY_ESCAPE)

	Cls
	
	display()
	event()

Wend

End
