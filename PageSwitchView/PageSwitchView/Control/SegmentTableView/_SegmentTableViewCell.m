//
//  _SegmentTableViewCell.m
//  PageSwitchView
//
//  Created by YLCHUN on 16/12/9.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "_SegmentTableViewCell.h"
static const CGFloat fontSize = 7;
static const CGFloat height = 8;

@interface _SegmentTableViewCell ()
{
    UILabel *_textLabel;
}
@property (nonatomic) UILabel *markLabel;
@property (nonatomic) NSLayoutConstraint *markLabel_CW;
@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UIView *bgView;
@end

@implementation _SegmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = self.backgroundColor;
    }
    return self;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = 2;
        _textLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_textLabel];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView  attribute:NSLayoutAttributeLeft multiplier:1 constant:7]];
        [self.contentView  addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView  attribute:NSLayoutAttributeRight multiplier:1 constant:-7]];
        
        [self markLabel];
    }
    return _textLabel;
}

-(UILabel*)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]init];
        _markLabel.font = [UIFont systemFontOfSize:fontSize];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.backgroundColor = [UIColor redColor];
        _markLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _markLabel.layer.cornerRadius = height/2.0;
        _markLabel.layer.masksToBounds = YES;
        _markLabel.hidden = YES;
        [self.contentView addSubview:_markLabel];
        [_markLabel addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
        self.markLabel_CW = [NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        [_markLabel addConstraint:self.markLabel_CW];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_markLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    return _markLabel;
}

-(UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor clearColor];
//        _bgView.contentMode = UIViewContentModeRedraw;
        [self.contentView insertSubview:_bgView atIndex:0];
        _bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _bgView;
}
-(void)setBgCView:(UIView *)bgCView {
    if (_bgCView != bgCView) {
        [_bgCView removeFromSuperview];
        _bgCView = bgCView;
        if (bgCView) {
            [self.bgView addSubview:bgCView];
        }
    }
    
}
-(UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _bgImageView.contentMode = UIViewContentModeRedraw;
        [self.contentView insertSubview:_bgImageView atIndex:_bgView?1:0];
        _bgImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_bgImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_bgImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem:_bgImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _bgImageView;
}
-(void)setNumber:(NSInteger)number {
    _number = number;
    self.markLabel.hidden = number == 0;
    CGFloat width = height;
    CGFloat unit = fontSize-1;
    NSString *text;
    if (number <= 0) {
        text = @"";
    }else
        if (number > 0 && number < 10) {
            width = width;
            text = [NSString stringWithFormat:@"%ld",number];
        }else
            if (number > 10 && number < 100) {
                width = unit+unit;
                text = [NSString stringWithFormat:@"%ld",number];
            }else {
                width = unit+unit+unit;
                text = @"99+";
                
            }
    self.markLabel_CW.constant = width;
    self.markLabel.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-(void)setBgImage:(UIImage *)bgImage {
//    self.bgImageView.image = bgImage;
//}
//
//-(UIImage *)bgImage{
//    return self.bgImageView.image;
//}
@end
