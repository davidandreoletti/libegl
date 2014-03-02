//
//  eglGetCurrentSurfaceTesT.h
//  eglTests
//
//  Created by David Andreoletti on 10/11/13.
//  Copyright (c) 2013 David Andreoletti. All rights reserved.
//

#ifndef TEST_INCLUDE_EGLGETCURRENTSURFACETEST_H_
#define TEST_INCLUDE_EGLGETCURRENTSURFACETEST_H_

#include "eglTest.h"
#include "eglPlatformHarness.h"

#include <stdlib.h>
#include <string.h>

static void test_eglGetCurrentSurface(EGLSurface* eglGetCurrentSurfaceSurface, EGLSurface expectedEglGetCurrentSurfaceSurface, EGLint readdraw, EGLint expectedEglGetCurrentSurfaceError)
{
    *eglGetCurrentSurfaceSurface = eglGetCurrentSurface(readdraw);
    test_compare_EGLint(eglGetError(), EQUAL, expectedEglGetCurrentSurfaceError);
    test_compare_EGLDisplay(*eglGetCurrentSurfaceSurface, EQUAL, expectedEglGetCurrentSurfaceSurface);
}

void eglGetCurrentSurface_0(TestPlatform* p) {
    //TODO
}

/*
 * Runs all eglGetCurrentSurface unit tests
 * @param p
 */
void run_eglGetCurrentSurface_unit_tests(TestPlatform* p) {
    TEST_CASE_SETUP(p)
    eglGetCurrentSurface_0(p);
    TEST_CASE_TEARDOWN(p)
}

#endif  // TEST_INCLUDE_EGLGETCURRENTSURFACETEST_H_
