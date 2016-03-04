//
//  XMGShopCell.m
//  瀑布流
//
//  Created by Mac on 16/3/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XMGShopCell.h"
#import "XMGShop.h"

#import "UIImageView+WebCache.h"


@interface XMGShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation XMGShopCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setShop:(XMGShop *)shop{

    [self.imageV sd_setImageWithURL:[NSURL URLWithString:shop.img]];
    
    self.title.text  = shop.price;

}

@end
