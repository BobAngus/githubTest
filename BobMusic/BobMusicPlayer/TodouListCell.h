//
//  TodouListCell.h
//  BobPlayer
//
//  Created by Bob Angus on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodouListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITextView *InformationLables;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;

@end
