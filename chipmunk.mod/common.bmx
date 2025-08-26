
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

Import BRL.Blitz
Import brl.math

Import "src/*.h"
Import "src/chipmunk.c"
Import "src/cpArray.c"
Import "src/cpBody.c"
Import "src/cpHashSet.c"
Import "src/cpPolyShape.c"
Import "src/cpSpace.c"
Import "src/cpSweep1D.c"
Import "src/cpArbiter.c"
Import "src/cpBBTree.c"
Import "src/cpCollision.c"
'Import "src/cpConstaint.c"
Import "src/cpShape.c"
Import "src/cpSpaceHash.c"
Import "src/cpMarch.c"
?Not ios
Import "src/cpHastySpace.c"	'causing problems on ios.
?
Import "src/cpPolyline.c"
Import "src/cpRobust.c"
Import "src/cpSpaceComponent.c"
Import "src/cpSpaceDebug.c"
Import "src/cpSpaceQuery.c"
Import "src/cpSpaceStep.c"
Import "src/cpSpatialIndex.c"
Import "src/constraints/cpConstraint.c"
Import "src/constraints/cpDampedRotarySpring.c"
Import "src/constraints/cpDampedSpring.c"
Import "src/constraints/cpGearJoint.c"
Import "src/constraints/cpGrooveJoint.c"
Import "src/constraints/cpPinJoint.c"
Import "src/constraints/cpPivotJoint.c"
Import "src/constraints/cpRatchetJoint.c"
Import "src/constraints/cpRotaryLimitJoint.c"
Import "src/constraints/cpSimpleMotor.c"
Import "src/constraints/cpSlideJoint.c"

Import "glue.cpp"

Extern

	Function cpunbind(obj:Byte ptr)

	Function bmx_cpf_clamp:Double(f:Double, Min:Double, Max:Double)
	Function bmx_cpf_lerp:Double(f1:Double, f2:Double, t:Double)
	Function bmx_cpf_lerpconst:Double(f1:Double, f2:Double, d:Double)
			
	Function bmx_cpvect_rperp:Byte Ptr(Handle:Byte Ptr)
	Function bmx_cpvect_lerp:Byte ptr(v1:Byte ptr, v2:Byte ptr, t:Double)
	Function bmx_cpvect_dist:Double(v1:Byte ptr, v2:Byte ptr)
	Function bmx_cpvect_near:Int(v1:Byte ptr, v2:Byte ptr, dist:Double)
	Function bmx_cpvect_forangle:Byte ptr(a:Double)
	
	Function bmx_cpbb_update(bbPtr:Byte ptr, l:Byte ptr, b:Byte ptr, r:Byte ptr, t:Byte ptr)

	Function bmx_cpbody_createkinematic:Byte Ptr(Handle:Object)
	Function bmx_cpbody_getcenterofgravity:Byte ptr(body:Byte ptr)
	Function cpBodyGetType:Byte Ptr(body:Byte Ptr)
	Function cpBodySetType(body:Byte ptr, cpBodyType:Byte ptr)
	Function cpBodyGetMoment:Double(body:Byte ptr)
	Function bmx_cpbody_setforce(body:Byte Ptr, Value:Byte Ptr)
	Function bmx_cpmomentforsegment:Double(m:Double, a:Byte ptr, b:Byte ptr, radius:Double)
	Function bmx_cpmomentforbox:Double(m:Double, Width:Double, Height:Double)
	Function bmx_cpmomentforbox2:Double(m:Double, box:Byte ptr)
	Function cpBodyIsSleeping:Int(body:Byte ptr)
	Function cpBodyEachArbiter(body:Byte Ptr, func(body:Byte Ptr,arbiter:Byte ptr, callbackData:Object), Data:Object)
	Function bmx_cpbody_velocityatworldpoint:Byte ptr(body:Byte ptr, Point:Byte ptr)
	Function bmx_cpbody_applyimpulseatworldpoint(body:Byte ptr, impulse:Byte ptr, Point:Byte ptr)
	Function bmx_cpbody_update:Double(cpObjectPtr:Byte Ptr)
	
	Function bmx_cpshape_getbb:Byte ptr(shape:Byte ptr)
	Function cpShapeGetSensor:Int(shape:Byte ptr)
	Function cpShapeSetSensor(shape:Byte ptr, Value:Int)
	Function cpShapeGetCollisionType:size_t(shape:Byte ptr)
	Function bmx_cpshape_setfilter(Handle:Byte Ptr, Filter:uInt)
	Function cpShapeGetSpace:Byte ptr(shape:Byte ptr)
	Function bmx_cpshape_pointquery:Double(shape:Byte ptr, p:Byte ptr, out:Byte ptr)
?Linux Or MacOs Or ios
	Function bmx_cpshape_update:Int(cpObjectPtr:Byte Ptr)
?Not (Linux Or MacOs Or ios)
	Function bmx_cpshape_update:uint(cpObjectPtr:Byte Ptr)
?

	Function bmx_cpcircleshape_getoffset:Byte ptr(circleShape:Byte ptr)

	Function cpSegmentShapeGetRadius:Double(shape:Byte Ptr)
	Function bmx_cpsegmentshapesetneighbors(shape:Byte ptr, prev:Byte ptr, nextShape:Byte ptr)

	Function cpPolyShapeGetRadius:Double(shape:Byte Ptr)
	Function bmx_cpboxshape_create:Byte ptr(Handle:Object, body:Byte ptr, Width:Double, Height:Double, radius:Double)
	Function bmx_cpboxshape_create2:Byte ptr(Handle:Object, body:Byte ptr, box:Byte ptr, radius:Double)
	Function cpPolyShapeSetRadius(shape:Byte ptr, radius:Double)

	Function bmx_cpspace_getgravity:Byte ptr(space:Byte ptr)
	Function cpSpaceGetSleepTimeThreshold:Double(space:Byte ptr)
	Function cpSpaceSetSleepTimeThreshold(space:Byte ptr, Value:Double)
	Function cpSpaceSetCollisionSlop(space:Byte ptr, Value:Double)
	Function cpSpaceGetCurrentTimeStep:Double(space:Byte ptr)
	Function cpSpaceIsLocked:Double(space:Byte Ptr)
	Function bmx_cpspace_getstaticbody:Byte ptr(Handle:Object, space:Byte ptr)
	Function cpSpaceReindexStatic(space:Byte Ptr)
	Function bmx_cpspace_addwildcardfunc(Handle:Byte Ptr, CollisionType:Int,  ..
		beginFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object), Data:Object,  ..
		preSolveFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		postSolveFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		separateFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object))
	Function bmx_cpspace_addpoststepcallback:Int(space:Byte ptr,  ..
		func(space:Byte Ptr, obj:Object, Data:Object), Key:Object, Data:Object)
	Function cpSpaceEachShape(space:Byte Ptr, func(obj:Byte Ptr, callbackData:Object), Data:Object)
	Function cpSpaceEachConstraint(space:Byte Ptr, func(obj:Byte Ptr, callbackData:Object), Data:Object)
	Function cpSpaceUseSpatialHash(space:Byte Ptr, dim:Double, Count:Int)
	Function bmx_cpspace_pointquerynearest:Byte ptr(space:Byte ptr, Point:Byte ptr, maxDistance:Double, Filter:uint, out:Byte ptr = Null)
	Function bmx_cpspace_segmentqueryfunc(shape:Byte ptr, Point:Byte ptr, Normal:Byte ptr, Alpha:Double, Data:Object)
	Function bmx_cpspace_segmentquery( ..
		space:Byte ptr, Start:Byte ptr, EndPoint:Byte ptr, radius:Double,  ..
		Filter:uint,  ..
		func(shape:Byte ptr, Point:Byte ptr, Normal:Byte ptr, Alpha:Double, callbackData:Object), Data:Object ..
	)
	Function bmx_cpspace_segmentqueryfirst:Byte ptr( ..
		space:Byte ptr, Start:Byte ptr, EndPoint:Byte ptr, radius:Double,  ..
		Filter:uint,  ..
		info:Byte ptr = Null ..
	)
	Function bmx_cpspace_update(cpObjectPtr:Byte Ptr, arbiters:Byte ptr)
	
	Function cpConstraintGetMaxForce:Double(constraint:Byte ptr)
	Function cpConstraintSetMaxForce(constraint:Byte ptr, Value:Double)
	Function cpConstraintSetErrorBias(constraint:Byte ptr, Value:Double)
	Function cpConstraintSetMaxBias(constraint:Byte ptr, Value:Double)
	Function cpConstraintSetCollideBodies(constraint:Byte ptr, collideBodies:Int)
	Function bmx_cpconstraint_setpresolvefunc(constraint:Byte ptr,  ..
		 preSolveFunc(constraint:Byte ptr, space:Byte Ptr))
	Function bmx_cpconstraint_setpostsolvefunc(constraint:Byte ptr,  ..
		 postSolveFunc(constraint:Byte ptr, space:Byte Ptr))
	Function cpConstraintGetImpulse:Double(constraint:Byte ptr)
		
	Function cpConstraintIsPinJoint:Int(constraint:Byte ptr)
	Function cpPinJointSetDist(constraint:Byte ptr, Value:Double)
				
	Function cpConstraintIsSlideJoint:Int(constraint:Byte ptr)
	Function bmx_cpslidejoint_setmax(constraint:Byte ptr, Value:Double)
	
	Function cpConstraintIsPivotJoint:Int(constraint:Byte ptr)
	Function bmx_cppivotjoint_setanchora(constraint:Byte ptr, Value:Byte ptr)
			
	Function cpConstraintIsGrooveJoint:Int(constraint:Byte ptr)
			
	Function cpConstraintIsDampedSpring:Int(constraint:Byte ptr)
	Function bmx_cpdampedspring_getanchora:Byte Ptr(Handle:Byte Ptr)
	Function bmx_cpdampedspring_getanchorb:Byte Ptr(Handle:Byte Ptr)
	Function cpDampedSpringGetRestLength:Double(constraint:Byte ptr)
	Function cpDampedSpringGetStiffness:Double(constraint:Byte ptr)
	Function cpDampedSpringSetSpringForceFunc(constraint:Byte ptr, springForceFunc:Double(spring:Byte ptr, Dist:Double))
		
	Function bmx_cpdampedrotaryspring_new:Byte ptr(Handle:Object, a:Byte ptr, b:Byte ptr, restAngle:Double, stiffness:Double, damping:Double)

	Function bmx_cprotarylimitjoint_new:Byte ptr(Handle:Object, a:Byte ptr, b:Byte ptr, Min:Double, Max:Double)
		
	Function bmx_cpratchetjoint_new:Byte ptr(Handle:Object, a:Byte ptr, b:Byte ptr, phase:Double, Ratchet:Double)

	Function bmx_cpgearjoint_new:Byte ptr(Handle:Object, a:Byte ptr, b:Byte ptr, phase:Double, ratio:Double)

	Function bmx_cpsimplemotor_new:Byte ptr(Handle:Object, a:Byte ptr, b:Byte ptr, rate:Double)
	Function cpSimpleMotorSetRate(constraint:Byte ptr, Value:Double)

	Function cpArbiterIgnore:Int(arb:Byte ptr)
	Function bmx_cparbiter_getdata:Object(arb:Byte ptr)
	Function cpArbiterSetUserData(arb:Byte ptr, Data:Object)
	Function cpArbiterGetCount:Int(arb:Byte Ptr)
	Function bmx_cparbiter_getnormal:Byte ptr(arb:Byte ptr)
	Function bmx_cparbiter_getpointa:Byte ptr(arb:Byte ptr, i:Int)
	Function bmx_cparbiter_getpointb:Byte ptr(arb:Byte ptr, i:Int)
    Function cpArbiterGetDepth:Double(arb:Byte Ptr, i:Int)
	Function cpArbiterGetShapes (arb:Byte Ptr, a:Byte Ptr, b:Byte Ptr)
	Function cpArbiterGetBodies (arb:Byte Ptr, a:Byte Ptr, b:Byte Ptr)
	Function bmx_cparbiter_totalimpulse:Byte ptr(Arb:Byte ptr)
	Function bmx_cparbiter_getcontacts:Byte Ptr(arb:Byte Ptr, i:Int)
	
	Function bmx_cpcontact_getr1:Byte ptr(contact:Byte ptr)
	Function bmx_cpcontact_setr1(contact:Byte ptr, r1:Byte ptr)
	Function bmx_cpcontact_getr2:Byte ptr(contact:Byte ptr)
	Function bmx_cpcontact_setr2(contact:Byte ptr, r2:Byte ptr)

	Function bmx_cptransform_update(transformPtr:Byte ptr, a:Byte ptr, b:Byte ptr, c:Byte ptr, d:Byte ptr, tx:Byte ptr, ty:Byte ptr)
	
	?Not ios
	Function bmx_cphastyspace_new:Byte ptr(Handle:Object)
	Function cpHastySpaceFree(space:Byte ptr)
	Function cpHastySpaceSetThreads(space:Byte ptr, threads:ulong)
	Function cpHastySpaceStep(space:Byte ptr, dt:Double)
	?
	
' -- above added by Hotcakes ------------------------

	Function cpfind:Object(obj:Byte Ptr)
	Function cpbind(p:Byte Ptr, obj:Object)

	Function cpInitChipmunk()
	Function cpResetShapeIdCounter()
	Function cpSpaceRehashStatic(space:Byte Ptr)
	Function cpSpaceStep(space:Byte Ptr, dt:Double)
	Function cpSpaceFree(space:Byte Ptr)

	Function bmx_cpbody_create:Byte Ptr(handle:Object, mass:Double, inertia:Double)
	Function bmx_cpbody_getmass:Double(handle:Byte Ptr)
	Function bmx_cpbody_getinertia:Double(handle:Byte Ptr)
	Function bmx_cpbody_getangle:Double(handle:Byte Ptr)
	Function bmx_cpbody_getangularvelocity:Double(handle:Byte Ptr)
	Function bmx_cpbody_gettorque:Double(handle:Byte Ptr)
	Function bmx_cpbody_setposition(handle:Byte Ptr, pos:Byte Ptr)
	Function bmx_cpbody_getposition:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpbody_getrot:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpbody_setvelocity(handle:Byte Ptr, velocity:Byte Ptr)
	Function cpBodyUpdatePosition(handle:Byte Ptr, dt:Double)
	Function bmx_cpbody_setangularvelocity(handle:Byte Ptr, av:Double)
	Function bmx_cpbody_setangle(handle:Byte Ptr, angle:Double)
	Function bmx_cpbody_updatevelocity(handle:Byte Ptr, gravity:Byte Ptr, damping:Double, dt:Double)
	Function cpBodyResetForces(handle:Byte Ptr)
	Function bmx_cpbody_applyforce(handle:Byte Ptr, force:Byte Ptr, offset:Byte Ptr)
	Function bmx_cpbody_local2world:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpbody_world2local:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpbody_getvelocity:Byte Ptr(cpObjectPtr:Byte Ptr)
	Function cpBodySetMass(handle:Byte Ptr, mass:Double)
	Function cpBodySetMoment(handle:Byte Ptr, moment:Double)
	Function bmx_body_applyimpulse(handle:Byte Ptr, impulse:Byte Ptr, offset:Byte Ptr)
	Function bmx_body_slew(handle:Byte Ptr, pos:Byte Ptr, dt:Double)
	Function cpBodyFree(handle:Byte Ptr)
	Function bmx_cpbody_settorque(handle:Byte Ptr, torque:Double)
	Function bmx_cpbody_posfunc(handle:Byte Ptr, func(body:Byte Ptr, dt:Double))
	Function bmx_cpbody_velfunc(handle:Byte Ptr, func(body:Byte Ptr, gravity:Byte Ptr, damping:Double, dt:Double))
	Function bmx_velocity_function(body:Byte Ptr, gravity:Byte Ptr, damping:Double, dt:Double)
	Function bmx_position_function(body:Byte Ptr, dt:Double)
	Function bmx_cpbody_setdata(body:Byte Ptr, data:Object)
	Function bmx_cpbody_getdata:Object(body:Byte Ptr)
	
	Function bmx_cpspace_create:Byte Ptr(handle:Object)
	Function bmx_cpspace_setgravity(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpspace_addstaticshape(handle:Byte Ptr, shape:Byte Ptr)
	Function bmx_cpspace_addbody(Handle:Byte Ptr, body:Byte Ptr)
	Function bmx_cpspace_addshape(handle:Byte Ptr, shape:Byte Ptr)
	Function bmx_cpspace_getactiveshapes:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpspace_getstaticshapes:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpspace_setiterations(handle:Byte Ptr, num:Int)
	Function bmx_cpspace_addconstraint(handle:Byte Ptr, constraint:Byte Ptr)
	Function bmx_cpspace_addcollisionpairfunc(handle:Byte Ptr, collTypeA:Int, collTypeB:Int, ..
		beginFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object), Data:Object,  ..
		preSolveFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		postSolveFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		separateFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object))
	Function bmx_cpspace_addcollisionpairnullfunc(handle:Byte Ptr, collTypeA:Int, collTypeB:Int)
	Function bmx_cpspace_removecollisionpairfunc(Handle:Byte Ptr, collTypeA:Int, collTypeB:Int,  ..
		beginFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		preSolveFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		postSolveFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		separateFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object))
	Function bmx_cpspace_setdefaultcollisionpairfunc(handle:Byte Ptr, ..
		beginFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object), Data:Object,  ..
		preSolveFunc:Int(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		postSolveFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object),  ..
		separateFunc(arb:Byte Ptr, space:Byte Ptr, Data:Object))
	Function bmx_cpspace_setdamping(Handle:Byte Ptr, damping:Double)
	
	Function cpSpaceRemoveBody(handle:Byte Ptr, body:Byte Ptr)
	Function cpSpaceRemoveShape(handle:Byte Ptr, shape:Byte Ptr)
	Function cpSpaceRemoveConstraint(handle:Byte Ptr, body:Byte Ptr)

	Function bmx_cpvect_create:Byte Ptr(x:Double, y:Double)
	Function bmx_cpvect_delete(handle:Byte Ptr)
	Function bmx_cpvect_getx:Double(handle:Byte Ptr)
	Function bmx_cpvect_gety:Double(handle:Byte Ptr)
	Function bmx_cpvect_add:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_sub:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_rotate:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_getxy(handle:Byte Ptr, x:Double Ptr, y:Double Ptr)
	Function bmx_cpvect_negate:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpvect_mult:Byte Ptr(handle:Byte Ptr, scalar:Double)
	Function bmx_cpvect_dot:Double(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_cross:Double(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_perp:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpvect_project:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_unrotate:Byte Ptr(handle:Byte Ptr, vec:Byte Ptr)
	Function bmx_cpvect_length:Double(handle:Byte Ptr)
	Function bmx_cpvect_lengthsq:Double(handle:Byte Ptr)
	Function bmx_cpvect_normalize:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpvect_toangle:Double(handle:Byte Ptr)
	Function bmx_cpvect_cpvzero:Byte Ptr()
	Function bmx_cpvect_fromvect:Byte Ptr(vect:Byte Ptr)

	Function bmx_cpsegmentshape_create:Byte Ptr(handle:Object, body:Byte Ptr, a:Byte Ptr, b:Byte Ptr, radius:Double)
	Function bmx_cpsegmentshape_getendpointa:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpsegmentshape_getendpointb:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpsegmentshape_getnormal:Byte Ptr(handle:Byte Ptr)

	Function bmx_cppolyshape_getvertsascoords:Double[](handle:Byte Ptr)
	Function bmx_cppolyshape_numverts:Int(handle:Byte Ptr)

	Function bmx_cpshape_setelasticity(handle:Byte Ptr, e:Double)
	Function bmx_cpshape_setfriction(Handle:Byte Ptr, u:Double)
	Function bmx_cpshape_setcollisiontype(Handle:Byte Ptr, Kind:size_t)
	Function bmx_cpshape_getbody:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpshape_setgroup(Handle:Byte Ptr, group:Int)
	Function bmx_cpshape_setlayers(handle:Byte Ptr, layers:Int)
	Function bmx_cpshape_setsurfacevelocity(handle:Byte Ptr, velocity:Byte Ptr)
	Function bmx_cpshape_getsurfacevelocity:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpshape_getelasticity:Double(handle:Byte Ptr)
	Function bmx_cpshape_getfriction:Double(handle:Byte Ptr)
	Function cpShapeFree(handle:Byte Ptr)
	Function bmx_cpshape_cachebb:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpshape_setdata(handle:Byte Ptr, data:Object)
	Function bmx_cpshape_getdata:Object(handle:Byte Ptr)

	Function bmx_momentforcircle:Double(m:Double, r1:Double, r2:Double, offset:Byte Ptr)
	Function bmx_cpdampedspring:Byte ptr(Handle:Object, a:Byte Ptr, b:Byte Ptr, anchor1:Byte Ptr, anchor2:Byte Ptr, rlen:Double, k:Double, dmp:Double, dt:Double)

	Function bmx_cpcircleshape_create:Byte Ptr(handle:Object, body:Byte Ptr, radius:Double, offset:Byte Ptr)
	Function bmx_cpcircleshape_getradius:Double(handle:Byte Ptr)
	Function bmx_cpcircleshape_getcenter:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpcircleshape_gettransformedcenter:Byte Ptr(handle:Byte Ptr)
	
	Function cpSpaceEachBody(handle:Byte Ptr, callback(obj:Byte Ptr, callbackData:Object), data:Object)

	Function bmx_cppinjoint_create:Byte Ptr(handle:Object, bodyA:Byte Ptr, bodyB:Byte Ptr, anchor1:Byte Ptr, anchor2:Byte Ptr)
	Function bmx_cpslidejoint_create:Byte Ptr(handle:Object, bodyA:Byte Ptr, bodyB:Byte Ptr, anchor1:Byte Ptr, anchor2:Byte Ptr, minDist:Double, maxDist:Double)
	Function bmx_cppivotjoint_create:Byte Ptr(Handle:Object, bodyA:Byte Ptr, bodyB:Byte Ptr, pivot:Byte Ptr, anchorB:Byte ptr)
	Function bmx_cpgroovejoint_create:Byte Ptr(handle:Object, bodyA:Byte Ptr, bodyB:Byte Ptr, grooveA:Byte Ptr, grooveB:Byte Ptr, anchor:Byte Ptr)
	Function cpConstraintFree(handle:Byte Ptr)

	Function bmx_cppinjoint_getanchor1:Byte Ptr(handle:Byte Ptr)
	Function bmx_cppinjoint_getanchor2:Byte Ptr(handle:Byte Ptr)

	Function bmx_cpslidejoint_getanchor1:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpslidejoint_getanchor2:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpslidejoint_getmindist:Double(handle:Byte Ptr)
	Function bmx_cpslidejoint_getmaxdist:Double(handle:Byte Ptr)

	Function bmx_cppivotjoint_getanchor1:Byte Ptr(handle:Byte Ptr)
	Function bmx_cppivotjoint_getanchor2:Byte Ptr(handle:Byte Ptr)

	Function bmx_cpgroovejoint_getgroovea:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpgroovejoint_getgrooveb:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpgroovejoint_getanchor:Byte Ptr(handle:Byte Ptr)

	Function bmx_cpconstraint_getbodya:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpconstraint_getbodyb:Byte Ptr(handle:Byte Ptr)

	Function bmx_CP_HASH_PAIR:Int(collTypeA:Int, collTypeB:Int)
	
	Function bmx_cpcontact_getposition:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpcontact_getnormal:Byte Ptr(handle:Byte Ptr)
	Function bmx_cpcontact_getdistance:Double(handle:Byte Ptr)
	Function bmx_cpcontact_getjnacc:Double(handle:Byte Ptr)
	Function bmx_cpcontact_getjtacc:Double(handle:Byte Ptr)

	Function bmx_cpbb_create:Byte Ptr(l:Double, b:Double, r:Double, t:Double)
	Function bmx_cpbb_intersects:Int(handle:Byte Ptr, other:Byte Ptr)
	Function bmx_cpbb_containsbb:Int(handle:Byte Ptr, other:Byte Ptr)
	Function bmx_cpbb_containsvect:Int(handle:Byte Ptr, v:Byte Ptr)
	Function bmx_cpbb_clampvect:Byte Ptr(handle:Byte Ptr, v:Byte Ptr)
	Function bmx_cpbb_wrapvect:Byte Ptr(handle:Byte Ptr, v:Byte Ptr)
	Function bmx_cpbb_delete(handle:Byte Ptr)

End Extern

Const INFINITY:Double = 1e1000

' -- below added by Hotcakes ------------------------

Const CP_BODY_TYPE_DYNAMIC:Byte ptr = 0
Const CP_BODY_TYPE_KINEMATIC:Byte ptr = 1
Const CP_BODY_TYPE_STATIC:Byte ptr = 2
Const CP_SHAPE_FILTER_ALL:uint = CP_ALL_CATEGORIES
Const CP_SHAPE_FILTER_NONE:uint = ~CP_ALL_CATEGORIES
Const CP_NO_GROUP:uint = 0								' /// Value for cpShape.group signifying that a shape is in no group.
Const CP_ALL_CATEGORIES:uint = ~0						' /// Value for cpShape.layers signifying that a shape is in every layer.

Global CP_PI:Double = ACos(-1.0)	' converts from code designed for radians to BlitzMax compatible degrees

Global ENABLE_HASTY:Int = 0
