//
//  ViewController.m
//  方向盘
//
//  Created by Heaton on 2018/2/24.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIImageView *rotationImageView;
@property(nonatomic) CGFloat lastRotation;
@property(nonatomic,strong) UIRotationGestureRecognizer *rotationGest;
// 滑帽初始化位置
@property(nonatomic,assign) int angle;
@property(nonatomic,assign) CGFloat addAngle;

@property(nonatomic,assign) CGPoint centerPoint;
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGFloat deta_degree;
@property(nonatomic,assign) CGFloat tempAngle;
@property(nonatomic,assign) CGFloat startAngle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
    self.rotationImageView.frame = CGRectMake(0,0,300,300);
    self.rotationImageView.center = self.view.center;
    self.rotationImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.rotationImageView];
    // test code
    self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform, ToRad(0));
    CGAffineTransform _trans = self.rotationImageView.transform;
    CGFloat rotate = acosf(_trans.a)+acosf(_trans.b);
    CGFloat angle = ToDeg(rotate);
    NSLog(@"旋转了%.2f度",angle);
    
    // 设置中心点
    self.centerPoint = self.rotationImageView.center;
    NSLog(@"centerX:%.2f------centerY:%.2f",self.centerPoint.x,self.centerPoint.y);
    self.addAngle = 0;
//
//    UIPanGestureRecognizer *pansGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePans:)];
//    [pansGesture setMaximumNumberOfTouches:1];
//
//    [self.rotationImageView addGestureRecognizer:pansGesture];
}

//- (void)handlePans:(UIPanGestureRecognizer *)sender
//{
//    CGPoint translationPoint = [sender velocityInView:self.view];
//    self.rotationImageView.transform = CGAffineTransformMakeRotation(sender.view.center.x+translationPoint.x);
//}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.rotationImageView]) {
        return;
    }
    CGPoint currentPoint = [touch locationInView:self.view];//当前手指的坐标
    self.startPoint = currentPoint;
    self.startAngle = [self detaDegreeWithX:self.centerPoint.x Y:self.centerPoint.y targetX:self.startPoint.x targetY:self.startPoint.y];
    self.tempAngle = self.startAngle;
    self.addAngle = 0;
    NSLog(@"开始角度%.2f",self.startAngle);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    CGPoint endPoint = [touch locationInView:self.view];
    // 根据触摸位置计算角度
    CGFloat angle = [self detaDegreeWithX:self.centerPoint.x Y:self.centerPoint.y targetX:endPoint.x targetY:endPoint.y];
    
    CGFloat deteAngle = angle - self.tempAngle;
    self.tempAngle = angle;
    NSLog(@"当前角度:%.2f---偏移角度:%.2f",self.addAngle,deteAngle);
    //当手指转了一圈回到原点，角度变化值为360，直接不作任何操作，下一次进入已经过了临界点再执行动画，角度变化就是渐变的，此处跳变不需要进行动画转到极限位置
    if (deteAngle <= -270 || deteAngle >= 270) {

        return;
    }
    //累加偏移的角度
    self.addAngle += deteAngle;
    //渐变累加角度超过60，或者当手指从一端划到对称的另一端，则是180度直接跳变，肯定会超过60的标准，直接给他还原最大或最小的极限----即无论是渐变还是跳变超过极限，都给他回位
    if (self.addAngle > 60) {
        self.addAngle = 60;
        self.rotationImageView.transform = CGAffineTransformIdentity;
        self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform,ToRad(self.addAngle));
        return;
    }
    if (self.addAngle < -60) {
        self.addAngle = -60;
        self.rotationImageView.transform = CGAffineTransformIdentity;
        self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform,ToRad(self.addAngle));
        return;
    }
    self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform,ToRad(deteAngle));
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.deta_degree = 0;
    self.tempAngle = 0;
    self.rotationImageView.transform = CGAffineTransformIdentity;
}

-(CGFloat)detaDegreeWithX:(CGFloat)x Y:(CGFloat)y targetX:(CGFloat)targetX targetY:(CGFloat)targetY{
    CGFloat detaX = targetX - x;
    CGFloat detaY = targetY - y;
    float d;
    if (detaX != 0) {
        CGFloat tan = atan(detaY / detaX);
        
        if (detaX > 0) {
            d = tan;
        } else {
            d = M_PI + tan;
        }
        
    } else {
        d = 0;
    }
    
    return (float)((d * 180) / M_PI);
    
}

@end
