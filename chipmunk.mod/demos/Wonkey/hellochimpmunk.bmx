
SuperStrict

Framework brl.StandardIO
Import brl.Max2D
Import brl.d3d9max2d

Import hot.chipmunk

Import "chipmunkdebugger.bmx"

Type HelloChipmunk

	Field space:CPSpace
	Field ground:CPSegmentShape
	
	Field ballBody:CPBody
	Field ballShape:CPCircleShape

	Field ballBody2:CPBody
	Field ballShape2:CPCircleShape

	Field polyBody:CPBody
	Field polyShape:CPPolyShape
	
	Method run()
		
		SetClsColor(128, 128, 128, 1)'(0, 0, 0, 1)

		'Create a new space and set its gravity to 100
		'		
		space = New CPSpace.Create()
		space.SetGravity(Vec2(0, 100))
		
		'Add a static line segment shape for the ground.
		'We'll make it slightly tilted so the ball will roll off.
		'We attach it to space->staticBody to tell Chipmunk it shouldn't be movable.
		'
		ground = New CPSegmentShape.Create(space.getstaticbody(), Vec2(-100, 15), Vec2(100, -15), 0)
		ground.SetFriction(1)
		ground.SetCollisionType(1)
		space.AddShape( ground )
		
		Local tshape:CPSegmentShape = New CPSegmentShape.Create(space.getstaticbody(), Vec2(-GraphicsWidth() / 2, GraphicsHeight() / 2 - 64), Vec2(0, GraphicsHeight() / 2), 0)
		tshape.SetFriction(1)
		tshape.SetCollisionType(1)
		space.AddShape(tshape)

		tshape = New CPSegmentShape.Create(space.getstaticbody(), Vec2(0, GraphicsHeight() / 2), Vec2(GraphicsWidth() / 2, GraphicsHeight() / 2 - 64), 0)
		tshape.SetFriction(1)
		tshape.SetCollisionType(1)
		space.AddShape(tshape)
		
		'Now let's make a ball that falls onto the line and rolls off.
		'First we need to make a cpBody to hold the physical properties of the object.
		'These include the mass, position, velocity, angle, etc. of the object.
		'Then we attach collision shapes to the cpBody to give it a size and shape.
		
		Local mass:Double = 1.0
		Local radius:Double = 10.0
  
		'The moment of inertia is like mass for rotation
		'Use the cpMomentFor*() functions to help you approximate it.
		Local moment:Double = MomentForCircle(mass, 0, radius, CPVZero)

		'The cpSpaceAdd*() functions return the thing that you are adding.
		'It's convenient to create and add an object in one line.
		ballBody = New CPBody.Create(mass, moment)
		ballBody.SetPosition(Vec2(0, -100))
		space.AddBody(ballBody)

		'Now we create the collision shape for the ball.
		'You can create multiple collision shapes that point to the same body.
		'They will all be attached to the body and move around to follow it.
		ballShape = New CPCircleShape.Create(ballBody, radius, CPVZero)
		ballShape.SetFriction(0.7)
		ballShape.SetCollisionType(2)
		space.AddShape(ballShape)

		ballBody2 = New CPBody.Create(mass, moment)
		ballBody2.SetPosition(Vec2(50, -100))
		space.AddBody(ballBody2)
		
		ballShape2 = New CPCircleShape.Create(ballBody2, radius, CPVZero)
		ballShape2.SetFriction(0.7)
		ballShape2.SetCollisionType(2)
		space.AddShape(ballShape2)
		
		'Now a pentagon...
		mass = 0.3
		radius=30.0

		Local NUM_VERTS:Int = 5
		Local verts:CPVect[] = New CPVect[NUM_VERTS]
		For Local it:Int = 0 Until NUM_VERTS
			Local angle:Float = 360 / NUM_VERTS * (4 - it)
			verts[it] = New CPVect
			verts[it] = Vec2(radius * Cos(angle), radius * Sin(angle))
		Next

		moment = MomentForPoly(mass, verts, CPVZero)
		polyBody = New CPBody.Create(mass, moment)
		polyBody.SetPosition(Vec2(50.0, -190.0))
		space.AddBody(polyBody)
				
		polyShape = New CPPolyShape.Create(polyBody, verts, Vec2(0, 0))
		polyShape.SetFriction(0.03)
		space.AddShape(polyShape)
		
		space.SetDefaultCollisionPairFunc(Lambda)
	End Method
	
		'Add collision handler...
		Function Lambda:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object)

			Print "Collision! a=" + cpShapeGetCollisionType(shapeA.cpObjectPtr) + ", b=" + cpShapeGetCollisionType(shapeB.cpObjectPtr)
			
			Return True
		End Function

	Method OnRender()
	
		Const timeStep:Float = 1.0 / 60.0
		
		space.DoStep(timeStep)
		
'		Local rot:=ballBody.Rotation
'		Local pos:=ballBody.Position
'		Local vel:=ballBody.Velocity
'		Print "ball rot="+ATan2( rot.y,rot.x )+", pos.x="+pos.x+", pos.y="+pos.y+", vel.x="+vel.x+", vel.y="+vel.y
'		Print cpVersionString
		SetOrigin GraphicsWidth() / 2, GraphicsHeight() / 2
		
		space.GetActiveShapes().ForEach(DebugDraw)
	End Method
	
	Method CleanUp()	'Yeah, right!
		ballShape.Free
		ballBody.Free
		ground.Free
		space.Free
	End Method
	
End Type

Graphics 640, 480, 0

Local Main:HelloChipmunk = New HelloChipmunk
Main.run

While Not KeyDown(KEY_ESCAPE)

	Cls

	Main.OnRender()

	Flip


Wend

Main.CleanUp()

End
