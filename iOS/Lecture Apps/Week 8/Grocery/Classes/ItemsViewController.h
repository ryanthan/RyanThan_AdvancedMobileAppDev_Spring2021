//
//  ItemsViewController.h
//  Grocery
//
//  Created by Aileen Pierce on 10/23/11.
//  Copyright 2011 University of Colorado at Boulder. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemsViewController : UITableViewController {
	NSArray *itemList;

}

@property (nonatomic, retain) NSArray *itemList;

@end
