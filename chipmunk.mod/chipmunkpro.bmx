
Rem Copyright 2013 Howling Moon Software.All rights reserved.
	See http://chipmunk2d.net/legal.php for more information.
EndRem

Include "temp.bmx"

Type TMarchSampleFuncCallback

	Field callback:Double(Point:CPVect, Data:ChipmunkAbstractSampler)
	Field Data:ChipmunkAbstractSampler

End Type

Type TMarchSegmentFuncCallback

	Field callback(v0:CPVect, v1:CPVect, Data:CPPolylineSet)
	Field Data:Object

End Type

Type CPMarch
	Rem
	bbdoc: Trace an anti-aliased contour of an image along a particular threshold.
	about: The given number of samples will be taken and spread across the bounding box area using the sampling function and context.
	The segment function will be called for each segment detected that lies along the density contour for @threshold.
	EndRem
	Function Soft( ..
	  bb:CPBB, x_samples:Size_T, y_samples:Size_T, threshold:Double,  ..
	  segment(v0:CPVect, v1:CPVect, Data:CPPolylineSet), segment_data:CPPolylineSet,  ..
	  sample:Double(Point:CPVect, Data:ChipmunkAbstractSampler), sample_data:ChipmunkAbstractSampler ..
	)
		Local segment_cb:TMarchSegmentFuncCallback = New TMarchSegmentFuncCallback
		segment_cb.callback = segment
		segment_cb.Data = segment_data

		Local sample_cb:TMarchSampleFuncCallback = New TMarchSampleFuncCallback
		sample_cb.callback = sample
		sample_cb.Data = sample_data

		bmx_cpmarch_soft( ..
			bb.bbPtr, x_samples, y_samples, threshold,  ..
			bmx_cpmarch_segmentfunc, segment_cb,  ..
			bmx_cpmarch_samplefunc, sample_cb ..
		)
	End Function
	
	Rem
	bbdoc: Trace an aliased curve of an image along a particular threshold.
	about: The given number of @samples will be taken and spread across the bounding box area using the sampling function and context.
	The segment function will be called for each segment detected that lies along the density contour for @threshold.
	EndRem
	Function Hard( ..
	  bb:CPBB, x_samples:Size_T, y_samples:Size_T, threshold:Double,  ..
	  segment(v0:CPVect, v1:CPVect, Data:CPPolylineSet), segment_data:Object,  ..
	  sample:Double(Point:CPVect, Data:ChipmunkAbstractSampler), sample_data:ChipmunkAbstractSampler ..
	)
		Local segment_cb:TMarchSegmentFuncCallback = New TMarchSegmentFuncCallback
		segment_cb.callback = segment
		segment_cb.Data = segment_data

		Local sample_cb:TMarchSampleFuncCallback = New TMarchSampleFuncCallback
		sample_cb.callback = sample
		sample_cb.Data = sample_data

		bmx_cpmarch_hard( ..
			bb.bbPtr, x_samples, y_samples, threshold,  ..
			bmx_cpmarch_segmentfunc, segment_cb,  ..
			bmx_cpmarch_samplefunc, sample_cb ..
		)
	End Function

	Function _samplehashCallback:Double(Point:Double Ptr, callbackData:Object) { nomangle }
	    If TMarchSampleFuncCallback(callbackData) Then
	        Return TMarchSampleFuncCallback(callbackData).callback(CPVect._create(Point), TMarchSampleFuncCallback(callbackData).Data)
	    End If
	End Function

	Function _segmenthashCallback(v0:Double Ptr, v1:Double Ptr, callbackData:Object) { nomangle }
	    If TMarchSegmentFuncCallback(callbackData) Then
	        TMarchSegmentFuncCallback(callbackData).callback(CPVect._create(v0), CPVect._create(v1), CPPolylineSet(TMarchSegmentFuncCallback(callbackData).Data))
	    End If
	End Function
End Type



Extern	' This block handles Object arrays
	Function bmx_cppolyline_verts(line:Byte Ptr, verts:CPVect[])
End Extern

Rem
bbdoc: Wrapper for the CPPolyline type.
EndRem
Type CPPolyline
	Private
	Public
    Field line:Byte Ptr
    Field _area:Double = 0
	Public
	
    Method initWithPolyline(line:Byte Ptr)
        Self.line = line
		cpbind(line, Self)
    End Method

    Method Delete()
        cpPolylineFree(line)
		cpunbind(Byte Ptr(line))
    End Method

    Function fromPolyline:CPPolyline(line:Byte Ptr)
        Local this:CPPolyline = New CPPolyline
		this.initWithPolyline(line)
        Return this
    End Function

	Rem
	bbdoc: Returns true if the first and last vertex are equal.
	EndRem
    Method isClosed:Byte()
        Return cpPolylineIsClosed(line)
    End Method

	Rem
	bbdoc: Returns the signed area of the polyline calculated by AreaForPoly.
	about: Non-closed polylines return an area of 0.
	EndRem
    Method area:Double()
        If _area = 0.0 And isClosed()
            _area = AreaForPoly(verts(), 0.0)
        End If
        Return _area
    End Method

	Rem
	bbdoc: Centroid of the polyline calculated by CentroidForPoly.
	about: It is an error to call this on a non-closed polyline.
	EndRem
    Method centroid:CPVect()
		If Not isClosed() Then Throw("Cannot compute the centroid of a non-looped polyline.")
        Return CentroidForPoly(verts())
    End Method

	Rem
	bbdoc: Calculates the moment of inertia for a closed polyline with the given @mass and @offset.
	EndRem
    Method momentForMass:Double(mass:Double, offset:CPVect)
		If Not isClosed() Then Throw("Cannot compute the moment of a non-looped polyline.")
        Return MomentForPoly(mass, verts(), offset, 0.0)
    End Method

	
	Rem
	bbdoc: Vertex count.
	EndRem
    Method Count:Int()
		Return (Int Ptr(line))[0]
    End Method

	Rem
	bbdoc: Array of vertexes.
	EndRem
    Method verts:CPVect[] ()
		Local offset:Byte Ptr = line + 8
	    Local numVerts:Int = Count()
		Local verts:CPVect[] = New CPVect[numVerts]
	    For Local i:Int = 0 To numVerts - 1
			verts[i] = Vec2((Double Ptr(offset))[i * 2], (Double Ptr(offset))[(i * 2) + 1])
	    Next
		Return verts
    End Method

	Rem
	bbdoc: Returns a copy of a polyline simplified by using the Douglas-Peucker algorithm.
	about: This works very well on smooth or gently curved shapes, but not well on straight edged or angular shapes.
	EndRem
    Method simplifyCurves:CPPolyline(tolerance:Double)
        Return CPPolyline.fromPolyline(cpPolylineSimplifyCurves(line, tolerance))
    End Method

	Rem
	bbdoc: Returns a copy of a polyline simplified by discarding "flat" vertexes.
	about: This works well on straight edged or angular shapes, not as well on smooth shapes.
	EndRem
    Method simplifyVertexes:CPPolyline(tolerance:Double)
        Return CPPolyline.fromPolyline(cpPolylineSimplifyVertexes(line, tolerance))
    End Method

	Rem
	bbdoc: Generate a convex hull that contains a polyline. (closed or not)
	EndRem
    Method toConvexHull:CPPolyline()
	    Return Self.toConvexHull(0.0)
    End Method

	Rem
	bbdoc: Generate an approximate convex hull that contains a polyline. (closed or not)
	EndRem
    Method toConvexHull:CPPolyline(tolerance:Double)
        Return CPPolyline.fromPolyline(cpPolylineToConvexHull(line, tolerance))
    End Method

	Rem
	bbdoc: Generate a set of convex hulls for a polyline.
	about: BETA
	EndRem
    Method toConvexHulls:CPPolylineSet(tolerance:Double)
        Local Set:CPPolylineSet = New CPPolylineSet(cpPolylineConvexDecomposition(line, tolerance))
		Set.initWithPolylineSet()
        Local Value:CPPolylineSet = CPPolylineSet.fromPolylineSet(Set.lines)
        cpPolylineSetFree(Set.lines, False)
		Set.lines = Null
        Return Value
    End Method

	Rem
	bbdoc: Create an array of segments for each segment in this polyline.
	EndRem
    Method asChipmunkSegmentsWithBody:TList(body:CPBody, radius:Double, offset:CPVect)
        Local arr:TList = New TList
		Local verts:CPVect[] = verts()
        Local a:CPVect = verts[0].Add(offset)
        For Local i:Int = 1 Until Count()
            Local b:CPVect = verts[i].Add(offset)
            arr.AddLast(New CPSegmentShape.Create(body, a, b, radius))
            a = b
        Next
        Return arr
    End Method

	Rem
	bbdoc: Create a CPPolyShape from this polyline. (Must be convex!)
	EndRem
	Method asChipmunkPolyShapeWithBody:CPPolyShape(body:CPBody, transform:CPTransform, radius:Double)
	    If Not isClosed() Then Throw("Cannot create a poly shape for a non-closed polyline.")
	    
	    Local transformedVerts:CPVect[] = verts()
		
	    For Local i:Int = 0 Until Count()
	        transformedVerts[i] = CPTransform.Point(Transform, transformedVerts[i])
	    Next
	    
	    Local offset:CPVect = CPTransform.Point(Transform, Vec2(0, 0)) ' Applying transform to zero vector to get offset
	    
	    Return New CPPolyShape.Create(body, transformedVerts, offset, radius)
	End Method

End Type


Rem
bbdoc: Wrapper for the CPPolylineSet type.
EndRem
Type CPPolylineSet
	Field lines:Byte Ptr

	Rem
	bdoc: Allocate and initialize a polyline set.
	EndRem
	Method New()
		lines = cpPolylineSetNew()
	End Method
	Method New(Set:Byte Ptr)
		lines = Set
	End Method

	Rem
	bbdoc: Add a line segment to a polyline set.
	about: A segment will either start a new polyline, join two others, or add to or loop an existing polyline.
	This is mostly intended to be used as a callback directly from CPMarch.Soft() or CPMarch.Hard().
	EndRem
	Function CollectSegment(v0:CPVect, v1:CPVect, lines:CPPolylineSet)
		bmx_cppolylineset_collectsegment(v0.vecPtr, v1.vecPtr, lines.lines)
	End Function

    Method initWithPolylineSet()
        For Local i:UInt = 0 Until Count()
            Local polyline:CPPolyline = lineAtIndex(i)
            Local verts:CPVect[] = polyline.verts()
            Local Count:Int = polyline.Count()
            For Local j:Int = 0 Until count - 1
                Local v0:CPVect = verts[j]
                Local v1:CPVect = verts[j + 1]
                CollectSegment(v0, v1, Self)
            Next
                Local v0:CPVect = verts[Count - 1]
                Local v1:CPVect = verts[0]
                CollectSegment(v0, v1, Self)
        Next
    End Method

    Method Delete()
		If lines
	        cpPolylineSetFree(lines, False)
			lines = Null
		EndIf
    End Method

    Function fromPolylineSet:CPPolylineSet(Set:Byte Ptr)
        Local this:CPPolylineSet = New CPPolylineSet(Set)
		this.initWithPolylineSet()
        Return this
    End Function

    Method Count:Int()
		Return (Int Ptr(lines))[0]
    End Method

    Method lineAtIndex:CPPolyline(Index:UInt)
		Local offset:Byte Ptr = lines + 8
		Local pointer:Byte Ptr = Byte Ptr Ptr(offset)[0]
		Return CPPolyline.fromPolyline((pointer)[Index])
    End Method
End Type


Rem
bbdoc: A sampler is an object that provides a basis function to build shapes from.
about: This can be from a block of pixel data (loaded from a file, or dumped from the screen), or even a mathematical function such as Perlin noise.
EndRem
Type ChipmunkAbstractSampler
    Field marchThreshold:Double = 0.5
    Field sampleFunc:Double(Point:CPVect, Data:ChipmunkAbstractSampler)

    Function initWithSamplingFunction:ChipmunkAbstractSampler(sampleFunc:Double(Point:CPVect, Data:ChipmunkAbstractSampler))
        Local this:ChipmunkAbstractSampler = New ChipmunkAbstractSampler
        this.sampleFunc = sampleFunc
	DebugStop
        Return this
    End Function

	Rem
	bbdoc: Sample at a specific point.
	EndRem
    Method sample:Double(Pos:CPVect)
        Return sampleFunc(Pos, Self)
    End Method

	Rem
	bbdoc: March a certain area of the sampler.
	EndRem
    Method march:CPPolylineSet(bb:CPBB, xSamples:Size_T, ySamples:Size_T, hard:Int)
        Local Set:CPPolylineSet = New CPPolylineSet
        If hard
            CPMarch.hard(bb, xSamples, ySamples, marchThreshold, Set.CollectSegment, Set, sampleFunc, Self)
        Else
            CPMarch.Soft(bb, xSamples, ySamples, marchThreshold, Set.CollectSegment, Set, sampleFunc, Self)
        End If
        Local Value:CPPolylineSet = CPPolylineSet.fromPolylineSet(Set.lines)
        cpPolylineSetDestroy(Set.lines, False)
        Return Value
    End Method

End Type



Rem
bbdoc: A simple sampler type that wraps a block as it's sampling function.
EndRem
Type ChipmunkBlockSampler Extends ChipmunkAbstractSampler
    Field block:Double(Point:CPVect)

	Function SampleFromBlock:Double(Point:CPVect, this:Object)
		Return ChipmunkBlockSampler(this).block(Point)
	End Function
	
    Function initWithBlock:ChipmunkBlockSampler(block:Double(Pos:CPVect))
        Local this:ChipmunkBlockSampler = New ChipmunkBlockSampler
        this.initWithSamplingFunction(this.SampleFromBlock)
        this.block = block
        Return this
    End Function

    Function samplerWithBlock:ChipmunkBlockSampler(block:Double(Pos:CPVect))
        Return ChipmunkBlockSampler.initWithBlock(block)
    End Function

End Type

Rem
//  ChipmunkImageSampler
//  DeformableChipmunk
//
//  Created by Scott Lembcke on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
EndRem

Rem
bbdoc: Generic sampler used with bitmap data.
about: Currently limited to 8 bit per component data.
Bitmap samplers currently provide no filtering, but could be easily extended to do so.
endrem
Type ChipmunkBitmapSampler Extends ChipmunkAbstractSampler
	Rem
	bbdoc: Width of the bitmap in Pixels.
	EndRem
	Field width:Size_T

	Rem
	bbdoc: Height of the bitmap in Pixels.
	EndRem
	Field height:Size_T
	Field stride:Size_T

	Rem
	bbdoc: Bytes per pixel of the bitmap.(ex:RGBA8888 would be 4)
	EndRem
	Field BytesPerPixel:Size_T

	Rem
	bbdoc: Zero - based ndex of the component To sample.(ex:Alpha of RGBA would be 3)
	EndRem
	Field component:Size_T
	Field Flip:Int
	Field Pixels:Byte Ptr

	Rem
	bbdoc: TPixmap Object holding the pixel Data.
	EndRem
	Field pixelData:TPixmap
	Field borderValue:Double

	Rem
	bbdoc: rect that the image maps To.
	about: Defaults to (0.5, 0.5, width - 0.5, height - 0.5) so that pixel centers will be cleanly sampled.
	EndRem
	Field outputRect:CPBB
'    Field sampleFunc:Double(Point:CPVect, this:ChipmunkBitmapSampler) = SampleFunc8Clamp

	Rem
	bbdoc: Much faster than Int(Floor(f))
	about: Profiling showed Floor() to be a sizable performance hog
	EndRem
	Function floor_int:Int(f:Double)
		Local i:Int = Int(f)
		If f < 0.0 And f <> i Then Return i - 1
		Return i
	End Function
	
	Rem
	bbdoc: TODO finish this?
	'ndRem
	Function SampleFunc4444:Double(Point:CPVect, this:ChipmunkImageSampler) inline
	    Local x:Int = Int(point.x)
	    Local y:Int
	    If this.Flip Then
	        y = Int(Point.y) - (this.Height - 1)
	    Else
	        y = Int(point.y)
	    End If
	    
	    Local com:Int = this.component
	    Local Byte:Int = this.GetPixelByte(x, y)
	    Local Value:Int = '(byte Shr (com Mod 2 * 4)) And $0F
	    
	    Return Double(Value) / 15.0
	End Function
	EndRem
	
	Function SampleFunc8Clamp:Double(Point:CPVect, this:ChipmunkAbstractSampler)
		Local w:Size_T = ChipmunkBitmapSampler(this).width
		Local h:Size_T = ChipmunkBitmapSampler(this).height
	
		Local bb:CPBB = ChipmunkBitmapSampler(this).outputRect
		Local clamped:CPVect = bb.ClampVect(Point)
	
		Local x:Int = floor_int((w - 1)*(clamped.x - bb.l)/(bb.r - bb.l) + 0.5)
		Local y:Int = floor_int((h - 1)*(clamped.y - bb.b)/(bb.t - bb.b) + 0.5)
	
		If ChipmunkBitmapSampler(this).Flip Then y = h - 1 - y
        Local pixelValue:Double = ChipmunkBitmapSampler(this).Pixels[y * ChipmunkBitmapSampler(this).stride + x * ChipmunkBitmapSampler(this).BytesPerPixel + ChipmunkBitmapSampler(this).component]

        Return pixelValue / 255.0
	End Function
	
	Function SampleFunc8Border:Double(Point:CPVect, this:ChipmunkAbstractSampler)
		Local w:Size_T = ChipmunkBitmapSampler(this).width
		Local h:Size_T = ChipmunkBitmapSampler(this).height
	
		Local bb:CPBB = ChipmunkBitmapSampler(this).outputRect
		If bb.ContainsVect(Point) Then
			Local x:Int = floor_int((w - 1)*(point.x - bb.l)/(bb.r - bb.l) + 0.5)
			Local y:Int = floor_int((h - 1)*(point.y - bb.b)/(bb.t - bb.b) + 0.5)
	
			If ChipmunkBitmapSampler(this).Flip Then y = h - 1 - y
	
		DebugLog("(" + Point.x + ", " + Point.y + ") -> (" + x + ", " + y + ")~n")
			Return Double(ChipmunkBitmapSampler(this).Pixels[y * ChipmunkBitmapSampler(this).stride + x * ChipmunkBitmapSampler(this).BytesPerPixel + ChipmunkBitmapSampler(this).component]) / 255.0
		Else
			Return ChipmunkBitmapSampler(this).borderValue
		End If
	End Function

	Rem
	bbdoc: Init a sampler from bitmap data.
	about: @Stride refers to the length of a row of pixels in bytes. (Generally just w*h*bytesPerPixel unless there is padding)
	Image must use one byte per component, but can have any number of components.
	@component refers to the 0-based index of the component to sample. (i.e. 3 would sample the alpha in an RGBA bitmap)
	@flip allows you to flip the image vertically to match how it migh be drawn.
	@pixelData can be either a TPixmap or NSMutableData (i.e. for deformable terrain) that contains the bitmap data.
	EndRem
	Method initWithWidth(width:Size_T, height:Size_T, stride:Size_T, BytesPerPixel:Size_T, component:Size_T, Flip:Int, pixelData:TPixmap)
	    Self.sampleFunc = SampleFunc8Clamp
			Self.width = width
			Self.height = height
			Self.stride = stride
			
			Self.bytesPerPixel = bytesPerPixel
			Self.component = component
			
			Self.Flip = Flip
			Self.pixelData = pixelData
			Self.Pixels = PixmapPixelPtr(pixelData)
			
			Self.outputRect = New CPBB.Create(0.5, 0.5, width - 0.5, height - 0.5)

	End Method


    Method Delete()
        pixelData = Null
    End Method

	Rem
	bbdoc: Set the border of the bitmap to repeat the edge pixels.
	EndRem
	Method setBorderRepeat()
        Self.sampleFunc = SampleFunc8Clamp
	End Method

	Rem
	bbdoc: Set the border of the bitmap to be a specific value.
	EndRem
	Method setBorderValue(borderValue:Double)
        Self.sampleFunc = SampleFunc8Border
        Self.borderValue = borderValue
	End Method

	Function BorderedBB:CPBB(bb:CPBB, width:Size_T, height:Size_T)
	    Local xBorder:Double = (bb.r - bb.l) / Double(width - 1)
	    Local yBorder:Double = (bb.t - bb.b) / Double(height - 1)
	    Return New CPBB.Create(bb.l - xBorder, bb.b - yBorder, bb.r + xBorder, bb.t + yBorder)
	End Function

	Rem
	bbdoc: March the entire image.
	EndRem
	Method marchAllWithBorder:CPPolylineSet(bordered:Int, hard:Int)
        Local width:Size_T = Self.width
        Local height:Size_T = Self.height
        Local bb:CPBB = Self.outputRect
        If bordered
            Return Self.March(BorderedBB(bb, width, height), width + 2, height + 2, hard)
        Else
            Return Self.March(bb, width, height, hard)
        End If
	End Method
End Type

Rem
bbdoc: Sampler built on top of a CGBitmapContext to allow deformable geometry.
about: Very efficient when paired with a ChipmunkTileCache.
EndRem
Type ChipmunkCGContextSampler Extends ChipmunkBitmapSampler
''	Rem
''	bbdoc: Image for this sampler.
''	EndRem
''	Field context:TImage
'	
'	Rem
'	bbdoc: TPixmap object holding the pixel data.
'	EndRem
'	Field pixelData:TPixmap

	Rem
	bbdoc: Initialize a context based sampler. Must provide options for a valid context.
	about: Find out more here in the Quartz 2D Programming Guide.
	EndRem
	Method initWithWidth:ChipmunkCGContextSampler(width:Size_T, height:Size_T, colorSpace:TPixmap, bitmapInfo:Int, component:Size_T)
        Local bpc:Size_T
		Select bitmapInfo
			Case PF_A8 Or PF_I8
				bpc = 8
			Case PF_RGB888 Or PF_BGR888
				bpc = 24
			Case PF_RGBA8888 Or PF_BGRA8888
				bpc = 32
		 End Select
        Local stride:Size_T = PixmapPitch(colorSpace)
        Local bpp:Size_T = stride / width
        If Not (bpc = 8) Then Throw("Cannot handle non-8bit-per-pixel bitmap data!")

		pixelData = ConvertPixmap(colorSpace, bitmapInfo)

        Super.initWithWidth(width, height, stride, bpp, component, True, pixelData)
	End Method

	Method Delete()
	End Method
	
End Type



Function ConvertToGrayscale:TPixmap(pixmap:TPixmap)
    Local w:Int = pixmap.width
    Local h:Int = pixmap.height
    Local newPixmap:TPixmap = CreatePixmap(w, h, pixmap.format)
    
    For Local y:Int = 0 Until h
        For Local x:Int = 0 Until w
            Local Color:Int = ReadPixel(pixmap, x, y)
            Local r:Int = (color Shr 16) And $FF
            Local g:Int = (color Shr 8) And $FF
            Local b:Int = color And $FF
            
            ' Calculate the grayscale value
            Local gray:Int = (r * 0.299 + g * 0.587 + b * 0.114)
            Local grayColor:Int = (gray Shl 16) Or (gray Shl 8) Or gray
            
            WritePixel(newPixmap, x, y, grayColor)
        Next
    Next
    
    Return newPixmap
End Function

Rem
bbdoc: A CGBitmapContext sampler initialized with an CGImage.
EndRem
Type ChipmunkImageSampler Extends ChipmunkCGContextSampler

	Rem
	bbdoc: Helper method to easily load Images by path. You are responsible for releasing the Image.
	EndRem
	Method LoadImage:TPixmap(url:String)
        Local image:TPixmap = LoadPixmap(url)
        Assert image, "Image could not be loaded."
        Return image
	End Method

	Rem
	bbdoc: Initialize an image sampler of a certain size with an Image.
	about: If @isMask is True, the image will be loaded as a black and white image, if False only the image alpha will be loaded.
	EndRem
	Method initWithImage:ChipmunkImageSampler(image:TPixmap, isMask:Int, contextWidth:Size_T = 0, contextHeight:Size_T = 0)
        If contextWidth = 0 Then contextWidth = PixmapWidth(image)
        If contextHeight = 0 Then contextHeight = PixmapHeight(image)

        Local colorSpace:TPixmap
		If isMask Then colorSpace = ConvertToGrayscale(image) Else colorSpace = Null
colorSpace = image
        Local bitmapInfo:Int
		If isMask Then bitmapInfo = PF_I8 Else bitmapInfo = PF_A8

        Super.initWithWidth(contextWidth, contextHeight, colorSpace, bitmapInfo, 0)
        DrawPixmap(image, 0, 0)
		
		Return Self
	End Method

	Rem
	bbdoc: Initialize an image sampler with an image file.
	about: If @isMask is True, the image will be loaded as a black and white image, if False only the image alpha will be loaded.
	EndRem
	Method initWithImageFile:ChipmunkImageSampler(imageFile:String, isMask:Int)
        Local image:TPixmap = LoadImage(imageFile)
        Local width:Size_T = PixmapWidth(image)
        Local height:Size_T = PixmapHeight(image)
		
        Self.initWithImage(image, isMask, width, height)
		
		Return Self
	End Method

	Rem
	bbdoc: Return an autoreleased image sampler initialized with an image file.
	about: If @isMask is True, the image will be loaded as a black and white image, if False only the image alpha will be loaded.
	EndRem
	Function samplerWithImageFile:ChipmunkImageSampler(url:String, isMask:Int)
        Return New ChipmunkImageSampler.initWithImageFile(url, isMask)
	End Function
	
End Type


Type DeformPoint
    Field posX:Double Ptr
	Field posY:Double Ptr
    Field radius:Double Ptr
    Field fuzz:Double Ptr
	Field p:TBank
	
	Method New(Pos:CPVect, radius:Double, fuzz:Double)
		p = CreateBank(32)
		Self.posX = BankBuf(p)
		Self.posY = BankBuf(p) + 8
		Self.radius = BankBuf(p) + 16
		Self.fuzz = BankBuf(p) + 24
		Self.posX[0] = Pos.x
		Self.posY[0] = Pos.y
		Self.radius[0] = radius
		Self.fuzz[0] = fuzz
DebugStop
	End Method
	Method New(Point:Double Ptr)
		p = CreateStaticBank(Point, 32)
		Self.posX = BankBuf(p)
		Self.posY = BankBuf(p) + 8
		Self.radius = BankBuf(p) + 16
		Self.fuzz = BankBuf(p) + 24
DebugStop
	End Method
End Type

Function PointBB:Double Ptr(Point:Object)
'	Local p:DeformPoint = New DeformPoint(Point)
    Local v:CPVect = Vec2(DeformPoint(Point).Posx[0], DeformPoint(Point).posY[0])
    Local r:Double = DeformPoint(Point).radius[0]
    Return New CPBB.Create(v.x - r, v.y - r, v.x + r, v.y + r).bbPtr
End Function



Rem
bbdoc: A point cloud sampler allows you to perform deformable terrain like with a bitmap backed sampler, but without any bounds. 
about: It only requires memory for the points you add instead of large RAM chewing bitmap.
However, unlike a bitmap, the deformation can only go one way. (i.e. You can add or remove terrain, but not both).
Without any points, the sampler will return 1.0. Adding points will put "holes" in it causing it to return lower values.
EndRem
Type ChipmunkPointCloudSampler Extends ChipmunkAbstractSampler
    Field cellSize:Double
    Field Index:CPSpatialIndex

    Function fuzz:Double(v:CPVect, c:CPVect, r:Double, softness:Double)
        Local distsq:Double = v.distsq(c)
        If distsq < r * r Then Return 1.0 - Clamp01((r - Sqr(distsq)) / (softness * r)) Else Return 1.0
    End Function

    Function PointQuery(v:Object, Point:Double Ptr, id:UInt, density:Byte Ptr)
		Local p:DeformPoint = New DeformPoint(Point)
		DebugStop
	    Double Ptr(density)[0] = Double Ptr(density)[0] * Self.fuzz(CPVect(v), Vec2(p.Posx[0], p.posY[0]), p.radius[0], p.fuzz[0])
		DebugStop
    End Function

    Function PointCloudSample:Double(Pos:CPVect, cloud:Object)
        Local density:Double = 1.0
        ChipmunkPointCloudSampler(cloud).Index.Query(Pos, New CPBB.NewForCircle(Pos, 0.0), PointQuery, Varptr density)
		
        Return density
    End Function

	Rem
	bbdoc: Initialize the sampler with the given cell size, which should roughly match the size of the points added to the sampler.
	EndRem
    Method initWithCellSize:ChipmunkPointCloudSampler(cellSize:Double)
        Self.sampleFunc = PointCloudSample
        Self.cellSize = cellSize
        ' TODO table size
        Self.Index = New CPSpatialIndex.Create(cellSize, 1000, PointBB, Null)
        Return Self
    End Method

    Function freeWrap(p:Byte Ptr, unused:Object)
		cpunbind(p)
        free_(p)
    End Function

    Method dealloc()
        Self.Index.ForEach(freeWrap, Null)
        Self.Index.Free()
    End Method

	Rem
    bbdoc: Add a point to the cloud and return the dirty rect for the point.
	EndRem
    Method addPoint:Double Ptr(Pos:CPVect, radius:Double, fuzz:Double)
		Local Point:DeformPoint = New DeformPoint(Pos, radius, fuzz)
        
        Self.Index.Insert(Point.p, Size_T(BankBuf(Point.p)))
        
        Return PointBB(Point)
    End Method

End Type


Type ChipmunkCachedTile
	Field bb:CPBB
	Field dirty:Int
	
	Field nextTile:ChipmunkCachedTile, prevTile:ChipmunkCachedTile
	
	Field shapes:TList = New TList

	Function ChipmunkCachedTileBB:Double Ptr(tile:Object)
		ChipmunkCachedTile(tile).bb.bbPtr[0] = ChipmunkCachedTile(tile).bb.l
		ChipmunkCachedTile(tile).bb.bbPtr[1] = ChipmunkCachedTile(tile).bb.b
		ChipmunkCachedTile(tile).bb.bbPtr[2] = ChipmunkCachedTile(tile).bb.r
		ChipmunkCachedTile(tile).bb.bbPtr[3] = ChipmunkCachedTile(tile).bb.t
		Return ChipmunkCachedTile(tile).bb.bbPtr
	End Function

	Function ChipmunkCachedTileQuery(Pos:Object, tile:Double Ptr, id:UInt, out:Byte Ptr)
	DebugStop
		If New CPBB.Create(tile[0], tile[1], tile[2], tile[3]).ContainsVect(CPVect(Pos)) Then out = Varptr tile
		DebugStop
	End Function


	Method initWithBB:ChipmunkCachedTile(bb:CPBB)
		Self.bb = bb
		Return Self
	End Method
	
End Type



Type TileRect
	Field l:Int, b:Int, r:Int, t:Int

	Method New(l:Int, b:Int, r:Int, t:Int)
		Self.l = l
		Self.b = b
		Self.r = r
		Self.t = t
	End Method
End Type

Rem
bbdoc: A tile cache enables an efficient means of updating a large deformable terrain.
about: General usage would be to pass a rectangle covering the viewport to ensureRect
and calling markDirtyRect each time a change is made that requires an area to be resampled.
endrem
Type ChipmunkAbstractTileCache Extends CPObject
	Rem
	bbdoc: The sampling function to use.
	EndRem
    Field sampler:ChipmunkAbstractSampler
    Field space:CPSpace

    Field tileSize:Double
    Field samplesPerTile:Size_T
	Rem
	bbdoc: Offset of the tile grid origin.
	EndRem
    Field tileOffset:CPVect

    Field tileCount:Size_T, cacheSize:Int
    Field tileIndex:CPSpatialIndex
    Field cacheHead:ChipmunkCachedTile, cacheTail:ChipmunkCachedTile

    Field ensuredBB:CPBB
    Field ensuredDirty:Int

	Rem
	bbdoc: Should the marching be hard or soft?
	about: See CPMarch.Hard() and CPMarch.Soft() for more information.
	EndRem
    Field marchHard:Int

	Rem
	bbdoc: Create the cache from the given sampler, space to add the generated segments to,
	size of the tiles, and the number of samples for each tile.
	EndRem
    Method initWithSampler:ChipmunkAbstractTileCache(sampler:ChipmunkAbstractSampler, space:CPSpace, tileSize:Double, samplesPerTile:Size_T, cacheSize:Int)
			Self.sampler = sampler
			Self.space = space
			
			Self.tileSize = tileSize
			Self.samplesPerTile = samplesPerTile
			Self.tileOffset = CPVZero
			
			Self.cacheSize = cacheSize
			resetCache()
		
        Return Self
    End Method

	Method removeShapesForTile(tile:ChipmunkCachedTile)
		For Local shape:CPShape = EachIn tile.shapes
			space.removeshape(shape)
		Next
	End Method

	Rem
	bbdoc: Clear out all the cached tiles to force a full regen.
	EndRem
    Method resetCache()
		ensuredDirty = True
		
		' Reset the spatial index.
		If tileIndex Then tileIndex.Free()
		tileIndex = New CPSpatialIndex.Create(tileSize, cacheSize, ChipmunkCachedTile.ChipmunkCachedTileBB, Null)

		' Remove all the shapes and release all the tiles.
		Local tile:ChipmunkCachedTile = cachetail
		While tile
			removeShapesForTile(tile)
			tile = tile.nextTile
		Wend
		
		' Clear out the tile list.
		cacheHead = Null
		cacheTail = Null
		tileCount = 0
    End Method

	Method marchTile(tile:ChipmunkCachedTile)
		' Remove old shapes for this tile.
		For Local shape:CPShape = EachIn tile.shapes
			space.removeshape(shape)
		Next
		Local Set:CPPolylineSet = New CPPolylineSet
		
		If marchHard
			CPMarch.Hard(tile.bb, samplesPerTile, samplesPerTile, sampler.marchThreshold,  ..
			 Set.CollectSegment, Set,  ..
			 sampler.sampleFunc, sampler)
		Else
			CPMarch.Soft(tile.bb, samplesPerTile, samplesPerTile, sampler.marchThreshold,  ..
			 Set.CollectSegment, Set,  ..
			 sampler.sampleFunc, sampler)
		End If
		
		If Set.Count()
			Local staticBody:CPBody = New CPBody.Create(INFINITY, INFINITY)
			Local shapes:TList = New TList
			
			For Local i:UInt = 0 Until Set.Count()
				Local simplified:CPPolyline = simplify(Set.lineatindex(i))
				
				Local tmp:CPVect[] = simplified.verts()
				For Local j:Int = 0 Until simplified.Count() - 1
					Local segment:CPSegmentShape = makeSegmentFor(staticBody, tmp[j], tmp[j + 1])
					shapes.AddLast(segment)
					space.AddShape(segment)
				Next
				
				cpPolylineFree(simplified.line)
			Next
			
			tile.shapes = shapes
		Else
			tile.shapes = Null
		End If
		For Local i:UInt = 0 Until Set.Count()
			Local offset:Byte Ptr = (Set.lines + 8)
			Local tmp:Byte Ptr = Byte Ptr Ptr(offset)[i]
			cpPolylineFree(tmp)
			cpunbind(Byte Ptr(tmp))
		Next
		cpPolylineSetFree(Set.lines, False)
		Set.lines = Null
		Set = Null
		tile.dirty = False
	End Method

	Method GetTileAt:ChipmunkCachedTile(Index:CPSpatialIndex, i:Int, j:Int, Size:Double, offset:CPVect)
		Local Point:CPVect = Vec2((i + 0.5) * Size + offset.x, (j + 0.5) * Size + offset.y)
		Local tile:ChipmunkCachedTile = Null
		Index.Query(Point, New CPBB.NewForCircle(Point, 0.0), ChipmunkCachedTile.ChipmunkCachedTileQuery, Varptr tile)
		Return tile
	End Method

	Function BBForTileRect:CPBB(rect:TileRect, Size:Double, offset:CPVect)
		Return New CPBB.Create(rect.l * Size + offset.x, rect.b * Size + offset.y, rect.r * Size + offset.x, rect.t * Size + offset.y)
	End Function

	Function TileRectForBB:TileRect(bb:CPBB, Size:Double, offset:CPVect, spt_inv:Double)
		Return New TileRect( ..
			Int(Floor((bb.l - offset.x) / Size - spt_inv)),  ..
			Int(Floor((bb.b - offset.x) / Size - spt_inv)),  ..
			Int(Ceil((bb.r - offset.y) / Size + spt_inv)),  ..
			Int(Ceil((bb.t - offset.y) / Size + spt_inv)) ..
		)
	End Function

	Rem
	bbdoc: Mark a region as needing an update.
	about: Geometry is not regenerated until ensureRect is called.
	EndRem
    Method markDirtyRect(bounds:CPBB)
		Local Size:Double = tileSize
		Local offset:CPVect = tileOffset
		Local rect:TileRect = TileRectForBB(bounds, Size, offset, 1.0 / samplesPerTile)
		
		If Not ensuredDirty And ensuredBB.ContainsBB(BBForTileRect(rect, Size, offset))
			ensuredDirty = True
		End If
		
		For Local i:Int = rect.l Until rect.r
			For Local j:Int = rect.b Until rect.t
				Local tile:ChipmunkCachedTile = GetTileAt(tileIndex, i, j, size, offset)
				If tile Then tile.dirty = True
			Next
		Next
    End Method

	Method pushTile(tile:ChipmunkCachedTile)
		tile.nextTile = Null

		If cacheHead Then cacheHead.nextTile = tile
		tile.prevTile = cacheHead

		cacheHead = tile
		If Not cacheTail Then cacheTail = tile
	End Method

	Method removeTile(tile:ChipmunkCachedTile)
		If (tile.prevTile = Null And cacheTail = tile) Then cacheTail = tile.nextTile
		If (tile.nextTile = Null And cacheHead = tile) Then cacheHead = tile.prevTile
		
		tile.prevTile.nextTile = tile.nextTile
		tile.nextTile.prevTile = tile.prevTile
		
		tile.nextTile = Null
		tile.prevTile = Null
	End Method

	Rem
	bbdoc: Ensure that the given rect has been fully generated and contains no dirty rects.
	EndRem
    Method ensureRect(bounds:CPBB)
		Local time:Double = MilliSecs()	'

		Local Size:Double = tileSize
		Local offset:CPVect = tileOffset
		Local rect:TileRect = TileRectForBB(bounds, Size, offset, 1.0 / samplesPerTile)
		
		Local ensure:CPBB = BBForTileRect(rect, size, offset)
		If Not ensuredDirty And ensuredBB.ContainsBB(ensure) Return

		Local Count:Int = 0	'
		DebugLog("Marching tiles in (" + rect.l + ", " + rect.b + ") - (" + rect.r + ", " + rect.t + "):~n")	'
		For Local i:Int = rect.l Until rect.r
			For Local j:Int = rect.b Until rect.t
				DebugLog("Marching tile (" + i + ", " + j + ")~n")	'

				Local tile:ChipmunkCachedTile = GetTileAt(tileIndex, i, j, Size, offset)
				
				If Not tile
					' tile does Not exist yet, make a New dirty tile.
					' Let the code below push it into the tile list.
					tile = New ChipmunkCachedTile.initWithBB(BBForTileRect(New TileRect(i, j, i + 1, j + 1), Size, offset))
					tile.dirty = True
					
					Local tmp:Size_T = HandleFromObject(tile)
					tileIndex.Insert(tile, tmp)
					Release tmp
					tileCount:+1
				End If
				
				If tile.dirty Then marchTile(tile)
				
				' Move tile To the front of the cache.(Or Add it For the First time)
				removeTile(tile)
				pushTile(tile)
			Next
		Next

		ensuredBB = ensure
		ensuredDirty = False

		' Remove tiles used the longest ago If over the cache Count;
		Local removeCount:Int = tileCount - cacheSize
		For Local i:Int = 0 Until removeCount
			Local tmp:Size_T = HandleFromObject(cachetail)
			tileIndex.Remove(cacheTail, tmp)
			Release(tmp)
			removeShapesForTile(cacheTail)
			removeTile(cacheTail)
			
			tileCount:-1
		Next

	DebugLog("Updated " + Count + " tiles in " + String(MilliSecs() - time) + "ms")	'
    End Method

	Rem
	bbdoc: Override this in a subclass to make custom polygon simplification behavior.
	about: Defaults to CPPolyline.SimplifyCurves(2.0)
	EndRem
    Method simplify:CPPolyline(polyline:CPPolyline)
		Throw "You must override simplify in a subclass"
        Return polyline.simplifyCurves(2.0)
    End Method

	Rem
	bbdoc: Override this method to construct the segment shapes.
	about: By default, it creates a 0 radius segment and sets 1.0 for friction and elasticity and nothing else.
	EndRem
    Method makeSegmentFor:CPSegmentShape(staticBody:CPBody, a:CPVect, b:CPVect)
		Throw "You must override makeSegmentFor in a subclass"
        Local segment:CPSegmentShape = New CPSegmentShape.Create(staticBody, a, b, 0.0)
        segment.SetFriction(1.0)
        segment.SetElasticity(1.0)
        Return segment
    End Method
	
End Type



Rem
bbdoc: Generic tile cache. Configurable enough to be useful for most uses.
EndRem
Type ChipmunkBasicTileCache Extends ChipmunkAbstractTileCache
	Rem
	bbdoc: Threshold value used by CPPolyline.SimplifyCurves().
	EndRem
    Field simplifyThreshold:Double

	Rem
	bbdoc: Radius of the generated segments.
	EndRem
    Field segmentRadius:Double

	Rem
	bbdoc: Friction of the generated segments.
	EndRem
    Field segmentFriction:Double
	Rem
	bbdoc: Elasticity of the generated segments.
	EndRem
    Field segmentElasticity:Double

	Rem
	bbdoc: Collision filter of the generated segments.
	EndRem
    Field segmentFilter:UInt

	Rem
	bbdoc: Collision type of the generated segments.
	EndRem
    Field segmentCollisionType:Size_T

	Method initWithSampler:ChipmunkAbstractTileCache(sampler:ChipmunkAbstractSampler, space:CPSpace, tileSize:Double, samplesPerTile:Size_T, cacheSize:Int)
			Self.simplifyThreshold = 2.0
			
			Self.segmentRadius = 0.0
			
			Self.segmentFriction = 1.0
			Self.segmentElasticity = 1.0
			
			Self.segmentFilter = CP_SHAPE_FILTER_ALL
			
			Self.segmentCollisionType = 0
			
		Super.initWithSampler(sampler, space, tileSize, samplesPerTile, cacheSize)
	End Method

	Method simplify:CPPolyline(polyline:CPPolyline)
		Return polyline.simplifyCurves(simplifyThreshold)
	End Method

	Method makeSegmentFor:CPSegmentShape(staticBody:CPBody, a:CPVect, b:CPVect)
		Local segment:CPSegmentShape = New CPSegmentShape.Create(staticBody, a, b, segmentRadius)
		segment.SetFriction(segmentFriction)
		segment.SetElasticity(segmentElasticity)
		segment.setFilter(segmentFilter)
		segment.SetCollisionType(segmentCollisionType)
		Return segment
	End Method
	
End Type
