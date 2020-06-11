//
//  TextFont.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#ifndef TextFont_h
#define TextFont_h

#pragma mark --文字大小--
// 系统字体
#define SYSTEM_FONT_OF_SIZE(size)         [UIFont systemFontOfSize:size]
//加粗字体
#define BOLD_SYSTEM_FONT_OF_SIZE(size)    [UIFont boldSystemFontOfSize:size]

// 导航栏标题文字大小
#define FONT_NAVI_TITLE                 SYSTEM_FONT_OF_SIZE(18)

#pragma mark --统一文字大小--

#define FONT_SIZE_H1                    18
#define FONT_SIZE_H2                    16
#define FONT_SIZE_H3                    14
#define FONT_SIZE_H4                    13


#endif /* TextFont_h */
