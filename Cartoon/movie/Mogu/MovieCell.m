//
//  MovieCell.m
//  Cartoon
//
//  Created by zxh on 2019/6/21.
//  Copyright © 2019 hanyong. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+WebCache.h"

@interface MovieCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *noteL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UITextView *actorL;
@property (weak, nonatomic) IBOutlet UILabel *idL;
@end


@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
    self.noteL.layer.cornerRadius = 5;
    self.noteL.layer.masksToBounds = YES;
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(MovieItem *)item{
    _item = item;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.pic]];
    self.noteL.text = item.note.length > 0 ? item.note : @"电影";
    self.nameL.text = item.name;
    self.actorL.text = item.actor;
    self.idL.text = [NSString stringWithFormat:@"%d",item.vid];
}

-(void)setXxModel:(XXMovieListModel *)xxModel{
    _xxModel = xxModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:xxModel.coverpic]];
    self.noteL.text = xxModel.episode_statustext;
    self.nameL.text = xxModel.title;
    self.actorL.text = xxModel.intro;
    self.idL.text = [NSString stringWithFormat:@"%@",xxModel.vodid];
}

@end
