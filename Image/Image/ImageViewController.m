//
//  ImageViewController.m
//  Image
//
//  Created by fengur on 2018/12/20.
//  Copyright © 2018 fengur. All rights reserved.
//  Todo https://www.bountysource.com/issues/59471475-fix-invalid-image-alphainfo-error buf_fixed


#import "ImageViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ImageViewController (){
    UIImageView *imageView;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
    UIImageView *imageView5;
}

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
    [self convertFormatTest];
    [self testImageGray];
    [self testReColor];
    [self testImageReColorAgain];
    [self testImageHighlight];
}

- (void)testImageHighlight{
    UIImage *image = [UIImage imageNamed:@"image1.png"];
    unsigned char *imageData = [self convertImageToData:image];
    unsigned char *imageDataNew = [self imageHighlightWithData:imageData imageWidth:image.size.width imageHeight:image.size.height];
    UIImage *newImage = [self convertDataToUIImage:imageDataNew originImage:image];
    imageView5.image = newImage;
}

- (void)testImageReColorAgain{
    UIImage *image = [UIImage imageNamed:@"image1.png"];
    unsigned char *imageData = [self convertImageToData:image];
    unsigned char *imageDataGray = [self imageGrayWithData:imageData imageWidth:image.size.width imageHeight:image.size.height];
    unsigned char *imageDataNew = [self imageRecolorWithData:imageDataGray imageWidth:image.size.width imageHeight:image.size.height];
    UIImage *newImage = [self convertDataToUIImage:imageDataNew originImage:image];
    imageView4.image = newImage;
}

- (void)testImageGray{
    UIImage *image = [UIImage imageNamed:@"image1.png"];
    unsigned char *imageData = [self convertImageToData:image];
    unsigned char *imageDataNew = [self imageGrayWithData:imageData imageWidth:image.size.width imageHeight:image.size.height];
    UIImage *newImage = [self convertDataToUIImage:imageDataNew originImage:image];
    imageView2.image = newImage;
}

- (void)testReColor{
    UIImage *image = [UIImage imageNamed:@"image1.png"];
    unsigned char *imageData = [self convertImageToData:image];
    unsigned char *imageDataNew = [self imageRecolorWithData:imageData imageWidth:image.size.width imageHeight:image.size.height];
    UIImage *newImage = [self convertDataToUIImage:imageDataNew originImage:image];
    imageView3.image = newImage;
}

- (void)convertFormatTest{
    UIImage *testImage = [UIImage imageNamed:@"image1.png"];
    unsigned char *imageData = [self convertImageToData:testImage];
    UIImage *imageNew = [self convertDataToUIImage:imageData originImage:testImage];
    imageView1.image = imageNew;
}

- (void)loadImage{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 160, 160)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"image1.png"];
    
    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30+160+30, 30, 160, 160)];
    imageView1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:imageView1];
    
    imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30+160+30, 160, 160)];
    imageView2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:imageView2];
    
    imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(30+160+30, 30+160+30, 160, 160)];
    imageView3.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:imageView3];
    
    imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30+160+30+30+160, 160, 160)];
    imageView4.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:imageView4];
    
    imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(30+160+30, 30+160+30+30+160, 160, 160)];
    [self.view addSubview:imageView5];
}

// unsigned char* C指针
// 1、UIImage-> CGImage
// 2、CGColorSpace
// 3、分配Bit级空间
// 4、CGBitmap
// 5、渲染
- (unsigned char*)convertImageToData:(UIImage *)image{
    CGImageRef imageRef = [image CGImage];
    CGSize imageSize = image.size;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 每个像素点 4个Byte (R G B A)
    // 像素点的个数等于当前图片的宽*高
    // 宽*高*4 等于图片的字节数
    // malloc:内存分配
    void *data = malloc(imageSize.width*imageSize.height*4);
    
    // 1 data
    // 2 width
    // 3 height
    // 4 每个元素的位数 RGBA 一个字节8位
    // 5 每行的字节数
    // 6 颜色空间
    // 7 kCGImageAlphaPremultipliedLast 当前颜色排列顺序 kCGBitmapByteOrder32Big RGBA每个4字节 4*8 = 32
    CGContextRef context = CGBitmapContextCreate(data, imageSize.width, imageSize.height, 8, imageSize.width*4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    // 1 CGBitmap
    // 2 CGRectMake
    // 3 imageRef
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), imageRef);
    
    // UIImage->data
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return (unsigned char*)data;
}


- (UIImage *)convertDataToUIImage:(unsigned char *)imageData originImage:(UIImage *)imageSource{
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    NSInteger dataLength = width*height*4;
    // 1 一般用NULL
    // 2 imagedata
    // 3 datalength
    // 4 一般用NULL
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL);
    // 每一个元素占用的位数
    int bitsPerComponend = 8;
    // 每个点占用的位数 （4个元素）
    int bitsPerPixel = 32;
    // 每一行占用的字节
    int bytesPerRow = 4*width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    // 1 imageWidth
    // 2 imageHeight
    // 3 每一个元素占用bit的位数
    // 4 每一个像素点占用的bit位数
    // 5 每一行有多少字节
    // 6 颜色空间
    // 7 bitmap 描述信息
    // 8 原始数据
    // 9 NULL 解码
    // 10 暂时设为NO
    // 11 渲染
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponend, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderIntent);
    UIImage *imageNew = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return imageNew;
}

- (unsigned char *)imageGrayWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight{
    // 1 分配内存空间 == image == width *height *4
    unsigned char *resultData = malloc(imageWidth*imageHeight*4*sizeof(unsigned char));
    // 1 resultdata
    // 2 0
    // 3 内存大小
    // 将申请的内存空间清0
    memset(resultData, 0, imageWidth*imageHeight*4*sizeof(unsigned char));
    for (int h =0;h<imageHeight;h++){
        for(int w=0;w<imageWidth;w++){
            unsigned int imageIndex = h*imageWidth+w;
            // 像素RGBA 一共4B
            // 取出所有的RGB值
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            // 系统推荐方法
            int bitMap = bitMapRed *77/255+bitMapGreen*151/255+bitMapBlue*88/255;
            // 可以用但是不推荐
            // int bitMap = (bitMapRed + bitMapGreen + bitMapBlue)/3;
            unsigned char newBitMap = (bitMap>255)?255:bitMap;
            memset(resultData+imageIndex*4, newBitMap, 1);
            memset(resultData+imageIndex*4+1, newBitMap, 1);
            memset(resultData+imageIndex*4+2, newBitMap, 1);
        }
    }
    return resultData;
}

- (unsigned char *)imageRecolorWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight{
    // 1 分配内存空间 == image == width *height *4
    unsigned char *resultData = malloc(imageWidth*imageHeight*4*sizeof(unsigned char));
    // 1 resultdata
    // 2 0
    // 3 内存大小
    // 将申请的内存空间清0
    memset(resultData, 0, imageWidth*imageHeight*4*sizeof(unsigned char));
    for (int h =0;h<imageHeight;h++){
        for(int w=0;w<imageWidth;w++){
            unsigned int imageIndex = h*imageWidth+w;
            // 像素RGBA 一共4B
            // 取出所有的RGB值
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            
            unsigned char newBitMapRed = 255-bitMapRed;
            unsigned char newBitMapGreen = 255-bitMapGreen;
            unsigned char newBitMapBlue = 255-bitMapBlue;
            
            memset(resultData+imageIndex*4, newBitMapRed, 1);
            memset(resultData+imageIndex*4+1, newBitMapGreen, 1);
            memset(resultData+imageIndex*4+2, newBitMapBlue, 1);
        }
    }
    return resultData;
}

- (unsigned char *)imageHighlightWithData:(unsigned char *)imageData imageWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight{
    unsigned char *resultData = malloc(imageWidth*imageHeight*sizeof(unsigned char)*4);
    memset(resultData, 0, imageHeight*imageWidth*sizeof(unsigned char)*4);
    NSArray *colorArrayBase = @[@"55",@"110",@"155",@"185",@"220",@"240",@"250",@"255"];
    NSMutableArray *colorArray = [[NSMutableArray alloc]init];
    int beforeNum = 0;
    for(int i = 0;i<8;i++){
        NSString *colorStr = [colorArrayBase objectAtIndex:i];
        int num = colorStr.intValue;
        float step = 0;
        if(i == 0){
            step = num/32.0;
            beforeNum = num;
        }else{
            step = (num-beforeNum)/32.0;
        }
        for(int j =0;j<32;j++){
            int newNum = 0;
            if(i == 0){
                newNum = (int)(j*step);
            }else{
                newNum = (int)(beforeNum+j*step);
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d",newNum];
            [colorArray addObject:newNumStr];
        }
        beforeNum = num;
    }
    
    for (int h =0;h<imageHeight;h++){
        for(int w=0;w<imageWidth;w++){
            unsigned int imageIndex = h*imageWidth+w;
            // 像素RGBA 一共4B
            // 取出原有的RGB值
            unsigned char bitMapRed = *(imageData+imageIndex*4);
            unsigned char bitMapGreen = *(imageData+imageIndex*4+1);
            unsigned char bitMapBlue = *(imageData+imageIndex*4+2);
            
            // colorArray index:(0-255) value
            NSString *redStr = [colorArray objectAtIndex:bitMapRed];
            NSString *greedStr = [colorArray objectAtIndex:bitMapGreen];
            NSString *blueStr = [colorArray objectAtIndex:bitMapBlue];
            
            unsigned char bitMapRedNew = redStr.intValue;
            unsigned char bitMapGreenNew = greedStr.intValue;
            unsigned char bitMapBlueNew = blueStr.intValue;
            
            memset(resultData+imageIndex*4, bitMapRedNew, 1);
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
        }
    }
    return resultData;
}


@end
