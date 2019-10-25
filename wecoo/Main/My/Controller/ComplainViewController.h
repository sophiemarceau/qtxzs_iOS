//
//  ComplainViewController.h
//  wecoo
//
//  Created by sophiemarceau_qu on 2016/10/28.
//  Copyright © 2016年 屈小波. All rights reserved.
//

#import "BaseViewController.h"
#import "SubmitView.h"
#import "PlaceholderTextView.h"
#import "PhotoCollectionViewCell.h"
@interface ComplainViewController : BaseViewController
@property (nonatomic,strong)SubmitView *submit;
@property (nonatomic,strong)UIImageView *myReportView;
@property (nonatomic,strong)UIView *viewBgImage;
@property (nonatomic,strong)UIView *complainView;
@property (nonatomic,strong)PlaceholderTextView *complainLabel;
//上传图片的button
@property (nonatomic, strong)UIImageView *photoBtn;
@property (nonatomic, strong)UICollectionView *collectionV;
@property (nonatomic, strong)UIView *collectionBGView;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;

@property (nonatomic,strong) SubmitView *subview;




@property (nonatomic,strong)UIImageView *plusImageView;

@property (nonatomic,strong)UILabel *defaultLabel;
@end
