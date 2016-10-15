//
//  WKWaterViewLayout.m
//  瀑布流
//
//  Created by 阿拉斯加的狗 on 2016/10/15.
//  Copyright © 2016年 阿拉斯加的🐶. All rights reserved.
//

#import "WKWaterViewLayout.h"

/** 默认的列数 */
static const NSInteger WKDefaultColumnCount = 3;
/** 默认的每一列间距 */
static const NSInteger WKDefaultColumnMargin = 10;
/** 默认的每一行间距 */
static const NSInteger WKDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets WKDefaultEdgeInsets = {10,10,10,10};


@interface WKWaterViewLayout ()

/** 存到所有cell的布局 */
@property (nonatomic,strong)NSMutableArray *attsArray;
/** 存放所有列的当前高度 */
@property (nonatomic,strong)NSMutableArray *columnHeights;
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
@end

@implementation WKWaterViewLayout

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return WKDefaultRowMargin;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return WKDefaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return WKDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return WKDefaultEdgeInsets;
    }
}


- (NSMutableArray *)columnHeights {

    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attsArray {

    if (!_attsArray) {
        _attsArray = [NSMutableArray array];
    }
    return _attsArray;
}

/** 
 *   准备布局
 */
- (void)prepareLayout {

    [super prepareLayout];
    
    //清楚以前计算的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清空之前的布局
    [self.attsArray removeAllObjects];
    
    //创建cell的每一个布局
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSUInteger i = 0; i < count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:path];
        
        //添加到数组中
        [self.attsArray addObject:atts];
    }
}

/**
 *   决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    
    return self.attsArray;
}

/**
 *   布局item的具体位置
 */
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *atts = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //布局item
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat W = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    //获取到collectionView的item的最短的那一列
    NSUInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSUInteger i = 1; i < self.columnCount; i ++) {
        
        //获取i行的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
        
    }
    
    CGFloat X = self.edgeInsets.left + destColumn * (W + self.columnMargin);
    
    CGFloat Y = minColumnHeight;
    if (Y != self.edgeInsets.top) {
        Y += self.rowMargin;
    }
    CGFloat H = [self.delegate waterViewLayout:self heightForItemAtIndex:indexPath.item itemWidth:W];
    
    atts.frame = CGRectMake(X, Y, W, H);
    
    //更新最短的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(atts.frame));
    
    return atts;
}

/**
 *   布局的滚动范围
 */
- (CGSize)collectionViewContentSize {

    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSUInteger i = 1; i < self.columnCount; i ++) {
        
        //获取i行的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight > maxColumnHeight) {
            maxColumnHeight = columnHeight;
            
        }
        
    }
    
    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}


@end
