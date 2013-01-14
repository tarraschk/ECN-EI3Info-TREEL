//---------------------------------------------------------------------------*

#include "lists-management.h"
#include "services.h"
#include "task-list.h"
#include "task-list-by-date.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   R U N N I N G    T A S K    W A I T S    O N    L I S T                 *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_runningTaskWaitsOnFIFOList (task_list * inList) {
  task_descriptor * t = kernel_runningTask () ;
  kernel_makeNoTaskRunning () ;
  t->mState = TASK_WAITING ;
  if (NULL != inList) {
    insertTaskAtTail (inList, t) ;
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R U N N I N G    T A S K    W A I T S    O N    L I S T                 *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_runningTaskWaitsOnListOrderedByPriority (task_list * inList) {
  task_descriptor * t = kernel_runningTask () ;
  kernel_makeNoTaskRunning () ;
  t->mState = TASK_WAITING ;
  if (NULL != inList) {
    insertTaskFollowingPriority (inList, t) ;
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R U N N I N G    T A S K    W A I T S    O N    L I S T S               *
//                                                                           *
//---------------------------------------------------------------------------*

static task_list_by_date gTaskListOrderedByDate ;

//---------------------------------------------------------------------------*

void kernel_runningTaskWaitsOnLists (task_list * inList,
                                     const bool inListIsOrderedByPriority,
                                     const uint32 inDate) {
  task_descriptor * t = kernel_runningTask () ;
  kernel_makeNoTaskRunning () ;
  t->mState = TASK_WAITING ;
  if (NULL != inList) {
    if (inListIsOrderedByPriority) {
      insertTaskFollowingPriority (inList, t) ;
    }else{
      insertTaskAtTail (inList, t) ;
    }
  }
  insertTaskWithDate (& gTaskListOrderedByDate, t, inDate) ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   F I R S T    W A I T I N G    T A S K    B E C O M E S    R E A D Y     *
//                                                                           *
//---------------------------------------------------------------------------*

bool kernel_firstWaitingTaskBecomesReady (task_list * inList,
                                          const uint32 inReturnCode) {
  task_descriptor * t = removeTaskAtHead (inList) ;
  if (NULL != t) {
    removeFromCurrentTaskListByDate (t) ;
    kernel_makeTaskReady (t) ;
    kernel_set_return_code (& (t->mTaskContext), inReturnCode) ;
  }
  return NULL != t ;
}

//---------------------------------------------------------------------------*
//                                                                           *
// T A S K S   W I T H   E A R L I E R   D A T E   B E C O M E S   R E A D Y *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_tasksWithEarlierDateBecomeReady (const uint32 inDate,
                                             const uint32 inReturnCode) {
  if (NULL != gTaskListOrderedByDate.mFirstTask) {
    task_descriptor * t ;
    while ((t = removeTaskIfDateReached (& gTaskListOrderedByDate, inDate))) {
      removeFromCurrentTaskList (t) ;
      kernel_makeTaskReady (t) ;
      kernel_set_return_code (& (t->mTaskContext), inReturnCode) ;
    }
  }
}

//---------------------------------------------------------------------------*
