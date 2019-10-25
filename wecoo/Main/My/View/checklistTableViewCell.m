//
//  checklistTableViewCell.m
//  wecoo
//
//  Created by 屈小波 on 2017/5/27.
//  Copyright © 2017年 屈小波. All rights reserved.
//

#import "checklistTableViewCell.h"

@implementation checklistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)prepareForReuse{
//    [super prepareForReuse];
//    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj,NSUInteger idx,BOOL * _Nonnull stop){
//        [obj removeFromSuperview];
//    }];
//}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BGColorGray;
        [self _initView];
    }
    return self;
}

-(void)_initView{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.timeLabel];
    [self.bgView addSubview:self.desLabel];
    [self.bgView addSubview:self.lineImageView];
    
    [self.bgView addSubview:self.buttonView];
    

    
    [self.buttonView addSubview:self.followView];
    [self.buttonView addSubview:self.followImageView];
    [self.buttonView addSubview:self.followrecordLabel];
    
    [self.buttonView addSubview:self.PhoneView];
    [self.buttonView addSubview:self.PhoneImageView];
    [self.buttonView addSubview:self.phoneLabel];
    
    [self.buttonView addSubview:self.quitButton];
    [self.buttonView addSubview:self.confirmPassButton];
    
    [self.bgView addSubview:self.followView1];
    [self.followView1 addSubview:self.followImageView1];
    [self.followView1 addSubview:self.followrecordLabel1];
    [self.bgView addSubview:self.PhoneView1];
    [self.PhoneView1 addSubview:self.PhoneImageView1];
    [self.PhoneView1 addSubview:self.phoneLabel1];
    [self.bgView addSubview:self.verticallineImageView1];
}

- (CGFloat)setCellHeight:(NSString *)strInfo withFlag:(int)listType{
    
    self.nameLabel.text  = [NSString stringWithFormat:@"客户姓名：%@",[self.celldata objectForKey:@"report_customer_name"]];
    self.timeLabel.text = [self.celldata objectForKey:@"report_createdtime"];
    CGFloat descheight =self.desLabel.frame.size.height;
    [self.desLabel setNumberOfLines:0];  //0行，则表示根据文本长度，自动增加行数
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    self.desLabel.text =[[self.celldata objectForKey:@"latestCustomerReportLogDto"] objectForKey:@"crl_note"];
    [self.desLabel sizeToFit];
    CGSize size  = CGSizeMake(self.desLabel.frame.size.width, self.desLabel.frame.size.height);
    
    descheight = descheight > size.height ? descheight : size.height;
    self.desLabel.size = CGSizeMake(self.desLabel.frame.size.width, descheight);
    
    self.lineImageView.frame = CGRectMake(0, self.desLabel.frame.origin.y+self.desLabel.frame.size.height+10*AUTO_SIZE_SCALE_X, kScreenWidth, 0.5*AUTO_SIZE_SCALE_X);
    
    if (listType ==1 || listType ==2 ) {
        self.PhoneView1.hidden = YES;
        self.followView1.hidden = YES;
        self.verticallineImageView1.hidden = YES;
        
        self.buttonView.hidden = NO;
        self.followView.hidden = NO;
        self.PhoneView.hidden = NO;
        
        self.buttonView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth, 58*AUTO_SIZE_SCALE_X);
        
        self.followView.frame = CGRectMake(self.followrecordLabel.frame.origin.x,
                                           self.followImageView.frame.origin.y,
                                           self.followrecordLabel.frame.size.width ,
                                           self.followrecordLabel.frame.size.height+self.followImageView.frame.size.height);
        
        self.PhoneView.frame = CGRectMake(self.phoneLabel.frame.origin.x,
                                          self.PhoneImageView.frame.origin.y,
                                          self.phoneLabel.frame.size.width ,
                                          self.phoneLabel.frame.size.height+self.PhoneImageView.frame.size.height);
        
        
        
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth, self.buttonView.frame.origin.y+self.buttonView.frame.size.height);
        return self.buttonView.frame.origin.y+self.buttonView.frame.size.height+10*AUTO_SIZE_SCALE_X;
    }else{
        self.PhoneView1.hidden = NO;
        self.followView1.hidden = NO;
        self.verticallineImageView1.hidden = NO;
        
        self.buttonView.hidden = YES;
        self.followView.hidden = YES;
        self.PhoneView.hidden = YES;
        
        self.PhoneView1.frame = CGRectMake(kScreenWidth/2, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        self.followView1.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        self.bgView.frame = CGRectMake(0, 0, kScreenWidth, self.followView1.frame.origin.y+self.followView1.frame.size.height);
        return self.followView1.frame.origin.y+self.followView1.frame.size.height+10*AUTO_SIZE_SCALE_X;
    }
    
    
}

-(void)PhoneTaped:(UITapGestureRecognizer *)sender{
    [MobClick event:kChectListPhoneonClickEvent];
    NSDictionary *dic = @{
                          @"report_id_str":[self.celldata objectForKey:@"report_id_str"],
                          };
    NSLog(@"dic======%@",dic);
    
    [[RequestManager shareRequestManager] GetCustomerTelByReportIdStrResult:dic viewController:nil successData:^(NSDictionary *result){
        //        [LZBLoadingView dismissLoadingView];
        if(IsSucess(result)){
            NSLog(@"result======%@",result);
            if (result != nil) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[result objectForKey:@"data"] objectForKey:@"result"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{}
                 
                                         completionHandler:^(BOOL success) {
                                         }];
                //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                //                    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.2f];
            }
        }else{
            [[RequestManager shareRequestManager] resultFail:result viewController:nil];
        }
    }failuer:^(NSError *error){
        [[RequestManager shareRequestManager] tipAlert:@"网络加载失败,请重试" viewController:nil];
    }];
}

-(void)TradeTaped:(UITapGestureRecognizer *)sender{
    [[sender view] setUserInteractionEnabled:NO];
    
    NSLog(@"data---->%@",self.celldata);
    [self.delegate buttononclick:[[sender view] tag] WithID:[self.celldata objectForKey:@"report_id"] WithReportString:[self.celldata objectForKey:@"report_id_str"] WithProjectIDString:[self.celldata objectForKey:@"project_id"]];
    [[sender view] setUserInteractionEnabled:YES];
}


-(void)onclickButton:(UIButton *)sender{
    NSLog(@"sender tag------%d",sender.tag);
    sender.enabled = NO;
    [MobClick event:kChectListBackonClickEvent];
    [self.delegate buttononclick:sender.tag WithID:[self.celldata objectForKey:@"report_id"
                                                    ] WithReportString:[self.celldata objectForKey:@"report_id_str"
                                                                        ] WithProjectIDString
                                :[self.celldata objectForKey:@"project_id"
                                  ]];
    sender.enabled = YES;
}


- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        self.nameLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.nameLabel.textColor = RedUIColorC1;
        self.nameLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,15*AUTO_SIZE_SCALE_X, (kScreenWidth-(30)*AUTO_SIZE_SCALE_X), 21*AUTO_SIZE_SCALE_X);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        self.timeLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:12*AUTO_SIZE_SCALE_X];
        self.timeLabel.textColor = UIColorFromRGB(0x999999);
        self.timeLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X,self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+3*AUTO_SIZE_SCALE_X, (kScreenWidth-(30)*AUTO_SIZE_SCALE_X), 16.5*AUTO_SIZE_SCALE_X);
    }
    return _timeLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        self.desLabel = [CommentMethod initLabelWithText:@"" textAlignment:NSTextAlignmentLeft font:15*AUTO_SIZE_SCALE_X];
        self.desLabel.frame = CGRectMake(15*AUTO_SIZE_SCALE_X, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height+5*AUTO_SIZE_SCALE_X, kScreenWidth-(30)*AUTO_SIZE_SCALE_X, 21*AUTO_SIZE_SCALE_X);
        self.desLabel.textColor = FontUIColorBlack;
        
    }
    return _desLabel;
}

-(UIImageView *)lineImageView{
    if (_lineImageView == nil) {
        self.lineImageView = [UIImageView new];
        self.lineImageView.backgroundColor = lineImageColor;
        self.lineImageView.frame = CGRectMake(0,
                                              self.desLabel.frame.origin.y+self.desLabel.frame.size.height,
                                              kScreenWidth,
                                              0.5*AUTO_SIZE_SCALE_X);
    }
    return  _lineImageView;
}

-(UIView *)buttonView{
    if (_buttonView == nil) {
        self.buttonView = [UIView new];
        self.buttonView.size = CGSizeMake(kScreenWidth, 58*AUTO_SIZE_SCALE_X);
        
       
    }
    return  _buttonView;
}



-(UIImageView *)followImageView{
    if (_followImageView == nil) {
        self.followImageView = [UIImageView new];
        self.followImageView.image = [UIImage imageNamed:@"icon_enterprise_review_chat_log"];
        self.followImageView.frame = CGRectMake(43*AUTO_SIZE_SCALE_X,
                                                10.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return  _followImageView;
}

- (UILabel *)followrecordLabel {
    if (_followrecordLabel == nil) {
        self.followrecordLabel = [CommentMethod initLabelWithText:@"跟进记录" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.followrecordLabel.frame = CGRectMake(30*AUTO_SIZE_SCALE_X, self.followImageView.frame.origin.y+self.followImageView.frame.size.height+3.5*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.followrecordLabel.textColor = FontUIColorBlack;
    }
    return _followrecordLabel;
}


-(UIView *)followView{
    if (_followView == nil) {
        self.followView = [UIView new];
        self.followView.tag = 2;
        self.followView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
        [self.followView addGestureRecognizer:tap1];
    }
    return  _followView;
}

- (UIImageView *)PhoneImageView {
    if (_PhoneImageView == nil) {
        self.PhoneImageView = [UIImageView new];
        self.PhoneImageView.image = [UIImage imageNamed:@"icon_enterprise_review_phone"];
        self.PhoneImageView.frame = CGRectMake(116*AUTO_SIZE_SCALE_X,
                                                10.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
        
    }
    return _PhoneImageView;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        self.phoneLabel = [CommentMethod initLabelWithText:@"拨打电话" textAlignment:NSTextAlignmentCenter font:11*AUTO_SIZE_SCALE_X];
        self.phoneLabel.frame = CGRectMake(104*AUTO_SIZE_SCALE_X, self.PhoneImageView.frame.origin.y+self.PhoneImageView.frame.size.height+3.5*AUTO_SIZE_SCALE_X, 50*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.phoneLabel.textColor = FontUIColorBlack;
    }
    return _phoneLabel;
}

-(UIView *)PhoneView{
    if (_PhoneView == nil) {
        self.PhoneView = [UIView new];
        self.PhoneView.tag = 3;
        self.PhoneView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhoneTaped:)];
        [self.PhoneView addGestureRecognizer:tap2];
        
    }
    return  _PhoneView;
}


-(UIButton *)quitButton{
    if (_quitButton == nil) {
        self.quitButton = [CommentMethod createButtonWithBackgroundColor:[UIColor whiteColor] Target:self Action:@selector(onclickButton:) Title:@"退回" FontColor:RedUIColorC1 FontSize:14*AUTO_SIZE_SCALE_X];
        self.quitButton.tag = 0;
        self.quitButton.frame = CGRectMake(178*AUTO_SIZE_SCALE_X,
                                           10*AUTO_SIZE_SCALE_X,
                                           72*AUTO_SIZE_SCALE_X,
                                           38*AUTO_SIZE_SCALE_X);
        self.quitButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.quitButton.layer.borderWidth=1.0;
        self.quitButton.layer.masksToBounds = YES;
        self.quitButton.layer.borderColor = [RedUIColorC1 CGColor];
    }
    return _quitButton;
}

-(UIButton *)confirmPassButton{
    if (_confirmPassButton == nil) {
        self.confirmPassButton = [CommentMethod createButtonWithBackgroundColor:RedUIColorC1 Target:self Action:@selector(onclickButton:) Title:@"确认通过" FontColor:[UIColor whiteColor] FontSize:14*AUTO_SIZE_SCALE_X];
        self.confirmPassButton.tag = 1;
        self.confirmPassButton.frame = CGRectMake(kScreenWidth-115*AUTO_SIZE_SCALE_X,
                                                  10*AUTO_SIZE_SCALE_X,
                                                  100*AUTO_SIZE_SCALE_X,
                                                  38*AUTO_SIZE_SCALE_X);
        self.confirmPassButton.layer.cornerRadius = 5*AUTO_SIZE_SCALE_X;
        self.confirmPassButton.layer.borderWidth=1.0;
        self.confirmPassButton.layer.masksToBounds = YES;
        self.confirmPassButton.layer.borderColor = [RedUIColorC1 CGColor];
    }
    return _confirmPassButton;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
    return  _bgView;
}

-(UIView *)followView1{
    if (_followView1 == nil) {
        self.followView1 = [UIView new];
        self.followView1.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        self.followView1.tag = 3;
        UITapGestureRecognizer *phonetap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TradeTaped:)];
        self.followView1.userInteractionEnabled = YES;
        [self.followView1 addGestureRecognizer:phonetap1];
        
    }
    return  _followView1;
}

-(UIImageView *)followImageView1{
    if (_followImageView1 == nil) {
        self.followImageView1 = [UIImageView new];
        self.followImageView1.image = [UIImage imageNamed:@"icon_enterprise_review_chat_log"];
        self.followImageView1.frame = CGRectMake(57*AUTO_SIZE_SCALE_X,
                                                14.5*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X,
                                                20*AUTO_SIZE_SCALE_X);
    }
    return  _followImageView1;
}

- (UILabel *)followrecordLabel1 {
    if (_followrecordLabel1 == nil) {
        self.followrecordLabel1 = [CommentMethod initLabelWithText:@"跟进记录" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.followrecordLabel1.frame = CGRectMake(87*AUTO_SIZE_SCALE_X, 17.5*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.followrecordLabel1.textColor = FontUIColorBlack;
    }
    return _followrecordLabel1;
}

-(UIView *)PhoneView1{
    if (_PhoneView1 == nil) {
        self.PhoneView1 = [UIView new];
        self.PhoneView1.frame = CGRectMake(kScreenWidth/2, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, kScreenWidth/2, 49*AUTO_SIZE_SCALE_X);
        UITapGestureRecognizer *phonetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PhoneTaped:)];
        self.PhoneView1.tag = 2;
        self.PhoneView1.userInteractionEnabled = YES;
        [self.PhoneView1 addGestureRecognizer:phonetap];
    }
    return  _PhoneView1;
}

- (UIImageView *)PhoneImageView1 {
    if (_PhoneImageView1 == nil) {
        self.PhoneImageView1 = [UIImageView new];
        self.PhoneImageView1.image = [UIImage imageNamed:@"icon_enterprise_review_phone"];
        
        self.PhoneImageView1.frame = CGRectMake(57*AUTO_SIZE_SCALE_X,
                                               14.5*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X,
                                               20*AUTO_SIZE_SCALE_X);
    }
    return _PhoneImageView1;
}



- (UILabel *)phoneLabel1 {
    if (_phoneLabel1 == nil) {
        self.phoneLabel1 = [CommentMethod initLabelWithText:@"拨打电话" textAlignment:NSTextAlignmentLeft font:11*AUTO_SIZE_SCALE_X];
        self.phoneLabel1.frame = CGRectMake(87*AUTO_SIZE_SCALE_X, 17.5*AUTO_SIZE_SCALE_X, 60*AUTO_SIZE_SCALE_X, 15*AUTO_SIZE_SCALE_X);
        self.phoneLabel1.textColor = FontUIColorBlack;
    }
    return _phoneLabel1;
}




-(UIImageView *)verticallineImageView1{
    if (_verticallineImageView1 == nil) {
        self.verticallineImageView1 = [UIImageView new];
        self.verticallineImageView1.backgroundColor = lineImageColor;
        self.verticallineImageView1.frame = CGRectMake(kScreenWidth/2,self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height+
                                                      23*AUTO_SIZE_SCALE_X,
                                                      0.5,
                                                      20*AUTO_SIZE_SCALE_X);
    }
    return  _verticallineImageView1;
}

@end
