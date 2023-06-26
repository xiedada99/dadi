//
//  HNTTableViewCell.m
//  demo
//
//  Created by 东哥 on 2022/4/12.
//

#import "HNTTableViewCell.h"

@interface HNTTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *accountAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotNumLael;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *glodLabel;

@end

@implementation HNTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HNTAccountModel *)model
{
    _model = model;
    self.glodLabel.text = [NSString stringWithFormat:@"%@",model.money ];
    
    self.accountAddressLabel.text = [NSString stringWithFormat:@"%ld 地址：%@",self.mark,model.address];
    
//    self.hotNumLael.text = [NSString stringWithFormat:@"%ld",model.model.height-model.block];
    
//    self.stateLabel.text = model.model.online;
    if ([self.stateLabel.text isEqualToString:@"online"]) {
        self.stateLabel.textColor = UIColor.blackColor;
    }else{
        self.stateLabel.textColor = UIColor.redColor;
    }
    
}

@end
