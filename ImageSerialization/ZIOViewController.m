//
//  ZIOViewController.m
//  ImageSerialization
//
//  Created by Sasha Zats on 11/9/13.
//  Copyright (c) 2013 Spot.IM. All rights reserved.
//

#import "ZIOViewController.h"

#import "UIImage+AlDente.h"

@interface ZIOViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *originalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *recomposedImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, strong) UIImage *originalImage;

@end

@implementation ZIOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.originalImage = [UIImage imageNamed:@"Abstract.jpg"];		
	self.view.backgroundColor = [UIColor colorWithPatternImage:self.originalImage];
}

- (IBAction)_sliderHandler:(id)sender {
	NSLog(@"Nubmer of iterations: %.0f", self.slider.value);
}

- (IBAction)_rawButtonHandler:(id)sender {
	self.originalImageView.image = self.originalImage;
	self.recomposedImageView.image = nil;

	__block UIImage *newImage;
	__block NSData *data;
	[self _measureTimeOfExecutionWithLabel:@"RAW encoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				data = [self _rawDataWithImage:self.originalImage];
			}
		}
	}];
	NSLog(@"Data size: %db", [data length]);
	[self _measureTimeOfExecutionWithLabel:@"RAW decoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				newImage = [self _imageWithRawData:data];
			}
		}
	}];
	
	self.recomposedImageView.image = newImage;
}

- (IBAction)_jpgButtonHandler:(id)sender {
	self.originalImageView.image = self.originalImage;
	self.recomposedImageView.image = nil;
	
	__block UIImage *newImage;
	__block NSData *data;
	[self _measureTimeOfExecutionWithLabel:@"JPG encoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				data = [self _JPGDataWithImage:self.originalImage];
			}
		}
	}];
	NSLog(@"Data size: %db", [data length]);
	[self _measureTimeOfExecutionWithLabel:@"JPG decoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				newImage = [self _imageWithJPGData:data];
			}
		}
	}];
	self.recomposedImageView.image = newImage;
}

- (IBAction)_pngButtonHandler:(id)sender {
	self.originalImageView.image = self.originalImage;
	self.recomposedImageView.image = nil;
	
	__block UIImage *newImage;
	__block NSData *data;
	[self _measureTimeOfExecutionWithLabel:@"PNG encoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				data = [self _PNGDataWithImage:self.originalImage];
			}
		}
	}];
	NSLog(@"Data size: %db", [data length]);
	[self _measureTimeOfExecutionWithLabel:@"PNG decoding" block:^{
		for (NSUInteger i = 0 ; i < self.slider.value; ++i) {
			@autoreleasepool {
				newImage = [self _imageWithPNGData:data];
			}
		}
	}];
	self.recomposedImageView.image = newImage;
}

- (NSData *)_PNGDataWithImage:(UIImage *)image {
	return UIImagePNGRepresentation(image);
}

- (UIImage *)_imageWithPNGData:(NSData *)data {
	return [UIImage imageWithData:data];
}

- (NSData *)_JPGDataWithImage:(UIImage *)image {
	return UIImageJPEGRepresentation(image, 0.75);
}

- (UIImage *)_imageWithJPGData:(NSData *)data {
	return [UIImage imageWithData:data];
}

- (NSData *)_rawDataWithImage:(UIImage *)image {
	return UIImageRAWRepresentation(image);
}

- (UIImage *)_imageWithRawData:(NSData *)data {
	return [UIImage az_imageWithRawData:data];
}

- (void)_measureTimeOfExecutionWithLabel:(NSString *)label block:(void(^)(void))block {
	NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
	block();
	NSTimeInterval finish = [[NSDate date] timeIntervalSince1970];
	NSLog(@"%@: %f", label, ((finish - start) * 1000) / self.slider.value);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
