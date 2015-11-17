//
//  CellModel.m
//  newProject
//
//  Created by wanawt on 15/11/17.
//  Copyright © 2015年 IOF－IOS2. All rights reserved.
//

#import "CellModel.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height;

@implementation CellModel

- (id)init {
    if (self == [super init]) {
        _imageSizeString = NSStringFromCGSize(CGSizeZero);
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    __block UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        _image = image;
        float h123 = ([UIScreen mainScreen].bounds.size.width-10)*image.size.height/image.size.width;
        imgView.frame = CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, h123);
        CGRect frame = [imgView frame];
        frame.size.height = h123+10;
        _imageSizeString = NSStringFromCGSize(frame.size);
        self.complete();
    }];
}

@end
