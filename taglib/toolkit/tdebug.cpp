/***************************************************************************
    copyright            : (C) 2002 - 2008 by Scott Wheeler
    email                : wheeler@kde.org
 ***************************************************************************/

/***************************************************************************
 *   This library is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Lesser General Public License version   *
 *   2.1 as published by the Free Software Foundation.                     *
 *                                                                         *
 *   This library is distributed in the hope that it will be useful, but   *
 *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU     *
 *   Lesser General Public License for more details.                       *
 *                                                                         *
 *   You should have received a copy of the GNU Lesser General Public      *
 *   License along with this library; if not, write to the Free Software   *
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA         *
 *   02110-1301  USA                                                       *
 *                                                                         *
 *   Alternatively, this file is available under the Mozilla Public        *
 *   License Version 1.1.  You may obtain a copy of the License at         *
 *   http://www.mozilla.org/MPL/                                           *
 ***************************************************************************/

#ifndef NDEBUG
#include <iostream>
#include <bitset>

#ifdef __ANDROID__
#include <android/log.h>
#endif

#include "tdebug.h"
#include "tstring.h"

using namespace TagLib;

void TagLib::debug(const String &s)
{
#ifdef __ANDROID__
  __android_log_print(ANDROID_LOG_DEBUG, "TAGLIB", "%s", s.toCString());
#endif
  std::cerr << "TagLib: " << s << std::endl;
}

void TagLib::debugData(const ByteVector &v)
{
  for(uint i = 0; i < v.size(); i++) {

#ifdef __ANDROID__
    __android_log_print(ANDROID_LOG_DEBUG, "TAGLIB", "***[%u] - '%c' - int %d", i, char(v[i]), int(v[i]));
#endif
    std::cout << "*** [" << i << "] - '" << char(v[i]) << "' - int " << int(v[i])
              << std::endl;

    std::bitset<8> b(v[i]);

    for(int j = 0; j < 8; j++)
    {
#ifdef __ANDROID__
      __android_log_print(ANDROID_LOG_DEBUG, "TAGLIB", "%d:%d %d", i, j, (int)b.test(j));
#endif
      std::cout << i << ":" << j << " " << b.test(j) << std::endl;
    }

    std::cout << std::endl;
  }
}
#endif
