
SuperStrict

Framework brl.d3d9max2d

Import image.png

Import hot.chipmunk

Import "../ChipmunkDemo.bmx"
Import "Demo.bmx"

Type ImageDemo Extends demo
	Private
	Field space:CPSpace
	Public
	
	Method New()
		Self.space = New CPSpace.Create()
		Self.space.SetGravity(Vec2(0, 100))
		
		Self.marchImage()
		
	End Method

	Method marchImage()
		' Create a sampler for a mask image
		Local image_url:String = "TestImage.png" ' URL to the PNG image file

		' ChipmunkImageSampler loads images using brl.stream and can load any image type it can (in this case a .png).
		Local sampler:ChipmunkImageSampler = New ChipmunkImageSampler.samplerWithImageFile(image_url, True)
		
		Local lines:CPPolylineSet = sampler.marchAllWithBorder(True, False)
	DebugLog "Number of polylines: " + lines.Count()
		For Local line:UInt = 0 Until lines.Count()
			Local currentPolyline:CPPolyline = lines.lineAtIndex(line)
			If currentPolyline.isClosed() And currentPolyline.area() > 0 Then
				Local hull:CPPolyline = currentPolyline.ToConvexHull().SimplifyVertexes(0.5).SimplifyCurves(1)
				DebugLog "hull: " + (hull.Count() - 1)
				
				Local centroid:CPVect = currentPolyline.Centroid()
				
				Local mass:Double = currentPolyline.Area() * 1.0
				Local moment:Double = currentPolyline.MomentForMass(mass, centroid.Negate())
				Local body:CPBody = New CPBody.Create(mass, moment)
				Self.space.AddBody(body)
				body.SetPosition(centroid)
				
				' Define the transformation and radius
				Local Transform:CPTransform = CPTransform.Translate(centroid.Negate())
				Local radius:Double = 0.0
				
				Local shape:CPPolyShape = hull.asChipmunkPolyShapeWithBody(body, Transform, radius)
				Self.space.AddShape(shape)
				shape.SetFriction(0.3)
			Else
				Local simple:CPPolyline = currentPolyline.SimplifyCurves(3)
				DebugLog "count: " + (simple.Count() - 1)
				
				Local segments:TList = simple.asChipmunkSegmentsWithBody(Self.space.GetStaticBody(), 2, CPVZero)
				For Local segment:CPShape = EachIn segments
					Self.space.AddShape(segment)
					segment.SetFriction(1.0)
				Next
			EndIf
		Next
	End Method
	
	Method Delete()
		Self.space = Null

	End Method

	Method leftMouse(Pos:CPVect)
	End Method
	Method rightMouse(Pos:CPVect)
	End Method
	Method drag(Pos:CPVect)
	End Method

	Method DoStep(dt:Double, bounds:CPBB)
		space.DoStep(dt)
	End Method

	Method drawOverlay()
		ChipmunkDemoTextDrawString(Vec2(20, 460),  ..
			"Controls:~n" + ..
			"Return to restart the demo.~n" + ..
			"Edit 'TestImage.png' in the app bundle to change the simulation.~n" ..
		)
	End Method

End Type

Global demo:imagedemo
Function updateSpace(space:CPSpace, dt:Double)
	demo.DoStep(dt, Null)
End Function
Function initSpace:CPSpace()
	demo = New ImageDemo
	Return demo.space
End Function
Function destroySpace(space:CPSpace)
'	demo.Delete
End Function
Global AutoGeometry:ChipmunkDemo = New ChipmunkDemo( ..
	"Chipmunk Pro: AutoGeometry",  ..
	1.0 / 60.0,  ..
	..
	InitSpace,  ..
	updateSpace,  ..
	ChipmunkDemoDefaultDrawImpl,  ..
	destroySpace ..
, -16)
