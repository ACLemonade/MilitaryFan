//
//  ReportInputCell.h
//  MilitaryFan
//
//  Created by Lemonade on 2017/3/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportInputCell;
@protocol ReportInputCellDelegate <NSObject>

- (void)reportInputCell:(ReportInputCell *)cell textViewDidChange:(UITextView *)textView;
- (void)reportInputCell:(ReportInputCell *)cell textViewDidEndEditing:(UITextView *)textView;
@end

@interface ReportInputCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextView *otherReportTV;

@property (nonatomic, weak) id<ReportInputCellDelegate> delegate;
@end
