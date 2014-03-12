/**************************************************************************
 * MIT LICENSE
 *
 * Copyright (c) 2013-2014, David Andreoletti <http://davidandreoletti.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **************************************************************************/

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
