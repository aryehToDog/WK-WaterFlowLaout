//
//  WKCollectionViewCell.m
//  瀑布流
//
//  Created by 阿拉斯加的狗 on 2016/10/15.
//  Copyright © 2016年 阿拉斯加的🐶. All rights reserved.
//

#import "WKCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "WKShops.h"
@interface WKCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;


@end

@implementation WKCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShops:(WKShops *)shops {

    _shops = shops;
    
    NSURL *url = [NSURL URLWithString:shops.img];
    [self.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
    
    self.priceLable.text = shops.price;
    

}

@end
