//
//  wheel.m
//  方向盘
//
//  Created by Heaton on 2018/3/15.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "wheel.h"

@interface wheel ()
@property(nonatomic,strong) UIImageView *rotationImageView;
@property(nonatomic) CGFloat lastRotation;
@property(nonatomic,strong) UIRotationGestureRecognizer *rotationGest;
// 滑帽初始化位置
@property(nonatomic,assign) int angle;
@property(nonatomic,assign) CGFloat currentAngle;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
@property(nonatomic,assign) BOOL isStop;
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
@property(nonatomic,assign) CGFloat angleFloat;
@end

@implementation wheel

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
    self.rotationImageView.frame = CGRectMake(0,0,300,300);
    self.rotationImageView.center = self.view.center;
    self.rotationImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.rotationImageView];
    
    self.centerX = self.view.center.x;
    self.centerY = self.view.center.y;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"开始移动");
//    UITouch *touch = [touches anyObject];
//    //self.tranformView，你想旋转的视图
//    if (![touch.view isEqual:self.rotationImageView]) {
//        return;
//    }
//    NSUInteger toucheNum = [[event allTouches] count];//有几个手指触摸屏幕
//    if (toucheNum <= 2 ) {
//        CGPoint center = CGPointMake(CGRectGetMidX([touch.view bounds]), CGRectGetMidY([touch.view bounds]));
//        CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
//        CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x);
//        self.angleFloat = 0;
//    }
//}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //self.tranformView，你想旋转的视图
    if (![touch.view isEqual:self.rotationImageView]) {
        return;
    }
    NSUInteger toucheNum = [[event allTouches] count];//有几个手指触摸屏幕
    if (toucheNum <= 2 ) {
        CGPoint center = CGPointMake(CGRectGetMidX([touch.view bounds]), CGRectGetMidY([touch.view bounds]));
        CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
        CGPoint previousPoint = [touch previousLocationInView:touch.view];//上一个坐标
        
        CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x) - atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
        CGFloat currentAngle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x);
        float a = self.angleFloat + ToDeg(angle);
        

        if (angle <= -M_PI/4 || angle >= M_PI/4) {
            
            return;
        }

        self.angleFloat += ToDeg(angle);
        if (self.angleFloat>60) {
            self.angleFloat = 60;
        }
        if (self.angleFloat<-60) {
            self.angleFloat = -60;
        }
        NSLog(@"当前角度%.2f偏移角度%.2f",self.angleFloat,ToDeg(angle));
        if(self.angleFloat<60 && self.angleFloat > -60){
            
            self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform, angle);
            if(angle<0.0){
                NSLog(@"向左");
            }else{
                NSLog(@"向右");
            }
            
        }

//        NSLog(@"============angle:%.2f",self.angleFloat);
//        CGAffineTransform _trans = self.rotationImageView.transform;
//        CGFloat rotate = acosf(_trans.a);
//        // 旋转180度后，需要处理弧度的变化
//        if (_trans.b < 0) {
//            rotate = M_PI -rotate;
//        }
//        // 将弧度转换为角度
//        CGFloat degree = rotate/M_PI * 180;
//
//        if(degree >= 80){
//            NSLog(@"--角度减小,degree:%.2f",degree);
//            if(degree <=130 && degree > 10){
//                return;
//            }
//        }else{
//            NSLog(@"--角度增加,degree:%.2f",degree);
//            if(degree >= 50){
//                self.currentAngle = 50;
//                return;
//            }
//        }
//
//        self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform, angle);
//        CGAffineTransform currentTrans = self.rotationImageView.transform;
//        CGFloat currentRotate = acosf(currentTrans.a);
//        // 旋转180度后，需要处理弧度的变化
//        if (_trans.b < 0) {
//            currentRotate = M_PI -currentRotate;
//        }
//        // 将弧度转换为角度
//        CGFloat currentDegree = rotate / M_PI * 180;
//        NSLog(@"角度是:%.2f",currentDegree);
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.rotationImageView.transform =  CGAffineTransformIdentity;
    self.angleFloat = 0.0;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.rotationImageView.transform =  CGAffineTransformIdentity;
    self.angleFloat = 0.0;
}



-(CGFloat)getDistance:(CGPoint)pointA withPointB:(CGPoint)pointB
{
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    
    return sqrt(x*x + y*y);
}

-(CGFloat)getRadius:(CGPoint)pointA withPointB:(CGPoint)pointB
{
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return atan2(x, y);
}
@end
