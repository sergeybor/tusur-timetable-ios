//
//  T3GroupItemPosition.h
//  TusurTimetable
//
//  Created by Katte on 31.07.14.
//  Copyright (c) 2014 Katte. All rights reserved.
//

#ifndef TusurTimetable_T3GroupItemPosition_h
#define TusurTimetable_T3GroupItemPosition_h

typedef enum {
	T3CellPosition_None,
	T3CellPosition_Top,
	T3CellPosition_Middle,
	T3CellPosition_Bottom,
	T3CellPosition_SingleCell //For the case when group contains only one cell
} T3CellPosition;

#endif
