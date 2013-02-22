#-------------------------------------------------
#
# Project created by QtCreator 2011-05-14T17:41:33
#
#-------------------------------------------------

QT       -= core gui

TARGET = hook

TEMPLATE = lib

#DEFINES += HOOKDLL_LIBRARY

SOURCES += \
    utility.cpp \
    stdafx.cpp \
    modinfo.cpp \
    logger.cpp \
    dllmain.cpp \
    disasm_table.cpp \
    disasm.cpp \
    apihook.cpp \
    profile.cpp \
    hooklock.cpp

HEADERS += \
		utility.h \
		stdafx.h \
    reroutes.h \
    modinfo.h \
    logger.h \
    dllmain.h \
    disasm_table.h \
    disasm.h \
    apihook.h \
    profile.h \
    hooklock.h

INCLUDEPATH += ../shared ../bsatk "$(BOOSTPATH)"

CONFIG(debug, debug|release) {
  LIBS += -L$$OUT_PWD/../shared/debug -L$$OUT_PWD/../bsatk/debug
  LIBS += -lDbgHelp
  DEFINES += DEBUG
} else {
		LIBS += -L$$OUT_PWD/../shared/release -L$$OUT_PWD/../bsatk/release
}

DEFINES += UNICODE _UNICODE
DEFINES += _CRT_SECURE_NO_WARNINGS _WINDLL
DEFINES += DEBUG_LOG

#QMAKE_CXXFLAGS += /analyze

#QMAKE_CFLAGS += -O2 -MT

LIBS += -lmo_shared -lkernel32 -luser32 -lshell32 -ladvapi32 -lshlwapi -lVersion -lbsatk

LIBS += -L"$(ZLIBPATH)/build" -lzlibstatic -L"$(BOOSTPATH)/stage/lib"

CONFIG(debug, debug|release) {
	SRCDIR = $$OUT_PWD/debug
	DSTDIR = $$PWD/../../outputd
} else {
	SRCDIR = $$OUT_PWD/release
	DSTDIR = $$PWD/../../output
}

SRCDIR ~= s,/,$$QMAKE_DIR_SEP,g
DSTDIR ~= s,/,$$QMAKE_DIR_SEP,g

QMAKE_POST_LINK += xcopy /y /I $$quote($$SRCDIR\\hook*.dll) $$quote($$DSTDIR) $$escape_expand(\\n)

OTHER_FILES += \
		version.rc

RC_FILE += \
		version.rc

OTHER_FILES +=