//
//  eglTestTimeUtils.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLTESTTIMEUTILS_H_
#define TEST_INCLUDE_EGLTESTTIMEUTILS_H_

#include <sys/time.h>

typedef struct timeval TimeRecord_t;

void recordCurrentTime(TimeRecord_t* t);

void diffTime(TimeRecord_t* s, TimeRecord_t* e, TimeRecord_t* r);

void timeToString(TimeRecord_t* t, char* c);

#define LOG_DURATION(s, e) \
{ \
    char t[100]; \
    TimeRecord_t d; \
    diffTime(s, e, &d); \
    timeToString(&d, t); \
    LOG2(D, "Duration (seconds): ", t ) \
}

#define START_RECORD_DURATION(s) {recordCurrentTime(s);}
#define END_RECORD_DURATION(e) {START_RECORD_DURATION(e)}

#endif  // TEST_INCLUDE_EGLTESTTIMEUTILS_H_