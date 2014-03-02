//
//  eglTestTimeUtils.c
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#include "eglTestTimeUtils.h"

#include <sys/time.h>
#include <stdio.h>
#include <inttypes.h>

void recordCurrentTime(TimeRecord_t* t) {
    gettimeofday(t, NULL);
}

void diffTime(TimeRecord_t* s, TimeRecord_t* e, TimeRecord_t* r) {   
    r->tv_sec = e->tv_sec - s->tv_sec;
    r->tv_usec = e->tv_usec - s->tv_usec;
}

void timeToString(TimeRecord_t* t, char* c) {
    sprintf(c, "%jd.%06jd\n", (intmax_t)t->tv_sec, (intmax_t)t->tv_usec);
}
