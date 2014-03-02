#
#  Makefile
#
#  For full documentation: make usage

#
THIS_MAKEFILE_DIR = $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

PREFIX_DIR_NAME=prefix
PREFIX=$(THIS_MAKEFILE_DIR)../$(PREFIX_DIR_NAME)

XBUILD=xcrun --verbose xcodebuild -verbose
PROJECT_ROOT=$(THIS_MAKEFILE_DIR)/proj.ios/eglapi-core-lib
PROJECT=$(PROJECT_ROOT)/eglapi-core-lib.xcodeproj
TARGET=egl

FINAL_LIB_FILENAME=$(PREFIX)/lib$(TARGET).a

# Usage
usage : 
	@echo " make X [PREFIX=/mypath/to/prefix/directory]"
	@echo "  X : Valid values:"
	@echo "   usage                           This help"
	@echo "   build-all-release               Release build for iphoneos + iphonesimulator"
	@echo "   build-all-debug                 Debug build for iphoneos + iphonesimulator "
	@echo "   build-iphoneos-release          Release build for iphoneos"
	@echo "   build-iphoneos-debug            Debug build for iphoneos"
	@echo "   build-iphonesimulator-release   Release build for iphonesimulator"
	@echo "   build-iphonesimulator-debug     Debug build for iphonesimulator"
	@echo "   clean                           Clear PREFIX dir"
	@echo "  PREFIX : Absolute path to directory to copy built library to. Default: $(PREFIX)"

# Build flavors
build-all-release: CONFIGURATION := Release
build-all-release: libUniversal.a

build-all-debug: CONFIGURATION := Debug
build-all-debug: libUniversal.a 

build-iphoneos-release: CONFIGURATION := Release
build-iphoneos-release: libUniversal-iphoneos.a

build-iphoneos-debug: CONFIGURATION := Debug
build-iphoneos-debug: libUniversal-iphoneos.a 

build-iphonesimulator-release: CONFIGURATION := Release
build-iphonesimulator-release: libUniversal-iphonesimulator.a 

build-iphonesimulator-debug: CONFIGURATION := Debug
build-iphonesimulator-debug: libUniversal-iphonesimulator.a 

libUniversal.a: libi386.a libArmv7.a libArmv7s.a libArm64.a
	cd $(PREFIX) && lipo -create -output $(PREFIX)/$@ $^ && ln -fs $(PREFIX)/$@ $(FINAL_LIB_FILENAME)

libUniversal-iphoneos.a: libArmv7.a libArmv7s.a libArm64.a
	cd $(PREFIX) &&lipo -create -output $(PREFIX)/$@ $^ && ln -fs $(PREFIX)/$@ $(FINAL_LIB_FILENAME)

libUniversal-iphonesimulator.a: libi386.a
	cd $(PREFIX) && lipo -create -output $(PREFIX)/$@ $^ && ln -fs $(PREFIX)/$@ $(FINAL_LIB_FILENAME)

libi386.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphonesimulator -configuration $(CONFIGURATION) clean build
	cd $(PREFIX) && mv $(PROJECT_ROOT)/build/$(CONFIGURATION)-iphonesimulator/lib$(TARGET).a $@

libArmv7.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch armv7 -configuration $(CONFIGURATION) clean build
	cd $(PREFIX) && mv $(PROJECT_ROOT)/build/$(CONFIGURATION)-iphoneos/lib$(TARGET).a $@

libArmv7s.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch armv7s -configuration $(CONFIGURATION) clean build
	cd $(PREFIX) && mv $(PROJECT_ROOT)/build/$(CONFIGURATION)-iphoneos/lib$(TARGET).a $@

libArm64.a:
	$(XBUILD) -project $(PROJECT) -target $(TARGET) -sdk iphoneos -arch arm64 -configuration $(CONFIGURATION) clean build
	cd $(PREFIX) && mv $(PROJECT_ROOT)/build/$(CONFIGURATION)-iphoneos/lib$(TARGET).a $@


# Clean 
clean:
	-rm -rvf $(PREFIX)/*
