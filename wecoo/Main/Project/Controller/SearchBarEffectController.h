//
//  SearchBarEffectController.h
//  微信搜索模糊效果
//
//  Created by MAC on 17/4/1.
//  Copyright © 2017年 MyanmaPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  searchSuccessDelegate<NSObject>
- (void)addSuccessReturnClientPage:(NSDictionary*)returnTypeDic;;
@end
@interface SearchBarEffectController : UIView


@property(nonatomic , strong)UISearchBar * searchBar;
@property(nonatomic , strong)NSMutableArray *ListArray;
@property(nonatomic , strong)NSMutableArray *menuArray;
@property(nonatomic , strong)UITableView * tableView;
@property(nonatomic, weak)id <searchSuccessDelegate>delegate;
- (void)hidden;
- (void)show;
@end
