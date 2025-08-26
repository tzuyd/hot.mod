
' Copyright (c) 2007-2016 Bruce A Henderson
' 
' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:
' 
' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.
' 
SuperStrict

Rem
bbdoc: Chipmunk 2D Physics
End Rem
Module hot.Chipmunk

ModuleInfo "Version: 1.08"
ModuleInfo "License: MIT"
ModuleInfo "Copyright: Wrapper - 2007-2016 Bruce A Henderson"
ModuleInfo "History:   Wrapper - 2024 1.07 Hotcakes"
ModuleInfo "Modserver: BRL"
ModuleInfo "REQUIRES:  BlitzMax NG build v0.136 or later"

ModuleInfo "History: 1.08"
ModuleInfo "History: Chipmunk Pro update!  Sort of"
ModuleInfo "History: Fixed:      CPContact.SetR2 (was setting R1 instead)"
ModuleInfo "History: Fixed:      beginFunc, postSolveFunc and separateFunc (Shape data set incorrectly)"
ModuleInfo "History: NEW:        CPVect.DistSq :Double()"
ModuleInfo "History: NEW:        CPBB.NewForCircle :CPBB()"
ModuleInfo "History: NEW:        CPSpace.RemoveShape ()"
ModuleInfo "History: 1.07"
ModuleInfo "History: Updated To latest v7.0.3 source."
ModuleInfo "History: Changed:    ResizeActiveHash () And ResizeStaticHash () have been merged into UseSpatialHash ()"
ModuleInfo "History:                 Using this will switch back from new Default Spatial Indexing to v5 Spatial Hashing"
ModuleInfo "History: Broken:     Joints seemingly randomly initialise at the wrong co-ordinates before correcting themselves"
ModuleInfo "History:                 after one frame, but this is often enough time to break those connected - see Pump.bmx"
ModuleInfo "History: Broken:     CPPivotJoint.Create (bodyA, bodyB, pivot)"
ModuleInfo "History:                 Use CPPivotJoint.Create (bodyA, bodyB, anchorA, anchorB) instead"
ModuleInfo "History: Fixed:      Collisions (broken since 1.02)"
ModuleInfo "History: Fixed:      MomentForCircle () (returning garbage via incorrect Ptr)"
ModuleInfo "History: Fixed:      If a cpObjectPtr has been bound, Freeing it *needs* cpunbind ()"
ModuleInfo "History: TODO:       Decide on an elegant way to synchronise local CPVect updates with Chipmunk"
ModuleInfo "History: NEW:        CPTransform "
ModuleInfo "History: NEW:        clamp :Double()"
ModuleInfo "History: NEW:        lerp :Double()"
ModuleInfo "History: NEW:        lerpconst :Double()"
ModuleInfo "History: NEW:        CPVect.RPerp :CPVect()"
ModuleInfo "History: NEW:        CPVect.Lerp :CPVect()"
ModuleInfo "History: NEW:        CPVect.Dist :Double()"
ModuleInfo "History: NEW:        CPVect.Near :Int()"
ModuleInfo "History: NEW:        CPVect.ForAngle :CPVect()"
ModuleInfo "History: NEW:        CPBody.CreateKinematic ()"
ModuleInfo "History: NEW:        CPBody.GetType :Byte Ptr()"
ModuleInfo "History: NEW:        CPBody.GetMoment :Double()"
ModuleInfo "History: NEW:        CPBody.GetCenterOfGravity :CPVect()"
ModuleInfo "History: NEW:        MomentForSegment :Double()"
ModuleInfo "History: NEW:        MomentForBox :Double()"
ModuleInfo "History: NEW:        AreaForPoly :Double()"
ModuleInfo "History: NEW:        CPBody.VelocityAtWorldPoint :CPVect()"
ModuleInfo "History: NEW:        CPBody.ApplyImpulseAtWorldPoint ()"
ModuleInfo "History: NEW:        CPBody.IsSleeping :Int()"
ModuleInfo "History: NEW:        CPBody.EachArbiter ()"
ModuleInfo "History: NEW:        CPShape.GetCollisionType :Int()"
ModuleInfo "History: NEW:        CPShape.SetFilter ()"
ModuleInfo "History: NEW:        CPShape.GetBB :CPBB()"
ModuleInfo "History: NEW:        CPShape.GetSensor :Int()"
ModuleInfo "History: NEW:        CPShape.SetSensor ()"
ModuleInfo "History: NEW:        CentroidForPoly :CPVect()"
ModuleInfo "History: NEW:        CPShape.PointQuery :Double()"
ModuleInfo "History: NEW:        CPCircleShape.GetOffset :CPVect()"
ModuleInfo "History: NEW:        CPSegmentShape.GetRadius :Double()"
ModuleInfo "History: NEW:        CPSegmentShape.SetNeighbors ()"
ModuleInfo "History: NEW:        CPPolyShape.GetRadius :Double()"
ModuleInfo "History: NEW:        CPBoxShape "
ModuleInfo "History: NEW:        ConvexHull :Int()"
ModuleInfo "History: NEW:        CPSpace.GetGravity :CPVect()"
ModuleInfo "History: NEW:        CPSpace.SetSleepTimeThreshold ()"
ModuleInfo "History: NEW:        CPSpace.SetCollisionSlop ()"
ModuleInfo "History: NEW:        CPSpace.GetCurrentTimeStep :Double()"
ModuleInfo "History: NEW:        CPSpace.GetStaticBody :CPBody()"
ModuleInfo "History: NEW:        CPSpace.AddWildcardFunc ()"
ModuleInfo "History: NEW:        CPSpace.AddPostStepCallback :Int()"
ModuleInfo "History: NEW:        CPSpace.EachShape ()"
ModuleInfo "History: NEW:        CPSpace.EachConstraint ()"
ModuleInfo "History: NEW:        CPSpace.PointQueryNearest :CPShape()"
ModuleInfo "History: NEW:        CPSpace.SegmentQuery ()"
ModuleInfo "History:                Note: Chipmunk docs are incorrect"
ModuleInfo "History: NEW:        CPSpace.SegmentQueryFirst :CPShape()"
ModuleInfo "History: NEW:        CPConstraint.GetMaxForce :Double()"
ModuleInfo "History: NEW:        CPConstraint.SetMaxForce ()"
ModuleInfo "History: NEW:        CPConstraint.SetErrorBias ()"
ModuleInfo "History: NEW:        CPConstraint.SetMaxBias ()"
ModuleInfo "History: NEW:        CPConstraint.SetCollideBodies ()"
ModuleInfo "History: NEW:        CPConstraint.GetImpulse :Double()"
ModuleInfo "History: NEW:        CPPinJoint.SetDist ()"
ModuleInfo "History: NEW:        CPSlideJoint.SetMax ()"
ModuleInfo "History: NEW:        CPPivotJoint.SetAnchorA ()"
ModuleInfo "History: NEW:        CPDampedSpring "
ModuleInfo "History: NEW:        CPDampedSpring.GetAnchorA :CPVect()"
ModuleInfo "History: NEW:        CPDampedSpring.GetAnchorB :CPVect()"
ModuleInfo "History: NEW:        CPDampedSpring.GetRestLength :Double()"
ModuleInfo "History: NEW:        CPDampedSpring.GetStiffness :Double()"
ModuleInfo "History: NEW:        CPDampedRotarySpring "
ModuleInfo "History: NEW:        CPRotaryLimitJoint "
ModuleInfo "History: NEW:        CPRatchetJoint "
ModuleInfo "History: NEW:        CPGearJoint "
ModuleInfo "History: NEW:        CPSimpleMotor "
ModuleInfo "History: NEW:        CPSimpleMotor.SetRate ()"
ModuleInfo "History: NEW:        CPArbiter.Ignore :Int()"
ModuleInfo "History: NEW:        CPArbiter.GetUserData :Object()"
ModuleInfo "History: NEW:        CPArbiter.SetUserData :Object()"
ModuleInfo "History: NEW:        CPArbiter.GetCount :Int()"
ModuleInfo "History: NEW:        CPArbiter.GetPointA :CPVect()"
ModuleInfo "History:                Note: Chipmunk docs are incorrect"
ModuleInfo "History: NEW:        CPArbiter.GetPointB :CPVect()"
ModuleInfo "History:                Note: Chipmunk docs are incorrect"
ModuleInfo "History: NEW:        CPArbiter.GetNormal :CPVect()"
ModuleInfo "History: NEW:        CPArbiter.GetShapes ()"
ModuleInfo "History: NEW:        CPArbiter.GetBodies ()"
ModuleInfo "History: NEW:        CPArbiter.SetContactPointSet ()"
ModuleInfo "History: NEW:        CPArbiter.TotalImpulse :CPVect()"
ModuleInfo "History: NEW:        CPPointQueryInfo (not working)"
ModuleInfo "History: NEW:        CPSegmentQueryInfo (not working)"
ModuleInfo "History: "
ModuleInfo "History: 1.05"
ModuleInfo "History: Updated For NG."
ModuleInfo "History: 1.04"
ModuleInfo "History: Updated To latest v5 source."
ModuleInfo "History: Changed CPJoint To CPConstraint."
ModuleInfo "History: Now uses Double instead of Float."
ModuleInfo "History: 1.03"
ModuleInfo "History: Added user Set/GetData() methods For CPBody And CPShape."
ModuleInfo "History: 1.02"
ModuleInfo "History: Update To latest Chipmunk source."
ModuleInfo "History: Added callbacks For body velocity And position."
ModuleInfo "History: 1.01"
ModuleInfo "History: Adds body SetTorque()."
ModuleInfo "History: Adds joint Free()."
ModuleInfo "History: Fixes problem where Free'ing wasn't removing the objects from the space."
ModuleInfo "History: 1.00"
ModuleInfo "History: Initial release."

ModuleInfo "C_OPTS: -std=gnu99"

Import brl.map
Import brl.math
Import brl.linkedlist
Import brl.pixmap
Import brl.bank
Import brl.max2d

Import "common.bmx"

Rem
bbdoc: Initialises the physics engine.  (deprecated in 1.07)
End Rem
Function InitChipmunk()
'	cpInitChipmunk()
End Function

Rem
bbdoc: Resets the shape id counter.  (deprecated in 1.07)
about: Chipmunk keeps a counter so that every New shape is given a unique hash value To be used in the spatial hash.
Because this affects the order in which the collisions are found And handled, you should reset the shape counter
every time you populate a space with New shapes. If you don't, there might be (very) slight differences in the simulation.
End Rem
Function ResetShapeIdCounter()
'	cpResetShapeIdCounter()
End Function
	
	
Type CPObject

	Field cpObjectPtr:Byte Ptr
	Field parent:CPSpace
	
End Type

Type _posFunc

	Field func(Body:CPBody, dt:Double)
	
End Type

Type _velFunc

	Field func(body:CPBody, gravity:CPVect, damping:Double, dt:Double)
	
End Type

Rem
bbdoc: A rigid body holds the physical properties of an object. (mass, position, velocity, etc.)
about: It does Not have a shape by itself. By attaching shapes To bodies, you can define the a body's shape.
You can attach many shapes To a single body To define a complex shape, Or none If it doesn't require a shape.
End Rem
Type CPBody Extends CPObject

	'Global posFuncs:TMap = New TMap
	'Global velFuncs:TMap = New TMap
	Field posFunction(body:CPBody, dt:Double)
	Field velFunction(body:CPBody, gravity:CPVect, damping:Double, dt:Double)

	Field Transform:CPTransform
	Field sleeping:sleeping
	
	Function _create:CPBody(cpObjectPtr:Byte Ptr)
		If cpObjectPtr Then
			Local this:CPBody = New CPBody
			this.cpObjectPtr = cpObjectPtr
			this._Update
			Return this
		Else
			DebugStop
		End If
	End Function

	Rem
	bbdoc: Creates a New body
	about: @mass=INFINITY to create a Static body
	End Rem
	Method Create:CPBody(mass:Double, inertia:Double)
		cpObjectPtr = bmx_cpbody_create(Self, mass, inertia)
		_Update
		Return Self
	End Method
	
	Method _Update()
		If cpObjectPtr
			If Not sleeping
				sleeping = New sleeping
			End If
			Local tt:CPTransform = New CPTransform
			sleeping.idleTime = bmx_cpbody_update(cpObjectPtr)

		    ' Construct transformation matrix manually
			Self.Transform = tt
		    Self.Transform.a = Cos(Self.GetAngle())
		    Self.Transform.b = -Sin(Self.GetAngle())
		    Self.Transform.tx = Self.GetPosition().x
		    Self.Transform.c = Sin(Self.GetAngle())
		    Self.Transform.d = Cos(Self.GetAngle())
		    Self.Transform.ty = Self.GetPosition().y
		End If
	End Method

	Rem
	bbdoc: Creates a New Kinematic body
	End Rem
	Method CreateKinematic:CPBody()
		cpObjectPtr = bmx_cpbody_createkinematic(Self)
		_Update
		Return Self
	End Method
	
	Rem
	bbdoc: the type of a body (dynamic, kinematic, static).
	about: See the section on <a href="http://chipmunk-physics.net/release/ChipmunkLatest-Docs/#BodyTypes">BodyTypes</a> for more information. 
	end rem
	Method GetType:Byte Ptr()
		Return cpBodyGetType(cpObjectPtr)
	End Method

	Rem
	bbdoc: Set the type of a body (dynamic, kinematic, static).
	about: See the section on <a href="http://chipmunk-physics.net/release/ChipmunkLatest-Docs/#BodyTypes">BodyTypes</a> for more information. 
	When changing an body to a dynamic body, the mass and moment of inertia are recalculated from the shapes added to the body. 
	Custom calculated moments of inertia are not preseved when changing types. 
	This function cannot be called directly in a collision callback. 
	See <a href="https://chipmunk-physics.net/release/ChipmunkLatest-Docs/#PostStep">Post-Step Callbacks</a> for more information.
	end rem
	Method SetType(cpBodyType:Byte Ptr)
		cpBodySetType(cpObjectPtr, cpBodyType)
	End Method

	Rem
	bbdoc: Returns the body mass.
	End Rem
	Method GetMass:Double()
		Return bmx_cpbody_getmass(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Moment of inertia (MoI or sometimes just moment) of the body.
	about: The moment is like the rotational mass of a body.
	EndRem
	Method GetMoment:Double()
		Return cpBodyGetMoment(cpObjectPtr)
	End Method

	Rem
	bbdoc: Location of the center of gravity in body local coordinates.
	about: The default value is (0, 0), meaning the center of gravity is the same as the position of the body.
	EndRem
	Method GetCenterOfGravity:CPVect()
		Return CPVect._create(bmx_cpbody_getcenterofgravity(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the body inertia.
	End Rem
	Method GetInertia:Double()
		Return bmx_cpbody_getinertia(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Gets the current angle For the body.
	End Rem
	Method GetAngle:Double()
		Return bmx_cpbody_getangle(cpObjectPtr)
	End Method

	Rem
	bbdoc: Sets the body angle
	End Rem
	Method SetAngle(angle:Double)
		bmx_cpbody_setangle(cpObjectPtr, angle)
	End Method
	
	Rem
	bbdoc: Returns the body angular velocity.
	End Rem
	Method GetAngularVelocity:Double()
		Return bmx_cpbody_getangularvelocity(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Sets the body angular velocity.
	End Rem
	Method SetAngularVelocity(av:Double)
		bmx_cpbody_setangularvelocity(cpObjectPtr, av)
	End Method
	
	Rem
	bbdoc: Returns the body torque.
	End Rem
	Method GetTorque:Double()
		Return bmx_cpbody_gettorque(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Sets the body torque.
	End Rem
	Method SetTorque(torque:Double)
		bmx_cpbody_settorque(cpObjectPtr, torque)
	End Method
	
	Rem
	bbdoc: Sets the body position.
	End Rem
	Method SetPosition(pos:CPVect)
		bmx_cpbody_setposition(cpObjectPtr, pos.vecPtr)
	End Method
	
	Rem
	bbdoc: Gets the body position
	End Rem
	Method GetPosition:CPVect()
		Return CPVect._create(bmx_cpbody_getposition(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Sets the body velocity.
	End Rem
	Method SetVelocity(velocity:CPVect)
		bmx_cpbody_setvelocity(cpObjectPtr, velocity.vecPtr)
	End Method
	
	Rem
	bbdoc: Returns the body velocity.
	End Rem
	Method GetVelocity:CPVect()
		Return CPVect._create(bmx_cpbody_getvelocity(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Updates the velocity of the body using Euler integration.
	about: You don't need To call this unless you are managing the Object manually instead of adding it To a CPSpace.
	End Rem
	Method UpdateVelocity(gravity:CPVect, damping:Double, dt:Double)
		bmx_cpbody_updatevelocity(cpObjectPtr, gravity.vecPtr, damping, dt)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method GetRot:CPVect()
		Return CPVect._create(bmx_cpbody_getrot(cpObjectPtr))
	End Method

	Rem
	bbdoc: Sets the body mass.
	End Rem
	Method SetMass(mass:Double)
	        cpBodySetMass(cpObjectPtr, mass)
	End Method
	
	Rem
	bbdoc: Sets the body moment.
	End Rem
	Method SetMoment(moment:Double)
		cpBodySetMoment(cpObjectPtr, moment)
	End Method
	
	Rem
	bbdoc: Updates the position of the body using Euler integration.
	about: Like UpdateVelocity() you shouldn't normally need To call this yourself.
	End Rem
	Method UpdatePosition(dt:Double)
		cpBodyUpdatePosition(cpObjectPtr, dt)
	End Method
	
	Rem
	bbdoc: Zero both the forces And torques accumulated on body.
	End Rem
	Method ResetForces()
		bmx_cpbody_setforce(cpObjectPtr, Vec2(0, 0))
		bmx_cpbody_settorque(cpObjectPtr, 0)
	End Method
	
	Rem
	bbdoc: Apply (accumulate) the @force on body with @offset.
	about: Both @force And @offset should be in world coordinates.
	End Rem
	Method ApplyForce(force:CPVect, offset:CPVect)
		bmx_cpbody_applyforce(cpObjectPtr, force.vecPtr, offset.vecPtr)
	End Method
	
	Rem
	bbdoc: Convert body Local To world coordinates.
	End Rem
	Method Local2World:CPVect(vec:CPVect)
		Return CPVect._create(bmx_cpbody_local2world(cpObjectPtr, vec.vecPtr))
	End Method
	
	Rem
	bbdoc: Convert world To body Local coordinates
	End Rem
	Method World2Local:CPVect(vec:CPVect)
		Return CPVect._create(bmx_cpbody_world2local(cpObjectPtr, vec.vecPtr))
	End Method
	
	Rem
	bbdoc: Get the absolute velocity of the rigid body at the given world point @point.
	about: It’s often useful to know the absolute velocity of a point on the surface of a body since the angular velocity affects everything except the center of gravity.
	end rem
	Method VelocityAtWorldPoint:CPVect(Point:CPVect)
		Return CPVect._create(bmx_cpbody_velocityatworldpoint(cpObjectPtr, Point.vecPtr))
	End Method

	Rem
	bbdoc: Add the impulse @impulse to body as if applied from the world point @point.
	EndRem
	Method ApplyImpulseAtWorldPoint(impulse:CPVect, Point:CPVect)
		bmx_cpbody_applyimpulseatworldpoint(cpObjectPtr, impulse.vecPtr, Point.vecPtr)
	End Method

	Rem
	bbdoc: Apply the @impulse To the body with @offset.
	about: Both @impulse And @offset should be in world coordinates.
	End Rem
	Method ApplyImpulse(impulse:CPVect, offset:CPVect)
		bmx_body_applyimpulse(cpObjectPtr, impulse.vecPtr, offset.vecPtr)
	End Method

	Rem
	bbdoc: Modify the velocity of an Object so that it will slew.
	End Rem
	Method Slew(pos:CPVect, dt:Double)
		bmx_body_slew(cpObjectPtr, pos.vecPtr, dt)
	End Method
	
	Rem
	bbdoc: Sets the position function.
	End Rem
	Method SetPositionFunction(func(Body:CPBody, dt:Double))
		posFunction = func
		bmx_cpbody_posfunc(cpObjectPtr, bmx_position_function)
	End Method
	
	Function _positionFunction(body:CPBody, dt:Double) { nomangle }
		body.posFunction(body, dt)
	End Function

	Rem
	bbdoc: Sets the velocity function.
	End Rem
	Method SetVelocityFunction(func(Body:CPBody, gravity:CPVect, damping:Double, dt:Double))
		velFunction = func
		bmx_cpbody_velfunc(cpObjectPtr, bmx_velocity_function)
	End Method
	
	Function _velocityFunction(body:CPBody, gravity:Byte Ptr, damping:Double, dt:Double) { nomangle }
		body.velFunction(body, CPVect._create(gravity), damping, dt)
	End Function
	
	Rem
	bbdoc: Sets user data For the body.
	End Rem
	Method SetData(data:Object)
		bmx_cpbody_setdata(cpObjectPtr, data)
	End Method
	
	Rem
	bbdoc: Retrieves user data For the body, Or Null If Not set.
	End Rem
	Method GetData:Object()
		Return bmx_cpbody_getdata(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Returns true if body is sleeping.
	end rem
	Method IsSleeping:Int()
		Return cpBodyIsSleeping(cpObjectPtr)
	End Method

	Rem
	bbdoc: This one is more interesting.
	about: Calls callback once for each collision pair that body is involved in. 
	Calling CPArbiter.Get[Bodies|Shapes]() will return the body or shape for body as the first argument. 
	You can use this to check all sorts of collision information for a body like if itâ€™s touching the ground, another particular object, how much collision force is being applied to an object, etc. 
	Sensor shapes and arbiters that have been rejected by a collision handler callback or CPArbiter.Ignore() are not tracked by the contact graph.
	End Rem
	Method EachArbiter(callback(body:Object, arbiter:Object, callbackData:Object), Data:Object = Null)
		
		Local cb:TBodyFuncCallback = New TBodyFuncCallback
		cb.callback = callback
		cb.data = data
		
		cpBodyEachArbiter(cpObjectPtr, hashCallback, cb)
		
	End Method
	
	Function hashCallback(body:Byte Ptr, arbiter:Byte Ptr, callbackData:Object)
		If TBodyFuncCallback(callbackData) Then
			TBodyFuncCallback(callbackData).callback(cpfind(body), cpArbiter._create(arbiter), TBodyFuncCallback(callbackData).Data)
		End If
	End Function

	Rem
	bbdoc: Frees the body.
	End Rem
	Method Free()
		If cpObjectPtr Then
			cpSpaceRemoveBody(parent.cpObjectPtr, cpObjectPtr)
			cpBodyFree(cpObjectPtr)
			cpunbind(cpObjectPtr)
			cpObjectPtr = Null
		End If
	End Method
	
End Type


Type _CollisionPair

	Field abHash:Int
	
	Field Data:Object
	Field beginFunc:Int(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object)
	Field preSolveFunc:Int(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object)
	Field postSolveFunc(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object)
	Field separateFunc(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object)
	
    Field normalCoeficient:Float = 1
	
	Method Compare:Int(obj:Object)
		Return abHash - _CollisionPair(obj).abHash
	End Method
	
End Type

Rem
bbdoc: Spaces are the basic simulation unit in Chipmunk.
about: You add bodies, shapes And joints To a space, And Then update the space as a whole.
<p>Notes</p>
<ul>
<li>When removing objects from the space, make sure you remove any other objects that reference it. For instance,
when you remove a body, remove the joints And shapes attached To it.</li>
<li>The number of iterations, And the size of the time Step determine the quality of the simulation. More iterations,
Or smaller time steps increase the quality.</li>
</li>Because static shapes are only rehashed when you request it, it's possible To use a much higher count argument To
CPHash.ResizeStaticHash() than To cpHashResizeStaticHash(). Doing so will use more memory though.</li>
</ul>
End Rem
Type CPSpace Extends CPObject

	Field activeShapes:CPSpatialIndex
	Field staticShapes:CPSpatialIndex
	
	Field collisionPairs:TMap = New TMap

	Field arbiters:CPArray
	
	Rem
	bbdoc: Creates a New CPSpace.
	End Rem
	Method Create:CPSpace()
		If ENABLE_HASTY
		?Not ios
			cpObjectPtr = bmx_cphastyspace_new(Self)
		?
		Else
			cpObjectPtr = bmx_cpspace_create(Self)
		End If
		Return Self
	End Method

	Method _Update()
		If cpObjectPtr
	'		bmx_cpspace_update Self.cpObjectPtr, VarPtr(arbiters)
			DebugStop
		End If
	End Method
	
	Rem
	bbdoc: /// Set the number of @threads to use for the solver.
	about: /// On ARM platforms that support NEON, this will enable the vectorized solver.
	/// CPSpace also supports multiple threads, but runs single threaded by default for determinism.
	End Rem
	Method SetThreads(threads:Size_T)
		If ENABLE_HASTY
		?Not ios
			cpHastySpaceSetThreads(cpObjectPtr, threads)
		?
		EndIf
	End Method

	Rem
	bbdoc: Global gravity applied to the space.
	about: Defaults to CPVZero. 
	Can be overridden on a per body basis by writing custom integration functions. 
	Changing the gravity will activate all sleeping bodies in the space.
	End Rem
	Method GetGravity:CPVect()
		Return CPVect._create(bmx_cpspace_getgravity(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Sets the amount of gravity applied To the system.
	End Rem
	Method SetGravity(vec:CPVect)
		bmx_cpspace_setgravity(cpObjectPtr, vec.vecPtr)
	End Method
	
	Rem
	bbdoc: Sets the amount of viscous damping applied To the system.
	End Rem
	Method SetDamping(damping:Double)
		bmx_cpspace_setdamping(cpObjectPtr, damping)
	End Method

	Rem
	bbdoc: Time a group of bodies must remain idle in order to fall asleep.
	about: The default @value of INFINITY disables the sleeping feature.
	end rem
	Method SetSleepTimeThreshold(Value:Double = INFINITY)
		cpSpaceSetSleepTimeThreshold(cpObjectPtr, Value)
	End Method
	
	Rem
	bbdoc: Amount of overlap between shapes that is allowed.
	about: To improve stability, set this as high as you can without noticable overlapping. 
	It defaults to 0.1.
	end rem
	Method SetCollisionSlop(Value:Double)
		cpSpaceSetCollisionSlop(cpObjectPtr, Value)
	End Method
	
	Rem
	bbdoc: Retrieves the current (if you are in a callback from DoStep()) or most recent (outside of a DoStep() call) timestep.
	End Rem
	Method GetCurrentTimeStep:Double()
		Return cpSpaceGetCurrentTimeStep(cpObjectPtr)
	End Method

	Rem
	bbdoc: A dedicated static body for the space. 
	about: You donâ€™t have to use it, but because its memory is managed automatically with the space its very convenient. 
	You can set its user data pointer to something helpful if you want for callbacks.
	End Rem
	Method GetStaticBody:CPBody()
		Local tmp:CPBody = New CPBody
		tmp.cpObjectPtr = bmx_cpspace_getstaticbody(tmp, cpObjectPtr)
		tmp.parent = Self
		Return tmp
	End Method
	
	Rem
	bbdoc: Adds a static shape To the space.
	about: Shapes added as static are assumed Not To move. Static shapes should be be attached To a rigid body with an
	infinite mass And moment of inertia. Also, don't add the rigid body used To the space, as that will cause it To
	fall under the effects of gravity.
	End Rem
	Method AddStaticShape(shape:CPShape)
		bmx_cpspace_addstaticshape(cpObjectPtr, shape.cpObjectPtr)
		shape.parent = Self
		shape.static = True
	End Method
	
	Rem
	bbdoc: Adds a body To the space.
	End Rem
	Method AddBody(body:CPBody)
		bmx_cpspace_addbody(cpObjectPtr, body.cpObjectPtr)
		body.parent = Self
	End Method
	
	Rem
	bbdoc: Adds a shape To the space.
	End Rem
	Method AddShape(shape:CPShape)
		bmx_cpspace_addshape(cpObjectPtr, shape.cpObjectPtr)
		shape.parent = Self
	End Method

	Rem
	bbdoc: This function removes @shape from space.
	about: The add/remove functions cannot be called from within a callback other than a postStep() callback (which is different than a postSolve() callback!). 
	Attempting to add or remove objects from the space while CPSpace.DoStep() is still executing will throw an assertion. 
	See the <a href="http://chipmunk-physics.net/release/ChipmunkLatest-Docs/#Callbacks">callbacks section</a> for more information. 
	Be careful not to free bodies before removing shapes and constraints attached to them or you will cause crashes.. 
	The contains functions allow you to check if an object has been added to the space or not.
	End Rem
	Method RemoveShape(shape:CPShape)
		cpSpaceRemoveShape(cpObjectPtr, shape.cpObjectPtr)
		shape.parent = Null
	End Method

	Rem
	bbdoc: Register @cpCollFunc To be called when a collision is found between a shapes with collision Type fields that match @collTypeA and @collTypeB.
	about: @data is passed To the Function as a parameter. The ordering of the collision types will match the ordering
	passed To the callback function.
	<p>
	Collision pair functions allow you To add callbacks For certain collision events. Each CPShape structure has a user
	definable collisionType Field that is used To identify its type. For instance, you could define an enumeration
	of collision types such as bullets And players, And Then register a collision pair Function to reduce the players
	health when a collision is found between the two.
	</p>
	<p>
	Additionally, the Return value of a collision pair Function determines whether or not a collision will be processed.
	If the Function returns False, the collision will be ignored. One use for this functionality is to allow a rock object
	To break a vase object. If the approximated energy of the collision is above a certain level, flag the vase To be
	removed from the space, apply an impulse To the rock To slow it down, And Return False. After the DoStep() returns,
	remove the vase from the space.
	</p>
	<p>
	<b>WARNING</b>: It is Not safe For collision pair functions To remove Or free shapes Or bodies from a space. Doing so will
	likely End in a segfault as an earlier collision may already be referencing the shape Or body. You must wait Until
	after the DoStep() Method returns.
	</p>
	End Rem
	Method AddCollisionPairFunc(collTypeA:Int, collTypeB:Int, beginFunc:Int(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null, Data:Object = Null,  ..
preSolveFunc:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
postSolveFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
separateFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null)
		If beginFunc Or preSolveFunc Or postSolveFunc Or separateFunc Then
			Local collpair:_CollisionPair = New _CollisionPair
			collpair.abHash = bmx_CP_HASH_PAIR(collTypeA, collTypeB)
			
			collpair.data = data
			collpair.beginFunc = beginFunc
			collpair.preSolveFunc = preSolveFunc
			collpair.postSolveFunc = postSolveFunc
			collpair.separateFunc = separateFunc
			
			' add it (for reference counting
			collisionPairs.Insert(collpair, collpair)
			
			Local dobegincollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
			Local dopreSolvecollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
			Local dopostSolvecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
			Local doseparatecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
			If beginFunc
				dobegincollision = _dobeginCollision
			EndIf
			If preSolveFunc
				dopreSolvecollision = _dopreSolveCollision
			EndIf
			If postSolveFunc
				dopostSolvecollision = _dopostSolveCollision
			EndIf
			If separateFunc
				doseparatecollision = _doseparateCollision
			End If
			
			bmx_cpspace_addcollisionpairfunc(cpObjectPtr, collTypeA, collTypeB, dobegincollision, collpair, dopreSolvecollision, dopostSolvecollision, doseparatecollision)
		Else
			bmx_cpspace_addcollisionpairnullfunc(cpObjectPtr, collTypeA, collTypeB)
		End If
	End Method
	
	Function _dobeginCollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object)
	    If _CollisionPair(data)
	        Local a:Byte ptr
	        Local b:Byte ptr
	        cpArbiterGetShapes(arb, VarPtr(a), VarPtr(b))
	
	        ' Get the number of contact points
	        Local Count:Int = cpArbiterGetCount(Arb)
	        
	        ' Create an array To store the CPContact objects
	        Local contacts:CPContact[] = New CPContact[count]
	        
	        ' Retrieve the CPContact objects from the arbiter
	        For Local i:Int = 0 Until count
	            contacts[i] = CPContact._create(bmx_cparbiter_getcontacts(arb, i))
	            ' You may need To set other properties of CPContact objects If required
	        Next
	
			If cpArbiter(_CollisionPair(Data).Data) Then _CollisionPair(Data).Data = New cpArbiter._create(arb)
			
	        ' Call the collision pair Function with the adjusted arguments
	        Return _CollisionPair(Data).beginFunc(CPShape(cpfind(a)), CPShape(cpfind(b)), contacts, _CollisionPair(Data).normalCoeficient, _CollisionPair(Data).Data)
		End If
	End Function
	
	Function _dopreSolveCollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object)
	    If _CollisionPair(data)
	        Local a:Byte ptr
	        Local b:Byte ptr
	        cpArbiterGetShapes(arb, VarPtr(a), VarPtr(b))
				
	        ' Get the number of contact points
	        Local Count:Int = cpArbiterGetCount(arb)
	        
	        ' Create an array To store the CPContact objects
	        Local contacts:CPContact[] = New CPContact[count]
	        
	        ' Retrieve the CPContact objects from the arbiter
	        For Local i:Int = 0 Until count
	            contacts[i] = CPContact._create(bmx_cparbiter_getcontacts(arb, i))
	            ' You may need To set other properties of CPContact objects If required
	        Next
	
			If cpArbiter(_CollisionPair(Data).Data) Then _CollisionPair(Data).Data = New cpArbiter._create(arb)
			
	        ' Call the collision pair Function with the adjusted arguments
	        Return _CollisionPair(Data).preSolveFunc(CPShape(cpfind(a)), CPShape(cpfind(b)), contacts, _CollisionPair(Data).normalCoeficient, _CollisionPair(Data).Data)
		End If
	End Function
	
	Function _dopostSolveCollision(arb:Byte Ptr, space:Byte Ptr, Data:Object)
	    If _CollisionPair(data)
	        Local a:Byte ptr
	        Local b:Byte ptr
	        cpArbiterGetShapes(arb, VarPtr(a), VarPtr(b))
				
	        ' Get the number of contact points
	        Local Count:Int = cpArbiterGetCount(arb)
	        
	        ' Create an array To store the CPContact objects
	        Local contacts:CPContact[] = New CPContact[count]
	        
	        ' Retrieve the CPContact objects from the arbiter
	        For Local i:Int = 0 Until count
	            contacts[i] = CPContact._create(bmx_cparbiter_getcontacts(arb, i))
	            ' You may need To set other properties of CPContact objects If required
	        Next
	
			If cpArbiter(_CollisionPair(Data).Data) Then _CollisionPair(Data).Data = New cpArbiter._create(arb)
			
	        ' Call the collision pair Function with the adjusted arguments
	        _CollisionPair(Data).postSolveFunc(CPShape(cpfind(a)), CPShape(cpfind(b)), contacts, _CollisionPair(Data).normalCoeficient, _CollisionPair(Data).Data)
		End If
	End Function
	
	Function _doseparateCollision(arb:Byte Ptr, space:Byte Ptr, Data:Object)
	    If _CollisionPair(data)
	        Local a:Byte ptr
	        Local b:Byte ptr
	        cpArbiterGetShapes(arb, VarPtr(a), VarPtr(b))
				
			If cpArbiter(_CollisionPair(Data).Data) Then _CollisionPair(Data).Data = New cpArbiter._create(arb)
			
	        ' Call the collision pair Function with the adjusted arguments
	        _CollisionPair(Data).separateFunc(CPShape(cpfind(a)), CPShape(cpfind(b)), Null, _CollisionPair(Data).normalCoeficient, _CollisionPair(Data).Data)
		End If
	End Function
	
	Function AlwaysCollide:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object)
		Return True
	End Function
	
	Function DoNothing(arb:Byte Ptr, space:Byte Ptr, Data:Object)
	End Function
	
	Rem
	bbdoc: Remove the Function for the given collision type pair.
	about: The order of @collTypeA And @collTypeB must match the original order used with AddCollisionPairFunc().
	'End Rem
	Method RemoveCollisionPairFunc(collTypeA:Int, collTypeB:Int)
		Local collpair:_CollisionPair = New _CollisionPair
		collpair.abHash = bmx_CP_HASH_PAIR(collTypeA, collTypeB)

		' remove any existing first..
		collisionPairs.Remove(collpair)
		
		bmx_cpspace_removecollisionpairfunc(cpObjectPtr, collTypeA, collTypeB,  ..
			AlwaysCollide,  ..
			AlwaysCollide,  ..
			DoNothing,  ..
			DoNothing)
	End Method

	Rem
	bbdoc: Add a wildcard collision handler for given collision @type.
	about: This handler will be used any time an object with this @type collides with another object, regardless of its @type. 
	A good example is a projectile that should be destroyed the first time it hits anything. 
	There may be a specific collision handler and two wildcard handlers. 
	Itâ€™s up to the specific handler to decide if and when to call the wildcard handlers and what to do with their return values. (See CallWildcard*()) 
	When a new wildcard handler is created, the callbacks will all be set to builtin callbacks that perform the default behavior. 
	(accept all collisions in @beginFunc() and @preSolveFunc(), or do nothing for @postSolveFunc() and @separateFunc().
	End Rem
	Method AddWildcardFunc(CollisionType:Int, beginFunc:Int(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null, Data:Object = Null,  ..
preSolveFunc:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
postSolveFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
separateFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null)
		If beginFunc Or preSolveFunc Or postSolveFunc Or separateFunc Then
			Local collpair:_CollisionPair = New _CollisionPair
			collpair.abHash = bmx_CP_HASH_PAIR(CollisionType, -9999)
			
			collpair.data = data
			collpair.beginFunc = beginFunc
			collpair.preSolveFunc = preSolveFunc
			collpair.postSolveFunc = postSolveFunc
			collpair.separateFunc = separateFunc
			
			' add it (for reference counting
			collisionPairs.Insert(collpair, collpair)
			
			Local dobegincollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
			Local dopreSolvecollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
			Local dopostSolvecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
			Local doseparatecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
			If beginFunc
				dobegincollision = _dobeginCollision
			EndIf
			If preSolveFunc
				dopreSolvecollision = _dopreSolveCollision
			EndIf
			If postSolveFunc
				dopostSolvecollision = _dopostSolveCollision
			EndIf
			If separateFunc
				doseparatecollision = _doseparateCollision
			End If

			bmx_cpspace_addwildcardfunc(cpObjectPtr, CollisionType, dobegincollision, collpair, dopreSolvecollision, dopostSolvecollision, doseparatecollision)
		EndIf
	End Method

	Rem
	bbdoc: The Default Function is called when no collision pair function is specified.
	about: By default, the Default Function simply accepts all collisions. Passing Null for each @Func will reset the 
	Default Function back to the default. (You know what I mean.)
	<p>
	Passing Null For any @Func will reject collisions by default.
	</p>
	End Rem
	Method SetDefaultCollisionPairFunc(beginFunc:Int(shapeA:CPShape, shapeB:CPShape,  ..
			contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null, Data:Object = Null,  ..
preSolveFunc:Int(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
postSolveFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null,  ..
separateFunc(shapeA:CPShape, shapeB:CPShape, contacts:CPContact[], normalCoeficient:Float, Data:Object) = Null)
		If beginFunc Or preSolveFunc Or postSolveFunc Or separateFunc Then
			
			Local collpair:_CollisionPair = New _CollisionPair
			collpair.abHash = bmx_CP_HASH_PAIR(-9999, -9999)
			
			collpair.data = data
			collpair.beginFunc = beginFunc
			collpair.preSolveFunc = preSolveFunc
			collpair.postSolveFunc = postSolveFunc
			collpair.separateFunc = separateFunc
				
			If Not (beginFunc Or preSolveFunc Or postSolveFunc Or separateFunc) Then
				collisionPairs.remove(collpair)
				bmx_cpspace_setdefaultcollisionpairfunc(cpObjectPtr, AlwaysCollide, Null, AlwaysCollide, DoNothing, DoNothing)
			Else
			
				' add it (for reference counting
				collisionPairs.insert(collpair, collpair)

				Local dobegincollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
				Local dopreSolvecollision:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object) = AlwaysCollide
				Local dopostSolvecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
				Local doseparatecollision(arb:Byte Ptr, space:Byte Ptr, Data:Object) = DoNothing
				If beginFunc
					dobegincollision = _dobeginCollision
				EndIf
				If preSolveFunc
					dopreSolvecollision = _dopreSolveCollision
				EndIf
				If postSolveFunc
					dopostSolvecollision = _dopostSolveCollision
				EndIf
				If separateFunc
					doseparatecollision = _doseparateCollision
				End If
				
				bmx_cpspace_setdefaultcollisionpairfunc(cpObjectPtr, dobegincollision, collpair, dopreSolvecollision, dopostSolvecollision, doseparatecollision)
			End If
		EndIf
	End Method
	
	Rem
	bbdoc: Add @func to be called before DoStep() returns.
	about: @key and @data will be passed to your function. 
	Only the first callback registered for any unique value of @key will be recorded. 
	It returns True if the callback is scheduled and False when the @key has already been used. 
	The behaviour of adding a postStep() callback from outside of a collision handler or query callback is undefined.
	end rem
	Method AddPostStepCallback:Int(func(space:Byte Ptr, obj:Object, Data:Object), Key:Object, Data:Object)
		Return bmx_cpspace_addpoststepcallback(cpObjectPtr, func, Key, Data)
	End Method
	
	Rem
	bbdoc: 
	End Rem
	Method AddConstraint(constraint:CPConstraint)
		bmx_cpspace_addconstraint(cpObjectPtr, constraint.cpObjectPtr)
		constraint.parent = Self
	End Method

	Rem
	bbdoc: Sizes the hash table.
	about: The spatial hashes used by Chipmunk's collision detection are fairly size sensitive. @dim is the size of the
	hash cells. Setting @dim To the average objects size is likely To give the best performance.
	<p>
	@count is the suggested minimum number of cells in the hash table. Bigger is better, but only To a point.
	Setting @count To ~10x the number of objects in the hash is probably a good starting point.
	</p>
	<p>
	By default, @dim is 100.0, And @count is 1000.
	</p>
	End Rem
	Method UseSpatialHash(dim:Double = 100, Count:Int = 1000)
		cpSpaceUseSpatialHash(cpObjectPtr, dim, Count)
	End Method

	Rem
	bbdoc: Update the space For the given time step.
	about: Using a fixed time Step is highly recommended. Doing so will increase the efficiency of the contact
	persistence, requiring an order of magnitude fewer iterations To resolve the collisions in the usual case.
	End Rem
	Method DoStep(dt:Double)
		If ENABLE_HASTY
		?Not ios
			cpHastySpaceStep(cpObjectPtr, dt)
		?
		Else
			cpSpaceStep(cpObjectPtr, dt)
		EndIf
	End Method
	
	Rem
	bbdoc: Sets the number of iterations To use when solving constraints (collisions And joints).
	about: Defaults To 10.
	End Rem
	Method SetIterations(num:Int)
		bmx_cpspace_setiterations(cpObjectPtr, num)
	End Method
	
Rem
bbdoc: Rehashes the shapes in the static spatial hash.
about: You only need To call this If you move one of the static shapes.
End Rem
Method RehashStatic()
    If Not cpSpaceIsLocked(cpObjectPtr) Then
        cpSpaceReindexStatic(cpObjectPtr)
    End If
End Method

	Rem
	bbdoc: Starts an iteration over every body of this space, calling @callback For each.
	about: Sleeping bodies are included, but static and kinematic bodies are not as they arenâ€™t added to the space.
	End Rem
	Method EachBody(callback(obj:Object, data:Object), data:Object = Null)
		
		Local cb:TFuncCallback = New TFuncCallback
		cb.callback = callback
		cb.data = data
		
		cpSpaceEachBody(cpObjectPtr, hashCallback, cb)
		
	End Method
	
	Rem
	bbdoc: Call @callback for each shape in the space also passing along your data pointer.
	about: Sleeping and static shapes are included.
	End Rem
	Method EachShape(callback(obj:Object, Data:Object), Data:Object = Null)
		
		Local cb:TFuncCallback = New TFuncCallback
		cb.callback = callback
		cb.data = data
		
		cpSpaceEachShape(cpObjectPtr, hashCallback, cb)
		
	End Method
	
	Rem
	bbdoc: Call @callback for each constraint in the space also passing along your data pointer.
	End Rem
	Method EachConstraint(callback(obj:Object, Data:Object), Data:Object = Null)
		
		Local cb:TFuncCallback = New TFuncCallback
		cb.callback = callback
		cb.data = data
		
		cpSpaceEachConstraint(cpObjectPtr, hashCallback, cb)
		
	End Method
	
	Function hashCallback(obj:Byte Ptr, callbackData:Object)
		If TFuncCallback(callbackData) Then
			TFuncCallback(callbackData).callback(cpfind(obj), TFuncCallback(callbackData).data)
		End If
	End Function

	Rem
	bbdoc: Returns the index of active shapes.
	End Rem
	Method GetActiveShapes:CPSpatialIndex()

		If Not activeShapes Then
			Local p:Byte Ptr = bmx_cpspace_getactiveshapes(cpObjectPtr)
			If p Then
				activeShapes = CPSpatialIndex(cpfind(p))
				If Not activeShapes Then
					activeShapes = New CPSpatialIndex.Bind(p)
		activeShapes.parent = Self
				End If
			End If
		End If
		
		Return activeShapes
	End Method
	
	Rem
	bbdoc: Returns the index of static shapes.
	End Rem
	Method GetStaticShapes:CPSpatialIndex()

		If Not staticShapes Then
			Local p:Byte Ptr = bmx_cpspace_getstaticshapes(cpObjectPtr)
			If p Then
				staticShapes = CPSpatialIndex(cpfind(p))
				If Not staticShapes Then
					staticShapes = New CPSpatialIndex.Bind(p)
		staticShapes.parent = Self
				End If
			End If
		End If
		
		Return staticShapes
	End Method
	
	Rem
	bbdoc: Query space at @point and return the closest shape within @maxDistance units of distance.
	about: @out is an optional (currently non-functional) pointer to a CPPointQueryInfo if you want additional information about the match.
	end rem
	Method PointQueryNearest:CPShape(Point:CPVect, maxDistance:Double, Filter:UInt, out:CPPointQueryInfo)
		Return CPShape(cpfind(bmx_cpspace_pointquerynearest(cpObjectPtr, Point.vecPtr, maxDistance, Filter, Null)))
	End Method

	Rem
	bbdoc: Query space along the line segment from @start to @end with the given @radius.
	about: The @filter is applied to the query and follows the same rules as the collision detection. 
	@func is called with the normalized distance along the line and surface normal for each shape found along with the @data argument passed to PointQuery(). 
	Sensor shapes are included.
	End Rem
	Method SegmentQuery( ..
		Start:CPVect, EndPoint:CPVect, radius:Double,  ..
		Filter:UInt,  ..
		callback(shape:Object, Point:Object, Normal:Object, Alpha:Double, Data:Object), Data:Object ..
	)
		Local cb:TSegmentFuncCallback = New TSegmentFuncCallback
		cb.callback = callback
		cb.data = data

		bmx_cpspace_segmentquery( ..
			cpobjectptr, Start.vecPtr, EndPoint.vecPtr, radius,  ..
			Filter,  ..
			bmx_cpspace_segmentqueryfunc, cb ..	' this was a doozy
		)
	End Method
	
	Function _segmenthashCallback(shape:Byte Ptr, Point:Byte Ptr, Normal:Byte Ptr, Alpha:Double, callbackData:Object) { nomangle }
	    If TSegmentFuncCallback(callbackData) Then
	        TSegmentFuncCallback(callbackData).callback(cpfind(shape), CPVect._create(Point), CPVect._create(Normal), Alpha, TSegmentFuncCallback(callbackData).Data)
	    End If
	End Function

	Rem
	bbdoc: Query space along the line segment from @start to @end with the given @radius.
	about: The @filter is applied to the query and follows the same rules as the collision detection. 
	Only the first shape encountered is returned and the search is short circuited. 
	Returns Null if no shape was found. 
	The info struct pointed to by @info will be initialized with the raycast info unless @info is Null. 
	Sensor shapes are ignored.
	end rem
	Method SegmentQueryFirst:CPShape(Start:CPVect, EndPoint:CPVect, radius:Double,  ..
	Filter:UInt,  ..
	info:CPSegmentQueryInfo ..
	)
		Local tmpshp:CPShape = New CPShape
		tmpshp.cpobjectptr = bmx_cpspace_segmentqueryfirst( ..
			cpObjectPtr, Start.vecPtr, EndPoint.vecPtr, radius,  ..
			Filter,  ..
			Varptr(info.shape) ..
		)
		If tmpshp.cpObjectPtr
			Return tmpshp
		EndIf
		Return Null
	End Method

	Rem
	bbdoc: Frees the CPSpace And all dependencies.
	End Rem
	Method Free()
		If cpObjectPtr Then
			If ENABLE_HASTY
			?Not ios
				cpHastySpaceFree(cpObjectPtr)
			?
			Else
				cpSpaceFree(cpObjectPtr)
			EndIf
			cpObjectPtr = Null
		End If
	End Method
End Type

Rem
bbdoc: The contact point of a collision between two shapes.
End Rem
Type CPContact

	Field contactPtr:Byte Ptr
	
	Function _create:CPContact(contactPtr:Byte Ptr)
		If contactPtr Then
			Local this:CPContact = New CPContact
			this.contactPtr = contactPtr
			Return this
		End If
	End Function

	Rem
	bbdoc: Returns the position of the collision.
	End Rem
	Method GetPosition:CPVect()
		Return CPVect._create(bmx_cpcontact_getposition(contactPtr))
	End Method
	
	Rem
	bbdoc: Returns the normal of the collision.
	End Rem
	Method GetNormal:CPVect()
		Return CPVect._create(bmx_cpcontact_getnormal(contactPtr))
	End Method
	
	Rem
	bbdoc: Returns the penetration distance of the collision.
	End Rem
	Method GetDistance:Double()
		Return bmx_cpcontact_getdistance(contactPtr)
	End Method
	
	Method GetR1:CPVect()
		Return CPVect._create(bmx_cpcontact_getr1(contactPtr))
	End Method

	Method SetR1(r1:CPVect)
		bmx_cpcontact_setr1(contactPtr, r1.vecPtr)
	End Method

	Method GetR2:CPVect()
		Return CPVect._create(bmx_cpcontact_getr2(contactPtr))
	End Method

	Method SetR2(r2:CPVect)
		bmx_cpcontact_setr2(contactPtr, r2.vecPtr)
	End Method

	Rem
	bbdoc: Returns the normal component of the accumulated (final) impulse applied To resolve the collision.
	about: This value is Not valid Until after the call To DoStep() returns.
	End Rem
	Method GetNormalAccumulatedImpulse:Double()
		Return bmx_cpcontact_getjnacc(contactPtr)
	End Method
	
	Rem
	bbdoc: Returns the tangential component of the accumulated (final) impulse applied To resolve the collision.
	about: This value is Not valid Until after the call To DoStep() returns.
	End Rem
	Method GetTangentAccumulatedImpulse:Double()
		Return bmx_cpcontact_getjtacc(contactPtr)
	End Method

	Function _setContact(contacts:CPContact[], index:Int, contactPtr:Byte Ptr) { nomangle }
		contacts[index] = _create(contactPtr)
	End Function
	
	Function _getContactForIndex:Byte Ptr(contacts:CPContact[], Index:Int) { nomangle }
		Return contacts[Index].contactptr
	End Function

End Type

Rem
bbdoc: A 2D vector
End Rem
Type CPVect
	Field vecPtr:Double Ptr
	
	Field x:Double
	Field y:Double

	Rem
	bbdoc: Creates a New CPVect.
	End Rem
	Method Create:CPVect(_x:Double, _y:Double)
		vecPtr = bmx_cpvect_create(_x, _y)
		x = _x
		y = _y
		Return Self
	End Method
	
	Function _create:CPVect(vecPtr:Byte Ptr)
		If vecPtr Then
			Local this:CPVect = New CPVect
			this.vecPtr = vecPtr
			bmx_cpvect_getxy(vecPtr, Varptr this.x, Varptr this.y)
			Return this
		End If
	End Function
	
	Function _createFromVect:CPVect(vect:Byte Ptr)
		If vect Then
			Return _create(bmx_cpvect_fromvect(vect))
		End If
	End Function
	
	Rem
	bbdoc: X
	End Rem
	Method GetX:Double()
		Return x
	End Method
	
	Rem
	bbdoc: Y
	End Rem
	Method GetY:Double()
		Return y
	End Method
	
	Method Delete()
		If vecPtr Then
			bmx_cpvect_delete(vecPtr)
			cpunbind(vecPtr)
			vecPtr = Null
		End If
	End Method
	
	Rem
	bbdoc: Adds @vec To this vector, returning the New combined vector.
	End Rem
	Method Add:CPVect(vec:CPVect)
		Return _create(bmx_cpvect_add(vecPtr, vec.vecPtr))
	End Method

	Rem
	bbdoc: Subtracts @vec from this vector, returning the New combined vector.
	End Rem
	Method Sub:CPVect(vec:CPVect)
		Return _create(bmx_cpvect_sub(vecPtr, vec.vecPtr))
	End Method
	
	Rem
	bbdoc: Uses complex multiplication To rotate (and scale) this vector by @vec.
	End Rem
	Method Rotate:CPVect(vec:CPVect)
		Return _create(bmx_cpvect_rotate(vecPtr, vec.vecPtr))
	End Method

	Rem
	bbdoc: Negate a vector.
	End Rem
	Method Negate:CPVect()
		Return _create(bmx_cpvect_negate(vecPtr))
	End Method
	
	Rem
	bbdoc: Scalar multiplication.
	End Rem
	Method Mult:CPVect(scalar:Double)
		Return _create(bmx_cpvect_mult(vecPtr, scalar))
	End Method
	
	Rem
	bbdoc: Vector dot product.
	End Rem
	Method Dot:Double(vec:CPVect)
		Return bmx_cpvect_dot(vecPtr, vec.vecPtr)
	End Method
	
	Rem
	bbdoc: 2D vector cross product analog.
	about: The cross product of 2D vectors exists only in the z component, so only that value is returned.
	End Rem
	Method Cross:Double(vec:CPVect)
		Return bmx_cpvect_cross(vecPtr, vec.vecPtr)
	End Method
	
	Rem
	bbdoc: Returns the perpendicular vector. (90 degree rotation)
	End Rem
	Method Perp:CPVect()
		Return _create(bmx_cpvect_perp(vecPtr))
	End Method
	
	Rem
	bbdoc: Returns a perpendicular vector. (-90 degree rotation)
	End Rem
	Method RPerp:CPVect()
		Return _create(bmx_cpvect_rperp(vecPtr))
	End Method
	
	Rem
	bbdoc: Returns the vector projection of the vector onto @vec.
	End Rem
	Method Project:CPVect(vec:CPVect)
		Return _create(bmx_cpvect_project(vecPtr, vec.vecPtr))
	End Method
	
	Rem
	bbdoc: Inverse of Rotate().
	End Rem
	Method UnRotate:CPVect(vec:CPVect)
		Return _create(bmx_cpvect_unrotate(vecPtr, vec.vecPtr))
	End Method
	
	Rem
	bbdoc: Returns the length of the vector.
	End Rem
	Method Length:Double()
		Return bmx_cpvect_length(vecPtr)
	End Method
	
	Rem
	bbdoc: Returns the squared length of the vector.
	about: Faster than Length() when you only need To compare lengths.
	End Rem
	Method LengthSq:Double()
		Return bmx_cpvect_lengthsq(vecPtr)
	End Method
	
	Rem
	bbdoc: Linearly interpolate between @Self and @v2.
	End Rem
	Method Lerp:CPVect(v2:CPVect, t:Double)
		Return _create(bmx_cpvect_lerp(vecPtr, v2.vecPtr, t))
	End Method

	Rem
	bbdoc: Returns a normalized copy of the vector.
	End Rem
	Method Normalize:CPVect()
		Return _create(bmx_cpvect_normalize(vecPtr))
	End Method
	
	Rem
	bbdoc: Returns the distance between @Self and @v2.
	end rem
	Method Dist:Double(v2:CPVect)
		Return bmx_cpvect_dist(vecPtr, v2.vecPtr)
	End Method

	Rem
	bbdoc: Returns the squared distance between @Self and @v2.
	about: Faster than CPVect.Dist() when you only need to compare distances.
	end rem
	Method DistSq:Double(v2:CPVect)
		Return bmx_cpvect_distsq(vecPtr, v2.vecPtr)
	End Method

	Rem
	bbdoc: Returns true if the distance between @Self and @v2 is less than @dist.
	End Rem
	Method Near:Int(v2:CPVect, dist:Double)
		Return bmx_cpvect_near(vecPtr, v2.vecPtr, dist)
	End Method

	Rem
	bbdoc: Returns the unit length vector for the given @angle (in radians).
	end rem
	Function ForAngle:CPVect(a:Double)
		Return _create(bmx_cpvect_forangle(a))
	End Function

	Rem
	bbdoc: Returns the angular direction the vector is pointing in (in degrees).
	End Rem
	Method ToAngle:Double()
		Return bmx_cpvect_toangle(vecPtr)
	End Method

	Function _getVectForIndex:Byte Ptr(verts:CPVect[], index:Int) { nomangle }
		Return verts[index].vecPtr
	End Function

End Type

Rem
bbdoc: A simple bounding box.
about: Stored as left, bottom, right, top values.
End Rem
Type CPBB

	Field bbPtr:Double Ptr
	
	Field l:Double, b:Double, r:Double, t:Double
	
	Rem
	bbdoc: Creates a New bounding box.
	End Rem
	Method Create:CPBB(l:Double, b:Double, r:Double, t:Double)
		bbPtr = bmx_cpbb_create(l, b, r, t)
		_Update
		Return Self
	End Method
	
	Function _create:CPBB(bbPtr:Byte Ptr)
		If bbPtr Then
			Local this:CPBB = New CPBB
			this.bbPtr = bbPtr
			this._Update
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Convenience constructor for making a CPBB fitting with a center point and half width and height.
	end rem
	Method NewForExtents:CPBB(c:CPVect, hw:Double, hh:Double)
	    Return Create(c.x - hw, c.y - hh, c.x + hw, c.y + hh)
	End Method

	Rem
	bbdoc: Convenience constructor for making a CPBB fitting a circle at position @p with radius @r.
	end rem
	Method NewForCircle:CPBB(p:CPVect, r:Double)
	    Return NewForExtents(p, r, r)
	End Method

	Method _Update()
		If bbPtr
			l = bbPtr[0]
			b = bbPtr[1]
			r = bbPtr[2]
			t = bbPtr[3]
		End If
	End Method
	
	Rem
	bbdoc: Returns True If the bounding boxes intersect.
	End Rem
	Method Intersects:Int(other:CPBB)
		Return bmx_cpbb_intersects(bbPtr, other.bbPtr)
	End Method
	
	Rem
	bbdoc: Returns True If the bounding box completely contains @other.
	End Rem
	Method ContainsBB:Int(other:CPBB)
		Return bmx_cpbb_containsbb(bbPtr, other.bbPtr)
	End Method
	
	Rem
	bbdoc: Returns True If the bounding box contains @v.
	End Rem
	Method ContainsVect:Int(v:CPVect)
		Return bmx_cpbb_containsvect(bbPtr, v.vecPtr)
	End Method
	
	Rem
	bbdoc: Returns a copy of @v clamped To the bounding box.
	End Rem
	Method ClampVect:CPVect(v:CPVect)
		Return CPVect._create(bmx_cpbb_clampvect(bbPtr, v.vecPtr))
	End Method
	
	Rem
	bbdoc: Returns a copy of @v wrapped To the bounding box.
	End Rem
	Method WrapVect:CPVect(v:CPVect)
		Return CPVect._create(bmx_cpbb_wrapvect(bbPtr, v.vecPtr))
	End Method

	Method Delete()
		If bbPtr Then
			bmx_cpbb_delete(bbPtr)
			bbPtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: A collision shape.
about: By attaching shapes To bodies, you can define the a body's shape. You can attach many shapes To a single body 
To define a complex shape, Or none If it doesn't require a shape.
<p>
There is often confusion between rigid bodies And their collision shapes in Chipmunk And how they relate To sprites.
A sprite would be a visual representation of an object, the sprite is drawn at the position of the rigid body.
The collision shape would be the material representation of the object, And how it should collide with other objects.
A sprite And collision shape have little To do with one another other than you probably want the collision shape To
match the sprite's shape.
</p>
End Rem
Type CPShape Extends CPObject

	Field static:Int = False

    ' Define a type alias for cpHashValue using a platform-specific type
?Linux Or MacOs Or ios
    Field hashid:Int ' Use the platform-specific type for IntPtr
?Not (Linux Or MacOs Or ios)
    Field hashid:UInt ' Use the platform-specific type for UIntPtr
?

	Method _Update()
		If cpObjectPtr
			hashid = bmx_cpshape_update(cpobjectPtr)
		End If
	End Method

	Rem
	bbdoc: The bounding box of the shape.
	about: Only guaranteed to be valid after CacheBB() or DoStep() is called. 
	Moving a body that a shape is connected to does not update its bounding box. 
	For shapes used for queries that arenâ€™t attached to bodies, you can also use Update().
	End Rem
	Method GetBB:CPBB()
		Return CPBB._create(bmx_cpshape_getbb(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Sets the elasticity of the shape.
	about: A value of 0.0 gives no bounce, While a value of 1.0 will give a "perfect" bounce. However due To inaccuracies
	in the simulation using 1.0 Or greater is Not recommended however.
	<p>
	The amount of elasticity applied during a collision is determined by multiplying the elasticity of both shapes together.
	</p>
	End Rem
	Method SetElasticity(e:Double)
		bmx_cpshape_setelasticity(cpObjectPtr, e)
	End Method
	
	Rem
	bbdoc: Returns the shape elasticity.
	End Rem
	Method GetElasticity:Double()
		Return bmx_cpshape_getelasticity(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Sets the friction coefficient For the shape.
	about: Chipmunk uses the Coulomb friction model, a value of 0.0 is frictionless.
	<a href="http://www.roymech.co.uk/Useful_Tables/Tribology/co_of_frict.htm">Tables of friction coefficients.</a>
	<p>
	The amount of friction applied during a collision is determined by multiplying the friction of both shapes together.
	</p>
	End Rem
	Method SetFriction(u:Double)
		bmx_cpshape_setfriction(cpObjectPtr, u)
	End Method
	
	Rem
	bbdoc: Returns the shape friction.
	End Rem
	Method GetFriction:Double()
		Return bmx_cpshape_getfriction(cpObjectPtr)
	End Method

	Rem
	bbdoc: You can assign types to Chipmunk collision shapes that trigger callbacks when objects of certain types touch.
	about: See the <a href="http://chipmunk-physics.net/release/ChipmunkLatest-Docs/#Callbacks-Handlers">callbacks section</a> for more information.
	End Rem
	Method GetCollisionType:Size_T()
		Return cpShapeGetCollisionType(cpObjectPtr)
	End Method

	Rem
	bbdoc: Sets the user-definable Type field.
	End Rem
	Method SetCollisionType(Kind:Size_T)
		bmx_cpshape_setcollisiontype(cpObjectPtr, Kind)
	End Method

	Rem
	bbdoc: Sets the group To which this shape belongs.
	about: Shapes in the same non-zero group do Not generate collisions. Useful when creating an Object out of many
	shapes that you don't want To Self collide. Defaults To 0.
	End Rem
	Method SetGroup(group:Int)
		bmx_cpshape_setgroup(cpObjectPtr, group)
	End Method

	Rem
	bbdoc: Sets the layers this shape occupies.
	about: Shapes only collide If they are in the same bit-planes. i.e. (a.layers & b.layers) != 0.
	<p>
	By default, a shape occupies all 32 bit-planes.
	</p>
	End Rem
	Method SetLayers(layers:Int)
		bmx_cpshape_setlayers(cpObjectPtr, layers)
	End Method
	
	Rem
	bbdoc: Set the collision filter for this shape. 
	about: See <a href="http://chipmunk-physics.net/release/ChipmunkLatest-Docs/#Filtering">Filtering Collisions</a> for more information.
	End Rem
	Method SetFilter(Filter:UInt)
		bmx_cpshape_setfilter(cpObjectPtr, Filter)
	End Method

	Rem
	bbdoc: Sets the surface velocity of the object.
	about: Useful For creating conveyor belts Or players that move around. This value is only used when calculating
	friction, Not the collision.
	End Rem
	Method SetSurfaceVelocity(velocity:CPVect)
		bmx_cpshape_setsurfacevelocity(cpObjectPtr, velocity.vecPtr)
	End Method
	
	Rem
	bbdoc: Returns the surface velocity of the object.
	End Rem
	Method GetSurfaceVelocity:CPVect()
		Return CPVect._create(bmx_cpshape_getsurfacevelocity(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the rigid body the shape is attached to.
	End Rem
	Method GetBody:CPBody()
		Local p:Byte Ptr = bmx_cpshape_getbody(cpObjectPtr)
		If p Then
			Local body:CPBody = CPBody(cpfind(p))
			If Not body Then
				Return CPBody._create(p)
			End If
			Return body
		End If
	End Method
	
	Rem
	bbdoc: An Int value if this shape is a sensor or not.
	about: Sensors only call collision callbacks, and never generate real collisions.
	end rem
	Method GetSensor:Int()
		Return cpShapeGetSensor(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: An Int value if this shape is a sensor or not.
	about: Sensors only call collision callbacks, and never generate real collisions.
	End Rem
	Method SetSensor(Value:Int)
		cpShapeSetSensor(cpObjectPtr, Value)
	End Method
	
	Rem
	bbdoc: Updates And returns the bounding box of the shape.
	End Rem
	Method CacheBB:CPBB()
		Return CPBB._create(bmx_cpshape_cachebb(cpObjectPtr))
	End Method

	Rem
	bbdoc: Sets user data For the body.
	End Rem
	Method SetData(data:Object)
		bmx_cpshape_setdata(cpObjectPtr, data)
	End Method
	
	Rem
	bbdoc: Retrieves user data For the body, Or Null If Not set.
	End Rem
	Method GetData:Object()
		Return bmx_cpshape_getdata(cpObjectPtr)
	End Method

	Method PointQuery:Double(p:CPVect, out:CPPointQueryInfo)
		Return bmx_cpshape_pointquery(cpObjectPtr, p.vecPtr, out)
	End Method

	Rem
	bbdoc: Frees the shape
	End Rem
	Method Free()
	    If cpObjectPtr Then
	        cpSpaceRemoveShape(parent.cpObjectPtr, cpObjectPtr)
			cpunbind(cpObjectPtr)
	        cpShapeFree(cpObjectPtr)
	        cpObjectPtr = Null
	    End If
	End Method

End Type

Rem
bbdoc: A line segment shape.
about: Meant mainly as a static shape. They can be attached To moving bodies, but they don't generate collisions with
other line segments.
End Rem
Type CPSegmentShape Extends CPShape

	Rem
	bbdoc: Creates a New line segment shape.
	about: @body is the body To attach the segment to, @a And @b are the endpoints, And @radius is the thickness of the
	segment.
	End Rem
	Method Create:CPSegmentShape(body:CPBody, a:CPVect, b:CPVect, radius:Double)
		cpObjectPtr = bmx_cpsegmentshape_create(Self, body.cpObjectPtr, a.vecPtr, b.vecPtr, radius)
		Return Self
	End Method

	Rem
	bbdoc: Returns the position of endpoint A.
	End Rem
	Method GetEndPointA:CPVect()
		Return CPVect._create(bmx_cpsegmentshape_getendpointa(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the position of endpoint B.
	End Rem
	Method GetEndPointB:CPVect()
		Return CPVect._create(bmx_cpsegmentshape_getendpointb(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the segment normal.
	End Rem
	Method GetNormal:CPVect()
		Return CPVect._create(bmx_cpsegmentshape_getnormal(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the shape radius.
	End Rem
	Method GetRadius:Double()
		Return cpSegmentShapeGetRadius(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: 
	about: 
	end rem
	Method SetNeighbors(prev:CPVect, nextShape:CPVect)
		bmx_cpsegmentshapesetneighbors(cpObjectPtr, prev.vecPtr, nextShape.vecptr)
	End Method
	
End Type

Rem
bbdoc: A convex polygon shape.
about: The slowest, but most flexible collision shape.
End Rem
Type CPPolyShape Extends CPShape

	Rem
	bbdoc: Creates a New convex polygon shape.
	about: @body is the body To attach the poly to, @verts is an array of CPVect's defining a convex hull with a
	counterclockwise winding, @offset is the offset from the body's center of gravity in body Local coordinates.
	End Rem
	Method Create:CPPolyShape(body:CPBody, verts:CPVect[], offset:CPVect, radius:Double = Null, Count:Int = Null)
		If Not Count
			Count = verts.Length
		End If
		cpObjectPtr = bmx_cppolyshape_create(Self, body.cpObjectPtr, verts, Count, offset.vecPtr, radius)
		_Update
		Return Self
	End Method

	Rem
	bbdoc: Returns the vertices as an array of Doubles.
	End Rem
	Method GetVertsAsCoords:Double[]()
		Return bmx_cppolyshape_getvertsascoords(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Returns the array of vertices.
	End Rem
	Method GetVerts:CPVect[] (Count:Int = 0)
		Local verts:CPVect[]
		If Count
			verts = New CPVect[Count]
		Else
			verts = New CPVect[bmx_cppolyshape_numverts(cpObjectPtr)]
		EndIf
		bmx_cppolyshape_getverts(cpObjectPtr, verts)
		Return verts
	End Method
	
	Rem
	bbdoc: Returns the shape radius.
	End Rem
	Method GetRadius:Double()
		Return cpPolyShapeGetRadius(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: /// Get the number of verts in a polygon shape.
	end rem
	Method GetCount:Int()
		Return bmx_cppolyshape_numverts(cpObjectPtr)
	End Method

	Function _setVert(verts:CPVect[], Index:Int, vec:Byte Ptr) { nomangle }
		verts[Index] = CPVect._create(vec)
	End Function
	
End Type

Rem
bbdoc: A circle shape.
about: The fastest collision shape. They also roll smoothly.
End Rem
Type CPCircleShape Extends CPShape

	Rem
	bbdoc: Creates a New circle shape.
	about: @body is the body attach the circle to, @offset is the offset from the body's center of gravity in body Local coordinates.
	End Rem
	Method Create:CPCircleShape(body:CPBody, radius:Double, offset:CPVect)
		cpObjectPtr = bmx_cpcircleshape_create(Self, body.cpObjectPtr, radius, offset.vecPtr)
		Return Self
	End Method
	
	Rem
	bbdoc: Returns the shape center, in body space coordinates.
	End Rem
	Method GetCenter:CPVect()
		Return CPVect._create(bmx_cpcircleshape_getcenter(cpObjectPtr))
	End Method

	Rem
	bbdoc: Returns the transformed shape center, in world coordinates.
	End Rem
	Method GetTransformedCenter:CPVect()
		Return CPVect._create(bmx_cpcircleshape_gettransformedcenter(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Getter for circle @shape properties.
	End Rem
	Method GetOffset:CPVect()
		Return CPVect._create(bmx_cpcircleshape_getoffset(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Returns the shape radius.
	End Rem
	Method GetRadius:Double()
		Return bmx_cpcircleshape_getradius(cpObjectPtr)
	End Method
	
End Type

Type TFuncCallback

	Field callback(obj:Object, Data:Object)
	Field Data:Object
	
End Type

Rem
bbdoc: The spatial index is Chipmunk's Default spatial index type.
about: 
End Rem
Type CPSpatialIndex Extends cpObject

	Rem
	bbdoc: Allocate and initialize a spatial hash.
	EndRem
	Method Create:CPSpatialIndex(celldim:Double, cells:Int, bbfunc:Double ptr(obj:Object), staticIndex:CPSpatialIndex)
		If staticIndex
			parent = staticIndex.parent
			cpobjectptr = cpSpaceHashNew(celldim, cells, bbfunc, staticIndex.cpObjectPtr)
		Else
			cpobjectptr = cpSpaceHashNew(celldim, cells, bbfunc, Null)
		End If
		Return Self'Bind(cpobjectptr)
	End Method

	Function _create:CPSpatialIndex(cpObjectPtr:Byte Ptr)
		If cpObjectPtr Then
			Local this:CPSpatialIndex = New CPSpatialIndex
			this.cpObjectPtr = cpObjectPtr
			Return this
		End If
	End Function

	Method Bind:CPSpatialIndex(p:Byte Ptr)
		cpObjectPtr = p
		cpbind(p, Self)
		Return Self
	End Method

	Rem
	bbdoc: Destroy and free a spatial index.
	EndRem
	Method Free()
'		cpunbind(cpObjectPtr)
		cpSpatialIndexFree(cpObjectPtr)
		cpObjectPtr = Null
	End Method
	
	Rem
	bbdoc: Iterate over the objects in the hash, calling @callback for each.
	about: @data is some optional user data that will be passed to @callback.
	End Rem
	Method ForEach(callback(obj:Object, Data:Object), Data:Object = Null)
	    Local cb:TFuncCallback = New TFuncCallback
	    cb.callback = callback
	    cb.data = data
	
	    bmx_cpspatialindex_each(cpObjectPtr, hashCallback, cb)
	End Method
	
	Function hashCallback(obj:Byte Ptr, callbackData:Object)
		If TFuncCallback(callbackData) Then
			TFuncCallback(callbackData).callback(cpfind(obj), TFuncCallback(callbackData).data)
		End If
	End Function

	Rem
	bbdoc: Add an object to a spatial index.
	about: Most spatial indexes use hashed storage, so you must provide a hash value too.
	End Rem
?Linux Or MacOs Or ios
	Method Insert(obj:Object, hashid:Int)
?Not (Linux Or MacOs Or ios)
	Method Insert(obj:Object, hashid:uint)
?
		bmx_cpspatialindex_insert(cpObjectPtr, obj, hashid)
	End Method
	
	Rem
	bbdoc: Remove an object from a spatial index.
	about: Most spatial indexes use hashed storage, so you must provide a hash value too.
	End Rem
?Linux Or MacOs Or ios
	Method Remove(obj:Object, hashid:Int)
?Not (Linux Or MacOs Or ios)
	Method Remove(obj:Object, hashid:uint)
?
		bmx_cpspatialindex_remove(cpObjectPtr, obj, hashid)
	End Method
	
	Rem
	bbdoc: Perform a rectangle query against the spatial index, calling @func for each potential match.
	End Rem
	Method Query(obj:Object, bb:CPBB, func(obj1:Object, obj2:Double ptr, id:uint, Data:Byte ptr), Data:Byte ptr)
		Local cb:TQueryFuncCallback = New TQueryFuncCallback
		cb.callback = func
		cb.data = data

		bmx_cpspatialindex_query(cpObjectPtr, obj, bb.bbPtr, QueryFuncCallback, cb)
	End Method
	
	Function QueryFuncCallback(obj1:Byte ptr, obj2:Double ptr, id:uint, callbackData:Object)
		If TQueryFuncCallback(callbackData) Then
			TQueryFuncCallback(callbackData).callback(cpfind(obj1), obj2, id, TQueryFuncCallback(callbackData).Data)
		End If
	End Function
End Type

Rem
bbdoc: Base Type for joints.
End Rem
Type CPConstraint Extends CPObject

	Rem
	bbdoc: Body A
	End Rem
	Method GetBodyA:CPBody()
		Return CPBody(cpfind(bmx_cpconstraint_getbodya(cpObjectPtr)))
	End Method
	
	Rem
	bbdoc: Body B
	End Rem
	Method GetBodyB:CPBody()
		Return CPBody(cpfind(bmx_cpconstraint_getbodyb(cpObjectPtr)))
	End Method
	
	Rem
	bbdoc: The maximum force that the constraint can use to act on the two bodies. 
	about: Defaults to INFINITY.
	end rem
	Method GetMaxForce:Double()
		Return cpConstraintGetMaxForce(cpObjectPtr)
	End Method

	Rem
	bbdoc: The maximum force that the constraint can use to act on the two bodies. 
	about: Defaults to INFINITY.
	end rem
	Method SetMaxForce(Value:Double)
		cpConstraintSetMaxForce(cpObjectPtr, Value)
	End Method

	Rem
	bbdoc: The percentage of joint error that remains unfixed after a second.
	about: This works exactly the same as the collision bias property of a space, but applies to fixing error (stretching) of joints instead of overlapping collisions.
	end rem
	Method SetErrorBias(Value:Double)
		cpConstraintSetErrorBias(cpObjectPtr, Value)
	End Method

	Rem
	bbdoc: The maximum speed at which the constraint can apply error correction.
	about: Defaults to INFINITY.
	End Rem
	Method SetMaxBias(Value:Double)
		cpConstraintSetMaxBias cpObjectPtr, Value
	End Method

	Rem
	bbdoc: Constraints can be used for filtering collisions too.
	about: When two bodies collide, Chipmunk ignores the collisions if this property is set to False on any constraint that connects the two bodies. 
	Defaults to True. 
	This can be used to create a chain that self collides, but adjacent links in the chain do not collide.
	End Rem
	Method SetCollideBodies(collideBodies:Int)
		cpConstraintSetCollideBodies(cpObjectPtr, collideBodies)
	End Method

	Rem
	bbdoc: /// Set the pre-solve function that is called before the solver runs.
	end rem
	Method SetPreSolveFunc(preSolveFunc(constraint:Byte Ptr, space:Byte Ptr))
		bmx_cpconstraint_setpresolvefunc(cpObjectPtr, preSolveFunc)
	End Method
	
	Rem
	bbdoc: /// Set the post-solve function that is called before the solver runs.
	end rem
	Method SetPostSolveFunc(postSolveFunc(constraint:Byte Ptr, space:Byte Ptr))
		bmx_cpconstraint_setpostsolvefunc(cpObjectPtr, postSolveFunc)
	End Method
	
	Rem
	bbdoc: The most recent impulse that constraint applied.
	about: To convert this to a force, divide by the timestep passed to DoStep(). 
	You can use this to implement breakable joints to check if the force they attempted to apply exceeded a certain threshold.
	End Rem
	Method GetImpulse:Double()
		Return cpConstraintGetImpulse(cpObjectPtr)
	End Method

	Method IsPinJoint:Int() ' Returns false positives.  Use If CPPinJoint(Self) where possible
		Return cpConstraintIsPinJoint(cpObjectPtr)
	End Method

	Method IsSlideJoint:Int()
		Return cpConstraintIsSlideJoint(cpObjectPtr)
	End Method

	Method IsPivotJoint:Int()
		Return cpConstraintIsPivotJoint(cpObjectPtr)
	End Method

	Method IsGrooveJoint:Int()
		Return cpConstraintIsGrooveJoint(cpObjectPtr)
	End Method

	Method IsDampedSpring:Int()
		Return cpConstraintIsDampedSpring(cpObjectPtr)
	End Method

	Method Free()
		If cpObjectPtr Then
			cpSpaceRemoveConstraint(parent.cpObjectPtr, cpObjectPtr)
			cpunbind(cpObjectPtr)
			cpConstraintFree(cpObjectPtr)
			cpObjectPtr = Null
		End If
	End Method
	
End Type

Rem
bbdoc: Connects two rigid bodies with a solid pin Or rod.
about: It keeps the anchor points at a set distance from one another.
End Rem
Type CPPinJoint Extends CPConstraint

	Rem
	bbdoc: Creates a New pin joint.
	End Rem
	Method Create:CPPinJoint(bodyA:CPBody, bodyB:CPBody, anchor1:CPVect, anchor2:CPVect)
		cpObjectPtr = bmx_cppinjoint_create(Self, bodyA.cpObjectPtr, bodyB.cpObjectPtr, anchor1.vecPtr, anchor2.vecPtr)
		Return Self
	End Method
	
	Rem
	bbdoc: Anchor point 1
	End Rem
	Method GetAnchor1:CPVect()
		Return CPVect._create(bmx_cppinjoint_getanchor1(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Anchor point 2
	End Rem
	Method GetAnchor2:CPVect()
		Return CPVect._create(bmx_cppinjoint_getanchor2(cpObjectPtr))
	End Method	

	Rem
	bbdoc: /// Set the @distance the joint will maintain between the two anchors.
	End Rem
	Method SetDist(Value:Double)
		cpPinJointSetDist(cpObjectPtr, Value)
	End Method

End Type

Rem
bbdoc: Like pin joints, but have a minimum And maximum distance.
about: A chain could be modeled using this joint. It keeps the anchor points from getting To far apart,
but will allow them To get closer together.
End Rem
Type CPSlideJoint Extends CPConstraint

	Rem
	bbdoc: Creates a New slide joint.
	End Rem
	Method Create:CPSlideJoint(bodyA:CPBody, bodyB:CPBody, anchor1:CPVect, anchor2:CPVect, minDist:Double, maxDist:Double)
		cpObjectPtr = bmx_cpslidejoint_create(Self, bodyA.cpObjectPtr, bodyB.cpObjectPtr, anchor1.vecPtr, anchor2.vecPtr, minDist, maxDist)
		Return Self
	End Method
	
	Rem
	bbdoc: Anchor point 1
	End Rem
	Method GetAnchor1:CPVect()
		Return CPVect._create(bmx_cpslidejoint_getanchor1(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Anchor point 2
	End Rem
	Method GetAnchor2:CPVect()
		Return CPVect._create(bmx_cpslidejoint_getanchor2(cpObjectPtr))
	End Method

	Rem
	bbdoc: Minimum allowed distance of the anchor points.
	End Rem
	Method GetMinDist:Double()
		Return bmx_cpslidejoint_getmindist(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: Maximum allowed distance of the anchor points.
	End Rem
	Method GetMaxDist:Double()
		Return bmx_cpslidejoint_getmaxdist(cpObjectPtr)
	End Method
	
	Rem
	bbdoc: /// Set the maximum distance the joint will maintain between the two anchors.
	End Rem
	Method SetMax(Value:Double)
		bmx_cpslidejoint_setmax(CPObjectptr, Value)
	End Method
End Type

Rem
bbdoc: Allows two objects To pivot about a single point.
End Rem
Type CPPivotJoint Extends CPConstraint

	Rem
	bbdoc: Creates a New pivot joint.
	about: @bodyA And @bodyB are the two bodies To connect, And @pivot is the point in world coordinates of the pivot.
	Because the pivot location is given in world coordinates, you must have the bodies moved into the correct positions
	already.
	Alternatively you can specify the joint based on a pair of anchor points, but make sure you have the bodies in the right place as the joint will fix itself as soon as you start simulating the space.
	End Rem
	Method Create:CPPivotJoint(bodyA:CPBody, bodyB:CPBody, pivot:CPVect, anchorB:CPVect = Null)
		If anchorB
			cpObjectPtr = bmx_cppivotjoint_create(Self, bodyA.cpObjectPtr, bodyB.cpObjectPtr, pivot.vecPtr, anchorB.vecPtr)
		Else
			cpObjectPtr = bmx_cppivotjoint_create(Self, bodyA.cpObjectPtr, bodyB.cpObjectPtr, pivot.vecPtr, Null)
		End If
		Return Self
	End Method

	Rem
	bbdoc: Anchor point 1
	End Rem
	Method GetAnchor1:CPVect()
		Return CPVect._create(bmx_cppivotjoint_getanchor1(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: /// Set the location of the first anchor relative to the first body.
	End Rem
	Method SetAnchorA(Value:CPVect)
		bmx_cppivotjoint_setanchora(cpObjectPtr, Value.vecPtr)
	End Method

	Rem
	bbdoc: Anchor point 2
	End Rem
	Method GetAnchor2:CPVect()
		Return CPVect._create(bmx_cppivotjoint_getanchor2(cpObjectPtr))
	End Method	
	
End Type

Rem
bbdoc: Attaches a point on one body To a groove on the other.
about: Think of it as a sliding pivot joint.
End Rem
Type CPGrooveJoint Extends CPConstraint

	Rem
	bbdoc: Creates a New groove joint.
	about: The groove goes from @grooveA To @grooveB on @bodyA, And the pivot is attached To @anchor on @bodyB.
	All coordinates are body local.
	End Rem
	Method Create:CPGrooveJoint(bodyA:CPBody, bodyB:CPBody, grooveA:CPVect, grooveB:CPVect, anchor:CPVect)
		cpObjectPtr = bmx_cpgroovejoint_create(Self, bodyA.cpObjectPtr, bodyB.cpObjectPtr, grooveA.vecPtr, grooveB.vecPtr, anchor.vecPtr)
		Return Self
	End Method

	Rem
	bbdoc: Groove A location.
	End Rem
	Method GetGrooveA:CPVect()
		Return CPVect._create(bmx_cpgroovejoint_getgroovea(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: Groove B location.
	End Rem
	Method GetGrooveB:CPVect()
		Return CPVect._create(bmx_cpgroovejoint_getgrooveb(cpObjectPtr))
	End Method	

	Rem
	bbdoc: Anchor point.
	End Rem
	Method GetAnchor:CPVect()
		Return CPVect._create(bmx_cpgroovejoint_getanchor(cpObjectPtr))
	End Method	

End Type

Rem
bbdoc: Convenience Function for the creation of a CPVect of @x, @y.
End Rem
Function Vec2:CPVect(x:Double, y:Double)
	Return New CPVect.Create(x, y)
End Function

Rem
bbdoc: A standard 0,0 vector.
End Rem
Global CPVZero:CPVect = CPVect._create(bmx_cpvect_cpvzero())

Extern	' This block handles Object arrays
	Function bmx_momentforpoly:Double(m:Double, verts:CPVect[], Count:Int, offset:Byte Ptr, radius:Double)
	Function bmx_cppolyshape_create:Byte Ptr(Handle:Object, body:Byte Ptr, verts:CPVect[], Count:Int, offset:Byte Ptr, radius:Double)
	Function bmx_cppolyshape_getverts(handle:Byte Ptr, verts:CPVect[])
	Function bmx_cpcontact_fill(conts:CPContact[], contacts:Byte Ptr, numContacts:Int)

	Function bmx_cpareaforpoly:Double(Count:Int, verts:CPVect[], radius:Double)

	Function bmx_cpcentroidforpoly:Byte Ptr(Count:Int, Verts:CPVect[])

	Function bmx_cpconvexhull:Int(Count:Int, verts:CPVect[], result:CPVect[], First:Int Ptr, tol:Double)

	Function bmx_cparbiter_setcontactpointset(arb:Byte ptr, Set:CPContact[])
End Extern

Rem
bbdoc: Calculates the moment of inertia For the polygons of mass @m.
End Rem
Function MomentForPoly:Double(m:Double, verts:CPVect[], offset:CPVect, radius:Double = 0, Count:Int = Null)
	If Not Count
		Count = verts.Length
	End If
	Return bmx_momentforpoly(m, verts, Count, offset.vecPtr, radius)
End Function

Rem
bbdoc: Calculates the moment of inertia For the circle of mass @m.
End Rem
Function MomentForCircle:Double(m:Double, r1:Double, r2:Double, offset:CPVect)
	Return bmx_momentforcircle(m, r1, r2, offset.vecPtr)
End Function

Rem
bbdoc: Apply a spring force between bodies @a and @b at anchors @anchor1 and @anchor2 respectively.
about: @k is the spring constant (force/distance), @rlen is the rest length of the spring, @dmp is the damping
constant (force/velocity), and @dt is the time step to apply the force over.
End Rem
Function DampedSpring:CPDampedSpring(a:CPBody, b:CPBody, anchor1:CPVect, anchor2:CPVect, rlen:Double, k:Double, dmp:Double, dt:Double=Null)
		Return New CPDampedSpring.Create(a, b, anchor1, anchor2, rlen, k, dmp, dt)
End Function

Rem
bbdoc: 
End Rem
Type cpArbiter
	
	Field cpArbiterPtr:Byte Ptr
	
	Function _create:cpArbiter(cpArbiterPtr:Byte Ptr)
		If cpArbiterPtr Then
			Local this:cpArbiter = New cpArbiter
			this.cpArbiterPtr = cpArbiterPtr
			Return this
		End If
	End Function
	
	Method Ignore:Int(arb:cpArbiter)
		Return cpArbiterIgnore(arb.cpArbiterPtr)
	End Method
	
	Rem
	bbdoc: A user definable context pointer. 
	about: The value will persist until just after the separate() callback is called for the pair.<br>
	<p><b>NOTE:</b> If you need to clean up this pointer, you should implement the separate() callback to do it. 
	Also be careful when destroying the space as there may be active collisions still. 
	In order to trigger the separate() callbacks and clean up your data, you’ll need to remove all the shapes from the space before disposing of it. 
	This is something I’d suggest doing anyway. 
	See ChipmunkDemo.bmx:ChipmunkDemoFreeSpaceChildren() for an example of how to do it easily.</p>
	EndRem
	Method GetUserData:Object()
		Return bmx_cparbiter_getdata(cpArbiterPtr)
	End Method

	Rem
	bbdoc: A user definable context pointer. 
	about: The value will persist until just after the separate() callback is called for the pair.<br>
	<p><b>NOTE:</b> If you need to clean up this pointer, you should implement the separate() callback to do it. 
	Also be careful when destroying the space as there may be active collisions still. 
	In order to trigger the separate() callbacks and clean up your data, you’ll need to remove all the shapes from the space before disposing of it. 
	This is something I’d suggest doing anyway. 
	See ChipmunkDemo.bmx:ChipmunkDemoFreeSpaceChildren() for an example of how to do it easily.</p>
	EndRem
	Method SetUserData(Data:Object)
		cpArbiterSetUserData(cpArbiterPtr, Data)
	End Method

	Rem
	bbdoc: Get the number of contacts tracked by this arbiter.
	about: For the forseeable future, the maximum number of contacts will be two.
	end rem
	Method GetCount:Int()
		Return cpArbiterGetCount(cpArbiterPtr)
	End Method
	
	Rem
	bbdoc: Get the collision normal of a collision point.
	end rem
	Method GetNormal:CPVect(i:Int = 0)
		Return CPVect._create(bmx_cparbiter_getnormal(cpArbiterPtr))
	End Method

	Rem
	bbdoc: Get the specific collision point of a collision point.
	about: For the forseeable future, the maximum number of contacts will be two.
	end rem
	Method GetPointA:CPVect(i:Int)
		Return CPVect._create(bmx_cparbiter_getpointa(cpArbiterPtr, i))
	End Method
	
	Rem
	bbdoc: Get the specific collision point of a collision point.
	about: For the forseeable future, the maximum number of contacts will be two.
	end rem
	Method GetPointB:CPVect(i:Int)
		Return CPVect._create(bmx_cparbiter_getpointb(cpArbiterPtr, i))
	End Method

	Rem
	bbdoc: Get the shapes in the order that they were defined in the collision handler associated with this arbiter.
	about: If you defined the handler as AddCollisionHandler(1, 2, ...), you you will find that @a.GetCollisionType() = 1 and @b.GetCollisionType() = 2.

	end rem
	Method GetShapes(a:CPShape, b:CPShape)
        cpArbiterGetShapes(cpArbiterPtr, Varptr(a.cpObjectPtr), Varptr(b.cpObjectPtr))
	End Method

	Rem
	bbdoc: Get the bodies in the order that they were defined in the collision handler associated with this arbiter.
	about: If you defined the handler as AddCollisionHandler(1, 2, ...), you you will find that @a->collision_type == 1 and @b->collision_type == 2.
	end rem
	Method GetBodies(a:CPBody, b:CPBody)
        cpArbiterGetBodies(cpArbiterPtr, Varptr(a.cpObjectPtr), Varptr(b.cpObjectPtr))
	End Method

	Rem
	bbdoc: 
	EndRem
	Method TotalImpulse:CPVect()
		Return CPVect._create(bmx_cparbiter_totalimpulse(cpArbiterPtr))
	End Method

	Rem
	bbdoc: Replace the contact point set of an @Arbiter. 
	about: You cannot change the number of contacts, but can change the location, normal or penetration distance. The “Sticky” demo uses this to allow objects to overlap an extra amount. You could also use it in a Pong style game to modify the normal of the collision based on the x-position of the collision even though the paddle is a flat shape.
	EndRem
	Method SetContactPointSet(Set:CPContact[])
		bmx_cparbiter_setcontactpointset(cpArbiterPtr, Set)
	End Method
End Type

' -- below added by Hotcakes ------------------------

Rem
bbdoc: Type used for 2×3 affine transforms in Chipmunk.
End Rem
Type CPTransform
	Field a:Double, b:Double, c:Double, d:Double, tx:Double, ty:Double
	Field transformPtr:Byte Ptr
	
	Function _create:CPTransform(transformPtr:Byte Ptr)
		If transformPtr Then
			Local this:CPTransform = New CPTransform
			this.transformPtr = transformPtr
			this._Update
			Return this
		End If
	End Function
	
	Rem
	bbdoc: Construct a new transform matrix in transposed order.
	end rem
	Method Create:CPTransform(a:Double, c:Double, tx:Double, b:Double, d:Double, ty:Double)
	    Self.a = a
		Self.b = b
		Self.c = c
		Self.d = d
		Self.tx = tx
		Self.ty = ty
	    Return Self
	End Method
	
	Method _Update()
		If transformPtr
'			bmx_cptransform_update transformPtr, VarPtr(a), VarPtr(b), VarPtr(c), VarPtr(d), VarPtr(tx), VarPtr(ty)
DebugStop
		End If
	End Method

	Rem
	bbdoc: Get the inverse of a transform matrix.
	end rem
	Function Inverse:CPTransform(t:CPTransform)
	    Local inv_det:Double = 1.0 / (t.a * t.d - t.c * t.b)
	    Return New CPTransform.Create( ..
	        t.d * inv_det, -t.c * inv_det, (t.c * t.ty - t.tx * t.d) * inv_det,  ..
	       - t.b * inv_det, t.a * inv_det, (t.tx * t.b - t.a * t.ty) * inv_det ..
	    )
	End Function
	
	Rem
	bbdoc: Multiply two transformation matrices.
	end rem
	Function Mult:CPTransform(t1:CPTransform, t2:CPTransform)
	    Return New CPTransform.Create( ..
	        t1.a * t2.a + t1.c * t2.b, t1.a * t2.c + t1.c * t2.d, t1.a * t2.tx + t1.c * t2.ty + t1.tx,  ..
	        t1.b * t2.a + t1.d * t2.b, t1.b * t2.c + t1.d * t2.d, t1.b * t2.tx + t1.d * t2.ty + t1.ty ..
	    )
	End Function
	
	Rem
	bbdoc: Transform an absolute point. (i.e. a vertex)
	end rem
	Function Point:CPVect(t:CPTransform, p:CPVect)
	    Return Vec2(t.a * p.x + t.c * p.y + t.tx, t.b * p.x + t.d * p.y + t.ty)
	End Function
		
	Rem
	bbdoc: Create a transation matrix.
	end rem
	Function Translate:CPTransform(Translate:CPVect)
	    Return New CPTransform.Create( ..
	        1.0, 0.0, Translate.x,  ..
	        0.0, 1.0, Translate.y ..
	    )
	End Function
	
	Rem
	bbdoc: Create a scale matrix.
	end rem
	Function Scale:CPTransform(scaleX:Double, scaleY:Double)
	    Return New CPTransform.Create( ..
	        scaleX, 0.0, 0.0,  ..
	        0.0, scaleY, 0.0 ..
	    )
	End Function
	
	Rem
	bbdoc: Miscellaneous (but useful) transformation matrice.
	end rem
	Function Ortho:CPTransform(bb:CPBB)
	    Return New CPTransform.Create( ..
	        2.0 / (bb.r - bb.l), 0.0, -(bb.r + bb.l) / (bb.r - bb.l),  ..
	        0.0, 2.0 / (bb.t - bb.b), -(bb.t + bb.b) / (bb.t - bb.b) ..
	    )
	End Function
	
End Type

Rem
bbdoc: Clamp @f to be between @min and @max.
end rem
Function Clamp:Double(f:Double, Min:Double, Max:Double)
	Return bmx_cpf_clamp(f, Min, Max)
End Function

Rem
bbdoc: Clamp @f to be between 0 and 1.
end rem
Function Clamp01:Double(f:Double)
	Return bmx_cpf_clamp01(f)
End Function



Rem
bbdoc: Linearly interpolate between @f1 and @f2.
end rem
Function Lerp:Double(f1:Double, f2:Double, t:Double)
	Return bmx_cpf_lerp(f1, f2, t)
End Function

Rem
bbdoc: Linearly interpolate from @f1 towards @f2 by no more than @d.
end rem
Function lerpconst:Double(f1:Double, f2:Double, d:Double)
	Return bmx_cpf_lerpconst(f1, f2, d)
End Function



Rem
bbdoc: Calculate the moment of inertia for a line segment.
about: The endpoints @a and @b are relative to the body.
end rem
Function MomentForSegment:Double(m:Double, a:CPVect, b:CPVect, radius:Double = 0)
	Return bmx_cpmomentforsegment(m, a.vecPtr, b.vecPtr, radius)
End Function

Rem
bbdoc: Calculate the @moment of inertia for a solid box centered on the body.
End Rem
Function MomentForBox:Double(m:Double, width:Double, height:Double)
	Return bmx_cpmomentforbox(m, width, height)
End Function

Rem
bbdoc: /// Calculate the moment of inertia for a solid @box.
End Rem
Function MomentForBox:Double(m:Double, box:CPBB)
	Return bmx_cpmomentforbox2(m, box.bbPtr)
End Function

Rem
bbdoc: Signed area of a polygon shape.
about: Returns a negative number for polygons with a clockwise winding.
end rem
Function AreaForPoly:Double(verts:CPVect[], radius:Double, Count:Int = Null)
	If Not Count
		Count = verts.Length
	End If
	Return bmx_cpareaforpoly(Count, verts, radius)
End Function

Type sleeping
'	Field root:Byte ptr
'	Field Next:Byte ptr
	Field idleTime:Double
End Type

Rem
bbdoc: Calculate the centroid for a polygon.
end rem
Function CentroidForPoly:CPVect(verts:CPVect[], Count:Int = Null)
	If Not Count
		Count = verts.Length
	End If
	Return CPVect._create(bmx_cpcentroidforpoly(Count, verts))
End Function

Type CPBoxShape Extends CPPolyShape
	Rem
	bbdoc: Because boxes are so common in physics games, Chipmunk provides shortcuts to create @box shaped polygons.
	about: The boxes will always be centered at the center of gravity of the @body you are attaching them to. 
	Adding a small @radius will bevel the corners and can significantly reduce problems where the box gets stuck on seams in your geometry. 
	If you want to create an off-center box, you will need to use CPPolyShape.Create().
	End Rem
	Method Create:CPPolyShape(body:CPBody, Width:Double, Height:Double, radius:Double)
		cpObjectPtr = bmx_cpboxshape_create(Self, body.cpObjectPtr, width, height, radius)
		_Update
		Return Self
	End Method

	Method Create:CPPolyShape(body:CPBody, box:CPBB, radius:Double)
		cpObjectPtr = bmx_cpboxshape_create2(Self, body.cpObjectPtr, Box.bbPtr, radius)
		_Update
		Return Self
	End Method
End Type

Rem
bbdoc: Calculate the convex hull of a given set of points.
about: Returns the @count of points in the hull. 
@result must be a CPVect array with at least @count elements. 
If @result is Null, then @verts array wil be reduced instead. 
@first is an optional integer to store where the first vertex in the hull came from (i.e. verts[first] = result[0]) 
@tol is the allowed amount to shrink the hull when simplifying it. A tolerance of 0.0 creates an exact hull.
End Rem
Function ConvexHull:Int(verts:CPVect[], result:CPVect[], First:Int, tol:Double, Count:Int = Null)
	If Not Count
		Count = verts.Length
	End If
	Return bmx_cpconvexhull(Count, verts, result, Varptr(First), tol)
End Function

Type TBodyFuncCallback

	Field callback(body:Object, arbiter:Object, callbackData:Object)
	Field Data:Object

End Type
	
Type TSegmentFuncCallback

	Field callback(shape:Object, Point:Object, Normal:Object, Alpha:Double, callbackData:Object)
	Field Data:Object

End Type

Type CPDampedSpring Extends CPConstraint

	Rem
	bbdoc: Defined much like a slide joint.
	about: @restLength is the distance the spring wants to be, @stiffness is the spring constant (<a href="http://en.wikipedia.org/wiki/Young's_modulus">Youngâ€™s modulus</a>), and @damping is how soft to make the damping of the spring.
	End Rem
	Method Create:CPDampedSpring(a:CPBody, b:CPBody, anchor1:CPVect, anchor2:CPVect, rlen:Double, k:Double, dmp:Double, dt:Double = Null)
		cpObjectptr = bmx_cpdampedspring(Self, a.cpObjectPtr, b.cpObjectPtr, anchor1.vecPtr, anchor2.vecPtr, rlen, k, dmp, dt)
		Return Self
	End Method

	Rem
	bbdoc: /// Get the location of the first anchor relative to the first body.
	End Rem
	Method GetAnchorA:CPVect()
		Return CPVect._create(bmx_cpdampedspring_getanchora(cpObjectPtr))
	End Method
	
	Rem
	bbdoc: /// Get the location of the second anchor relative to the second body.
	End Rem
	Method GetAnchorB:CPVect()
		Return CPVect._create(bmx_cpdampedspring_getanchorb(cpObjectPtr))
	End Method	

	Rem
	bbdoc: /// Get the rest length of the spring.
	End Rem
	Method GetRestLength:Double()
		Return cpDampedSpringGetRestLength(cpObjectPtr)
	End Method

	Rem
	bbdoc: /// Get the stiffness of the spring in force/distance.
	End Rem
	Method GetStiffness:Double()
		Return cpDampedSpringGetStiffness(cpObjectPtr)
	End Method

	Rem
	bbdoc: /// Set the damping of the spring.
	End Rem
	Method SetSpringForceFunc(springForceFunc:Double(spring:Byte ptr, Dist:Double))
		cpDampedSpringSetSpringForceFunc(cpObjectPtr, springForceFunc)
	End Method
End Type

Type CPDampedRotarySpring Extends CPConstraint

	Rem
	bbdoc: Like a damped spring, but works in an angular fashion.
	about: @restAngle is the relative angle in radians that the bodies want to have, @stiffness and @damping work basically the same as on a damped spring.
	End Rem
	Method Create:CPDampedRotarySpring(a:CPBody, b:CPBody, restAngle:Double, stiffness:Double, damping:Double)
		cpObjectptr = bmx_cpdampedrotaryspring_new(Self, a.cpObjectPtr, b.cpObjectPtr, restAngle, stiffness, damping)
		Return Self
	End Method
End Type

Type CPRotaryLimitJoint Extends CPConstraint

	Rem
	bbdoc: Constrains the relative rotations of two bodies.
	about: @min and @max are the angular limits in radians. 
	It is implemented so that it’s possible to for the range to be greater than a full revolution.
	End Rem
	Method Create:CPRotaryLimitJoint(a:CPBody, b:CPBody, Min:Double, Max:Double)
		cpObjectptr = bmx_cprotarylimitjoint_new(Self, a.cpObjectPtr, b.cpObjectPtr, Min, Max)
		Return Self
	End Method
End Type

Type CPRatchetJoint Extends CPConstraint

	Rem
	bbdoc: Works like a socket wrench.
	about: @ratchet is the distance between “clicks”, @phase is the initial offset to use when deciding where the ratchet angles are.
	End Rem
	Method Create:CPRatchetJoint(a:CPBody, b:CPBody, phase:Double, Ratchet:Double)
		cpObjectptr = bmx_cpratchetjoint_new(Self, a.cpObjectPtr, b.cpObjectPtr, phase, Ratchet)
		Return Self
	End Method
End Type

Type CPGearJoint Extends CPConstraint

	Rem
	bbdoc: Keeps the angular velocity ratio of a pair of bodies constant.
	about: @ratio is always measured in absolute terms. 
	It is currently not possible to set the ratio in relation to a third bodyâ€™s angular velocity. 
	@phase is the initial angular offset of the two bodies.
	End Rem
	Method Create:CPGearJoint(a:CPBody, b:CPBody, phase:Double, ratio:Double)
		cpObjectptr = bmx_cpgearjoint_new(Self, a.cpObjectPtr, b.cpObjectPtr, phase, ratio)
		Return Self
	End Method

End Type

Rem
bbdoc: /// Opaque struct type for damped rotary springs.
End Rem
Type CPSimpleMotor Extends CPConstraint

	Rem
	bbdoc: Keeps the relative angular velocity of a pair of bodies constant.
	about: @rate is the desired relative angular velocity. 
	You will usually want to set an force (torque) maximum for motors as otherwise they will be able to apply a nearly infinite torque to keep the bodies moving.
	End Rem
	Method Create:CPSimpleMotor(a:CPBody, b:CPBody, rate:Double)
		cpObjectPtr = bmx_cpsimplemotor_new(Self, a.cpObjectPtr, b.cpObjectPtr, rate)
		Return Self
	End Method

	Rem
	bbdoc: /// Set the @rate of the motor.
	End Rem
	Method SetRate(Value:Double)
		cpSimpleMotorSetRate(cpObjectPtr, Value)
	End Method	

End Type



Rem
bbdoc: Spatial query callback function type.
EndRem
Type TQueryFuncCallback
	Field callback(obj1:Object, obj2:Double ptr, id:uint, Data:Byte ptr)
	Field Data:Byte ptr
End Type



Rem
bbdoc: Point queries are useful for things like mouse picking and simple sensors.
about: They allow you to check if there are shapes within a certain distance of a point, find the closest point on a shape to a given point or find the closest shape to a point.
Nearest point queries return the point on the surface of the shape as well as the distance from the query point to the surface point.
end rem
Type CPPointQueryInfo
'	The nearest shape, NULL if no shape was within range.
    Field shape:Byte Ptr
'	The closest point on the shape's surface. (in world space coordinates)
    Field pointX:Double
	Field pointY:Double
'	The distance to the point. The distance is negative if the point is inside the shape.
    Field distance:Double
'	The gradient of the signed distance function.
'	The value should be similar to info.p/info.d, but accurate even for very small values of info.d.
    Field gradientX:Double
	Field gradientY:Double
End Type

Rem
bbdoc: Segment queries are like ray casting, but because not all spatial indexes allow processing infinitely long ray queries it is limited to segments. 
about: In practice this is still very fast and you donâ€™t need to worry too much about the performance as long as you arenâ€™t using extremely long segments for your queries.
Segment queries return more information than just a simple yes or no, they also return where a shape was hit and its surface normal at the hit point. 
t is the percentage between the query start and end points. 
If you need the hit point in world space or the absolute distance from start, see the segment query helper functions farther down. 
If a segment query starts within a shape it will have t = 0 and n = CPVZero.
end rem
Type CPSegmentQueryInfo
'	The shape that was Hit, Or Null If no collision occured.
	Field shape:Byte Ptr
'	The point of impact.
	Field pointX:Double
	Field pointY:Double
'	The normal of the surface hit.
	Field normalX:Double
	Field normalY:Double
'	The normalized distance along the query segment in the range [0, 1].
	Field Alpha:Double
End Type

Type CPArray Extends CPObject
	Field num:Int, Max:Int
	Field arr:Byte Ptr[Self.num]

	Method Bind:CPArray(p:Byte Ptr)
		cpObjectPtr = p
		cpbind(p, Self)
		Return Self
	End Method

	Rem
	bbdoc: Iterate over the objects in the hash, calling @callback for each.
	about: @data is some optional user data that will be passed to @callback.
	End Rem
	Method ForEach(callback(obj:Object, data:Object), data:Object = Null)
		
		Local cb:TFuncCallback = New TFuncCallback
		cb.callback = callback
		cb.data = data
		
		cpSpaceEachShape(cpObjectPtr, hashCallback, cb)
		
	End Method
	
	Function hashCallback(obj:Byte Ptr, callbackData:Object)
		If TFuncCallback(callbackData) Then
			TFuncCallback(callbackData).callback(cpfind(obj), TFuncCallback(callbackData).data)
		End If
	End Function

End Type

Include "chipmunkpro.bmx"
