//
//  ViewController.m
//  SearchController
//
//  Created by zhouyu on 2017/12/16.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
// 数据源数组
@property (nonatomic, strong) NSMutableArray *datas;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"searchController";
    self.view.backgroundColor = [UIColor redColor];
    for (int i = 0; i < 100; i++) {
        NSString *str = [NSString stringWithFormat:@"测试数据%d", i];
        [self.datas addObject:str];
    }
    [self setUpUI];
}

#pragma mark - UISearchResultsUpdating - 搜索的时候
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *inputStr = searchController.searchBar.text ;
    //删除上一次的搜索结果
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    //匹配所搜内容
    for (NSString *str in self.datas) {
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            [self.results addObject:str];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 这里通过searchController的active属性来区分展示数据源是哪个
//    if (self.searchController.active) {
        return self.results.count ;
//    }
//    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25];
    // 这里通过searchController的active属性来区分展示数据源是哪个
//    if (self.searchController.active ) {
        cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
//    } else {
//        cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
//    } else {
//        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
//    }
}

#pragma mark - UISearchControllerDelegate代理
// 1. 展示搜索控制器--添加所搜结果的tableView
- (void)presentSearchController:(UISearchController *)searchController{
//    [self.view addSubview:self.tableView];
    NSLog(@"presentSearchController");
}
// 2. 将要弹出搜索控制器
- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"willPresentSearchController");
}
// 3. 已经弹出搜索控制器
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"didPresentSearchController");
}
// 4. 将要消失搜索控制器
- (void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"willDismissSearchController");
}
//5. 已经消失搜索控制器--删除所搜结果的tableView
- (void)didDismissSearchController:(UISearchController *)searchController{
//    [self.tableView removeFromSuperview];
    NSLog(@"didDismissSearchController");
}

//设置UI
- (void)setUpUI {
    [self searchController];
//    [self.view addSubview:self.tableView];
}

//搜索控制器
- (UISearchController *)searchController{
    if (_searchController == nil) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        searchController.delegate = self;
        // 设置结果更新代理
        searchController.searchResultsUpdater = self;
        // 因为在当前控制器展示结果, 所以不需要这个透明视图  //搜索时，背景变暗色
        searchController.dimsBackgroundDuringPresentation = YES;
        if (@available(iOS 9.1, *)) {
            //搜索时，背景变模糊
            searchController.obscuresBackgroundDuringPresentation = NO;
        }
        //是否隐藏导航栏,默认是YES
        searchController.hidesNavigationBarDuringPresentation = NO;
        self.navigationItem.titleView = searchController.searchBar;
        
        searchController.searchBar.placeholder = @"搜索";
        [searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        // 改变取消按钮字体颜色
//        searchController.searchBar.tintColor =  [UIColor whiteColor];
        // 改变searchBar背景颜色
//        searchController.searchBar.barTintColor = [UIColor blueColor];
        // 取消searchBar上下边缘的分割线
//        searchController.searchBar.backgroundImage = [[UIImage alloc] init];
        // 显示背景
//        searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
        _searchController = searchController;
    }
    return _searchController;
}

//结果展示
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - 44 - [UIApplication sharedApplication].statusBarFrame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
//        _tableView.tableHeaderView = _searchController.searchBar;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
//初始数据
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    return _datas;
}
//结果展示
- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    return _results;
}


@end
