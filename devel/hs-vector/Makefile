# $OpenBSD: Makefile,v 1.23 2018/01/22 22:05:07 kili Exp $

COMMENT =		Int-indexed arrays

# Dependency of meta/haskell-platform.
# Please do *not* update without thinking.
PORTROACH =		ignore:1

DISTNAME =		vector-0.12.0.1
REVISION =		1
CATEGORIES =		devel

MAINTAINER =		Jim Razmus II <jim@openbsd.org>, \
			Matthias Kilian <kili@openbsd.org>

# BSD3
PERMIT_PACKAGE_CDROM =	Yes

MODULES =		lang/ghc

MODGHC_BUILD =		cabal hackage haddock register

MODGHC_PACKAGE_KEY =	GlAtqLgBDl72y7bejfsrfc

BUILD_DEPENDS +=	devel/hs-primitive>=0.5.0.1,<0.7

.include <bsd.port.mk>
