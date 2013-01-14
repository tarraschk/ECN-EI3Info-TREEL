//---------------------------------------------------------------------------*
//                                                                           *
//  Task list                                                                *
//                                                                           *
//---------------------------------------------------------------------------*

#ifndef TASK_LIST_DEFINED
#define TASK_LIST_DEFINED

//---------------------------------------------------------------------------*

#include "processor-defines.h"

//---------------------------------------------------------------------------*
//   Force C linking for C++ compilation                                     *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  extern "C" {
#endif

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    L I S T                                                      *
//                                                                           *
// The task list routines described below use the following fields of the    *
// task descriptor:                                                          *
//   - struct task_descriptor * mNextTaskInList ;                            *
//   - struct task_descriptor * mPreviousTaskInList ;                        *
//   - struct task_list * mMyTaskList ;                                      *
//                                                                           *
// Theses routines do not enable nor disable interrupts.                     *
//                                                                           *
//---------------------------------------------------------------------------*

typedef struct task_list {
  struct task_descriptor * mFirstTask ;
  struct task_descriptor * mLastTask ;
} task_list ;

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    T A S K    L I S T                                           *
//                                                                           *
// This routine inits task list as an empty list.                            *
// inTaskList should not be NULL, but designates an actual task_list object. *
//                                                                           *
//---------------------------------------------------------------------------*

void initTaskList (task_list * inTaskList) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   I N S E R T    T A S K    A T   T A I L                                 *
//                                                                           *
// This routine inserts inTaskDescriptor into the inTaskList task list, at   *
// the last position.                                                        *
// if inTaskDescriptor is NULL, this routine has no effect.                  *
// inTaskList should not be NULL, but designates an actual task_list object. *
//                                                                           *
// Task insertion is performed in O(1) time.                                 *
//                                                                           *
//---------------------------------------------------------------------------*

void insertTaskAtTail (task_list * inTaskList,
                       struct task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*

void insertTaskFollowingPriority (task_list * inTaskList,
                                  struct task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    T A S K    A T   H E A D                                 *
//                                                                           *
// This routine removes the first task from the inTaskList task list, and    *
// returns it as function result.                                            *
// inTaskList should not be NULL, but designates an actual task_list object. *
// If the list is empty, this routine has no effect and returns NULL.        *
//                                                                           *
// Task removing is performed in O(1) time.                                  *
//                                                                           *
//---------------------------------------------------------------------------*

struct task_descriptor * removeTaskAtHead (task_list * inTaskList) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   G E T    T A S K    A T   H E A D                                       *
//                                                                           *
// This routine returns the first task in the inTaskList task list, without  *
// modifying the list. If the list is empty, it returns NULL.                *
// inTaskList should not be NULL, but designates an actual task_list object. *
//                                                                           *
// This routine is performed in O(1) time.                                   *
//                                                                           *
//---------------------------------------------------------------------------*

struct task_descriptor * taskAtHead (task_list * inTaskList) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    F R O M    C U R R E N T    T A S K    L I S T           *
//                                                                           *
// This routine removes the inTaskDescriptor task from the task list it      *
// currently belongs.                                                        *
//                                                                           *
// If inTaskDescriptor is NULL, this routine has no effect.                  *
// If the inTaskDescriptor task does not belong to a task list, this routine *
// has no effect.                                                            *
//                                                                           *
// Task removing is performed in O(1) time.                                  *
//                                                                           *
//---------------------------------------------------------------------------*

void removeFromCurrentTaskList (struct task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*
//   End of force C linking for C++ compilation                              *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif
