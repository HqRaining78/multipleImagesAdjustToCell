//
//  ViewController.m
//  newProject
//
//  Created by IOF－IOS2 on 15/10/22.
//  Copyright © 2015年 IOF－IOS2. All rights reserved.
//

#import "ViewController.h"
#import "HWHttpTool.h"
#import "UIImageView+WebCache.h"
#import "ZZBImageCell.h"
#import "CellModel.h"

#define kGeneralValueAddedProductUrl @"http://399300.com.cn/chinavalueline33/product.asmx"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *imgsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    _imgsArray = [NSMutableArray array];
    
    [self initView];
    [self loadData];
}

- (void)loadData
{
    NSString *soapMiddleString = [NSString stringWithFormat:@"<GetProdGouchengDetail xmlns=\"http://399300.com.cn/\">\n"
                                  "<id>%d</id>\n"
                                  "</GetProdGouchengDetail>\n",
                                  3
                                  ];
    
    // webservice soap用于网络请求
    [HWHttpTool soapPost:kGeneralValueAddedProductUrl params:soapMiddleString method:@"GetProdGouchengDetail" success:^(id json) {
        NSArray *listArray = ((NSDictionary *)json)[@"R1"];
        NSDictionary *dict = listArray.firstObject;
        NSString *imgStr = dict[@"jichujiayicailiao"];
        NSArray *imgArray = [imgStr componentsSeparatedByString:@","];
        for (NSString *urlString in imgArray) {
            CellModel *model = [[CellModel alloc] init];
            [model setUrlString:urlString];
            model.complete = ^() {
                [_tableView  reloadData];
            };
            [_imgsArray addObject:model];
        }
    } failure:^(NSError *error) {
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imgsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellModel *model = _imgsArray[indexPath.row];
    CGSize size = CGSizeFromString(model.imageSizeString);
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[ZZBImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    
    CellModel *model = self.imgsArray[indexPath.row];
    [cell setContent:model.urlString];
    
    return cell;
}

- (void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
