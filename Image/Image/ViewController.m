//
//  ViewController.m
//  Image
//
//  Created by fengur on 2018/12/20.
//  Copyright © 2018 fengur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIImageView *containImageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    containImageView = [[UIImageView alloc]init];
    containImageView.frame = CGRectMake(0, 100, 500, 300);
    [self.view addSubview:containImageView];
    containImageView.clipsToBounds = YES;
    [self pngToJpg];
}

- (void)imageShow{
    containImageView.image = [UIImage imageNamed:@"j1.jpg"];
}

- (void)jpgToPng{
    UIImage *image = [UIImage imageNamed:@"j1.png"];
    NSData *data = UIImagePNGRepresentation(image);
    UIImage *imagePng = [UIImage imageWithData:data];
    containImageView.image = imagePng;
}

- (void)pngToJpg{
    UIImage *image = [UIImage imageNamed:@"p1.png"];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    UIImage *imageJpg = [UIImage imageWithData:data];
    containImageView.image = imageJpg;
}

@end
