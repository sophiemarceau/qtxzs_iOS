//
//  WZBSpeedDialView.m
//  WZBSpeedDial
//


#import "WZBSpeedDialView.h"
#import "UICountingLabel.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

static const CGFloat kMarkerRadius = 4.f; // 光标直径
static const CGFloat kAnimationTime = 2.f;

@interface WZBSpeedDialView (){
    CGPoint xypoint;
}

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICountingLabel *speedLabel;
@property (nonatomic, strong) UIImageView *markerImageView; // 光标

@end

@implementation WZBSpeedDialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        xypoint = CGPointMake(frame.size.width/2, frame.size.height-35*AUTO_SIZE_SCALE_X);
        self.backgroundColor = RedUIColorC1;
        // 显示速度值的label
        [self addSubview:self.speedLabel];
        UILabel *fenLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.speedLabel.frame.origin.x+self.speedLabel.frame.size.width, self.speedLabel.frame.origin.y, 20*AUTO_SIZE_SCALE_X, self.speedLabel.frame.size.height)];
         fenLabel.font = [UIFont fontWithName:@"Avenir Next" size:20*AUTO_SIZE_SCALE_X];
        fenLabel.text = @"分";
        fenLabel.textColor = [UIColor whiteColor];
        fenLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:fenLabel];
        // 画圆弧
        [self drawCicrle];
//        // 画刻度
        [self drawCalibration];
//        // 增加刻度值
        [self addCalibrationValue];
//        // 进度的曲线
        [self drawProgressCicrle];
        // 计时器
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setSpeedProgress) userInfo:nil repeats:YES];
        
     
    }
    return self;
}

- (UICountingLabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake((kScreenWidth-80*AUTO_SIZE_SCALE_X)/2,
                                                                        250*AUTO_SIZE_SCALE_X-kNavHeight-50*AUTO_SIZE_SCALE_X-20*AUTO_SIZE_SCALE_X,
                                                                        80*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X)];
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.font = [UIFont fontWithName:@"Avenir Next" size:45*AUTO_SIZE_SCALE_X];
        _speedLabel.textColor = [UIColor whiteColor];
        //设置格式
        _speedLabel.format = @"%d";
        //设置变化范围及动画时间
//        _speedLabel.backgroundColor= [UIColor blueColor];
        

    }
    return _speedLabel;
}

// 画圆弧
- (void)drawCicrle {
    
    UIBezierPath *cicrle = [UIBezierPath bezierPathWithArcCenter:xypoint radius:170/2*AUTO_SIZE_SCALE_X  startAngle:degreesToRadians(-200)
                                                        endAngle:degreesToRadians(20) clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 8.0f;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = UIColorFromRGB(0xf56569).CGColor;
    shapeLayer.path = cicrle.CGPath;
    [self.layer addSublayer:shapeLayer];
}

// 画刻度
- (void)drawCalibration {
    CGFloat perAngle = (M_PI+40*M_PI/6/30) / 30;
    
    for (int i = 0; i< 31; i++) {
//        CGFloat startAngel = (-M_PI - 40*M_PI/6/30 + perAngle * i);
        CGFloat startAngel = (degreesToRadians(-200)+ perAngle * i);
        CGFloat endAngel = startAngel + perAngle/10;
        UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:xypoint radius:170/2*AUTO_SIZE_SCALE_X startAngle:startAngel endAngle:endAngel clockwise:YES];
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        
        if (i % 5 == 0) {
            perLayer.strokeColor = UIColorFromRGB(0xf89b9d).CGColor;
            perLayer.lineWidth = 17.0f/2;
        }else{
            perLayer.strokeColor = UIColorFromRGB(0xf89b9d).CGColor;

            perLayer.lineWidth = 7/2;
        }
        
        perLayer.path = tickPath.CGPath;
        [self.layer addSublayer:perLayer];
    }
}

// 增加刻度值
- (void)addCalibrationValue {
    CGFloat textAngel = (M_PI)/5;
    
    for (NSInteger i = 0; i < 6; i++) {
        CGPoint point = [self calculateTextPositonWithArcCenter:xypoint Angle:textAngel * i];
//        NSString *tickText = [NSString stringWithFormat:@"%zd",labs(5-i)*5];
        //默认label的大小23 * 14
       
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 8, point.y - 7, 23, 14)];
        text.text = [NSString stringWithFormat:@"%@",[self setTagString:i]];
        text.backgroundColor = [UIColor clearColor];
        text.font = [UIFont systemFontOfSize:10.f*AUTO_SIZE_SCALE_X];
        text.textColor = [UIColor whiteColor];
        text.textAlignment = NSTextAlignmentLeft;
        text.transform = CGAffineTransformMakeRotation(-M_PI/2+textAngel * i);
        [self addSubview:text];
    }
}

-(NSString *)setTagString:(int)tag{
    NSString *name ;
    
    switch (tag) {
        case 0:
        {
            name =@"较差";
            
            break;
        }
            
        case 1:{
            name =@"一般";
            
            break;
        }
            
        case 2:{
            name =@"中等";
            
            break;
            
        }
            
        case 3:{
            name =@"良好";
            
            break;
            
        }
        case 4:{
            name =@"优秀";
            
            break;
            
        }
            
        case 5:{
            name =@"极好";
            
            break;
        }
            
        default:
            break;
    }
    return name;

}
// 进度的曲线
- (void)drawProgressCicrle {
    UIBezierPath *progressPath  = [UIBezierPath bezierPathWithArcCenter:xypoint radius:100*AUTO_SIZE_SCALE_X startAngle:degreesToRadians(-200) endAngle:degreesToRadians(20) clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    
    progressLayer.lineWidth = 1.5f;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = UIColorFromRGB(0xf49fa0).CGColor;
    progressLayer.path = progressPath.CGPath;
    self.progressLayer = progressLayer;
//    progressLayer.strokeStart = 0;
//    progressLayer.strokeEnd =1;
    [self.layer addSublayer:progressLayer];
}

// 计算label的坐标
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center
                                       Angle:(CGFloat)angel {
    CGFloat x = 70*AUTO_SIZE_SCALE_X * cosf(angel);
    CGFloat y = 70*AUTO_SIZE_SCALE_X * sinf(angel);
    return CGPointMake(center.x -x, center.y - y);
}

- (void)setSpeedProgress {
    [UIView animateWithDuration:0.8 animations:^{
    }];

}
#pragma mark - Animation
 // 光标动画
- (void)createAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    
    // 设置动画属性
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = kAnimationTime;
    pathAnimation.repeatCount = 1;
    
    // 设置动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, xypoint.x, xypoint.y, 100*AUTO_SIZE_SCALE_X, startAngle, endAngle, 0);
    pathAnimation.path = path;
    CGPathRelease(path);
    CGFloat x = 100.0/2*AUTO_SIZE_SCALE_X * cosf(degreesToRadians(-200));
    CGFloat y = 100.0/2*AUTO_SIZE_SCALE_X * sinf(degreesToRadians(-200));
    
    self.markerImageView.frame = CGRectMake(xypoint.x + x, xypoint.y + y, kMarkerRadius, kMarkerRadius);
    self.markerImageView.layer.cornerRadius = self.markerImageView.frame.size.height / 2;
    [self addSubview:self.markerImageView];
    [self.markerImageView.layer addAnimation:pathAnimation forKey:@"moveMarker"];
}

- (void)circleAnimation { // 弧形动画
    
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    self.progressLayer.strokeEnd = 0;
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:kAnimationTime];
    self.progressLayer.strokeEnd = _percent / 150.0;
    [CATransaction commit];
}

- (UIImageView *)markerImageView {
    
    if (nil == _markerImageView) {
        _markerImageView = [[UIImageView alloc] init];
        _markerImageView.backgroundColor = UIColorFromRGB(0xffffff);
        _markerImageView.alpha = 0.7;
        _markerImageView.layer.shadowColor = UIColorFromRGB(0xffffff).CGColor;
        _markerImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _markerImageView.layer.shadowRadius = 3.f;
        _markerImageView.layer.shadowOpacity = 1;
    }
    return _markerImageView;
}


#pragma mark - Setters / Getters

- (void)setPercent:(CGFloat)percent {
    

    [self setPercent:percent animated:YES];
}

- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    
    _percent = percent;
//    NSLog(@"%f",_percent);
    _percent = percent;
    [self.speedLabel countFrom:0
                         to:_percent
               withDuration:2.0f];
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(circleAnimation) userInfo:nil repeats:NO];
    
    [self createAnimationWithStartAngle:degreesToRadians(-200)
                               endAngle:degreesToRadians(-200 + 220 * percent / 150)];
    

}


@end
