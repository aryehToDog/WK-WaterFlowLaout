//
//  WKWaterViewLayout.h
//  瀑布流
//
//  Created by 阿拉斯加的狗 on 2016/10/15.
//  Copyright © 2016年 阿拉斯加的🐶. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WKWaterViewLayout;
@protocol WKWaterViewLayoutDelegate <NSObject>

@required
/** 外部所在的尺寸计算布局内的高度 */
- (CGFloat)waterViewLayout:(WKWaterViewLayout *)waterLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/** 瀑布流所在的列数 */
- (CGFloat)columnCountInWaterflowLayout:(WKWaterViewLayout *)waterflowLayout;
/** item的每一列的边距 */
- (CGFloat)columnMarginInWaterflowLayout:(WKWaterViewLayout *)waterflowLayout;
/** item的每一行的边距 */
- (CGFloat)rowMarginInWaterflowLayout:(WKWaterViewLayout *)waterflowLayout;
/** 内边距 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WKWaterViewLayout *)waterflowLayout;

@end

@interface WKWaterViewLayout : UICollectionViewLayout


@property (nonatomic,weak)id<WKWaterViewLayoutDelegate> delegate;

@end
