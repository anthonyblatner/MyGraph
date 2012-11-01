//
//  Common.h
//  MyGraph
//
//  Created by Anthony Blatner on 10/23/12.
//  Copyright (c) 2012 AMB Software. All rights reserved.
//

#ifndef MyGraph_Common_h
#define MyGraph_Common_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif
