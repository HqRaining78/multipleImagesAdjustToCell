//
//  imgCell.m
//  newProject
//
//  Created by IOF－IOS2 on 15/10/22.
//  Copyright © 2015年 IOF－IOS2. All rights reserved.
//

#import "ZZBImageCell.h"
#import "UIImageView+WebCache.h"

@interface ZZBImageCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZBImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
    [self.contentView addSubview:self.imgView];
}

- (void)setContent:(NSString *)content
{
    __block UIImageView *imgView = self.imgView;
    [imgView sd_setImageWithURL:[NSURL URLWithString:content] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        float h123 = ([UIScreen mainScreen].bounds.size.width-10)*image.size.height/image.size.width;
        imgView.frame = CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width-10, h123);
        CGRect frame = [self frame];
        frame.size.height = h123+10;
        self.frame = frame;
    }];
}

@end
