//
//  ViewController.m
//  瀑布流
//
//  Created by 阿拉斯加的狗 on 2016/10/15.
//  Copyright © 2016年 阿拉斯加的🐶. All rights reserved.
//

#import "ViewController.h"
#import "WKWaterViewLayout.h"
#import "WKShops.h"
#import "WKCollectionViewCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>
@interface ViewController ()<UICollectionViewDataSource,WKWaterViewLayoutDelegate>

@property (nonatomic,strong)NSMutableArray *shops;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ViewController

static NSString *const shopId = @"shop";

- (NSMutableArray *)shops {

    if (!_shops) {
        _shops = [NSMutableArray array];
        
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化collectionview
    [self setUpCollectionView];

    //设置刷新控件
    [self setUpRefresh];
}

/** 
 * 设置刷新控件
 */

- (void)setUpRefresh {

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];


}

/** 
 *  上拉加载新数据
 */

- (void)loadNewShops {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *shops = [WKShops mj_objectArrayWithFilename:@"1.plist"];
        
        //下拉刷新前清空所有数据加载新的
        [self.shops removeAllObjects];
        
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        //结束刷新
        [self.collectionView.mj_header endRefreshing];
        
    });
    
}

/**
 *  下拉加载更多数据
 */
- (void)loadMoreShops {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *shops = [WKShops mj_objectArrayWithFilename:@"1.plist"];
        
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
        
    });

}

/** 
 * 初始化collectionview
 */

- (void)setUpCollectionView {
    
    WKWaterViewLayout *waterLayout = [[WKWaterViewLayout alloc]init];
    waterLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:waterLayout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WKCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:shopId];

}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shops.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopId forIndexPath:indexPath ];
    
    WKShops *shops = self.shops[indexPath.row];
    
    cell.shops = shops;
    
    return cell;
}


#pragma mark - <WKWaterViewLayoutDelegate>
- (CGFloat)waterViewLayout:(WKWaterViewLayout *)waterLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    
    WKShops *shops = self.shops[index];
    
    return itemWidth * shops.h / shops.w;

}

@end
