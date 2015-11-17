//
//  HWHttpTool.h
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年 sx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

// soap网络请求
+ (void)soapPost:(NSString *)url params:(NSString *)params method:(NSString *)method success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
//
+ (void)newPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
