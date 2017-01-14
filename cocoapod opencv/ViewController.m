//
//  ViewController.m
//  cocoapod opencv
//
//  Created by 董建新 on 2017/1/13.
//  Copyright © 2017年 Jacob Dong. All rights reserved.
//

#import "CVWrapper.h"


#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

//  设备管理者
@property (strong, nonatomic) CMMotionManager *mgr;

//  记录xyz的点
@property (assign, nonatomic) CGFloat xPoint;
@property (assign, nonatomic) CGFloat yPoint;
@property (assign, nonatomic) CGFloat zPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mgr = [[CMMotionManager alloc] init];
    
    [self stitch];
    
    

}

-(void)stitch{
    
    
       dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        
           UIImage* image1 = [UIImage imageNamed:@"pano_19_16_mid"];
           UIImage* image2 = [UIImage imageNamed:@"pano_19_20_mid"];
           UIImage* image3 = [UIImage imageNamed:@"pano_19_22_mid"];
           UIImage* image4 = [UIImage imageNamed:@"pano_19_25_mid"];
           
           
           NSArray* imageArray = @[image1,image2,image3,image4];
           
           UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
           

           
           
           
           
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //  创建一个imageview
            self.imageView = [[UIImageView alloc] initWithImage:stitchedImage];
            
            
            //  注意要设置小了 scroll view  但是将contentsize设置大
            UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
            
            self.scrollView = scrollView;
            
            [scrollView addSubview:self.imageView];
            
            scrollView.contentSize = self.imageView.bounds.size;
            
            scrollView.maximumZoomScale = 4;
            scrollView.minimumZoomScale = 0.4;
            
            scrollView.delegate = self;
            
            
            scrollView.contentOffset = CGPointMake(0,0);
            

            
            
            [self.view addSubview:self.scrollView];

            [self startDeviceMotion];
            
        });
        
        
        
    });
    
    
    
}


-(void)startDeviceMotion{
    
    if (self.mgr.deviceMotionAvailable) {
        
        [self.mgr startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
           
            self.xPoint = motion.rotationRate.x;
            self.yPoint = motion.rotationRate.y;
            self.zPoint = motion.rotationRate.z;
            
//            self.scrollView.contentOffset = CGPointMake(self.xPoint, self.yPoint);
            
            
        }];
        
        
        
    }
    
    
}




-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
