//---------------------------------------------------------------------------*
//                                                                           *
//  Task descriptor                                                          *
//                                                                           *
//---------------------------------------------------------------------------*

#ifndef TASK_DESCRIPTOR_DEFINED
#define TASK_DESCRIPTOR_DEFINED

//---------------------------------------------------------------------------*

#include "processor-defines.h"
#include "task-context.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//   Force C linking for C++ compilation                                     *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  extern "C" {
#endif

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    S T A T E    E N U M E R A T I O N                           *
//                                                                           *
//---------------------------------------------------------------------------*

typedef enum {
  TASK_CREATED,
  TASK_READY,
  TASK_RUNNING,
  TASK_WAITING,
  TASK_TERMINATED
} task_state ;

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    R O U T I N E    T Y P E                                     *
//                                                                           *
//---------------------------------------------------------------------------*

typedef void (* routineTaskType) (const uint32 inArgument1,
                                  const uint32 inArgument2) ;

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    D E S C R I P T O R                                          *
//                                                                           *
//---------------------------------------------------------------------------*

typedef struct task_descriptor {
//--- Task state
  task_state mState ;
//--- Priority
  uint8 mPriority ;
//--- Theses 4 fields are used by task_list type. It provides
//    the way to link task descriptor into a task_list.
//    They are NULL when the task does not belong to any list.
//    See task_list.h
  bool mIsInListOrderedByPriority ;
  struct task_descriptor * mNextTaskInList ;
  struct task_descriptor * mPreviousTaskInList ;
  struct task_list * mMyTaskList ;
//--- Theses 4 fields are used by task_list_by_date type. It provides
//    the way to link task descriptor into a task_list_by_date.
//    They are NULL when the task does not belong to any list.
//    See task_list.h
  struct task_descriptor * mNextTaskInListByDate ;
  struct task_descriptor * mPreviousTaskInListByDate ;
  struct task_list_by_date * mMyTaskListByDate ;
  uint32 mDate ;
//--- Pointers for linking this descriptor to existing task list
  struct task_descriptor * mPreviousTaskDescriptor ;
  struct task_descriptor * mNextTaskDescriptor ;
//--- Context buffer
  task_context mTaskContext ;
//--- Stack buffer parameters
  void * mStackBufferAddress ;
  uint32 mStackBufferSize ; // In bytes
  ptrdiff_t mFreeStackSize ; // In bytes
//--- List of task waiting for terminaison of this task
//  struct task_list mTaskWaitingForTerminaisonList ;
} task_descriptor ;

//---------------------------------------------------------------------------*
//   End of force C linking for C++ compilation                              *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif
