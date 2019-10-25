//
//  MXPullDownMenu000.m
//  MXPullDownMenu
//
//  Created by 马骁 on 14-8-21.
//  Copyright (c) 2014年 Mx. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MXPullDownMenu.h"
#import "publicTableViewCell.h"
#import "CategoryCell.h"
#import  "UIImageView+WebCache.h"

@implementation MXPullDownMenu
{
    
    UIColor *_menuColor;
    UIView *_backGroundView;
    UITableView *_tableView;
    NSMutableArray *_titles;
    NSMutableArray *_indicators;
    NSInteger _currentSelectedMenudIndex;
    bool _show;
    NSInteger _numOfMenu;
    
    NSArray *_array;
    
    
    NSArray *_images;
    NSArray *_titlesname;
    
    NSInteger _index;
    
    UIView *verysmallview;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    
    }
    return self;
}

- (MXPullDownMenu *)initWithArray:(NSArray *)array selectedColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 50*AUTO_SIZE_SCALE_X);
        _menuColor = FontUIColorBlack;
        _array = array;

        _numOfMenu = _array.count;
        
        CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
        CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
        
        _titles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        _indicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
        
        for (int i = 0; i < _numOfMenu; i++) {
            
            CGPoint position = CGPointMake( (i * 2 + 1) * textLayerInterval , self.frame.size.height / 2);
            CATextLayer *title = [self creatTextLayerWithNSString:[_array[i][0] objectForKey:@"name"] withColor:_menuColor andPosition:position];
            [self.layer addSublayer:title];
            [_titles addObject:title];
//            CAShapeLayer *indicator = [self creatIndicatorWithColor:_menuColor andPosition:CGPointMake(position.x + title.bounds.size.width / 2 + 8, self.frame.size.height / 2)];
//            [self.layer addSublayer:indicator];
//            [_indicators addObject:indicator];
            UIImageView *arrow = [[UIImageView alloc] init];
            arrow.image = [UIImage imageNamed:@"icon_money_reward_open"];

            arrow.frame = CGRectMake(position.x + title.bounds.size.width / 2 + 5*AUTO_SIZE_SCALE_X,
                                     (self.frame.size.height -6*AUTO_SIZE_SCALE_X)/ 2,
                                     11*AUTO_SIZE_SCALE_X,
                                     6*AUTO_SIZE_SCALE_X);
            [self addSubview:arrow];
            [_indicators addObject:arrow];
            if (i != _numOfMenu - 1) {
                CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
                CAShapeLayer *separator = [self creatSeparatorLineWithColor:UIColorFromRGB(0xefefef) andPosition:separatorPosition];
                [self.layer addSublayer:separator];
            }
            
        }
        
        
        UIImageView *widthline=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y+self.frame.size.height-0.5f, kScreenWidth, 0.5f)];
        widthline.backgroundColor = lineImageColor;
        widthline.contentMode =  UIViewContentModeScaleToFill;
        
        [self addSubview:widthline];
        _tableView = [self creatTableViewAtPosition:CGPointMake(0, self.frame.origin.y + self.frame.size.height)];
        _tableView.showsVerticalScrollIndicator  = YES;
        _tableView.tintColor = color;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        // 设置menu, 并添加手势
        self.backgroundColor = [UIColor clearColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMenu:)];
        [self addGestureRecognizer:tapGesture];
        // 创建背景
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackGround:)];
        [_backGroundView addGestureRecognizer:gesture];
         
        _currentSelectedMenudIndex = -1;
        _show = NO;
    }
    return self;
}



#pragma mark - tapEvent



// 处理菜单点击事件.
- (void)tapMenu:(UITapGestureRecognizer *)paramSender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:khiddenKeyboard object:nil];
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 得到tapIndex
    
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    

    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                }];
            }];
        }
    }
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
            
        }];
        
    } else {
        
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
         [_collectionView reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
        }];
        
    }

   

}

- (void)tapBackGround:(UITapGestureRecognizer *)paramSender
{
    

    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];

}


#pragma mark - tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    [self confiMenuWithSelectRow:indexPath.row];
    [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row];
    
}


#pragma mark tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array[_currentSelectedMenudIndex] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellName = @"publicTableViewCell";
    publicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"publicTableViewCell" owner:self options:nil];
        cell = (publicTableViewCell *)[nibArray objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor grayColor];
    textLabel.font = [UIFont systemFontOfSize:15*AUTO_SIZE_SCALE_X];
    textLabel.text = [_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"name"];
    textLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, 0, kScreenWidth-15*AUTO_SIZE_SCALE_X, 45*AUTO_SIZE_SCALE_X);
    [cell addSubview:textLabel];
    
    if (textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
        //        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        //        [cell.textLabel setTextColor:[tableView tintColor]];
        [textLabel setTextColor:RedUIColorC1];
    }
  
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.textLabel.font = [UIFont systemFontOfSize:13.0];
//    }
//    
//    [cell.textLabel setTextColor:[UIColor grayColor]];
//    [cell setAccessoryType:UITableViewCellAccessoryNone];
//    cell.textLabel.text = [_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"name"];
//    
//    if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
////        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
////        [cell.textLabel setTextColor:[tableView tintColor]];
//        [cell.textLabel setTextColor:[UIColor orangeColor]];
//    }
    
    return cell;
}





#pragma mark - animation

- (void)animateIndicator:(UIImageView *)indicator Forward:(BOOL)forward complete:(void(^)())complete
{
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.25];
//    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
//    
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
//    
//    if (!anim.removedOnCompletion) {
//        [indicator addAnimation:anim forKey:anim.keyPath];
//    } else {
//        [indicator addAnimation:anim andValue:anim.values.lastObject forKeyPath:anim.keyPath];
//    }
//    
//    [CATransaction commit];
//    
//    indicator.fillColor = forward ? _tableView.tintColor.CGColor : _menuColor.CGColor;
    if (forward) {
        indicator.image = [UIImage imageNamed:@"icon_money_reward_close"];
        
    }else{
        indicator.image = [UIImage imageNamed:@"icon_money_reward_open"];
    }
    
    complete();
}





- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete
{
    
    if (show) {
        
        [self.superview addSubview:view];
        [view.superview addSubview:self];

        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        
    }
    complete();
    
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        
        if(_currentSelectedMenudIndex==0){
            tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            [self.superview addSubview:tableView];
            
            
            CGFloat tableViewHeight = ([tableView numberOfRowsInSection:0] > 5) ? (5 * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight);
            if ([tableView numberOfRowsInSection:0] > 5) {
                tableViewHeight =846/2*AUTO_SIZE_SCALE_X;
            }
           
           
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                verysmallview.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            } completion:^(BOOL finished) {
                [self.collectionView removeFromSuperview];
                [verysmallview removeFromSuperview];
            }];

            
        }else{
            verysmallview = [UIView new];
            verysmallview.backgroundColor = [UIColor whiteColor];
            [self.superview addSubview:self.collectionView];
            [self.superview addSubview:verysmallview];
            tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            self.collectionView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height+5*AUTO_SIZE_SCALE_X, self.frame.size.width, kScreenHeight-self.frame.origin.y - self.frame.size.height-TABBAR_HEIGHT-5*AUTO_SIZE_SCALE_X);
            verysmallview.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 5*AUTO_SIZE_SCALE_X);
            [tableView removeFromSuperview];
   
        }

    } else {
        if(_currentSelectedMenudIndex==0){
            [UIView animateWithDuration:0.2 animations:^{
                _tableView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            } completion:^(BOOL finished) {
                [tableView removeFromSuperview];
            }];
            
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
                verysmallview.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            } completion:^(BOOL finished) {
                [self.collectionView removeFromSuperview];
                [verysmallview removeFromSuperview];
            }];
        }
        
        
        
    }
    complete();
    
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete
{
    if (show) {
        title.foregroundColor = _tableView.tintColor.CGColor;
    } else {
        title.foregroundColor = _menuColor.CGColor;
    }
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    
    complete();
}

- (void)animateIdicator:(UIImageView *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                }];
            }];
        }];
    }];
    
    complete();
}


#pragma mark - drawing


- (CAShapeLayer *)creatIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)creatSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 50*AUTO_SIZE_SCALE_X)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CATextLayer *)creatTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point
{
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 15*AUTO_SIZE_SCALE_X;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}


- (UITableView *)creatTableViewAtPosition:(CGPoint)point
{
    UITableView *tableView = [UITableView new];
    
    tableView.frame = CGRectMake(point.x, point.y, self.frame.size.width, 0);
    tableView.rowHeight = 45*AUTO_SIZE_SCALE_X;
    
    return tableView;
}


#pragma mark - otherMethods


- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 15*AUTO_SIZE_SCALE_X;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

- (void)confiMenuWithSelectRow:(NSInteger)row
{
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [[[_array objectAtIndex:_currentSelectedMenudIndex] objectAtIndex:row] objectForKey:@"name"];
    
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
        
    }];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

   return [_array[_currentSelectedMenudIndex] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row ==0) {
        [cell.iconImageView setImage:[UIImage imageNamed:[_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"icon_ios_2x"]]];
    }
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"icon_ios_2x"]]];
    cell.namelabel.text = [_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"name"];
    int  is_hot = [[_array[_currentSelectedMenudIndex][indexPath.row] objectForKey:@"is_hot"] intValue];
    if (is_hot == 1) {
        cell.hotImageView.hidden = NO;
    }else{
        cell.hotImageView.hidden = YES;
    }
    
    NSLog(@"_index item %ld", indexPath.row);
    if (indexPath.row == _index) {
//        cell.backgroundColor = UIColorFromRGB(0xD8D8D8);
        [cell.namelabel setTextColor:RedUIColorC1];
    }else {
//        cell.backgroundColor = [UIColor whiteColor];
        [cell.namelabel setTextColor:[UIColor grayColor] ];
    }
//    if (textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
//        //        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//        //        [cell.textLabel setTextColor:[tableView tintColor]];
//        [textLabel setTextColor:RedUIColorC1];
//    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    _index = indexPath.item;


    [self confiMenuWithSelectRow:_index];
    [self.delegate PullDownMenu:self didSelectRowAtColumn:_currentSelectedMenudIndex row:indexPath.row];

}


- (UICollectionView *)collectionView
{
    if (_collectionView==nil) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake(83*AUTO_SIZE_SCALE_X, 83*AUTO_SIZE_SCALE_X);
//        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 1*AUTO_SIZE_SCALE_X;
//        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 5*AUTO_SIZE_SCALE_X;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0,5*AUTO_SIZE_SCALE_X, 0, 5*AUTO_SIZE_SCALE_X);
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        [_collectionView registerClass:[CategoryCell class] forCellWithReuseIdentifier:@"cell"];

    }
    return _collectionView;
}



@end

#pragma mark - CALayer Category

@implementation CALayer (MXAddAnimationAndValue)

- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value forKeyPath:(NSString *)keyPath
{
    [self addAnimation:anim forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}


@end
