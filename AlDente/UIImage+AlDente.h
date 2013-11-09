//
//  UIImage+RawSerialization.h
//  ImageSerialization
//
//  Created by Sasha Zats on 11/9/13.
//  Copyright (c) 2013 Spot.IM. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSData *UIImageRAWRepresentation(UIImage *image);

@interface UIImage (AlDente)

+ (UIImage *)az_imageWithRawData:(NSData *)data;

@end
