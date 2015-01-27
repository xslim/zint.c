

@interface ZintImage
+ (UIImage *)imageForQRcode:(NSString *)code
+ (UIImage *)imageForBarcode:(NSString *)code symbology:(int)symbology
+ (UIImage *)imageForBarcode:(NSString *)code symbology:(int)symbology scale:(int)scale

+ (UIImage *)imageFromRGB:(unsigned char *)buffer width:(int)width height:(int)height
@end
