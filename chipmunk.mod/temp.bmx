
' CG-related placeholders (these would be provided by an external library in actual use)
Function CGBitmapContextCreate:TPixmap(Data:TPixmap, Width:Size_T, Height:Size_T, bpc:Size_T, stride:Size_T, colorSpace:Byte ptr, bitmapInfo:Size_T)
DebugStop
	If Data
	End If
    Return CreatePixmap(Width, Height, PF_RGBA8888)
End Function

Function CGBitmapContextGetBitsPerComponent:UInt(context:Byte Ptr)
DebugStop
    Return 8
End Function

Function CGBitmapContextGetBitsPerPixel:UInt(context:Byte Ptr)
DebugStop
    Return 32
End Function

Function CGContextDrawImage(context:Byte Ptr, x:Int, y:Int, Width:Size_T, Height:Size_T, image:Byte Ptr)
DebugStop
End Function

Function CGContextRelease(context:Byte Ptr)
DebugStop
End Function

Function CGImageSourceCreateWithURL:Byte ptr(url:String)
DebugStop
    Return Byte Ptr(PixmapPixelPtr(LoadPixmap(url))) ' Simulating a CGImageSourceRef
End Function

Function CGImageSourceCreateImageAtIndex:Byte ptr(source:Byte Ptr, Index:Int, options:Byte Ptr)
DebugStop
    Return Byte Ptr(source[Index]) ' Simulating a CGImageRef
End Function

Function CGImageGetWidth:uint(image:Byte Ptr)
DebugStop
    Return 1024
End Function

Function CGImageGetHeight:uint(image:Byte Ptr)
DebugStop
    Return 768
End Function

Function CGColorSpaceCreateDeviceGray:Byte Ptr()
DebugStop
    Return Byte Ptr(BankBuf(CreateBank(256)))
End Function

Function CGColorSpaceRelease(colorSpace:Byte Ptr)
DebugStop
End Function

Function CGImageRelease(image:Byte Ptr)
DebugStop
End Function
