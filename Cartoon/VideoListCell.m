//
//  VideoListCell.m
//  Cartoon
//
//  Created by hanyong on 2019/4/22.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "VideoListCell.h"


@interface VideoListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIView *bview;
@end


@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.nameL.backgroundColor = [UIColor orangeColor];
    self.bview.backgroundColor = [UIColor orangeColor];
    self.bview.layer.cornerRadius = 8;
    self.imageV.layer.cornerRadius = 8;
    self.imageV.layer.masksToBounds = YES;
    self.bview.layer.masksToBounds = YES;
    self.backgroundColor = [FYColorTool colorFromHexRGB:@"#91A9CE" alpha:1];
    self.contentView.backgroundColor = [FYColorTool colorFromHexRGB:@"#91A9CE" alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(VideoListModel *)model{
    _model = model;
    NSString *pic =model.pic; //[model.pic stringByReplacingOccurrencesOfString:@"\/" withString:@""];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:pic]];
    self.nameL.text = model.name;
}
@end
