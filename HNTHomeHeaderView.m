//
//  HNTHomeHeaderView.m
//  demo
//
//  Created by 东哥 on 2022/4/25.
//

#import "HNTHomeHeaderView.h"

@interface HNTHomeHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *addresLabel;

@property (weak, nonatomic) IBOutlet UILabel *banceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation HNTHomeHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)setInfoModel:(HNTAccountModel *)infoModel
{
    _infoModel = infoModel;

    self.countLabel.text = [NSString stringWithFormat:@"热点数：%d",infoModel.hotspot_count];
    self.banceLabel.text = [NSString stringWithFormat:@"当前：%@ / 上次： %@",infoModel.money,infoModel.money];
    self.addresLabel.text = [NSString stringWithFormat:@"%ld：%@",self.indexNumbet+1,infoModel.address];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
