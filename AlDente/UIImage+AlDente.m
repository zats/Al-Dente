//
//  UIImage+RawSerialization.m
//  ImageSerialization
//
//  Created by Sasha Zats on 11/9/13.
//  Copyright (c) 2013 Spot.IM. All rights reserved.
//

#import "UIImage+AlDente.h"

NSData *UIImageRAWRepresentation(UIImage *image) {
	CGImageRef cgImage = image.CGImage;
	
	size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
	size_t width = CGImageGetWidth(cgImage);
	size_t height = CGImageGetHeight(cgImage);
	size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
	
	NSMutableData *mutableData = [NSMutableData data];
	
	// Basic image information
	[mutableData appendBytes:&bitsPerPixel length:sizeof(bitsPerPixel)];
	[mutableData appendBytes:&bitsPerComponent length:sizeof(bitsPerComponent)];
	[mutableData appendBytes:&bytesPerRow length:sizeof(bytesPerRow)];
	[mutableData appendBytes:&width length:sizeof(width)];
	[mutableData appendBytes:&height length:sizeof(height)];
	[mutableData appendBytes:&colorSpace length:sizeof(colorSpace)];
	[mutableData appendBytes:&bitmapInfo length:sizeof(bitmapInfo)];
	
	// UIImage information
	CGFloat scale = image.scale;
	UIImageOrientation imageOrientation = image.imageOrientation;
	[mutableData appendBytes:&scale length:sizeof(scale)];
	[mutableData appendBytes:&imageOrientation length:sizeof(imageOrientation)];

	// Raw image data itself
	CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
	CFDataRef cfData = CGDataProviderCopyData(dataProvider);
	[mutableData appendData:(__bridge NSData *)cfData];
	CFRelease(cfData);
	
	return [mutableData copy];	
}

@implementation UIImage (AlDente)

+ (UIImage *)az_imageWithRawData:(NSData *)data {
	size_t bitsPerPixel = 0;
	size_t bitsPerComponent = 0;
	size_t width = 0;
	size_t height = 0;
	size_t bytesPerRow = 0;
	CGColorSpaceRef colorSpace = 0;
	CGBitmapInfo bitmapInfo = 0;
	CGFloat imageScale = 0;
	UIImageOrientation imageOrientation = 0;

	NSUInteger offset = 0;
	[data getBytes:&bitsPerPixel range:NSMakeRange(offset, sizeof(bitsPerPixel))];
	offset += sizeof(bitsPerPixel);
	
	[data getBytes:&bitsPerComponent range:NSMakeRange(offset, sizeof(bitsPerComponent))];
	offset += sizeof(bitsPerComponent);
	
	[data getBytes:&bytesPerRow range:NSMakeRange(offset, sizeof(bytesPerRow))];
	offset += sizeof(bytesPerRow);
	
	[data getBytes:&width range:NSMakeRange(offset, sizeof(width))];
	offset += sizeof(width);
	
	[data getBytes:&height range:NSMakeRange(offset, sizeof(height))];
	offset += sizeof(height);
	
	[data getBytes:&colorSpace range:NSMakeRange(offset, sizeof(colorSpace))];
	offset += sizeof(colorSpace);
	
	[data getBytes:&bitmapInfo range:NSMakeRange(offset, sizeof(bitmapInfo))];
	offset += sizeof(bitmapInfo);
	
	[data getBytes:&imageScale range:NSMakeRange(offset, sizeof(imageScale))];
	offset += sizeof(imageScale);
	
	[data getBytes:&imageOrientation range:NSMakeRange(offset, sizeof(imageOrientation))];
	offset += sizeof(imageOrientation);
	
	
	data = [data subdataWithRange:NSMakeRange(offset, [data length] - offset)];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	CGImageRef cgImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, provider, NULL, NO, kCGRenderingIntentDefault);
	UIImage *result = [UIImage imageWithCGImage:cgImage
										  scale:imageScale
									orientation:imageOrientation];
	CFRelease(provider);
	CFRelease(cgImage);
	return result;
}

@end
