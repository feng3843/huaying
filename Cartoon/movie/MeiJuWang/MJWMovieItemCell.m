//
//  MJWMovieItemCell.m
//  Cartoon
//
//  Created by zxh on 2020/2/20.
//  Copyright © 2020 hanyong. All rights reserved.
//

#import "MJWMovieItemCell.h"

@interface MJWMovieItemCell()
@property (weak, nonatomic) IBOutlet UILabel *infoL;

@property (weak, nonatomic) IBOutlet UIImageView *picImgV;
@property (weak, nonatomic) IBOutlet UILabel *stateL;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *hitsL;

@property (weak, nonatomic) IBOutlet UILabel *pfL;

@end


@implementation MJWMovieItemCell

-(void)setModel:(MJWMovieItemModel *)model{
    _model = model;
    [self.picImgV sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.infoL.text = model.info;
    self.stateL.text = model.state;
    self.nameL.text = model.name;
    self.hitsL.text = model.hits;
    self.pfL.text = [NSString stringWithFormat:@"豆瓣%@",model.pf];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
