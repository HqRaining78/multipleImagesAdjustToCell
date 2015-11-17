//
//  HWHttpTool.m
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年 sx. All rights reserved.
//

#import "HWHttpTool.h"
#import "AFNetworking.h"
#import "SoapXmlParseHelper.h"

#define BaseUrl @"http://399300.com.cn/"

@implementation HWHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)newPost:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)soapPost:(NSString *)url params:(NSString *)params method:(NSString *)method success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSString *soapMsg = [self getTheSoapMsg:params];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [manager setSecurityPolicy:securityPolicy];
    
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    
    NSString *soapAction = [NSString stringWithFormat:BaseUrl@"%@", method];
    
    [manager.requestSerializer setValue:length forHTTPHeaderField:@"Content-Length"];
    
    [manager.requestSerializer setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    
    //将之前构建好的 soap:Envelope部分写入http 请求的body：：
    
    [request setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [operation responseString];
        
        if ([response hasPrefix:@"<?xml version=\"1.0\""]) {
            id result = [SoapXmlParseHelper SoapMessageResultXml:response ServiceMethodName:method];
            NSData *data = [result  dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers | NSJSONReadingAllowFragments) error:nil];
            if (success) {
                success(jsonObject);
            }
        } else {
            response = [response substringToIndex:[response rangeOfString:@"<?xml version=\"1.0\""].location];
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers | NSJSONReadingAllowFragments) error:nil];
            if (success) {
                success(jsonObject);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    [manager.operationQueue addOperation:operation];
}

+ (NSString *)getTheSoapMsg:(NSString *)middleStr
{
    NSString *string = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                        "<soap:Header>\n"
                        "<MySoapHeader xmlns=\"http://399300.com.cn/\">\n"
                        "<UserName>inlk_72$s</UserName>\n"
                        "<PassWord>1735$%%sfe</PassWord>\n"
                        "</MySoapHeader>\n"
                        "</soap:Header>\n"
                        "<soap:Body>\n"
                        "%@"
                        "</soap:Body>\n"
                        "</soap:Envelope>\n", middleStr];
    return string;
}

@end
