//
//  T3FavouriteCell.h
//  TusurTimetable
//
//  Created by Katte on 26.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface T3FavouriteCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)configureWithItem:(NSManagedObject *)item;

@end
