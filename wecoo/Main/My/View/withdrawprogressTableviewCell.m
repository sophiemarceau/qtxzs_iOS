//
//  withdrawprogressTableviewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/2/3.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "withdrawprogressTableviewCell.h"


@implementation withdrawprogressTableviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - init
+ (instancetype)userStatusCellWithTableView:(UITableView *)tableView{
    static NSString *cellidentifier =@"SCYImageViewCell";
    withdrawprogressTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (!cell) {
        cell = [[withdrawprogressTableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
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
    self.lbdescription.userInteractionEnabled = YES;
    [self.contentView addSubview:self.infoView];
    [self.infoView addSubview:self.lbDate];
    [self.infoView addSubview:self.lbdescription];
    [self addSubview:self.timeImageView];
    
    style3 = @{
               @"body" :@[[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0*AUTO_SIZE_SCALE_X],FontUIColorGray],
               @"help":
                   [WPAttributedStyleAction styledActionWithAction:^{
                   NSLog(@"help action");
                   [[NSNotificationCenter defaultCenter] postNotificationName:kModifyWithdraw object:self.everyDic];
                   
               
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
}

- (CGFloat)setCellHeight:(NSDictionary *)strInfo isHighLighted:(BOOL)isHigh isRedColor:(BOOL)isRed isZero:(BOOL)isZero isLastData:(BOOL)isLastData{
    
    CGFloat descheight =self.lbdescription.frame.size.height;
    [self.lbdescription setNumberOfLines:0];  //0行，则表示根据文本长度，自动增加行数
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    NSString *info = @"";
    info = [info stringByAppendingString:strInfo[@"swal_opertype_name"]];
    
    int swal_opertype = [strInfo[@"swal_opertype"] intValue];
    int link = [strInfo[@"link"] intValue];
    int swa_type = [[strInfo objectForKey:@"swa_type"] intValue];

    if (swal_opertype == 1) {
        if (![strInfo[@"swa_sum_str"] isEqual:[NSNull null]] && strInfo[@"swa_sum_str"] !=nil && ![strInfo[@"swa_sum_str"] isEqualToString:@""]) {
            info = [info stringByAppendingFormat:@" <a>%@</a>",strInfo[@"swa_sum_str"]];
        }
        if (swa_type == 1) {
             info = [info stringByAppendingFormat:@"\r\n%@",@"提现方式：个人银行卡提现"];
        }else{
            info = [info stringByAppendingFormat:@"\r\n%@",@"提现方式：支付宝提现"];
        }        
    }
    
    if (swal_opertype == 2) {
        
    }
    
    if (swal_opertype == 3) {
        if (link == 2) {
            info = [info stringByAppendingFormat:@", 去<help><u>%@</u></help>",@"修改认证信息"];
        }
        if (![strInfo[@"swal_desc"] isEqualToString:@""]) {
            info = [info stringByAppendingFormat:@"\r\n%@%@",@"原因：",strInfo[@"swal_desc"]];
        }
    }
    if (swal_opertype == 4) {
       
        if (link == 0) {
            info = [info stringByAppendingFormat:@",%@",@"已修改信息"];
        }else{
            info = [info stringByAppendingFormat:@", 去<help><u>%@</u></help>",@"修改申请信息"];
            if(![strInfo[@"swal_desc"] isEqual:[NSNull null]] && strInfo[@"swal_desc"] !=nil)
            {
                if (![strInfo[@"swal_desc"] isEqualToString:@""]) {
                    info = [info stringByAppendingFormat:@"\r\n%@%@",@"原因：",strInfo[@"swal_desc"]];
                }                
            }
        }
    }
    if (swal_opertype == 5) {
        
    }
    if (swal_opertype == 6) {
        info = [info stringByAppendingFormat:@"\r\n%@%@ %@",@"打款账号:",strInfo[@"us_realname"],strInfo[@"account"]];
    }
    
    self.lbdescription.attributedText = [info attributedStringWithStyleBook:style3];
    [self.lbdescription sizeToFit];
    CGSize size  = CGSizeMake(self.lbdescription.frame.size.width, self.lbdescription.frame.size.height);
    
    descheight = descheight > size.height ? descheight : size.height;
    self.lbdescription.size = CGSizeMake(self.lbdescription.frame.size.width, descheight);
    
    
    self.lbDate.frame = CGRectMake(self.lbDate.frame.origin.x, self.lbdescription.origin.y+self.lbdescription.frame.size.height+8*AUTO_SIZE_SCALE_X, self.lbDate.frame.size.width, self.lbDate.frame.size.height);
    
    
    self.infoView.frame = CGRectMake(self.infoView.frame.origin.x,
                                     self.infoView.frame.origin.y,
                                     self.infoView.frame.size.width,
                                     self.lbDate.frame.origin.y + self.lbDate.frame.size.height+15*AUTO_SIZE_SCALE_X);

    if(isHigh){
        self.timeImageView.image = [UIImage imageNamed:@"icon-timeAxis-red"];
    }else{
        self.timeImageView.image  =[UIImage imageNamed:@"icon-timeAxis"];
    }
    
    return self.infoView.frame.origin.y + self.infoView.frame.size.height ;
}



//+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
//{
////    CGFloat heig =self->lbdescription.frame.size.height;
////    [self layout];
//    
////    return heig;
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//
//    CGRect rect=[self boundingRectWithSize:CGSizeMake(width,MAXFLOAT)options:(NSStringDrawingUsesLineFragmentOrigin)attributes:dictcontext:nil];
//    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
//    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
//    return CGSizeMake(sizeWidth, sizeHieght);
//}











-(UIImageView *)infoView{
    if (_infoView == nil) {
        self.infoView = [UIImageView new];
        self.infoView.frame = CGRectMake(30*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X, kScreenWidth-45*AUTO_SIZE_SCALE_X, 63*AUTO_SIZE_SCALE_X);
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"icon-timeAxisTxt"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(50*AUTO_SIZE_SCALE_X, 15, 5, 5)];
        self.infoView.image = backImage;
        
    }
    return _infoView;
}

- (WPHotspotLabel *)lbdescription {
    if (_lbdescription == nil) {
        self.lbdescription = [[WPHotspotLabel alloc] initWithFrame:CGRectZero];
        self.lbdescription.textAlignment = NSTextAlignmentLeft;
        self.lbdescription.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, 8*AUTO_SIZE_SCALE_X, kScreenWidth-(30+15+20+23)*AUTO_SIZE_SCALE_X, 28*AUTO_SIZE_SCALE_X);
    }
    return _lbdescription;
}

- (UILabel *)lbDate {
    if (_lbDate == nil) {
        self.lbDate = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.lbDate.textColor = FontUIColorGray;
        self.lbDate.frame = CGRectMake(20*AUTO_SIZE_SCALE_X, self.lbdescription.origin.y+self.lbdescription.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth-(30+15+43)*AUTO_SIZE_SCALE_X, 10*AUTO_SIZE_SCALE_X);
    }
    return _lbDate;
}

- (UIImageView *)timeImageView {
    if (_timeImageView == nil) {
        self.timeImageView = [UIImageView new];
        self.timeImageView.frame = CGRectMake(10*AUTO_SIZE_SCALE_X ,40*AUTO_SIZE_SCALE_X,15, 15);
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

@end
