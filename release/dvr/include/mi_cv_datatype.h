﻿//<MStar Software>
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

///////////////////////////////////////////////////////////////////////////////////////////////////
/// @file    mi_vdf.h
/// @brief The vdf interface definition
/// @author MStar Semiconductor Inc.
///////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef _MI_CV_DATATYPE_H_
#define _MI_CV_DATATYPE_H_

#include "mi_common_datatype.h"
#include "mi_sys_datatype.h"
//#include <pthread.h>


#define MI_CV_DEVICE_MAX_NUM        1
#define MI_CV_CHANNEL_MAX_NUM       64      // sensor num
#define MI_CV_CMD_MAX_NUM           3


typedef void* MI_CV_HANDLE;
typedef void* MI_CV_INSTANCE;
typedef MI_U32 MI_CV_DEV;
typedef MI_U32 MI_CV_PORT;
typedef MI_U32 MI_CV_CHN;


typedef enum
{
    E_MI_CV_ERR_DEV_OPENED = MI_CV_INITIAL_ERROR_CODE,
    E_MI_CV_ERR_DEV_NOT_OPEN,
    E_MI_CV_ERR_DEV_NOT_CLOSE,
    E_MI_CV_ERR_CHN_OPENED,
    E_MI_CV_ERR_CHN_NOT_OPEN,
    E_MI_CV_ERR_CHN_NOT_STOPED,
    E_MI_CV_ERR_CHN_STOPED,
    E_MI_CV_ERR_CHN_NOT_CLOSE,
    E_MI_CV_ERR_PORT_NOT_UNBIND,
}MI_CV_ErrCode_e;

typedef struct MI_CV_InputPortAttr_s
{
    MI_U16 u16Width;                         // Width of target image
    MI_U16 u16Height;                        // Height of target image
    MI_SYS_PixelFormat_e  ePixelFormat;      // Pixel format of target image
    MI_SYS_CompressMode_e eCompressMode;     // Compression mode of the input
}MI_CV_InputPortAttr_t;

typedef struct MI_CV_OutputPortAttr_s
{
    MI_U16 u16Width;                         // Width of target image
    MI_U16 u16Height;                        // Height of target image
    MI_SYS_PixelFormat_e  ePixelFormat;      // Pixel format of target image
    MI_SYS_CompressMode_e eCompressMode;     // Compression mode of the output
}MI_CV_OutputPortAttr_t;


#define MI_CV_OK                      MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_INFO, MI_SUCCESS)
#define MI_ERR_CV_ILLEGAL_PARAM       MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_ILLEGAL_PARAM)
#define MI_ERR_CV_NULL_PTR            MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_NULL_PTR)
#define MI_ERR_CV_BUSY                MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_BUSY)
#define MI_ERR_CV_FAIL                MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_FAILED)
#define MI_ERR_CV_INVALID_DEVID       MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_INVALID_DEVID)
#define MI_ERR_CV_NOT_SUPPORT         MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_NOT_SUPPORT)
#define MI_ERR_CV_MOD_INITED          MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_INITED)
#define MI_ERR_CV_MOD_NOT_INIT        MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_NOT_INIT)
#define MI_ERR_CV_DEV_OPENED          MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_DEV_OPENED)
#define MI_ERR_CV_DEV_NOT_OPEN        MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_DEV_NOT_OPEN)
#define MI_ERR_CV_DEV_NOT_STOP        MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_DEV_NOT_STOPED)
#define MI_ERR_CV_DEV_NOT_CLOSE       MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_DEV_NOT_CLOSE)
#define MI_ERR_CV_NOT_CONFIG          MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_NOT_CONFIG)
#define MI_ERR_CV_CHN_OPENED          MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_CHN_OPENED)
#define MI_ERR_CV_CHN_NOT_OPEN        MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_CHN_NOT_OPEN)
#define MI_ERR_CV_CHN_NOT_STOP        MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_CHN_NOT_STOPED)
#define MI_ERR_CV_CHN_STOPED          MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_CHN_STOPED)
#define MI_ERR_CV_CHN_NOT_CLOSE       MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_CHN_NOT_CLOSE)
#define MI_ERR_CV_PORT_NOT_DISABLE    MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_ERR_NOT_DISABLE)
#define MI_ERR_CV_PORT_NOT_UNBIND     MI_DEF_ERR(E_MI_MODULE_ID_CV, E_MI_ERR_LEVEL_ERROR, E_MI_CV_ERR_PORT_NOT_UNBIND)




#endif///_MI_VDF_H_
