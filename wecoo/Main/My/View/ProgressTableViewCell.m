//
//  ProgressTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/16.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "ProgressTableViewCell.h"
#import "ProgressModel.h"


@implementation ProgressTableViewCell{
 NSDictionary* style3;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier = @"DetailTableViewCell";
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[ProgressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _initView];
    }
    return self;
}


-(void)_initView{
    self.contentView.userInteractionEnabled = YES;
    self.infoView.userInteractionEnabled = YES;
    self.descriptionLabel.userInteractionEnabled = YES;
    
    
    [self.contentView addSubview:self.infoView];

    [self.contentView addSubview:self.descriptionLabel];
    
    [self.contentView addSubview:self.timeImageView];
    

    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30*AUTO_SIZE_SCALE_X);
        make.right.offset(-15*AUTO_SIZE_SCALE_X);
        make.top.offset(15*AUTO_SIZE_SCALE_X);
        make.bottom.offset(0);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50*AUTO_SIZE_SCALE_X);
        make.right.offset(-20);
        make.top.offset(23*AUTO_SIZE_SCALE_X);
        make.bottom.offset(-7*AUTO_SIZE_SCALE_X);
        
    }];
    
    style3 = @{
               @"body" :@[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0*AUTO_SIZE_SCALE_X],FontUIColorGray],
               @"help":
                   [WPAttributedStyleAction styledActionWithAction:^{
                       NSLog(@"help action");
                       [[NSNotificationCenter defaultCenter] postNotificationName:kModifyWithdraw object:self.dictionary];
                       
                       [MobClick event:kRecordProgressOnClickEvent];
                   }],
               @"settings":[WPAttributedStyleAction styledActionWithAction:^{
                   NSLog(@"Settings action");}],
               @"u": @[
                       UIColorFromRGB(0x6e5dff),
                       @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}
                       ],
               @"a": @[
                       RedUIColorC1,
                       ],
               };

    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*AUTO_SIZE_SCALE_X);
        make.top.equalTo(self.mas_top).offset(40*AUTO_SIZE_SCALE_X);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
}

-(void)setModel:(ProgressModel *)model
{
    NSString *content = [NSString stringWithFormat:@"%@\n%@",model.title,model.title2];
    self.descriptionLabel.attributedText = [content attributedStringWithStyleBook:style3];
}

-(void)lineimageviewSetIndexPath:(NSIndexPath *)indexPath withCount:(int)count{
    [self.contentView addSubview:self.lineImageView];
    [self.contentView addSubview:self.lineImageView1];
    [self.contentView addSubview:self.lineImageView2];

    if (indexPath.row == 0 ) {
        
        
        self.lineImageView.hidden = NO;
        [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17*AUTO_SIZE_SCALE_X);
            make.width.equalTo(@0.5);
            make.top.equalTo(self.timeImageView.mas_bottom).offset(0);
            make.bottom.offset(0);
        }];
        [self.lineImageView2  removeFromSuperview];
    }else{
        [self.lineImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17*AUTO_SIZE_SCALE_X);
            //                make.right.offset(-(kScreenWidth-16.5));
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.equalTo(@0.5);
        }];
        if (indexPath.row == count -1) {
            [self.lineImageView  removeFromSuperview];
            [self.lineImageView1  removeFromSuperview];
            [self.lineImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(17*AUTO_SIZE_SCALE_X);
                make.top.equalTo(self.mas_top).offset(0);
                make.width.equalTo(@0.5);
                make.bottom.equalTo(self.timeImageView.mas_top);
            }];
        }
    }
}

-(void)isHighLighted:(BOOL)isHigh{
    if(isHigh){
        self.timeImageView.image = [UIImage imageNamed:@"icon-timeAxis-red"];
    }else{
        self.timeImageView.image  =[UIImage imageNamed:@"icon-timeAxis"];
    }
}

-(UIImageView *)infoView{
    if (_infoView == nil) {
        self.infoView = [UIImageView new];
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"icon-timeAxisTxt"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(50*AUTO_SIZE_SCALE_X, 15, 5, 5)];
        self.infoView.image = backImage;
        
    }
    return _infoView;
}

- (WPHotspotLabel *)descriptionLabel {
    if (_descriptionLabel == nil) {
        self.descriptionLabel = [[WPHotspotLabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.numberOfLines = 0;

    }
    return _descriptionLabel;
}

- (UIImageView *)timeImageView {
    if (_timeImageView == nil) {
        self.timeImageView = [UIImageView new];
    }
    return _timeImageView;
}

- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineImageView;
}

- (UIImageView *)lineImageView1 {
    if (_lineImageView1 == nil) {
        self.lineImageView1 = [UIImageView new];
        self.lineImageView1.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineImageView1;
}

- (UIImageView *)lineImageView2 {
    if (_lineImageView2 == nil) {
        self.lineImageView2 = [UIImageView new];
        self.lineImageView2.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _lineImageView2;
}

@end
