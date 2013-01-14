
#ifndef LIST_MANAGEMENT_ROUTINES_DECLARED
#define LIST_MANAGEMENT_ROUTINES_DECLARED

//---------------------------------------------------------------------------*

#include "task-descriptor.h"
#include "task-list.h"

//---------------------------------------------------------------------------*
//   Force C linking for C++ compilation                                     *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  extern "C" {
#endif

//---------------------------------------------------------------------------*

void kernel_runningTaskWaitsOnFIFOList (task_list * inList) ;

void kernel_runningTaskWaitsOnListOrderedByPriority (task_list * inList) ;

void kernel_runningTaskWaitsOnLists (task_list * inList,
                                     const bool inListIsOrderedByPriority,
                                     const uint32 inDate) ;

bool kernel_firstWaitingTaskBecomesReady (task_list * inList,
                                          const uint32 inReturnCode) ;

void kernel_tasksWithEarlierDateBecomeReady (const uint32 inDate,
                                             const uint32 inReturnCode) ;

//---------------------------------------------------------------------------*
//   End of force C linking for C++ compilation                              *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif

