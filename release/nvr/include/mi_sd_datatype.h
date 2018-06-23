//<MStar Software>
//******************************************************************************
// MStar Software
// Copyright (c) 2010 - 2012 MStar Semiconductor, Inc. All rights reserved.
// All software, firmware and related documentation herein ("MStar Software") are
// intellectual property of MStar Semiconductor, Inc. ("MStar") and protected by
// law, including, but not limited to, copyright law and international treaties.
// Any use, modification, reproduction, retransmission, or republication of all
// or part of MStar Software is expressly prohibited, unless prior written
// permission has been granted by MStar.
//
// By accessing, browsing and/or using MStar Software, you acknowledge that you
// have read, understood, and agree, to be bound by below terms ("Terms") and to
// comply with all applicable laws and regulations:
//
// 1. MStar shall retain any and all right, ownership and interest to MStar
//    Software and any modification/derivatives thereof.
//    No right, ownership, or interest to MStar Software and any
//    modification/derivatives thereof is transferred to you under Terms.
//
// 2. You understand that MStar Software might include, incorporate or be
//    supplied together with third party`s software and the use of MStar
//    Software may require additional licenses from third parties.
//    Therefore, you hereby agree it is your sole responsibility to separately
//    obtain any and all third party right and license necessary for your use of
//    such third party`s software.
//
// 3. MStar Software and any modification/derivatives thereof shall be deemed as
//    MStar`s confidential information and you agree to keep MStar`s
//    confidential information in strictest confidence and not disclose to any
//    third party.
//
// 4. MStar Software is provided on an "AS IS" basis without warranties of any
//    kind. Any warranties are hereby expressly disclaimed by MStar, including
//    without limitation, any warranties of merchantability, non-infringement of
//    intellectual property rights, fitness for a particular purpose, error free
//    and in conformity with any international standard.  You agree to waive any
//    claim against MStar for any loss, damage, cost or expense that you may
//    incur related to your use of MStar Software.
//    In no event shall MStar be liable for any direct, indirect, incidental or
//    consequential damages, including without limitation, lost of profit or
//    revenues, lost or damage of data, and unauthorized system use.
//    You agree that this Section 4 shall still apply without being affected
//    even if MStar Software has been modified by MStar in accordance with your
//    request or instruction for your use, except otherwise agreed by both
//    parties in writing.
//
// 5. If requested, MStar may from time to time provide technical supports or
//    services in relation with MStar Software to you for your use of
//    MStar Software in conjunction with your or your customer`s product
//    ("Services").
//    You understand and agree that, except otherwise agreed by both parties in
//    writing, Services are provided on an "AS IS" basis and the warranty
//    disclaimer set forth in Section 4 above shall apply.
//
// 6. Nothing contained herein shall be construed as by implication, estoppels
//    or otherwise:
//    (a) conferring any license or right to use MStar name, trademark, service
//        mark, symbol or any other identification;
//    (b) obligating MStar or any of its affiliates to furnish any person,
//        including without limitation, you and your customers, any assistance
//        of any kind whatsoever, or any information; or
//    (c) conferring any license or right under any intellectual property right.
//
// 7. These terms shall be governed by and construed in accordance with the laws
//    of Taiwan, R.O.C., excluding its conflict of law rules.
//    Any and all dispute arising out hereof or related hereto shall be finally
//    settled by arbitration referred to the Chinese Arbitration Association,
//    Taipei in accordance with the ROC Arbitration Law and the Arbitration
//    Rules of the Association by three (3) arbitrators appointed in accordance
//    with the said Rules.
//    The place of arbitration shall be in Taipei, Taiwan and the language shall
//    be English.
//    The arbitration award shall be final and binding to both parties.
//
//******************************************************************************
//<MStar Software>

#ifndef _MI_SD_DATATYPE_H_
#define _MI_SD_DATATYPE_H_
#include "mi_sys_datatype.h"

#ifdef __cplusplus
extern "C" {
#endif

#define MI_SD_MAX_CHANNEL_NUM (64)
#define MI_SD_REALTIMEMODE_MAXCHNL_NUM (1)
#define MI_SD_MAX_PORT_NUM (1)
#define MI_SD_MAX_WORKINGLIST_NODE (2)

#define MI_SD_CHANNEL_MAX_WIDTH  (2560)
#define MI_SD_CHANNEL_MAX_HEIGHT (1440)


#define MI_SD_OK (0)
#define MI_ERR_SD_INVALID_CHNID (0xA0078001) //The SD channel ID is invalid.
#define MI_ERR_SD_INVALID_PORTID (0xA0078002) //The SD outport ID is invalid.
#define MI_ERR_SD_ILLEGAL_PARAM (0xA0078003) //The SD parameter is invalid.
#define MI_ERR_SD_EXIST (0xA0078004) //A SD channel is created.
#define MI_ERR_SD_UNEXIST (0xA0078005) //No SD channel is created.
#define MI_ERR_SD_NULL_PTR (0xA0078006) //The pointer of the input parameter is null.
#define MI_ERR_SD_NOT_SUPPORT (0xA0078008) //The operation is not supported.
#define MI_ERR_SD_NOT_PERM (0xA0078009) //The operation is forbidden.
#define MI_ERR_SD_NOMEM (0xA007800C) //The memory fails to be allocated.
#define MI_ERR_SD_NOBUF (0xA007800D) //The buffer pool fails to be allocated.
#define MI_ERR_SD_BUF_EMPTY (0xA007800E) //The picture queue is empty.
#define MI_ERR_SD_NOTREADY (0xA0078010) //The SD is not initialized.
#define MI_ERR_SD_BUSY (0xA0078012) //The SD is busy.


typedef MI_U32 MI_SD_CHANNEL;
typedef MI_U32 MI_SD_PORT;

typedef struct MI_SD_ChannelAttr_s
{
    MI_U16 u16MaxW;
    MI_U16 u16MaxH;
    MI_SYS_WindowRect_t stCropRect;
    MI_BOOL bLdcOnoff;//LDC enable
}MI_SD_ChannelAttr_t;


/*Define attributes of SD port's work mode*/
typedef struct MI_SD_OuputPortAttr_s
{
    MI_U16 u16Width;                         // Width of target image
    MI_U16 u16Height;                        // Height of target image
    MI_SYS_PixelFormat_e  ePixelFormat;            // Pixel format of target image
    MI_SYS_CompressMode_e eCompressMode;   // Compression mode of the output
}MI_SD_OuputPortAttr_t;

#ifdef __cplusplus
}
#endif

#endif///_MI_SD_DATATYPE_H_