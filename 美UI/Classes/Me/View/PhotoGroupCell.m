//
//  PhotoGroupCell.m
//  美UI
//
//  Created by Lee on 17/2/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PhotoGroupCell.h"

@implementation PhotoGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"cell";
    PhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

@end
