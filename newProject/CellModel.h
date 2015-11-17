//
//  CellModel.h
//  newProject
//
//  Created by wanawt on 15/11/17.
//  Copyright © 2015年 IOF－IOS2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellModel : NSObject

//@property (nonatomic, retain) __block UIImage *image;
@property (nonatomic, copy) NSString *urlString; // 图片url
@property (nonatomic, copy) NSString *imageSizeString; // 图片大小

@property (nonatomic, copy) void (^complete)();

- (id)init;

@end
