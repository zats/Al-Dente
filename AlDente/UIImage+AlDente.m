//
//  UIImage+RawSerialization.m
//  ImageSerialization
//
//  Created by Sasha Zats on 11/9/13.
//  Copyright (c) 2013 Spot.IM. All rights reserved.
//

#import "UIImage+AlDente.h"

static const NSUInteger AZSignature = 'zraw';

NSData *UIImageRAWRepresentation(UIImage *image) {
	CGImageRef cgImage = image.CGImage;
	
	NSMutableData *mutableData = [NSMutableData dataWithBytes:&AZSignature
													   length:sizeof(AZSignature)];

	// Basic image information
	size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
	size_t width = CGImageGetWidth(cgImage);
	size_t height = CGImageGetHeight(cgImage);
	size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
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
	NSUInteger signature = 0;
	[data getBytes:&signature range:NSMakeRange(0, sizeof(signature))];
	if (signature != AZSignature){
		return nil;
	}

	NSUInteger offset = 4;

	size_t bitsPerPixel = 0;
	[data getBytes:&bitsPerPixel range:NSMakeRange(offset, sizeof(bitsPerPixel))];
	offset += sizeof(bitsPerPixel);
	
	size_t bitsPerComponent = 0;
	[data getBytes:&bitsPerComponent range:NSMakeRange(offset, sizeof(bitsPerComponent))];
	offset += sizeof(bitsPerComponent);
	
	size_t bytesPerRow = 0;
	[data getBytes:&bytesPerRow range:NSMakeRange(offset, sizeof(bytesPerRow))];
	offset += sizeof(bytesPerRow);
	
	size_t width = 0;
	[data getBytes:&width range:NSMakeRange(offset, sizeof(width))];
	offset += sizeof(width);
	
	size_t height = 0;
	[data getBytes:&height range:NSMakeRange(offset, sizeof(height))];
	offset += sizeof(height);
	
	CGColorSpaceRef colorSpace = 0;
	[data getBytes:&colorSpace range:NSMakeRange(offset, sizeof(colorSpace))];
	offset += sizeof(colorSpace);
	
	CGBitmapInfo bitmapInfo = 0;
	[data getBytes:&bitmapInfo range:NSMakeRange(offset, sizeof(bitmapInfo))];
	offset += sizeof(bitmapInfo);
	
	CGFloat imageScale = 0;
	[data getBytes:&imageScale range:NSMakeRange(offset, sizeof(imageScale))];
	offset += sizeof(imageScale);
	
	UIImageOrientation imageOrientation = 0;
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
