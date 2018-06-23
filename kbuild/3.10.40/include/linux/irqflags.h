/*
 * include/linux/irqflags.h
 *
 * IRQ flags tracing: follow the state of the hardirq and softirq flags and
 * provide callbacks for transitions between ON and OFF states.
 *
 * This file gets included from lowlevel asm headers too, to provide
 * wrapped versions of the local_irq_*() APIs, based on the
 * raw_local_irq_*() macros from the lowlevel headers.
 */
#ifndef _LINUX_TRACE_IRQFLAGS_H
#define _LINUX_TRACE_IRQFLAGS_H

#include <linux/typecheck.h>
#include <asm/irqflags.h>
#include <mstar/mpatch_macro.h>

#ifdef CONFIG_TRACE_IRQFLAGS
  extern void trace_softirqs_on(unsigned long ip);
  extern void trace_softirqs_off(unsigned long ip);
  extern void trace_hardirqs_on(void);
  extern void trace_hardirqs_off(void);
# define trace_hardirq_context(p)	((p)->hardirq_context)
# define trace_softirq_context(p)	((p)->softirq_context)
# define trace_hardirqs_enabled(p)	((p)->hardirqs_enabled)
# define trace_softirqs_enabled(p)	((p)->softirqs_enabled)
# define trace_hardirq_enter()	do { current->hardirq_context++; } while (0)
# define trace_hardirq_exit()	do { current->hardirq_context--; } while (0)
# define lockdep_softirq_enter()	do { current->softirq_context++; } while (0)
# define lockdep_softirq_exit()	do { current->softirq_context--; } while (0)
# define INIT_TRACE_IRQFLAGS	.softirqs_enabled = 1,
#else
# define trace_hardirqs_on()		do { } while (0)
# define trace_hardirqs_off()		do { } while (0)
# define trace_softirqs_on(ip)		do { } while (0)
# define trace_softirqs_off(ip)		do { } while (0)
# define trace_hardirq_context(p)	0
# define trace_softirq_context(p)	0
# define trace_hardirqs_enabled(p)	0
# define trace_softirqs_enabled(p)	0
# define trace_hardirq_enter()		do { } while (0)
# define trace_hardirq_exit()		do { } while (0)
# define lockdep_softirq_enter()	do { } while (0)
# define lockdep_softirq_exit()		do { } while (0)
# define INIT_TRACE_IRQFLAGS
#endif

#if defined(CONFIG_IRQSOFF_TRACER) || \
	defined(CONFIG_PREEMPT_TRACER)
 extern void stop_critical_timings(void);
 extern void start_critical_timings(void);
#else
# define stop_critical_timings() do { } while (0)
# define start_critical_timings() do { } while (0)
#endif

/*
 * Wrap the arch provided IRQ routines to provide appropriate checks.
 */
#define raw_local_irq_disable()		arch_local_irq_disable()
#define raw_local_irq_enable()		arch_local_irq_enable()
#define raw_local_irq_save(flags)			\
	do {						\
		typecheck(unsigned long, flags);	\
		flags = arch_local_irq_save();		\
	} while (0)
#define raw_local_irq_restore(flags)			\
	do {						\
		typecheck(unsigned long, flags);	\
		arch_local_irq_restore(flags);		\
	} while (0)
#define raw_local_save_flags(flags)			\
	do {						\
		typecheck(unsigned long, flags);	\
		flags = arch_local_save_flags();	\
	} while (0)
#define raw_irqs_disabled_flags(flags)			\
	({						\
		typecheck(unsigned long, flags);	\
		arch_irqs_disabled_flags(flags);	\
	})
#define raw_irqs_disabled()		(arch_irqs_disabled())
#define raw_safe_halt()			arch_safe_halt()

/*
 * The local_irq_*() APIs are equal to the raw_local_irq*()
 * if !TRACE_IRQFLAGS.
 */
#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
#if (MP_DEBUG_TOOL_KDEBUG == 1)
#ifdef CONFIG_KDEBUGD_FTRACE
extern int kdbg_ftrace_trace_type;

enum {
	TRACER_IRQS_OFF         = (1 << 1),
	TRACER_PREEMPT_OFF      = (1 << 2),
};

#ifdef CONFIG_PREEMPT_TRACER
static inline int
check_preempt_trace(void)
{
	return kdbg_ftrace_trace_type & TRACER_PREEMPT_OFF;
}
#else
# define check_preempt_trace() (0)
#endif

#ifdef CONFIG_IRQSOFF_TRACER
static inline int
check_irq_trace(void)
{
	return kdbg_ftrace_trace_type & TRACER_IRQS_OFF;
}
#else
# define check_irq_trace() (0)
#endif
#endif /* CONFIG_KDEBUGD_FTRACE */
#endif /*MP_DEBUG_TOOL_KDEBUG*/

#if (MP_DEBUG_TOOL_KDEBUG == 0) || !defined(CONFIG_KDEBUGD_FTRACE)
#define local_irq_enable() \
	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
#else
#define local_irq_enable() \
       do { if (!check_preempt_trace() && check_irq_trace()) trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
#endif /* MP_DEBUG_TOOL_KDEBUG && CONFIG_KDEBUGD_FTRACE */

#if (MP_DEBUG_TOOL_KDEBUG == 0) || !defined(CONFIG_KDEBUGD_FTRACE)
#define local_irq_disable() \
	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
#else
#define local_irq_disable() \
       do { raw_local_irq_disable(); if (!check_preempt_trace() && check_irq_trace()) trace_hardirqs_off(); } while (0)
#endif /* MP_DEBUG_TOOL_KDEBUG && CONFIG_KDEBUGD_FTRACE */

#if (MP_DEBUG_TOOL_KDEBUG == 0) || !defined(CONFIG_KDEBUGD_FTRACE)
#define local_irq_save(flags)				\
	do {						\
		raw_local_irq_save(flags);		\
		trace_hardirqs_off();			\
	} while (0)
#else
#define local_irq_save(flags)                          \
       do {                                            \
		raw_local_irq_save(flags);              \
		if (!check_preempt_trace() && check_irq_trace())        \
			trace_hardirqs_off();                   \
       } while (0)
#endif /*MP_DEBUG_TOOL_KDEBUG &&  CONFIG_KDEBUGD_FTRACE */


#if (MP_DEBUG_TOOL_KDEBUG == 0) || !defined(CONFIG_KDEBUGD_FTRACE)
#define local_irq_restore(flags)			\
	do {						\
		if (raw_irqs_disabled_flags(flags)) {	\
			raw_local_irq_restore(flags);	\
			trace_hardirqs_off();		\
		} else {				\
			trace_hardirqs_on();		\
			raw_local_irq_restore(flags);	\
		}					\
	} while (0)
#else
#define local_irq_restore(flags)                        \
	do {                                            \
		 if (raw_irqs_disabled_flags(flags)) {   \
			raw_local_irq_restore(flags);   \
		 if (!check_preempt_trace() && check_irq_trace())        \
			trace_hardirqs_off();           \
		 } else {                                \
		 if (!check_preempt_trace() && check_irq_trace())        \
			trace_hardirqs_on();            \
			raw_local_irq_restore(flags);   \
		  }                                       \
	} while (0)
#endif /* MP_DEBUG_TOOL_KDEBUG && CONFIG_KDEBUGD_FTRACE */

#define local_save_flags(flags)				\
	do {						\
		raw_local_save_flags(flags);		\
	} while (0)

#define irqs_disabled_flags(flags)			\
	({						\
		raw_irqs_disabled_flags(flags);		\
	})

#define irqs_disabled()					\
	({						\
		unsigned long _flags;			\
		raw_local_save_flags(_flags);		\
		raw_irqs_disabled_flags(_flags);	\
	})

#if (MP_DEBUG_TOOL_KDEBUG == 0) || !defined(CONFIG_KDEBUGD_FTRACE)
#define safe_halt()				\
	do {					\
		trace_hardirqs_on();		\
		raw_safe_halt();		\
	} while (0)
#else
#define safe_halt()                            \
       do {                                    \
		if (!check_preempt_trace() && check_irq_trace())        \
		trace_hardirqs_on();            \
		raw_safe_halt();                \
       } while (0)
#endif /* MP_DEBUG_TOOL_KDEBUG && CONFIG_KDEBUGD_FTRACE */


#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */

#define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
#define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
#define local_irq_save(flags)					\
	do {							\
		raw_local_irq_save(flags);			\
	} while (0)
#define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
#define local_save_flags(flags)	do { raw_local_save_flags(flags); } while (0)
#define irqs_disabled()		(raw_irqs_disabled())
#define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
#define safe_halt()		do { raw_safe_halt(); } while (0)

#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */

#endif
