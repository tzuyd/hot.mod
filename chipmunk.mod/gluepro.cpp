
#include "chipmunk/cpmarch.h"
#include "chipmunk/cppolyline.h"

#ifdef BMX_NG
#define CB_PREF(func) func
#else
#define CB_PREF(func) _##func
#endif

extern "C" {
	void cpbind(void *obj, BBObject *peer);
	void CB_PREF(hot_chipmunk_CPPolyline__setVert)(BBArray *verts, int index, cpVect *vec);
	cpFloat CB_PREF(hot_chipmunk_CPMarch__samplehashCallback)(cpVect* point, void* data);
	void CB_PREF(hot_chipmunk_CPMarch__segmenthashCallback)(cpVect* v0,cpVect* v1, void* data);

	cpVect *bmx_cpvect_new(cpVect v);

	cpFloat bmx_cpmarch_samplefunc(cpVect point, void *data);
	void bmx_cpmarch_segmentfunc(cpVect v0,cpVect v1, void *data);
	void
	bmx_cpmarch_soft(
		cpBB* bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
		cpMarchSegmentFunc segment, void *segment_data,
		cpMarchSampleFunc sample, void *sample_data
	);
	void
	bmx_cpmarch_hard(
		cpBB* bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
		cpMarchSegmentFunc segment, void *segment_data,
		cpMarchSampleFunc sample, void *sample_data
	);

	cpSpace *bmx_cphastyspace_new(BBObject * handle);

	void bmx_cppolyline_verts(cpPolyline *line, BBArray *verts);
    void bmx_cppolylineset_collectsegment(cpVect* v0, cpVect* v1, cpPolylineSet *lines);
    cpPolyline *bmx_cppolylineset_vert(cpPolylineSet *lines, int index);
}

cpFloat bmx_cpmarch_samplefunc(cpVect point, void* data){
	return CB_PREF(hot_chipmunk_CPMarch__samplehashCallback)(bmx_cpvect_new(point),data);
}

void bmx_cpmarch_segmentfunc(cpVect v0,cpVect v1, void* data){
	CB_PREF(hot_chipmunk_CPMarch__segmenthashCallback)(bmx_cpvect_new(v0),bmx_cpvect_new(v1),data);
}

void
bmx_cpmarch_soft(
	cpBB *bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
	cpMarchSegmentFunc segment, void* segment_data,
	cpMarchSampleFunc sample, void* sample_data
){
	cpMarchSoft(
		*bb, x_samples, y_samples, threshold,
		segment, segment_data,
		sample, sample_data
	);
}

void
bmx_cpmarch_hard(
	cpBB* bb, unsigned long x_samples, unsigned long y_samples, cpFloat threshold,
	cpMarchSegmentFunc segment, void* segment_data,
	cpMarchSampleFunc sample, void* sample_data
){
	cpMarchHard(
		*bb, x_samples, y_samples, threshold,
		segment, segment_data,
		sample, sample_data
	);
}



cpSpace *bmx_cphastyspace_new(BBObject * handle){
	cpSpace * space = cpHastySpaceNew();
	cpbind(space, handle);
	return space;
}



void bmx_cppolyline_verts(cpPolyline *line, BBArray *verts) {
	int numVerts = line->count;
	for (int i = 0; i < numVerts; ++i) {
		cpVect vert = line->verts[i];
		CB_PREF(hot_chipmunk_CPPolyline__setVert)(verts, i, bmx_cpvect_new(vert));
	}
}

void bmx_cppolylineset_collectsegment(cpVect* v0, cpVect* v1, cpPolylineSet *lines){
    cpPolylineSetCollectSegment(*v0, *v1, lines);
}

cpPolyline *bmx_cppolylineset_vert(cpPolylineSet *lines, int index) {
    if (index >= 0 && index < lines->count) {
        return lines->lines[index];
    }
    return NULL; // Return nullptr if the index is out of bounds
}
