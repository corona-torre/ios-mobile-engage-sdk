//
//  Copyright © 2018 Emarsys. All rights reserved.
//

#define TABLE_NAME_BUTTON_CLICK @"button_click"
#define COLUMN_NAME_CAMPAIGN_ID @"campaign_id"
#define COLUMN_NAME_BUTTON_ID @"button_id"
#define COLUMN_NAME_TIMESTAMP @"timestamp"

#define SQL_CREATE_TABLE_BUTTON_CLICK [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT, %@ TEXT, %@ DOUBLE);", TABLE_NAME_BUTTON_CLICK, COLUMN_NAME_CAMPAIGN_ID, COLUMN_NAME_BUTTON_ID, COLUMN_NAME_TIMESTAMP]
#define SQL_INSERT [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@) VALUES (?, ?, ?);", TABLE_NAME_BUTTON_CLICK, COLUMN_NAME_CAMPAIGN_ID, COLUMN_NAME_BUTTON_ID, COLUMN_NAME_TIMESTAMP]
#define SQL_SELECT(filter) [NSString stringWithFormat:@"SELECT * FROM %@ %@;", TABLE_NAME_BUTTON_CLICK, filter]
#define SQL_DELETE_ITEM_FROM_BUTTON_CLICK(filter) [NSString stringWithFormat:@"DELETE FROM %@ %@;", TABLE_NAME_BUTTON_CLICK, filter]
#define SQL_PURGE [NSString stringWithFormat:@"DELETE FROM %@;", TABLE_NAME_BUTTON_CLICK]
#define SQL_COUNT [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@;", TABLE_NAME_BUTTON_CLICK]