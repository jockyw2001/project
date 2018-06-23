#ifndef __MI_CV_H__
#define __MI_CV_H__

#include "mi_cv_datatype.h"

#ifdef __cplusplus
extern "C"
{
#endif


MI_S32 MI_CV_CreateDev(MI_U32 u32DevId);
MI_S32 MI_CV_DestroyDev(MI_U32 u32DevId);
MI_S32 MI_CV_CreateChn(MI_U32 u32DevId, MI_U32 u32ChnId);
MI_S32 MI_CV_DestroyChn(MI_U32 u32DevId, MI_U32 u32ChnId);
MI_S32 MI_CV_SetInputPortAttr(MI_U32 u32DevId, MI_U32 u32ChnId, MI_U32 u32PortId, MI_CV_InputPortAttr_t* pstAttr);
MI_S32 MI_CV_GetInputPortAttr(MI_U32 u32DevId, MI_U32 u32ChnId, MI_U32 u32PortId, MI_CV_InputPortAttr_t* pstAttr);
MI_S32 MI_CV_SetOutputPortAttr(MI_U32 u32DevId, MI_U32 u32ChnId, MI_U32 u32PortId, MI_CV_OutputPortAttr_t* pstAttr);
MI_S32 MI_CV_GetOutputPortAttr(MI_U32 u32DevId, MI_U32 u32ChnId, MI_U32 u32PortId, MI_CV_OutputPortAttr_t* pstAttr);

MI_S32 MI_CV_GetCdnnCfgBuf(void *pAddr, MI_U32 u32Size);



#ifdef __cplusplus
}
#endif

#endif /* __MI_MD_H__ */
