
#ifndef TASK_LIST_BY_DATE_DEFINED
#define TASK_LIST_BY_DATE_DEFINED

//---------------------------------------------------------------------------*

#include "task-descriptor.h"

//---------------------------------------------------------------------------*
//   Force C linking for C++ compilation                                     *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  extern "C" {
#endif

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    L I S T    B Y    D A T E                                    *
//                                                                           *
// The task list routines described below use the following fields of the    *
// task descriptor:                                                          *
//   - struct task_descriptor * mNextTaskInListByDate ;                      *
//   - struct task_descriptor * mPreviousTaskInListByDate ;                  *
//   - struct task_list_by_date * mMyTaskListByDate ;                        *
//                                                                           *
// Theses routines do not enable nor disable interrupts.                     *
//                                                                           *
//---------------------------------------------------------------------------*

typedef struct task_list_by_date {
  struct task_descriptor * mFirstTask ;
  struct task_descriptor * mLastTask ;
} task_list_by_date ;

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    T A S K    L I S T    B Y    D A T E                         *
//                                                                           *
// This routine inits task list as an empty list.                            *
// inTaskList should not be NULL, but designates an actual list object.      *
//                                                                           *
//---------------------------------------------------------------------------*

void initTaskListByDate (task_list_by_date * inTaskList) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   I N S E R T    T A S K    W I T H     D A T E                           *
//                                                                           *
// This routine insert inTaskDescriptor into the inTaskList task list, in    *
// order to get a list ordered with increasing dates.                        *
// if inTaskDescriptor is NULL, this routine has no effect.                  *
// inTaskList should not be NULL, but designates an actual list object.      *
//                                                                           *
// Insertion is performed in O(n) time. It is quite good since grenerally    *
// there are few tasks that are waiting simultnaneously.                     * 
//                                                                           *
//---------------------------------------------------------------------------*

void insertTaskWithDate (task_list_by_date * inTaskList,
                         task_descriptor * inTaskDescriptor,
                         const uint32 inDate) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    T A S K    I F    D A T E    R E A C H E D               *
//                                                                           *
// This routine removes the first task from the inTaskList task list, if     *
// its date is lower or equal to the inReferenceDate argument.               *
// If the list is empty, this routine has no effect and returns NULL.        *
// If the date of the first task is greater than the inReferenceDate         *
// argument, this routine has no effect and returns NULL.                    *
// inTaskList should not be NULL, but designates an actual list object.      *
//                                                                           *
// Task removing is performed in O(1) time.                                  *
//                                                                           *
//---------------------------------------------------------------------------*

task_descriptor * removeTaskIfDateReached (task_list_by_date * inTaskList,
                                           const uint32 inReferenceDate) ;

//---------------------------------------------------------------------------*
//                                                                           *
// R E M O V E   F R O M   C U R R E N T   T A S K   L I S T   B Y   D A T E *
//                                                                           *
// This routine removes the inTaskDescriptor task from the task list it      *
// currently belongs.                                                        *
//                                                                           *
// If inTaskDescriptor is NULL, this routine has no effect.                  *
// If the inTaskDescriptor task does not belong to a task list by date, this *
// routine has no effect.                                                    *
//                                                                           *
// Task removing is performed in O(1) time.                                  *
//                                                                           *
//---------------------------------------------------------------------------*

void removeFromCurrentTaskListByDate (task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*
//   End of force C linking for C++ compilation                              *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif
