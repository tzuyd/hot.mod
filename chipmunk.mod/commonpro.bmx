
Extern

	Function bmx_cpmarch_samplefunc:Double(Point:Byte ptr, Data:Object)
	Function bmx_cpmarch_segmentfunc(v0:Byte ptr, v1:Byte ptr, Data:Object)
	Function bmx_cpmarch_soft( ..
	  bb:Byte ptr, x_samples:Size_T, y_samples:Size_T, threshold:Double,  ..
	  segment(v0:Byte ptr, v1:Byte ptr, Data:Object), segment_data:Object,  ..
	  sample:Double(Point:Byte ptr, Data:Object), sample_data:Object ..
	)
	Function bmx_cpmarch_hard( ..
	  bb:Byte ptr, x_samples:Size_T, y_samples:Size_T, threshold:Double,  ..
	  segment(v0:Byte ptr, v1:Byte ptr, Data:Object), segment_data:Object,  ..
	  sample:Double(Point:Byte ptr, Data:Object), sample_data:Object ..
	)

	Function cpPolylineFree(line:Byte ptr)
	Function cpPolylineIsClosed:Int(line:Byte ptr)
	Function cpPolylineSimplifyVertexes:Byte ptr(line:Byte ptr, tol:Double)
	Function cpPolylineSimplifyCurves:Byte ptr(line:Byte ptr, tol:Double)
	Function cpPolylineSetNew:Byte ptr()
	Function cpPolylineSetDestroy(Set:Byte ptr, freePolylines:Int)
	Function cpPolylineSetFree(Set:Byte ptr, freePolylines:Int)
	Function bmx_cppolylineset_collectsegment(v0:Byte ptr, v1:Byte ptr, lines:Byte ptr)
	Function cpPolylineToConvexHull:Byte ptr(line:Byte ptr, tol:Double)
	Function cpPolylineConvexDecomposition:Byte ptr(line:Byte ptr, tol:Double)
'	Function bmx_cppolylineset_vert:Byte ptr(lines:Byte ptr, Index:Int)
End Extern

?Not ios
Global ENABLE_HASTY:Int = 0
?ios
Const ENABLE_HASTY:Int = 0
?
	