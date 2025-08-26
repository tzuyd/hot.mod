
/*
  Copyright (c) 2007-2016 Bruce A Henderson

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
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

#include <map>

#include <stddef.h>

#include "chipmunk/chipmunk.h"
#include "chipmunk/chipmunk_private.h"
#include "chipmunk/chipmunk_unsafe.h"

#include "blitz.h"

#ifdef BMX_NG
#define CB_PREF(func) func
#else
#define CB_PREF(func) _##func
#endif

extern "C" {
	void cpunbind(void* obj);
	void CB_PREF(hot_chipmunk_CPSpace__segmenthashCallback)(cpShape* shape, cpVect* point, cpVect* normal, cpFloat alpha, void* data);
	cpContact* CB_PREF(hot_chipmunk_CPContact__getContactForIndex)(BBArray* verts, int index);

	cpFloat bmx_cpf_clamp(cpFloat f, cpFloat min, cpFloat max);
	cpFloat bmx_cpf_lerp(cpFloat f1, cpFloat f2, cpFloat t);
	cpFloat bmx_cpf_lerpconst(cpFloat f1, cpFloat f2, cpFloat d);

	cpVect* bmx_cpvect_rperp(cpVect* vec);
	cpVect* bmx_cpvect_lerp(cpVect* v1, cpVect* v2, cpFloat t);
	cpFloat bmx_cpvect_dist(cpVect* v1, cpVect* v2);
	cpBool bmx_cpvect_near(cpVect* v1, cpVect* v2, cpFloat dist);
	cpVect* bmx_cpvect_forangle(cpFloat a);

	void bmx_cpbb_update(cpBB* bbPtr, cpFloat* l, cpFloat* b, cpFloat* r, cpFloat* t);

	cpBody* bmx_cpbody_createkinematic(BBObject* handle);
	cpVect* bmx_cpbody_getcenterofgravity(cpBody* body);
	void bmx_cpbody_setforce(cpBody* body, cpVect* value);
	cpFloat bmx_cpmomentforsegment(cpFloat m, cpVect* a, cpVect* b, cpFloat radius);
	cpFloat bmx_cpmomentforbox(cpFloat m, cpFloat width, cpFloat height);
	cpFloat bmx_cpmomentforbox2(cpFloat m, cpBB* box);
	cpFloat bmx_cpareaforpoly(int count, BBArray* verts, cpFloat radius);
	cpVect* bmx_cpbody_velocityatworldpoint(cpBody* body, cpVect* point);
	void bmx_cpbody_applyimpulseatworldpoint(cpBody* body, cpVect* impulse, cpVect* point);
	cpFloat bmx_cpbody_update(cpBody* cpObjectPtr);

	cpBB* bmx_cpshape_getbb(cpShape* shape);
	void bmx_cpshape_setfilter(cpShape* shape, unsigned int filter);
	cpVect* bmx_cpcentroidforpoly(int count, BBArray* verts);
	cpFloat bmx_cpshape_pointquery(cpShape* shape, cpVect* p, cpPointQueryInfo* out);
	cpHashValue bmx_cpshape_update(cpShape* cpObjectPtr);

	cpVect* bmx_cpcircleshape_getoffset(cpShape* circleShape);

	void bmx_cpsegmentshapesetneighbors(cpShape* shape, cpVect* prev, cpVect* next);

	cpShape* bmx_cpboxshape_create(BBObject* handle, cpBody* body, cpFloat width, cpFloat height, cpFloat radius);
	cpShape* bmx_cpboxshape_create2(BBObject* handle, cpBody* body, cpBB* box, cpFloat radius);
	int bmx_cpconvexhull(int count, BBArray* verts, BBArray* result, int* first, cpFloat tol);

	cpVect* bmx_cpspace_getgravity(cpSpace* space);
	cpBody* bmx_cpspace_getstaticbody(BBObject* handle, cpSpace* space);
	void bmx_cpspace_addwildcardfunc(cpSpace* space, unsigned long type, cpCollisionBeginFunc func, void* data,
		cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc);
	cpBool bmx_cpspace_addpoststepcallback(cpSpace* space, cpPostStepFunc func, void* key, void* data);
	cpShape* bmx_cpspace_pointquerynearest(cpSpace* space, cpVect* point, cpFloat maxDistance, unsigned int filter, cpPointQueryInfo* out);
	void bmx_cpspace_segmentqueryfunc(cpShape* shape, cpVect point, cpVect normal, cpFloat alpha, void* data);
	void bmx_cpspace_segmentquery(
		cpSpace* space, cpVect* start, cpVect* end, cpFloat radius,
		unsigned int filter,
		cpSpaceSegmentQueryFunc func, void* data
	);
	cpShape* bmx_cpspace_segmentqueryfirst(
		cpSpace* space, cpVect* start, cpVect* end, cpFloat radius,
		unsigned int filter,
		cpSegmentQueryInfo* info
	);
	void bmx_cpspace_update(cpSpace* cpObjectPtr, cpArray* arbiters);

	void bmx_cpconstraint_setpresolvefunc(cpConstraint* constraint, cpConstraintPreSolveFunc preSolveFunc);
	void bmx_cpconstraint_setpostsolvefunc(cpConstraint* constraint, cpConstraintPostSolveFunc postSolveFunc);

	void bmx_cpslidejoint_setmax(cpConstraint* constraint, cpFloat value);

	void bmx_cppivotjoint_setanchora(cpConstraint* constraint, cpVect* value);

	cpVect* bmx_cpdampedspring_getanchora(cpDampedSpring* dampedspring);
	cpVect* bmx_cpdampedspring_getanchorb(cpDampedSpring* dampedspring);

	cpConstraint* bmx_cpdampedrotaryspring_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat restAngle, cpFloat stiffness, cpFloat damping);

	cpConstraint* bmx_cprotarylimitjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat min, cpFloat max);

	cpConstraint* bmx_cpratchetjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat phase, cpFloat ratchet);

	cpConstraint* bmx_cpgearjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat phase, cpFloat ratio);

	cpConstraint* bmx_cpsimplemotor_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat rate);

	BBObject* bmx_cparbiter_getdata(cpArbiter* arb);
	cpVect* bmx_cparbiter_getnormal(cpArbiter* arb);
	cpVect* bmx_cparbiter_getpointa(cpArbiter* arb, int i);
	cpVect* bmx_cparbiter_getpointb(cpArbiter* arb, int i);
	void bmx_cparbiter_setcontactpointset(cpArbiter* arb, BBArray* set);
	cpVect* bmx_cparbiter_totalimpulse(cpArbiter* arb);
	cpContact* bmx_cparbiter_getcontacts(cpArbiter* arb, int i);

	cpVect* bmx_cpcontact_getr1(cpContact* contact);
	void bmx_cpcontact_setr1(cpContact* contact, cpVect* r1);
	cpVect* bmx_cpcontact_getr2(cpContact* contact);
	void bmx_cpcontact_setr2(cpContact* contact, cpVect* r2);

	void bmx_cptransform_update(cpTransform* transformPtr, cpFloat* a, cpFloat* b, cpFloat* c, cpFloat* d, cpFloat* tx, cpFloat* ty);

	cpSpace* bmx_cphastyspace_new(BBObject* handle);

	// -- above added by Hotcakes --------------------

	cpVect* CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(BBArray* verts, int index);
	BBObject* cpfind(void* obj);
	void cpbind(void* obj, BBObject* peer);
	void CB_PREF(hot_chipmunk_CPPolyShape__setVert)(BBArray* verts, int index, cpVect* vec);
	void CB_PREF(hot_chipmunk_CPContact__setContact)(BBArray* conts, int index, cpContact* contact);
	void CB_PREF(hot_chipmunk_CPBody__velocityFunction)(BBObject* body, cpVect* gravity, cpFloat damping, cpFloat dt);
	void CB_PREF(hot_chipmunk_CPBody__positionFunction)(BBObject* body, cpFloat dt);

	void bmx_velocity_function(cpBody* body, cpVect gravity, cpFloat damping, cpFloat dt);
	void bmx_position_function(cpBody* body, cpFloat dt);

	cpBody* bmx_cpbody_create(BBObject* handle, cpFloat mass, cpFloat inertia);
	cpFloat bmx_cpbody_getmass(cpBody* body);
	cpFloat bmx_cpbody_getinertia(cpBody* body);
	cpFloat bmx_cpbody_getangle(cpBody* body);
	cpFloat bmx_cpbody_getangularvelocity(cpBody* body);
	cpFloat bmx_cpbody_gettorque(cpBody* body);
	void bmx_cpbody_setposition(cpBody* body, cpVect* vec);
	cpVect* bmx_cpbody_getposition(cpBody* body);
	cpVect* bmx_cpbody_getrot(cpBody* body);
	void bmx_cpbody_setvelocity(cpBody* body, cpVect* velocity);
	void bmx_cpbody_setangularvelocity(cpBody* body, cpFloat av);
	void bmx_cpbody_setangle(cpBody* body, cpFloat angle);
	void bmx_cpbody_updatevelocity(cpBody* body, cpVect* gravity, cpFloat damping, cpFloat dt);
	void bmx_cpbody_applyforce(cpBody* body, cpVect* force, cpVect* offset);
	cpVect* bmx_cpbody_local2world(cpBody* body, cpVect* vec);
	cpVect* bmx_cpbody_world2local(cpBody* body, cpVect* vec);
	cpVect* bmx_cpbody_getvelocity(cpBody* body);
	void bmx_body_applyimpulse(cpBody* body, cpVect* impulse, cpVect* offset);
	void bmx_body_slew(cpBody* body, cpVect* pos, cpFloat dt);
	void bmx_cpbody_settorque(cpBody* body, cpFloat torque);
	void bmx_cpbody_posfunc(cpBody* body, cpBodyPositionFunc func);
	void bmx_cpbody_velfunc(cpBody* body, cpBodyVelocityFunc func);
	void bmx_cpbody_setdata(cpBody* body, BBObject* data);
	BBObject* bmx_cpbody_getdata(cpBody* body);

	cpSpace* bmx_cpspace_create(BBObject* handle);
	void bmx_cpspace_setgravity(cpSpace* space, cpVect* vec);
	void bmx_cpspace_addstaticshape(cpSpace* space, cpShape* shape);
	void bmx_cpspace_addbody(cpSpace* space, cpBody* body);
	void bmx_cpspace_addshape(cpSpace* space, cpShape* shape);
	cpArray* bmx_cpspace_getactiveshapes(cpSpace* space);
	cpArray* bmx_cpspace_getstaticshapes(cpSpace* space);
	void bmx_cpspace_setiterations(cpSpace* space, int num);
	void bmx_cpspace_addconstraint(cpSpace* space, cpConstraint* joint);
	void bmx_cpspace_addcollisionpairfunc(cpSpace* space, unsigned long a, unsigned long b, cpCollisionBeginFunc func, void* data,
		cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc);
	void bmx_cpspace_addcollisionpairnullfunc(cpSpace* space, unsigned long a, unsigned long b);
	void bmx_cpspace_removecollisionpairfunc(cpSpace* space, unsigned long a, unsigned long b, cpCollisionBeginFunc beginFunc,
		cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc);
	void bmx_cpspace_setdefaultcollisionpairfunc(cpSpace* space, cpCollisionBeginFunc func, void* data,
		cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc);
	void bmx_cpspace_setdamping(cpSpace* space, cpFloat damping);

	cpVect* bmx_cpvect_create(cpFloat x, cpFloat y);
	void bmx_cpvect_delete(cpVect* vec);
	cpVect* bmx_cpvect_new(cpVect v);
	cpFloat bmx_cpvect_getx(cpVect* vec);
	cpFloat bmx_cpvect_gety(cpVect* vec);
	cpVect* bmx_cpvect_add(cpVect* vec, cpVect* vec2);
	cpVect* bmx_cpvect_sub(cpVect* vec, cpVect* vec2);
	cpVect* bmx_cpvect_rotate(cpVect* vec, cpVect* vec2);
	void bmx_cpvect_getxy(cpVect* vec, cpFloat* x, cpFloat* y);
	cpVect* bmx_cpvect_negate(cpVect* vec);
	cpVect* bmx_cpvect_mult(cpVect* vec, cpFloat scalar);
	cpFloat bmx_cpvect_dot(cpVect* vec, cpVect* vec1);
	cpFloat bmx_cpvect_cross(cpVect* vec, cpVect* vec1);
	cpVect* bmx_cpvect_perp(cpVect* vec);
	cpVect* bmx_cpvect_project(cpVect* vec, cpVect* vec1);
	cpVect* bmx_cpvect_unrotate(cpVect* vec, cpVect* vec1);
	cpFloat bmx_cpvect_length(cpVect* vec);
	cpFloat bmx_cpvect_lengthsq(cpVect* vec);
	cpVect* bmx_cpvect_normalize(cpVect* vec);
	cpFloat bmx_cpvect_toangle(cpVect* vec);
	cpVect* bmx_cpvect_cpvzero();
	cpVect* bmx_cpvect_fromvect(cpVect vect);

	cpShape* bmx_cpsegmentshape_create(BBObject* handle, cpBody* body, cpVect* a, cpVect* b, cpFloat radius);
	cpVect* bmx_cpsegmentshape_getendpointa(cpSegmentShape* shape);
	cpVect* bmx_cpsegmentshape_getendpointb(cpSegmentShape* shape);
	cpVect* bmx_cpsegmentshape_getnormal(cpSegmentShape* shape);

	void bmx_cpshape_setelasticity(cpShape* shape, cpFloat e);
	void bmx_cpshape_setfriction(cpShape* shape, cpFloat u);
	void bmx_cpshape_setcollisiontype(cpShape* shape, cpCollisionType type);
	cpBody* bmx_cpshape_getbody(cpShape* shape);
	void bmx_cpshape_setgroup(cpShape* shape, unsigned long group);
	void bmx_cpshape_setlayers(cpShape* shape, unsigned long layers);
	void bmx_cpshape_setsurfacevelocity(cpShape* shape, cpVect* velocity);
	cpVect* bmx_cpshape_getsurfacevelocity(cpShape* shape);
	cpFloat bmx_cpshape_getelasticity(cpShape* shape);
	cpFloat bmx_cpshape_getfriction(cpShape* shape);
	cpBB* bmx_cpshape_cachebb(cpShape* shape);
	void bmx_cpshape_setdata(cpShape* shape, BBObject* data);
	BBObject* bmx_cpshape_getdata(cpShape* shape);

	cpFloat bmx_momentforpoly(cpFloat m, BBArray* verts, int count, cpVect* offset, cpFloat radius);
	cpFloat bmx_momentforcircle(cpFloat m, cpFloat r1, cpFloat r2, cpVect* offset);
	cpConstraint* bmx_cpdampedspring(BBObject* handle, cpBody* a, cpBody* b, cpVect* anchor1, cpVect* anchor2, cpFloat rlen, cpFloat k, cpFloat dmp, cpFloat dt);

	BBArray* bmx_cppolyshape_getvertsascoords(cpPolyShape* shape);
	int bmx_cppolyshape_numverts(cpPolyShape* shape);
	void bmx_cppolyshape_getverts(cpPolyShape* shape, BBArray* verts);

	cpShape* bmx_cppolyshape_create(BBObject* handle, cpBody* body, BBArray* verts, int count, cpVect* offset, cpFloat radius);

	cpShape* bmx_cpcircleshape_create(BBObject* handle, cpBody* body, cpFloat radius, cpVect* offset);
	cpFloat bmx_cpcircleshape_getradius(cpCircleShape* shape);
	cpVect* bmx_cpcircleshape_getcenter(cpCircleShape* shape);
	cpVect* bmx_cpcircleshape_gettransformedcenter(cpCircleShape* shape);

	cpConstraint* bmx_cppinjoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* anchor1, cpVect* anchor2);
	cpConstraint* bmx_cpslidejoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* anchor1, cpVect* anchor2, cpFloat minDist, cpFloat maxDist);
	cpConstraint* bmx_cppivotjoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* pivot, cpVect* anchorB);
	cpConstraint* bmx_cpgroovejoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* grooveA, cpVect* grooveB, cpVect* anchor);

	unsigned int bmx_CP_HASH_PAIR(int collTypeA, int collTypeB);

	cpVect* bmx_cpcontact_getposition(cpContact* contact);
	cpVect* bmx_cpcontact_getnormal(cpContact* contact);
	cpFloat bmx_cpcontact_getdistance(cpContact* contact);
	cpFloat bmx_cpcontact_getjnacc(cpContact* contact);
	cpFloat bmx_cpcontact_getjtacc(cpContact* contact);
	void bmx_cpcontact_fill(BBArray* conts, cpContact* contacts, int numContacts);

	cpBB* bmx_cpbb_create(cpFloat l, cpFloat b, cpFloat r, cpFloat t);
	int bmx_cpbb_intersects(cpBB* bb, cpBB* other);
	int bmx_cpbb_containsbb(cpBB* bb, cpBB* other);
	int bmx_cpbb_containsvect(cpBB* bb, cpVect* v);
	cpVect* bmx_cpbb_clampvect(cpBB* bb, cpVect* v);
	cpVect* bmx_cpbb_wrapvect(cpBB* bb, cpVect* v);
	void bmx_cpbb_delete(cpBB* bb);

	cpVect* bmx_cppinjoint_getanchor1(cpPinJoint* joint);
	cpVect* bmx_cppinjoint_getanchor2(cpPinJoint* joint);

	cpVect* bmx_cpslidejoint_getanchor1(cpSlideJoint* joint);
	cpVect* bmx_cpslidejoint_getanchor2(cpSlideJoint* joint);
	cpFloat bmx_cpslidejoint_getmindist(cpSlideJoint* joint);
	cpFloat bmx_cpslidejoint_getmaxdist(cpSlideJoint* joint);

	cpVect* bmx_cppivotjoint_getanchor1(cpPivotJoint* joint);
	cpVect* bmx_cppivotjoint_getanchor2(cpPivotJoint* joint);

	cpVect* bmx_cpgroovejoint_getgroovea(cpGrooveJoint* joint);
	cpVect* bmx_cpgroovejoint_getgrooveb(cpGrooveJoint* joint);
	cpVect* bmx_cpgroovejoint_getanchor(cpGrooveJoint* joint);

	cpBody* bmx_cpconstraint_getbodya(cpConstraint* joint);
	cpBody* bmx_cpconstraint_getbodyb(cpConstraint* joint);
}

unsigned int bmx_CP_HASH_PAIR(int collTypeA, int collTypeB) {
	return CP_HASH_PAIR(collTypeA, collTypeB);
}


typedef std::map<void*, BBObject*> PeerMap;

static PeerMap peerMap;

void cpbind(void* obj, BBObject* peer) {
	if (!obj || peer == &bbNullObject) return;
	if (cpfind(obj) == &bbNullObject) {
		peerMap.insert(std::make_pair(obj, peer));
		BBRETAIN(peer);
	}
}

BBObject* cpfind(void* obj) {
	if (!obj) return &bbNullObject;
	PeerMap::iterator it = peerMap.find(obj);
	if (it != peerMap.end()) return it->second;
	return &bbNullObject;
}

void cpunbind(void* obj) {
	BBObject* peer = cpfind(obj);
	if (peer != &bbNullObject) {
		peerMap.erase(obj);
		BBRELEASE(peer);
	}
}

BBArray* vertsToBBDoubleArray(int num, cpVect* verts) {
	BBArray* p = bbArrayNew1D("d", num * 2);
	cpFloat* s = (cpFloat*)BBARRAYDATA(p, p->dims);
	for (int i = 0;i < num;++i) {
		s[i * 2] = verts[i].x;
		s[i * 2 + 1] = verts[i].y;
	}
	return p;
}

// -------------------------------------------------

cpBody* bmx_cpbody_create(BBObject* handle, cpFloat mass, cpFloat inertia) {
	cpBody* body;
	if (mass == INFINITY) {
		// Create a static body if mass is infinite
		body = cpBodyNewStatic();
	}
	else {
		body = cpBodyNew(mass, inertia);
	}
	cpbind(body, handle);
	return body;
}

cpFloat bmx_cpbody_getmass(cpBody* body) {
	return body->m;
}

cpFloat bmx_cpbody_getinertia(cpBody* body) {
	return body->i;
}

cpFloat bmx_cpbody_getangle(cpBody* body) {
	return body->a * 57.2957795f;
}

void bmx_cpbody_setangle(cpBody* body, cpFloat angle) {
	cpBodySetAngle(body, angle / 57.2957795f);
}

cpFloat bmx_cpbody_getangularvelocity(cpBody* body) {
	return body->w;
}

cpFloat bmx_cpbody_gettorque(cpBody* body) {
	return body->t;
}

void bmx_cpbody_setposition(cpBody* body, cpVect* vec) {
	body->p = *vec;
}

cpVect* bmx_cpbody_getposition(cpBody* body) {
	return bmx_cpvect_new(body->p);
}

cpVect* bmx_cpbody_getrot(cpBody* body) {
	return bmx_cpvect_new(cpBodyGetRotation(body));
}

void bmx_cpbody_setvelocity(cpBody* body, cpVect* velocity) {
	body->v = *velocity;
}

void bmx_cpbody_setangularvelocity(cpBody* body, cpFloat av) {
	body->w = av;
}

void bmx_cpbody_updatevelocity(cpBody* body, cpVect* gravity, cpFloat damping, cpFloat dt) {
	cpBodyUpdateVelocity(body, *gravity, damping, dt);
}

void bmx_cpbody_applyforce(cpBody* body, cpVect* force, cpVect* offset) {
	// Calculate the world point to apply the force
	cpVect worldPoint = cpvadd(cpBodyGetPosition(body), *offset);

	// Apply the force at the calculated world point
	cpBodyApplyForceAtWorldPoint(body, *force, worldPoint);
}

cpVect* bmx_cpbody_local2world(cpBody* body, cpVect* vec) {
	return bmx_cpvect_new(cpBodyLocalToWorld(body, *vec));
}

cpVect* bmx_cpbody_world2local(cpBody* body, cpVect* vec) {
	return bmx_cpvect_new(cpBodyWorldToLocal(body, *vec));
}

cpVect* bmx_cpbody_getvelocity(cpBody* body) {
	return bmx_cpvect_new(body->v);
}

void bmx_body_applyimpulse(cpBody* body, cpVect* impulse, cpVect* offset) {
	// Calculate the world point to apply the impulse
	cpVect worldPoint = cpvadd(cpBodyGetPosition(body), *offset);

	// Apply the impulse at the calculated world point
	cpBodyApplyImpulseAtWorldPoint(body, *impulse, worldPoint);
}

void bmx_body_slew(cpBody* body, cpVect* pos, cpFloat dt) {
	// Check if pointer is valid
	if (!pos) {
		return;  // Avoid potential crash with null pointer
	}

	// Get current position
	cpVect current_pos = cpBodyGetPosition(body);

	// Calculate desired delta position
	cpVect desired_delta = cpvsub(*pos, current_pos);

	// Set the body's velocity to reach the desired position in dt
	cpBodySetVelocity(body, cpvmult(desired_delta, 1.0f / dt));
}

void bmx_cpbody_settorque(cpBody* body, cpFloat torque) {
	body->t = torque;
}

void bmx_cpbody_posfunc(cpBody* body, cpBodyPositionFunc func) {
	body->position_func = func;
}

void bmx_cpbody_velfunc(cpBody* body, cpBodyVelocityFunc  func) {
	body->velocity_func = func;
}

void bmx_velocity_function(cpBody* body, cpVect gravity, cpFloat damping, cpFloat dt) {
	return CB_PREF(hot_chipmunk_CPBody__velocityFunction)(cpfind(body), bmx_cpvect_new(gravity), damping, dt);
}

void bmx_position_function(cpBody* body, cpFloat dt) {
	return CB_PREF(hot_chipmunk_CPBody__positionFunction)(cpfind(body), dt);
}


void bmx_cpbody_setdata(cpBody* body, BBObject* data) {
	cpBodySetUserData(body, data);
}

BBObject* bmx_cpbody_getdata(cpBody* body) {
	cpDataPointer userData = cpBodyGetUserData(body);
	if (userData) {
		return (BBObject*)userData;
	}
	else {
		return &bbNullObject;
	}
}

// -------------------------------------------------

cpSpace* bmx_cpspace_create(BBObject* handle) {
	cpSpace* space = cpSpaceNew();
	cpbind(space, handle);
	return space;
}

void bmx_cpspace_setgravity(cpSpace* space, cpVect* vec) {
	space->gravity = *vec;
}

void bmx_cpspace_addstaticshape(cpSpace* space, cpShape* shape) {
	cpSpaceAddShape(space, shape);
}

void bmx_cpspace_addbody(cpSpace* space, cpBody* body) {
	cpSpaceAddBody(space, body);
}

void bmx_cpspace_addshape(cpSpace* space, cpShape* shape) {
	cpSpaceAddShape(space, shape);
}

// Define functions to get active shapes and static shapes from the space
cpArray* bmx_cpspace_getactiveshapes(cpSpace* space) {
	return (cpArray*)space->dynamicShapes;
}

cpArray* bmx_cpspace_getstaticshapes(cpSpace* space) {
	return (cpArray*)space->staticShapes;
}

void bmx_cpspace_setiterations(cpSpace* space, int num) {
	space->iterations = num;
}

void bmx_cpspace_addconstraint(cpSpace* space, cpConstraint* constraint) {
	cpSpaceAddConstraint(space, constraint);
}

void bmx_cpspace_addcollisionpairfunc(cpSpace* space, unsigned long a, unsigned long b, cpCollisionBeginFunc beginFunc, cpDataPointer data,
	cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc)
{
	// Get or create a collision handler for the given collision types
	cpCollisionHandler* handler = cpSpaceAddCollisionHandler(space, a, b);

	// Set the callback functions and user data for the collision handler
	handler->beginFunc = beginFunc;
	handler->preSolveFunc = preSolveFunc;
	handler->postSolveFunc = postSolveFunc;
	handler->separateFunc = separateFunc;
	handler->userData = data;
}

void bmx_cpspace_addcollisionpairnullfunc(cpSpace* space, unsigned long a, unsigned long b)
{
	cpSpaceAddCollisionHandler(space, a, b);
}

void bmx_cpspace_removecollisionpairfunc(cpSpace* space, unsigned long a, unsigned long b, cpCollisionBeginFunc beginFunc,
	cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc) {
	cpCollisionHandler* handler = cpSpaceAddCollisionHandler(space, a, b);
	handler->beginFunc = beginFunc;
	handler->preSolveFunc = preSolveFunc;
	handler->postSolveFunc = postSolveFunc;
	handler->separateFunc = separateFunc;
	handler->userData = NULL;
}

void bmx_cpspace_setdefaultcollisionpairfunc(cpSpace* space, cpCollisionBeginFunc beginFunc, cpDataPointer data,
	cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc)
{
	cpCollisionHandler* handler = cpSpaceAddDefaultCollisionHandler(space);
	handler->beginFunc = beginFunc;
	handler->preSolveFunc = preSolveFunc;
	handler->postSolveFunc = postSolveFunc;
	handler->separateFunc = separateFunc;
	handler->userData = data;
}

void bmx_cpspace_setdamping(cpSpace* space, cpFloat damping)
{
	space->damping = damping;
}

// -------------------------------------------------

cpVect* bmx_cpvect_create(cpFloat x, cpFloat y) {

	cpVect* vec = new cpVect;
	vec->x = x;
	vec->y = y;
	return vec;
}

cpVect* bmx_cpvect_new(cpVect v) {
	cpVect* vec = new cpVect;
	vec->x = v.x;
	vec->y = v.y;
	return vec;
}

void bmx_cpvect_delete(cpVect* vec) {
	delete vec;
}

cpFloat bmx_cpvect_getx(cpVect* vec) {
	return vec->x;
}

cpFloat bmx_cpvect_gety(cpVect* vec) {
	return vec->y;
}

cpVect* bmx_cpvect_add(cpVect* vec, cpVect* vec2) {
	return bmx_cpvect_new(cpvadd(*vec, *vec2));
}

cpVect* bmx_cpvect_sub(cpVect* vec, cpVect* vec2) {
	return bmx_cpvect_new(cpvsub(*vec, *vec2));
}

cpVect* bmx_cpvect_rotate(cpVect* vec, cpVect* vec2) {
	return bmx_cpvect_new(cpvrotate(*vec, *vec2));
}

void bmx_cpvect_getxy(cpVect* vec, cpFloat* x, cpFloat* y) {
	*x = vec->x;
	*y = vec->y;
}

cpVect* bmx_cpvect_negate(cpVect* vec) {
	return bmx_cpvect_new(cpvneg(*vec));
}

cpVect* bmx_cpvect_mult(cpVect* vec, cpFloat scalar) {
	return bmx_cpvect_new(cpvmult(*vec, scalar));
}

cpFloat bmx_cpvect_dot(cpVect* vec, cpVect* vec1) {
	return cpvdot(*vec, *vec1);
}

cpFloat bmx_cpvect_cross(cpVect* vec, cpVect* vec1) {
	return cpvcross(*vec, *vec1);
}

cpVect* bmx_cpvect_perp(cpVect* vec) {
	return bmx_cpvect_new(cpvperp(*vec));
}

cpVect* bmx_cpvect_project(cpVect* vec, cpVect* vec1) {
	return bmx_cpvect_new(cpvproject(*vec, *vec1));
}

cpVect* bmx_cpvect_unrotate(cpVect* vec, cpVect* vec1) {
	return bmx_cpvect_new(cpvunrotate(*vec, *vec1));
}

cpFloat bmx_cpvect_length(cpVect* vec) {
	return cpvlength(*vec);
}

cpFloat bmx_cpvect_lengthsq(cpVect* vec)
{
	return cpvlengthsq(*vec);
}

cpVect* bmx_cpvect_normalize(cpVect* vec) {
	return bmx_cpvect_new(cpvnormalize(*vec));
}

cpFloat bmx_cpvect_toangle(cpVect* vec) {
	return cpvtoangle(*vec);
}

cpVect* bmx_cpvect_cpvzero() {
	return bmx_cpvect_new(cpvzero);
}

cpVect* bmx_cpvect_fromvect(cpVect vect) {
	return bmx_cpvect_new(vect);
}

// -------------------------------------------------

cpShape* bmx_cpsegmentshape_create(BBObject* handle, cpBody* body, cpVect* a, cpVect* b, cpFloat radius) {
	cpShape* shape = cpSegmentShapeNew(body, *a, *b, radius);
	cpbind(shape, handle);
	return shape;
}

cpVect* bmx_cpsegmentshape_getendpointa(cpSegmentShape* shape) {
	return bmx_cpvect_new(shape->a);
}

cpVect* bmx_cpsegmentshape_getendpointb(cpSegmentShape* shape) {
	return bmx_cpvect_new(shape->b);
}

cpVect* bmx_cpsegmentshape_getnormal(cpSegmentShape* shape) {
	return bmx_cpvect_new(shape->n);
}

// -------------------------------------------------

cpBB* bmx_cpbb_new(cpBB bb) {
	cpBB* bbox = new cpBB;
	bbox->l = bb.l;
	bbox->t = bb.t;
	bbox->r = bb.r;
	bbox->b = bb.b;
	return bbox;
}

void bmx_cpbb_delete(cpBB* bb) {
	delete bb;
}


cpBB* bmx_cpbb_create(cpFloat l, cpFloat b, cpFloat r, cpFloat t) {
	cpBB* bbox = new cpBB;
	bbox->l = l;
	bbox->t = t;
	bbox->r = r;
	bbox->b = b;
	return bbox;
}

int bmx_cpbb_intersects(cpBB* bb, cpBB* other) {
	return cpBBIntersects(*bb, *other);
}

int bmx_cpbb_containsbb(cpBB* bb, cpBB* other) {
	return cpBBContainsBB(*bb, *other);
}

int bmx_cpbb_containsvect(cpBB* bb, cpVect* v) {
	return cpBBContainsVect(*bb, *v);
}

cpVect* bmx_cpbb_clampvect(cpBB* bb, cpVect* v) {
	return bmx_cpvect_new(cpBBClampVect(*bb, *v));
}

cpVect* bmx_cpbb_wrapvect(cpBB* bb, cpVect* v) {
	return bmx_cpvect_new(cpBBWrapVect(*bb, *v));
}

// -------------------------------------------------

void bmx_cpshape_setelasticity(cpShape* shape, cpFloat e) {
	shape->e = e;
}

void bmx_cpshape_setfriction(cpShape* shape, cpFloat u) {
	shape->u = u;
}

void bmx_cpshape_setcollisiontype(cpShape* shape, cpCollisionType type)
{
	cpShapeSetCollisionType(shape, (cpCollisionType)type);
}

cpBody* bmx_cpshape_getbody(cpShape* shape) {
	return shape->body;
}

void bmx_cpshape_setgroup(cpShape* shape, unsigned long group) {
	cpShapeFilter filter = cpShapeGetFilter(shape);
	filter.group = (cpGroup)group;
	cpShapeSetFilter(shape, filter);
}

void bmx_cpshape_setlayers(cpShape* shape, unsigned long layers) {
	cpShapeFilter filter = cpShapeGetFilter(shape);
	filter.categories = (cpBitmask)layers;
	cpShapeSetFilter(shape, filter);
}

void bmx_cpshape_setsurfacevelocity(cpShape* shape, cpVect* velocity) {
	cpShapeSetSurfaceVelocity(shape, *velocity);
}

cpVect* bmx_cpshape_getsurfacevelocity(cpShape* shape) {
	cpVect* velocity = bmx_cpvect_new(shape->surfaceV);
	return velocity;
}

cpFloat bmx_cpshape_getelasticity(cpShape* shape) {
	return shape->e;
}

cpFloat bmx_cpshape_getfriction(cpShape* shape) {
	return shape->u;
}

cpBB* bmx_cpshape_cachebb(cpShape* shape) {
	return bmx_cpbb_new(cpShapeCacheBB(shape));
}

// Function to set custom data for a cpShape
void bmx_cpshape_setdata(cpShape* shape, BBObject* data) {
	cpShapeSetUserData(shape, reinterpret_cast<cpDataPointer>(data));
}

BBObject* bmx_cpshape_getdata(cpShape* shape) {
	if (shape) {
		cpDataPointer userData = cpShapeGetUserData(shape);
		if (userData) {
			return reinterpret_cast<BBObject*>(userData);
		}
	}
	return &bbNullObject;
}

// -------------------------------------------------

cpFloat bmx_momentforpoly(cpFloat m, BBArray* verts, int count, cpVect* offset, cpFloat radius) {
	cpVect tVerts[count];
	for (int i = 0; i < count; i++) {
		tVerts[i] = *CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(verts, i);
	}
	return cpMomentForPoly(m, count, tVerts, *offset, radius);
}

cpFloat bmx_momentforcircle(cpFloat m, cpFloat r1, cpFloat r2, cpVect* offset) {
	return cpMomentForCircle(m, r1, r2, *offset);
}

cpConstraint* bmx_cpdampedspring(BBObject* handle, cpBody* a, cpBody* b, cpVect* anchor1, cpVect* anchor2, cpFloat rlen, cpFloat k, cpFloat dmp, cpFloat dt) {
	cpConstraint* dampedspring = cpDampedSpringNew(a, b, *anchor1, *anchor2, rlen, k, dmp);
	cpbind(dampedspring, handle);
	return dampedspring;
}

// -------------------------------------------------

cpShape* bmx_cppolyshape_create(BBObject* handle, cpBody* body, BBArray* verts, int count, cpVect* offset, cpFloat radius) {
	cpVect tVerts[count];
	for (int i = 0; i < count; i++)
	{
		// Apply the offset to each vertex
		tVerts[i] = cpvadd(*offset, *CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(verts, i));
	}
	cpShape* shape = cpPolyShapeNew(body, count, tVerts, cpTransformIdentity, radius);
	cpbind(shape, handle);
	return shape;
}

BBArray* bmx_cppolyshape_getvertsascoords(cpPolyShape* shape) {
	int numVerts = cpPolyShapeGetCount((cpShape*)shape);
	int numCoords = numVerts * 2; // Two coordinates (x, y) for each vertex
	BBArray* result = bbArrayNew1D("d", numCoords);

	// Access the data pointer of the result array
	double* data = (double*)BBARRAYDATA(result, numCoords);

	for (int i = 0; i < numVerts; ++i) {
		cpVect vert = cpPolyShapeGetVert((cpShape*)shape, i);
		// Populate the result array with vertex coordinates
		data[i * 2] = vert.x;
		data[i * 2 + 1] = vert.y;
	}

	return result;
}

int bmx_cppolyshape_numverts(cpPolyShape* shape) {
	return cpPolyShapeGetCount((cpShape*)shape);
}

void bmx_cppolyshape_getverts(cpPolyShape* shape, BBArray* verts) {
	int numVerts = cpPolyShapeGetCount((cpShape*)shape);
	for (int i = 0; i < numVerts; ++i) {
		cpVect vert = cpPolyShapeGetVert((cpShape*)shape, i);
		CB_PREF(hot_chipmunk_CPPolyShape__setVert)(verts, i, bmx_cpvect_new(vert));
	}
}

// -------------------------------------------------

cpShape* bmx_cpcircleshape_create(BBObject* handle, cpBody* body, cpFloat radius, cpVect* offset) {
	cpShape* shape = cpCircleShapeNew(body, radius, *offset);
	cpbind(shape, handle);
	return shape;
}

cpFloat bmx_cpcircleshape_getradius(cpCircleShape* shape) {
	return shape->r;
}

cpVect* bmx_cpcircleshape_getcenter(cpCircleShape* shape) {
	return bmx_cpvect_new(shape->c);
}

cpVect* bmx_cpcircleshape_gettransformedcenter(cpCircleShape* shape) {
	return bmx_cpvect_new(shape->tc);
}


// -------------------------------------------------

cpConstraint* bmx_cppinjoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* anchor1, cpVect* anchor2) {
	cpConstraint* joint = cpPinJointNew(bodyA, bodyB, *anchor1, *anchor2);
	cpbind(joint, handle);
	return joint;
}

cpVect* bmx_cppinjoint_getanchor1(cpPinJoint* joint) {
	return bmx_cpvect_new(cpPinJointGetAnchorA((cpConstraint*)joint));
}

cpVect* bmx_cppinjoint_getanchor2(cpPinJoint* joint) {
	return bmx_cpvect_new(cpPinJointGetAnchorB((cpConstraint*)joint));
}

// -------------------------------------------------

cpConstraint* bmx_cpslidejoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* anchor1, cpVect* anchor2, cpFloat minDist, cpFloat maxDist) {
	cpConstraint* joint = cpSlideJointNew(bodyA, bodyB, *anchor1, *anchor2, minDist, maxDist);
	cpbind(joint, handle);
	return joint;
}

cpVect* bmx_cpslidejoint_getanchor1(cpSlideJoint* joint) {
	return bmx_cpvect_new(cpSlideJointGetAnchorA((cpConstraint*)joint));
}

cpVect* bmx_cpslidejoint_getanchor2(cpSlideJoint* joint) {
	return bmx_cpvect_new(cpSlideJointGetAnchorB((cpConstraint*)joint));
}

cpFloat bmx_cpslidejoint_getmindist(cpSlideJoint* joint) {
	return joint->min;
}

cpFloat bmx_cpslidejoint_getmaxdist(cpSlideJoint* joint) {
	return joint->max;
}

// -------------------------------------------------

cpConstraint* bmx_cppivotjoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* pivot, cpVect* anchorB)
{
	if (anchorB != NULL)
	{
		cpConstraint* joint = cpPivotJointNew2(bodyA, bodyB, *pivot, *anchorB);
		cpbind(joint, handle);
		return joint;
	}
	else
	{
		cpConstraint* joint = cpPivotJointNew(bodyA, bodyB, *pivot);
		cpbind(joint, handle);
		return joint;
	}
}

cpVect* bmx_cppivotjoint_getanchor1(cpPivotJoint* joint) {
	return bmx_cpvect_new(cpPivotJointGetAnchorA((cpConstraint*)joint));
}

cpVect* bmx_cppivotjoint_getanchor2(cpPivotJoint* joint) {
	return bmx_cpvect_new(cpPivotJointGetAnchorB((cpConstraint*)joint));
}

// -------------------------------------------------

cpConstraint* bmx_cpgroovejoint_create(BBObject* handle, cpBody* bodyA, cpBody* bodyB, cpVect* grooveA, cpVect* grooveB, cpVect* anchor) {
	cpConstraint* joint = cpGrooveJointNew(bodyA, bodyB, *grooveA, *grooveB, *anchor);
	cpbind(joint, handle);
	return joint;
}

cpVect* bmx_cpgroovejoint_getgroovea(cpGrooveJoint* joint) {
	return bmx_cpvect_new(joint->grv_a);
}

cpVect* bmx_cpgroovejoint_getgrooveb(cpGrooveJoint* joint) {
	return bmx_cpvect_new(joint->grv_b);
}

cpVect* bmx_cpgroovejoint_getanchor(cpGrooveJoint* joint) {
	return bmx_cpvect_new(joint->anchorB);
}

// -------------------------------------------------

cpBody* bmx_cpconstraint_getbodya(cpConstraint* joint) {
	return joint->a;
}

cpBody* bmx_cpconstraint_getbodyb(cpConstraint* joint) {
	return joint->b;
}

// -------------------------------------------------

cpVect* bmx_cpcontact_getposition(cpContact* contact) {
	// Calculate the average position of the two bodies involved in the contact.
	cpVect position = cpvmult(cpvadd(contact->r1, contact->r2), 0.5);
	return bmx_cpvect_new(position);
}

cpVect* bmx_cpcontact_getnormal(cpContact* contact) {
	// Calculate the normal vector
	cpVect normal = cpvsub(contact->r2, contact->r1);

	// Normalize the normal vector
	cpVect normalizedNormal = cpvnormalize(normal);

	// Return the normalized normal vector
	return bmx_cpvect_new(normalizedNormal);
}

cpFloat bmx_cpcontact_getdistance(cpContact* contact) {
	return cpvlength(cpv(contact->r1.x - contact->r2.x, contact->r1.y - contact->r2.y));
}

cpFloat bmx_cpcontact_getjnacc(cpContact* contact) {
	return contact->jnAcc;
}

cpFloat bmx_cpcontact_getjtacc(cpContact* contact) {
	return contact->jtAcc;
}

void bmx_cpcontact_fill(BBArray* conts, cpContact* contacts, int numContacts) {
	for (int i = 0; i < numContacts; i++) {
		CB_PREF(hot_chipmunk_CPContact__setContact)(conts, i, &contacts[i]);
	}
}

// -- below added by Hotcakes ----------------------

cpFloat bmx_cpf_clamp(cpFloat f, cpFloat min, cpFloat max) {
	return cpfclamp(f, min, max);
}

cpFloat bmx_cpf_lerp(cpFloat f1, cpFloat f2, cpFloat t) {
	return cpflerp(f1, f2, t);
}

cpFloat bmx_cpf_lerpconst(cpFloat f1, cpFloat f2, cpFloat d) {
	return cpflerpconst(f1, f2, d);
}

cpVect* bmx_cpvect_rperp(cpVect* vec)
{
	return bmx_cpvect_new(cpvrperp(*vec));
}

cpVect* bmx_cpvect_lerp(cpVect* v1, cpVect* v2, cpFloat t)
{
	return bmx_cpvect_new(cpvlerp(*v1, *v2, t));
}

cpFloat bmx_cpvect_dist(cpVect* v1, cpVect* v2) {
	return cpvdist(*v1, *v2);
}

cpBool bmx_cpvect_near(cpVect* v1, cpVect* v2, cpFloat dist) {
	cpBool volatile result = cpvnear(*v1, *v2, dist);	// if this calculation is being optimised out too early, then how many others are??
	return result;
}

cpVect* bmx_cpvect_forangle(cpFloat a)
{
	return bmx_cpvect_new(cpvforangle(a));
}

void bmx_cpbb_update(cpBB* bbPtr, cpFloat* l, cpFloat* b, cpFloat* r, cpFloat* t)
{
	*l = bbPtr->l;
	*b = bbPtr->b;
	*r = bbPtr->r;
	*t = bbPtr->t;
}

cpBody* bmx_cpbody_createkinematic(BBObject* handle)
{
	cpBody* body;
	body = cpBodyNewKinematic();
	cpbind(body, handle);
	return body;
}

cpVect* bmx_cpbody_getcenterofgravity(cpBody* body) {
	return bmx_cpvect_new(cpBodyGetCenterOfGravity(body));
}

void bmx_cpbody_setforce(cpBody* body, cpVect* value)
{
	cpBodySetForce(body, *value);
}

cpFloat bmx_cpmomentforsegment(cpFloat m, cpVect* a, cpVect* b, cpFloat radius) {
	return cpMomentForSegment(m, *a, *b, radius);
}

cpFloat bmx_cpmomentforbox(cpFloat m, cpFloat width, cpFloat height)
{
	return cpMomentForBox(m, width, height);
}

cpFloat bmx_cpmomentforbox2(cpFloat m, cpBB* box)
{
	return cpMomentForBox2(m, *box);
}

cpFloat bmx_cpareaforpoly(int count, BBArray* verts, cpFloat radius) {
	// Create a temporary array to hold the cpVect vertices
	cpVect tVerts[count];

	// Populate the temporary array with vertices from the BBArray
	for (int i = 0; i < count; ++i) {
		tVerts[i] = *CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(verts, i);
	}

	// Calculate the area for the polygon using the Chipmunk function
	return cpAreaForPoly(count, tVerts, radius);
}

cpVect* bmx_cpbody_velocityatworldpoint(cpBody* body, cpVect* point)
{
	return bmx_cpvect_new(cpBodyGetVelocityAtWorldPoint(body, *point));
}

void bmx_cpbody_applyimpulseatworldpoint(cpBody* body, cpVect* impulse, cpVect* point)
{
	cpBodyApplyImpulseAtWorldPoint(body, *impulse, *point);
}

cpFloat bmx_cpbody_update(cpBody* cpObjectPtr)
{
	return cpObjectPtr->sleeping.idleTime;
}

cpBB* bmx_cpshape_getbb(cpShape* shape) {
	return bmx_cpbb_new(cpShapeGetBB(shape));
}

void bmx_cpshape_setfilter(cpShape* shape, unsigned int filter)
{
	cpShapeFilter mfilter = cpShapeGetFilter(shape);
	mfilter.group = (cpGroup)CP_NO_GROUP;
	mfilter.categories = (cpBitmask)filter;
	mfilter.mask = (cpBitmask)filter;
	cpShapeSetFilter(shape, mfilter);
}

cpVect* bmx_cpcentroidforpoly(int count, BBArray* verts) {
	// Create a temporary array to hold the cpVect vertices
	cpVect tVerts[count];

	// Populate the temporary array with vertices from the BBArray
	for (int i = 0; i < count; ++i) {
		tVerts[i] = *CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(verts, i);
	}

	// Calculate the centroid for the polygon using the Chipmunk function
	return bmx_cpvect_new(cpCentroidForPoly(count, tVerts));
}

cpFloat bmx_cpshape_pointquery(cpShape* shape, cpVect* p, cpPointQueryInfo* out)
{
	return cpShapePointQuery(shape, *p, NULL);
}

cpHashValue bmx_cpshape_update(cpShape* cpObjectPtr)
{
	return cpObjectPtr->hashid;
}

cpVect* bmx_cpcircleshape_getoffset(cpShape* circleShape)
{
	return bmx_cpvect_new(cpCircleShapeGetOffset(circleShape));
}

void bmx_cpsegmentshapesetneighbors(cpShape* shape, cpVect* prev, cpVect* next)
{
	cpSegmentShapeSetNeighbors(shape, *prev, *next);
}

cpShape* bmx_cpboxshape_create(BBObject* handle, cpBody* body, cpFloat width, cpFloat height, cpFloat radius)
{
	cpShape* shape = cpBoxShapeNew(body, width, height, radius);
	cpbind(shape, handle);
	return shape;
}

cpShape* bmx_cpboxshape_create2(BBObject* handle, cpBody* body, cpBB* box, cpFloat radius)
{
	cpShape* shape = cpBoxShapeNew2(body, *box, radius);
	cpbind(shape, handle);
	return shape;
}

int bmx_cpconvexhull(int count, BBArray* verts, BBArray* result, int* first, cpFloat tol) {
	// Convert BBArray to cpVect array
	cpVect tVerts[count];
	for (int i = 0; i < count; ++i) {
		tVerts[i] = *CB_PREF(hot_chipmunk_CPVect__getVectForIndex)(verts, i);
	}

	// Call cpConvexHull
	int hullCount = cpConvexHull(count, tVerts, tVerts, first, tol);

	// Convert cpVect array to BBArray
	for (int i = 0; i < hullCount; ++i) {
		cpVect vert = tVerts[i];
		CB_PREF(hot_chipmunk_CPPolyShape__setVert)(result, i, bmx_cpvect_new(vert));
	}

	// Return the count of points in the hull
	return hullCount;
}

cpVect* bmx_cpspace_getgravity(cpSpace* space)
{
	return bmx_cpvect_new(cpSpaceGetGravity(space));
}

cpBody* bmx_cpspace_getstaticbody(BBObject* handle, cpSpace* space)
{
	cpBody* userData = cpSpaceGetStaticBody(space);
	if (userData) {
		cpbind(userData, handle);
		return userData;
	}
	else {
		return NULL;
	}
}

void bmx_cpspace_addwildcardfunc(cpSpace* space, unsigned long type, cpCollisionBeginFunc beginFunc, cpDataPointer data,
	cpCollisionPreSolveFunc preSolveFunc, cpCollisionPostSolveFunc postSolveFunc, cpCollisionSeparateFunc separateFunc)
{
	// Get or create a collision handler for the given collision types
	cpCollisionHandler* handler = cpSpaceAddWildcardHandler(space, type);

	// Set the callback functions and user data for the collision handler
	handler->beginFunc = beginFunc;
	handler->preSolveFunc = preSolveFunc;
	handler->postSolveFunc = postSolveFunc;
	handler->separateFunc = separateFunc;
	handler->userData = data;
}

cpBool bmx_cpspace_addpoststepcallback(cpSpace* space, cpPostStepFunc func, void* key, void* data)
{
	return cpSpaceAddPostStepCallback(space, func, key, data);
}

cpShape* bmx_cpspace_pointquerynearest(cpSpace* space, cpVect* point, cpFloat maxDistance, unsigned int filter, cpPointQueryInfo* out)
{
	cpShapeFilter mfilter;
	mfilter.group = (cpGroup)CP_NO_GROUP;
	mfilter.categories = (cpBitmask)filter;
	mfilter.mask = (cpBitmask)filter;

	// Perform the point query in the Chipmunk space
	cpPointQueryInfo info;
	cpShape* nearestShape = cpSpacePointQueryNearest(space, *point, maxDistance, mfilter, NULL); //&info);

	// Check if the nearest shape is found
		/*	if (nearestShape != NULL)
			{
				// Write values directly to the 'out' parameter using explicit offsets
				*((cpSpace **)&out[0]) = (cpSpace *)info.shape;
				*((cpFloat *)&out[sizeof(cpSpace *)]) = (cpFloat)info.point.x;
				*((cpFloat *)&out[sizeof(cpSpace *) + sizeof(cpFloat)]) = (cpFloat)info.point.y;
				*((cpFloat *)&out[sizeof(cpSpace *) + 2 * sizeof(cpFloat)]) = (cpFloat)info.distance;
				*((cpFloat *)&out[sizeof(cpSpace *) + 3 * sizeof(cpFloat)]) = (cpFloat)info.gradient.x;
				*((cpFloat *)&out[sizeof(cpSpace *) + 4 * sizeof(cpFloat)]) = (cpFloat)info.gradient.y;
			}
			else
			{
				// If no nearest shape found, set all fields to zero
				memset(out, 0, sizeof(cpPointQueryInfo));
			}
		*/
	return nearestShape;
}

void bmx_cpspace_segmentqueryfunc(cpShape* shape, cpVect point, cpVect normal, cpFloat alpha, void* data) {
	CB_PREF(hot_chipmunk_CPSpace__segmenthashCallback)(shape, bmx_cpvect_new(point), bmx_cpvect_new(normal), alpha, data);
}

void bmx_cpspace_segmentquery(
	cpSpace* space, cpVect* start, cpVect* end, cpFloat radius,
	unsigned int filter,
	cpSpaceSegmentQueryFunc func, void* data
) {
	cpShapeFilter mfilter;
	mfilter.group = (cpGroup)CP_NO_GROUP;
	mfilter.categories = (cpBitmask)filter;
	mfilter.mask = (cpBitmask)filter;

	cpSpaceSegmentQuery(space, *start, *end, radius, mfilter, func, data);
}

cpShape* bmx_cpspace_segmentqueryfirst(
	cpSpace* space, cpVect* start, cpVect* end, cpFloat radius,
	unsigned int filter,
	cpSegmentQueryInfo* info
) {
	cpShapeFilter mfilter;
	mfilter.group = (cpGroup)CP_NO_GROUP;
	mfilter.categories = (cpBitmask)filter;
	mfilter.mask = (cpBitmask)filter;

	// Perform the point query in the Chipmunk space
	cpSegmentQueryInfo out;
	cpShape* nearestShape = cpSpaceSegmentQueryFirst(space, *start, *end, radius, mfilter, NULL); //&info);

	return nearestShape;
}

void bmx_cpspace_update(cpSpace* cpObjectPtr, cpArray* arbiters) {
	*arbiters = *cpObjectPtr->arbiters;
}

void bmx_cpconstraint_setpresolvefunc(cpConstraint* constraint, cpConstraintPreSolveFunc preSolveFunc) {
	cpConstraintSetPreSolveFunc(constraint, preSolveFunc);
}

void bmx_cpconstraint_setpostsolvefunc(cpConstraint* constraint, cpConstraintPostSolveFunc postSolveFunc)
{
	cpConstraintSetPostSolveFunc(constraint, postSolveFunc);
}

void bmx_cpslidejoint_setmax(cpConstraint* constraint, cpFloat value)
{
	cpSlideJointSetMax(constraint, value);
}

void bmx_cppivotjoint_setanchora(cpConstraint* constraint, cpVect* value)
{
	cpPivotJointSetAnchorA(constraint, *value);
}

cpVect* bmx_cpdampedspring_getanchora(cpDampedSpring* dampedspring) {
	return bmx_cpvect_new(cpDampedSpringGetAnchorA((cpConstraint*)dampedspring));
}

cpVect* bmx_cpdampedspring_getanchorb(cpDampedSpring* dampedspring) {
	return bmx_cpvect_new(cpDampedSpringGetAnchorB((cpConstraint*)dampedspring));
}

cpConstraint* bmx_cpdampedrotaryspring_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat restAngle, cpFloat stiffness, cpFloat damping)
{
	cpConstraint* joint = cpDampedRotarySpringNew(a, b, restAngle, stiffness, damping);
	cpbind(joint, handle);
	return joint;
}

cpConstraint* bmx_cprotarylimitjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat min, cpFloat max)
{
	cpConstraint* joint = cpRotaryLimitJointNew(a, b, min, max);
	cpbind(joint, handle);
	return joint;
}

cpConstraint* bmx_cpratchetjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat phase, cpFloat ratchet)
{
	cpConstraint* joint = cpRatchetJointNew(a, b, phase, ratchet);
	cpbind(joint, handle);
	return joint;
}

cpConstraint* bmx_cpgearjoint_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat phase, cpFloat ratio) {
	cpConstraint* joint = cpGearJointNew(a, b, phase, ratio);
	cpbind(joint, handle);
	return joint;
}

cpConstraint* bmx_cpsimplemotor_new(BBObject* handle, cpBody* a, cpBody* b, cpFloat rate) {
	cpConstraint* joint = cpSimpleMotorNew(a, b, rate);
	cpbind(joint, handle);
	return joint;
}

BBObject* bmx_cparbiter_getdata(cpArbiter* arb) {
	cpDataPointer userData = cpArbiterGetUserData(arb);
	if (userData) {
		return (BBObject*)userData;
	}
	else {
		return &bbNullObject;
	}
}

cpVect* bmx_cparbiter_getnormal(cpArbiter* arb) {
	return bmx_cpvect_new(cpArbiterGetNormal(arb));
}

cpVect* bmx_cparbiter_getpointa(cpArbiter* arb, int i)
{
	return bmx_cpvect_new(cpArbiterGetPointA(arb, i));
}

cpVect* bmx_cparbiter_getpointb(cpArbiter* arb, int i)
{
	return bmx_cpvect_new(cpArbiterGetPointB(arb, i));
}

void bmx_cparbiter_setcontactpointset(cpArbiter* arb, BBArray* set) {
	cpContactPointSet newSet = cpArbiterGetContactPointSet(arb);

	// Retrieve the normal from the first contact point
	cpContact* firstContact = CB_PREF(hot_chipmunk_CPContact__getContactForIndex)(set, 0);
	cpVect normal = cpvsub(firstContact->r2, firstContact->r1);
	newSet.normal = cpvnormalize(normal);

	// Set the position of each contact point
	for (int i = 0; i < newSet.count; ++i) {
		cpContact* contact = CB_PREF(hot_chipmunk_CPContact__getContactForIndex)(set, i);
		newSet.points[i].pointA = contact->r1;
		newSet.points[i].pointB = contact->r2;
	}

	// Set the new contact point set for the arbiter
	cpArbiterSetContactPointSet(arb, &newSet);
}

cpVect* bmx_cparbiter_totalimpulse(cpArbiter* arb)
{
	return bmx_cpvect_new(cpArbiterTotalImpulse(arb));
}

// Define the function to get contacts from cpArbiter
cpContact* bmx_cparbiter_getcontacts(cpArbiter* arb, int i)
{
	// Check if the arbiter exists and has contacts
	if (arb && arb->contacts && i >= 0 && i < arb->count)
	{
		// Return a pointer to the cpContact at index i
		return &(arb->contacts[i]);
	}
	// Return NULL if the arbiter or contacts are NULL, or if the index is out of bounds
	return NULL;
}

cpVect* bmx_cpcontact_getr1(cpContact* contact)
{
	return bmx_cpvect_new(contact->r1);
}

void bmx_cpcontact_setr1(cpContact* contact, cpVect* r1)
{
	contact->r1 = *r1;
}

cpVect* bmx_cpcontact_getr2(cpContact* contact)
{
	return bmx_cpvect_new(contact->r2);
}

void bmx_cpcontact_setr2(cpContact* contact, cpVect* r2)
{
	contact->r1 = *r2;
}

void bmx_cptransform_update(cpTransform* transformPtr, cpFloat* a, cpFloat* b, cpFloat* c, cpFloat* d, cpFloat* tx, cpFloat* ty)
{
	*a = transformPtr->a;
	*b = transformPtr->b;
	*c = transformPtr->c;
	*d = transformPtr->d;
	*tx = transformPtr->tx;
	*ty = transformPtr->ty;
}

cpSpace* bmx_cphastyspace_new(BBObject* handle) {
	cpSpace* space = cpHastySpaceNew();
	cpbind(space, handle);
	return space;
}
