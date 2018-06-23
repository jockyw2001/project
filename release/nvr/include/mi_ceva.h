#ifndef __MI_CEVA_H__
#define __MI_CEVA_H__

#include "mi_ceva_datatype.h"

#ifdef __cplusplus
extern "C"
{
#endif


MI_S32 MI_CEVA_CreateDev(MI_U32 u32DevId);
MI_S32 MI_CEVA_DestroyDev(MI_U32 u32DevId);
MI_S32 MI_CEVA_CreateChn(MI_U32 u32DevId, MI_U32 u32ChnId);
MI_S32 MI_CEVA_DestroyChn(MI_U32 u32DevId, MI_U32 u32ChnId);
MI_S32 MI_CEVA_SetChnPortAttr(MI_CEVA_ChnPortAttr_t* pstChnAttr);
MI_S32 MI_CEVA_GetChnPortAttr(MI_U32 u32DevId, MI_U32 u32ChnId, MI_U32 u32PortId, MI_CEVA_ChnPortType_e ePortType, MI_CEVA_ChnPortAttr_t* pstAttr);
MI_S32 MI_CEVA_RegisterCallback(MI_U32 u32DevId, MI_U32 u32CvCmd, MI_CEVA_Callback pfCallback);
MI_S32 MI_CEVA_Run(MI_U32 u32DevId, MI_U32 u32ChnId);
MI_S32 MI_CEVA_Stop(MI_U32 u32DevId, MI_U32 u32ChnId);

MI_S32 MI_CEVA_GetCdnnCfgBuf(void *pAddr);
MI_S32 MI_CEVA_GetCdnnComputeBuf(MI_PHY phyAddr, void *pAddr);
MI_S32 MI_CEVA_ReleaseCdnnComputeBuf(MI_PHY phyAddr, void *pAddr);




#ifdef __cplusplus
}
#endif

#endif /* __MI_MD_H__ */
