LOCAL_PATH:= $(call my-dir)

#on a 32bit maschine run ./configure --enable-password-save --disable-pkcs11 --with-ifconfig-path=/system/bin/ifconfig --with-route-path=/system/bin/route
#from generated Makefile copy variable contents of openvpn_SOURCES to common_SRC_FILES
# append missing.c to the end of the list
# missing.c defines undefined functions.
# in tun.c replace /dev/net/tun with /dev/tun

openvpn_SRC_FILES:= $(wildcard $(LOCAL_PATH)/src/openvpn/*.c)
openvpn_SRC_FILES:= $(openvpn_SRC_FILES:$(LOCAL_PATH)/%=%)

plugins_SRC_FILES:= $(wildcard $(LOCAL_PATH)/src/plugins/*.c)
plugins_SRC_FILES:= $(plugins_SRC_FILES:$(LOCAL_PATH)/%=%)

common_CFLAGS += -DANDROID_CHANGES -DHAVE_CONFIG_H

common_C_INCLUDES += \
	external/openssl \
	external/openssl/include \
	external/openssl/crypto \
	external/lzo/include \
	external/openvpn/include \
	external/openvpn/src/compat \
	external/openvpn \
	system/security/keystore

common_SHARED_LIBRARIES := libcutils libkeystore_binder

ifneq ($(TARGET_SIMULATOR),true)
	common_SHARED_LIBRARIES += libdl
endif

# static linked binary
# =====================================================

#include $(CLEAR_VARS)
#LOCAL_SRC_FILES:= $(common_SRC_FILES)
#LOCAL_CFLAGS:= $(common_CFLAGS)
#LOCAL_C_INCLUDES:= $(common_C_INCLUDES)
#
#LOCAL_SHARED_LIBRARIES += $(common_SHARED_LIBRARIES)
#LOCAL_STATIC_LIBRARIES:= libopenssl-static liblzo-static
#
##LOCAL_LDLIBS += -ldl
##LOCAL_PRELINK_MODULE:= false
#
#LOCAL_MODULE:= openvpn-static
#LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
#include $(BUILD_EXECUTABLE)

# dynamic linked binary
# =====================================================

include $(CLEAR_VARS)
LOCAL_SRC_FILES:= $(openvpn_SRC_FILES)
LOCAL_SRC_FILES+= $(plugins_SRC_FILES)
LOCAL_CFLAGS:= $(common_CFLAGS)
LOCAL_C_INCLUDES:= $(common_C_INCLUDES)

LOCAL_SHARED_LIBRARIES:= $(common_SHARED_LIBRARIES) libcutils libssl libcrypto liblzo

#LOCAL_LDLIBS += -ldl
#LOCAL_PRELINK_MODULE:= false

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= openvpn
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
include $(BUILD_EXECUTABLE)
