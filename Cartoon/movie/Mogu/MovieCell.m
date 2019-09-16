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

-(void)setWmModel:(WMModel *)wmModel{
    _wmModel = wmModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:wmModel.d_pic]];
    self.noteL.text = wmModel.d_remarks;
    self.nameL.text = wmModel.d_name;
    
    self.idL.text = [NSString stringWithFormat:@"%@",wmModel.d_id];
}

-(void)setDwsjModel:(DWSJModel *)dwsjModel{
    _dwsjModel = dwsjModel;
    NSString *baseUrl = @"http://www.cctv1zhibo.com/";
    self.actorL.text = @"";
    self.noteL.hidden = YES;
    self.idL.text = @"";
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,dwsjModel.src]] placeholderImage:[UIImage imageNamed:@"电台"]];
    self.nameL.text = dwsjModel.title;
}

-(void)setKkModel:(KKModel *)kkModel{
    _kkModel = kkModel;
    self.actorL.text = @"";
    self.noteL.hidden = YES;
    self.idL.text = @"";
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:kkModel.src] placeholderImage:[UIImage imageNamed:@"电台"]];
    self.nameL.text = kkModel.title;
}

-(void)setDdModel:(DDMovieItem *)ddModel{
    _ddModel = ddModel;
    self.actorL.text = ddModel.vod_content;
    self.noteL.text = ddModel.vod_remarks;
    self.idL.text = [NSString stringWithFormat:@"%@",ddModel.vod_id];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:ddModel.vod_pic] placeholderImage:[UIImage imageNamed:@"电台"]];
    self.nameL.text = ddModel.vod_name;
}

@end
