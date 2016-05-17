//
//  dummyMessageTableViewCell.h
//  RapidlyUpdatingTableTest
//
//  Created by Matthew Keable on 17/05/2016.
//  Copyright © 2016 Matthew Keable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DummyMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end
