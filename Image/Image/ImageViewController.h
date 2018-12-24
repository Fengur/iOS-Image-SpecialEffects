//
//  ImageViewController.h
//  Image
//
//  Created by fengur on 2018/12/20.
//  Copyright © 2018 fengur. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageViewController : UIViewController

- (unsigned char*)convertImageToData:(UIImage *)image;

- (UIImage *)convertDataToUIImage:(unsigned char *)imageData originImage:(UIImage *)imageSource;

- (UIImage *)convertDataToUIImage:(unsigned char *)imageData originImage:(UIImage *)imageSource;

- (unsigned char *)imageGrayWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

- (unsigned char *)imageRecolorWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

- (unsigned char *)imageHighlightWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

@end

NS_ASSUME_NONNULL_END
