//
//  ReportInputCell.m
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ReportInputCell.h"


@implementation ReportInputCell

- (void)textViewDidChange:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(reportInputCell:textViewDidChange:)]) {
        [_delegate reportInputCell:self textViewDidChange:textView];
    }
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(reportInputCell:textViewDidEndEditing:)]) {
        [_delegate reportInputCell:self textViewDidEndEditing:textView];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.selectBtn addTarget:self action:@selector(selectSender:) forControlEvents:UIControlEventTouchUpInside];
    self.otherReportTV.userInteractionEnabled = NO;
    [self.otherReportTV resignFirstResponder];
    self.otherReportTV.textColor = [UIColor lightGrayColor];
}
//- (void)selectSender:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    BOOL selectedState = sender.selected;
//    if (selectedState) {
//        self.otherReportTV.userInteractionEnabled = YES;
//        [self.otherReportTV becomeFirstResponder];
//        self.otherReportTV.textColor = [UIColor blackColor];
//    } else {
//        self.otherReportTV.userInteractionEnabled = NO;
//        [self.otherReportTV resignFirstResponder];
//        self.otherReportTV.textColor = [UIColor lightGrayColor];
//    }
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
