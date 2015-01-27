#import "ZintImage.h"
#import "zint.h"

@implementation ZintImage

+ (UIImage *)imageForQRcode:(NSString *)code {
  return [self imageForBarcode:code symbology:BARCODE_QRCODE];
}

+ (UIImage *)imageForBarcode:(NSString *)code symbology:(int)symbology {
  int scale = [[UIScreen mainScreen] scale];
  return [self imageForBarcode:code symbology:symbology scale:scale];
}


+ (UIImage *)imageForBarcode:(NSString *)code symbology:(int)symbology scale:(int)scale {
  struct zint_symbol *barcode_symbol = ZBarcode_Create();
  barcode_symbol->symbology = symbology;
  barcode_symbol->scale = scale;

  ZBarcode_Encode(barcode_symbol, (void *)str, sizeof(str));
  ZBarcode_Buffer(barcode_symbol, 0);

  UIImage *img = [self imageFromRGB:barcode_symbol->bitmap width:barcode_symbol->bitmap_width height:barcode_symbol->bitmap_height];
  //NSLog(@"img size: %@", NSStringFromCGSize(img.size));

  ZBarcode_Delete(barcode_symbol);
  return img;
}

+ (UIImage *)imageFromRGB:(unsigned char *)buffer width:(int)width height:(int)height {
  UIImage *image = nil;

  char* rgba = (char*)malloc(width*height*4);
  for(int i=0; i < width*height; ++i) {
    rgba[4*i] = buffer[3*i];
    rgba[4*i+1] = buffer[3*i+1];
    rgba[4*i+2] = buffer[3*i+2];
    rgba[4*i+3] = 0;
  }


  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast;

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef bitmapContext = CGBitmapContextCreate(
    rgba,
    width,
    height,
    8, // bitsPerComponent
    4*width, // bytesPerRow
    colorSpace,
    bitmapInfo);

  CFRelease(colorSpace);

  CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);


  image = [UIImage imageWithCGImage:cgImage];

  CFRelease(cgImage);
  CFRelease(bitmapContext);

  free(rgba);
  return image;
}

@end
