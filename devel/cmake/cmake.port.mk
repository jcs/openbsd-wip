# $OpenBSD: cmake.port.mk,v 1.64 2018/09/11 12:12:31 bcallah Exp $

BUILD_DEPENDS+=	devel/cmake

.for _n _v in ${SHARED_LIBS}
CONFIGURE_ENV+=LIB${_n}_VERSION=${_v}
MAKE_ENV+=LIB${_n}_VERSION=${_v}
.endfor

USE_NINJA ?= Yes

# XXX: Ninja is broken on m88k
.if ${MACHINE_ARCH} == "m88k"
USE_NINJA = No
.endif

.if ${USE_NINJA:L} == "yes"
BUILD_DEPENDS += devel/ninja>=1.5.1
NINJA ?= ninja
NINJA_FLAGS ?= -v -j ${MAKE_JOBS}
.elif ${USE_NINJA:L} == "samurai"
BUILD_DEPENDS += devel/samurai
NINJA ?= samu
NINJA_FLAGS ?= -v -j ${MAKE_JOBS}
CONFIGURE_ARGS += -DCMAKE_MAKE_PROGRAM=${NINJA}
.endif

.if ${USE_NINJA:L} == "yes" || ${USE_NINJA:L} == "samurai"
_MODCMAKE_GEN = Ninja
MODCMAKE_BUILD_TARGET = cd ${WRKBUILD} && exec ${SETENV} ${MAKE_ENV} \
	${NINJA} ${NINJA_FLAGS} ${ALL_TARGET}
MODCMAKE_INSTALL_TARGET = cd ${WRKBUILD} && exec ${SETENV} ${MAKE_ENV} \
	${FAKE_SETUP} ${NINJA} ${NINJA_FLAGS} ${FAKE_TARGET}
MODCMAKE_TEST_TARGET = cd ${WRKBUILD} && exec ${SETENV} ${ALL_TEST_ENV} \
	${NINJA} ${NINJA_FLAGS} ${TEST_FLAGS} ${TEST_TARGET}

.if !target(do-build)
do-build:
	@${MODCMAKE_BUILD_TARGET}
.endif

.if !target(do-install)
do-install:
	@${MODCMAKE_INSTALL_TARGET}
.endif

.if !target(do-test)
do-test:
	@${MODCMAKE_TEST_TARGET}
.endif

.else
_MODCMAKE_GEN = "Unix Makefiles"
# XXX cmake include parser is bogus
DPB_PROPERTIES += nojunk
.endif

CONFIGURE_ENV +=	MODJAVA_VER=${MODJAVA_VER} \
			MODLUA_VERSION=${MODLUA_VERSION} \
			MODLUA_BIN=${MODLUA_BIN} \
			MODLUA_INCL_DIR=${MODLUA_INCL_DIR} \
			MODPY_VERSION=${MODPY_VERSION} \
			MODPY_BIN=${MODPY_BIN} \
			MODPY_INCDIR=${MODPY_INCDIR} \
			MODPY_LIBDIR=${MODPY_LIBDIR} \
			MODRUBY_REV=${MODRUBY_REV} \
			MODTCL_VERSION=${MODTCL_VERSION} \
			MODTK_VERSION=${MODTK_VERSION} \
			MODTCL_INCDIR=${MODTCL_INCDIR} \
			MODTK_INCDIR=${MODTK_INCDIR} \
			MODTCL_LIBDIR=${MODTCL_LIBDIR} \
			MODTK_LIBDIR=${MODTK_LIBDIR} \
			MODTCL_LIB=${MODTCL_LIB} \
			MODTK_LIB=${MODTK_LIB}

MODCMAKE_DEBUG ?=		No

.if empty(CONFIGURE_STYLE)
CONFIGURE_STYLE=	cmake
.endif
MODCMAKE_configure=	cd ${WRKBUILD} && ${SETENV} \
	CC="${CC}" CFLAGS="${CFLAGS}" \
	CXX="${CXX}" CXXFLAGS="${CXXFLAGS}" \
	${CONFIGURE_ENV} ${LOCALBASE}/bin/cmake \
		-DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY:Bool=True \
		-G ${_MODCMAKE_GEN} ${CONFIGURE_ARGS} ${WRKSRC}

.if !defined(CONFIGURE_ARGS) || ! ${CONFIGURE_ARGS:M*CMAKE_BUILD_TYPE*}
.  if ${MODCMAKE_DEBUG:L} == "yes"
CONFIGURE_ARGS += -DCMAKE_BUILD_TYPE:String=Debug
MODCMAKE_BUILD_SUFFIX =	-debug.cmake
.  else
CONFIGURE_ARGS += -DCMAKE_BUILD_TYPE:String=Release
MODCMAKE_BUILD_SUFFIX =	-release.cmake
.  endif
.endif
SUBST_VARS +=	MODCMAKE_BUILD_SUFFIX

SEPARATE_BUILD ?=	Yes

TEST_TARGET ?=	test

MODCMAKE_WANTCOLOR ?= No
MODCMAKE_VERBOSE ?= Yes

.if ${MODCMAKE_WANTCOLOR:L} == "yes" && defined(TERM)
MAKE_ENV += TERM=${TERM}
.endif

.if ${MODCMAKE_VERBOSE:L} == "yes"
MAKE_ENV += VERBOSE=1
.endif
