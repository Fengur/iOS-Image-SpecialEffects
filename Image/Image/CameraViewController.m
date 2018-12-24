//
//  CameraViewController.m
//  Image
//
//  Created by fengur on 2018/12/24.
//  Copyright © 2018 fengur. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageViewController.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    ImageViewController *imageControl;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageControl = [[ImageViewController alloc]init];
    [self configImageViewController];
}

- (void)configImageViewController{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (__bridge NSString *)kUTTypeImage;
    imagePicker.mediaTypes = @[mediaType];
    imagePicker.delegate = self;
    [self.navigationController presentViewController:imagePicker animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        unsigned char *imageData = [imageControl convertImageToData:image];
        unsigned char *imageDataNew = [imageControl imageGrayWithData:imageData imageWidth:image.size.width imageHeight:image.size.height];
        UIImage *imageNew = [imageControl convertDataToUIImage:imageDataNew originImage:image];
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
