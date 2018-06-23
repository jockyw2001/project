#ifndef _MS_MSYS_H_
#define _MS_MSYS_H_
#include "mdrv_msys_io_st.h"
#include "linux/proc_fs.h"
extern int msys_release_dmem(MSYS_DMEM_INFO *mem_info);
extern int msys_request_dmem(MSYS_DMEM_INFO *mem_info);
extern void ms_records_irq(MSYS_IRQ_INFO *irq_info);
extern void msys_dump_irq_info(void);
extern int msys_get_chipVersion(void);

extern struct proc_dir_entry* msys_get_proc_zen(void);
extern struct proc_dir_entry* msys_get_proc_zen_kernel(void);
extern struct proc_dir_entry* msys_get_proc_zen_mi(void);
extern struct proc_dir_entry* msys_get_proc_zen_omx(void);
extern struct class *msys_get_sysfs_class(void);


#endif
