//
//  ViewController.m
//  方向盘
//
//  Created by Heaton on 2018/2/24.
//  Copyright © 2018年 WangMingDeveloper. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIImageView *rotationImageView;
@property(nonatomic,strong) UIImageView *speedImageView;// 速度转盘指针
@property(nonatomic,strong) UIImageView *fuelImageView;// 油量转盘指针
@property(nonatomic,strong) UIImageView *rpmImageView;// 转速转盘指针
@property(nonatomic,strong) UIButton *forwordButton;
@property(nonatomic,strong) UIButton *backwordButton;

@property(nonatomic,strong) NSTimer *fuelTimerCount;
@property(nonatomic,strong) NSTimer *speedTimerCount;
@property(nonatomic,strong) NSTimer *speedMixTimerCount;
@property(nonatomic,assign) NSInteger fuelCount;
@property(nonatomic,assign) NSInteger speedCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 方向盘
    self.rotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timg"]];
    CGFloat height = 300;
    CGFloat width = 300;
    CGFloat x = 20;
    CGFloat y = self.view.frame.size.height  - height;
    self.rotationImageView.frame = CGRectMake(x,y,width,height);
    self.rotationImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.rotationImageView];
    
    // 前进后退
    CGFloat btnX = CGRectGetMaxX(self.rotationImageView.frame)+100;
    CGFloat btnW = width * 0.4;
    CGFloat btnH =  btnW * 0.488;
    CGFloat btnY = self.view.frame.size.height - btnH - 20;
    
    self.forwordButton = [[UIButton alloc] initWithFrame:CGRectMake(btnX,btnY,btnW,btnH)];
    [self.forwordButton setBackgroundImage:[UIImage imageNamed:@"前进"] forState:UIControlStateNormal];
    [self.forwordButton addTarget:self action:@selector(forwordBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
     [self.forwordButton addTarget:self action:@selector(forwordBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwordButton];
    
    self.backwordButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.forwordButton.frame)+20,btnY,btnW,btnH)];
    [self.backwordButton setBackgroundImage:[UIImage imageNamed:@"后退"] forState:UIControlStateNormal];
    [self.backwordButton addTarget:self action:@selector(backwordBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.backwordButton addTarget:self action:@selector(backwordBtnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backwordButton];
    
    
    //仪表盘
    UIView *dashboardView = [[UIView alloc] initWithFrame:CGRectMake(btnX,40,self.view.frame.size.width - btnX-20,200)];
//    dashboardView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:dashboardView];
    
    CGFloat speedWidth = dashboardView.frame.size.width * 0.4;
    CGFloat speedHeigth = speedWidth;
    UIImageView *speedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SpeedoMeter"]];
    speedImageView.frame = CGRectMake((dashboardView.frame.size.width - speedWidth)/2,(dashboardView.frame.size.height-speedHeigth)/2,speedWidth,speedHeigth);
    [dashboardView addSubview:speedImageView];
    
    self.speedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Needle"]];
    self.speedImageView.frame = CGRectMake(0,0,speedWidth * 0.104,speedHeigth*0.9011);
    CGPoint center = speedImageView.center;
    center.y = center.y;
    self.speedImageView.center = center;
    [dashboardView addSubview:self.speedImageView];
    
    UIImageView *center1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Center"]];
    center1.frame = CGRectMake(0,0,26,26);
    center1.center = center;
    [dashboardView addSubview:center1];
    
    
    CGFloat rpmWidth = speedWidth * 0.70;
    CGFloat rpmHeight = rpmWidth;
    
    
    UIImageView *rpmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RpmMeter"]];
    rpmImageView.frame = CGRectMake(0,(dashboardView.frame.size.height-rpmHeight)/2,rpmWidth,rpmHeight);
    [dashboardView addSubview:rpmImageView];
    
    
    self.rpmImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Needle"]];
    self.rpmImageView.frame = CGRectMake(0,0,rpmWidth * 0.066,rpmHeight * 0.577);
    CGPoint rpmCenter = rpmImageView .center;
    rpmCenter.y = rpmCenter.y;
    self.rpmImageView.center = rpmCenter;
    [dashboardView addSubview:self.rpmImageView ];
    
    UIImageView *center2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Center"]];
    center2.frame = CGRectMake(0,0,10,10);
    center2.center = rpmCenter;
    [dashboardView addSubview:center2];
    
    
    
    UIImageView *fuel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FualMeter"]];
    fuel.frame = CGRectMake(CGRectGetMaxX(speedImageView.frame)-10,(dashboardView.frame.size.height-rpmHeight)/2,rpmWidth,rpmHeight);
    [dashboardView addSubview:fuel];
    
    
    self.fuelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Needle"]];
    self.fuelImageView.frame = CGRectMake(0,0,rpmWidth * 0.066,rpmHeight * 0.577);
    CGPoint fuelCenter = fuel.center;
    fuelCenter.y = fuelCenter.y;
    fuelCenter.x = fuelCenter.x - 10;
    self.fuelImageView.center = fuelCenter;
    [dashboardView addSubview:self.fuelImageView ];
    
    UIImageView *center3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Center"]];
    center3.frame = CGRectMake(0,0,10,10);
    center3.center = fuelCenter;
    [dashboardView addSubview:center3];
    
    [self rotateSpeedoMeterNeedle:-127];
    [self rotateRPMNeedle:-145];
    [self rotateFuelNeedle:150];

    self.fuelCount = 25;
    self.speedCount = -127;
    [self startFuelTimer];
}

-(void)forwordBtnTouchDown:(UIButton *)sender{
    NSLog(@"按下来了");
    self.backwordButton.enabled = NO;
    [self startAddSpeedTimer];
}

-(void)forwordBtnTouchUp:(UIButton *)sender{
    NSLog(@"松开手了");
    [self.speedTimerCount invalidate];
    self.speedTimerCount = nil;
    [UIView animateWithDuration:3 animations:^{
        [self rotateSpeedoMeterNeedle:-127];
    }];
    self.backwordButton.enabled = YES;
}


-(void)backwordBtnTouchDown:(UIButton *)sender{
    NSLog(@"按下来了");
    [self startMixSpeedTimer];
    self.forwordButton.enabled = NO;
}

-(void)backwordBtnTouchUp:(UIButton *)sender{
    NSLog(@"松开手了");
    self.forwordButton.enabled = YES;
}

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
        CGAffineTransform _trans = self.rotationImageView.transform;
        NSLog(@"角度是:%.2f",angle);
        CGFloat rotate = acosf(_trans.a);
        // 旋转180度后，需要处理弧度的变化
        if (_trans.b < 0) {
            rotate = M_PI -rotate;
        }
        // 将弧度转换为角度
        CGFloat degree = rotate/M_PI * 180;

        if(degree >= 80){
            NSLog(@"--角度减小,degree:%.2f",degree);
            if(degree <=120){
                return;
            }
        }else{
            NSLog(@"--角度增加,degree:%.2f",degree);
            if(degree >= 50){
                return;
            }
        }
        
        self.rotationImageView.transform = CGAffineTransformRotate(self.rotationImageView.transform, angle);
        CGAffineTransform currentTrans = self.rotationImageView.transform;
        CGFloat currentRotate = acosf(currentTrans.a);
        // 旋转180度后，需要处理弧度的变化
        if (_trans.b < 0) {
            currentRotate = M_PI -currentRotate;
        }
        // 将弧度转换为角度
        CGFloat currentDegree = rotate / M_PI * 180;
        
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.rotationImageView.transform =  CGAffineTransformIdentity;
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

-(void)rotateSpeedoMeterNeedle:(CGFloat)speed{
    [UIView animateWithDuration:0.5 animations:^{
        self.speedImageView.transform = CGAffineTransformMakeRotation((M_PI/180) * speed);
    }];
}

-(void)rotateRPMNeedle:(CGFloat)speed{
    [UIView animateWithDuration:0.5 animations:^{
        self.rpmImageView.transform = CGAffineTransformMakeRotation((M_PI/180) * speed);
    }];
}

-(void)rotateFuelNeedle:(CGFloat)speed{
 
    [UIView animateWithDuration:0.5 animations:^{
        self.fuelImageView.transform = CGAffineTransformMakeRotation((M_PI/180) * speed);
    }];
}


-(void)startFuelTimer{
    self.fuelTimerCount = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fulCount) userInfo:nil repeats:YES];
}

-(void)fulCount{
    self.fuelCount++;
    if(self.fuelCount >= 150){
        self.fuelCount = 25;
    }
    NSLog(@"fuelCoutn:%ld",self.fuelCount);
    [self rotateFuelNeedle:self.fuelCount];
}

-(void)startAddSpeedTimer{
    self.speedTimerCount = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(speedAddCont) userInfo:nil repeats:YES];
}

-(void)startMixSpeedTimer{
    self.speedMixTimerCount = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(speedMixCont) userInfo:nil repeats:YES];
}

-(void)speedAddCont{
    self.speedCount += 3;
    if(self.speedCount >=120)return;
    [self rotateSpeedoMeterNeedle:self.speedCount];
}

-(void)speedMixCont{
    self.speedCount -= 3;
    if(self.speedCount <= -127){
        [self.speedMixTimerCount invalidate];
        self.speedMixTimerCount = nil;
        self.speedCount = -127;
    }
    [self rotateSpeedoMeterNeedle:self.speedCount];
}
@end
