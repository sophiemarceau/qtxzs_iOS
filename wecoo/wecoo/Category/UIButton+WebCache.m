//
//  UIButton+WebCache.m
//  WXMovie
//


//

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIButton (WebCache)

//- (void)setImageWithURL:(NSURL *)url
//{
//    [self setImageWithURL:url placeholderImage:nil];
//}
//
//- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
//{
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    // Remove in progress downloader from queue
//    [[manager cancelForDelegate:self];
//    
//     ]
//
//    [self setImage:placeholder forState:UIControlStateNormal];
//    
//    if (url)
//    {
//        [manager downloadWithURL:url delegate:self];
//    }
//}
//
//- (void)cancelCurrentImageLoad
//{
//    [[SDWebImageManager sharedManager] cancelForDelegate:self];
//}
//
//- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
//{
//
//    [self setImage:image forState:UIControlStateNormal];
//}

@end
