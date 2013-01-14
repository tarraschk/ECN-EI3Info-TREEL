//---------------------------------------------------------------------------*

#include "task-list-by-date.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    T A S K    L I S T                                           *
//                                                                           *
//---------------------------------------------------------------------------*

void initTaskListByDate (task_list_by_date * inTaskList) {
  inTaskList->mFirstTask = NULL ;
  inTaskList->mLastTask = NULL ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   I N S E R T    T A S K    W I T H     D A T E                           *
//                                                                           *
// If list is empty, simply insert the task.                                 *
// If the first task has a later date, insert the task at the beginning.     *
//---------------------------------------------------------------------------*

void insertTaskWithDate (task_list_by_date * inTaskList,
                         task_descriptor * inTaskDescriptor,
                         const uint32 inDate) {
  if (NULL != inTaskDescriptor) {
    inTaskDescriptor->mMyTaskListByDate = inTaskList ;
    inTaskDescriptor->mDate = inDate ;
    inTaskDescriptor->mNextTaskInListByDate = NULL ;
    inTaskDescriptor->mPreviousTaskInListByDate = NULL ;
    if (NULL == inTaskList->mFirstTask) { // Empty List
      inTaskList->mLastTask = inTaskDescriptor ;
      inTaskList->mFirstTask = inTaskDescriptor ;
    }else if (inTaskList->mFirstTask->mDate >= inDate) { // At beginning
      inTaskDescriptor->mNextTaskInListByDate = inTaskList->mFirstTask ;
      inTaskList->mFirstTask->mPreviousTaskInListByDate = inTaskDescriptor ;
      inTaskList->mFirstTask = inTaskDescriptor ;
    }else if (inTaskList->mLastTask->mDate <= inDate) { // At end
      inTaskDescriptor->mPreviousTaskInListByDate = inTaskList->mLastTask ;
      inTaskList->mLastTask->mNextTaskInListByDate = inTaskDescriptor ;
      inTaskList->mLastTask = inTaskDescriptor ;
    }else{
      task_descriptor * t = inTaskList->mFirstTask->mNextTaskInListByDate ;
      while (t->mDate < inDate) {
        t = t->mNextTaskInListByDate ;
      }
    //--- Insert before task t
      task_descriptor * taskBefore = t->mPreviousTaskInListByDate ;
      taskBefore->mNextTaskInListByDate = inTaskDescriptor ;
      t->mPreviousTaskInListByDate = inTaskDescriptor ;
      inTaskDescriptor->mNextTaskInListByDate = t ;
      inTaskDescriptor->mPreviousTaskInListByDate = taskBefore ;
    }
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    T A S K    A T    H E A D                                *
//                                                                           *
//---------------------------------------------------------------------------*

task_descriptor * removeTaskIfDateReached (task_list_by_date * inTaskList,
                                           const uint32 inReferenceDate) {
  task_descriptor * t = inTaskList->mFirstTask ;
  if ((NULL == t) || (t->mDate > inReferenceDate)) {
    t = NULL ;
  }else{
    if (NULL == t->mNextTaskInListByDate) { // List becomes empty ?
      inTaskList->mLastTask = NULL ;
      inTaskList->mFirstTask = NULL ;
    }else{
      inTaskList->mFirstTask = t->mNextTaskInListByDate ;
      inTaskList->mFirstTask->mPreviousTaskInListByDate = NULL ;
    }
    t->mMyTaskListByDate = NULL ;
    t->mNextTaskInListByDate = NULL ;
    t->mPreviousTaskInListByDate = NULL ;
  }
  return t ;
}

//---------------------------------------------------------------------------*
//                                                                           *
// R E M O V E   F R O M   C U R R E N T   T A S K   L I S T   B Y   D A T E *
//                                                                           *
//---------------------------------------------------------------------------*

void removeFromCurrentTaskListByDate (task_descriptor * inTaskDescriptor) {
  if ((NULL != inTaskDescriptor) && (NULL != inTaskDescriptor->mMyTaskListByDate)) {
    task_list_by_date * taskList = inTaskDescriptor->mMyTaskListByDate ;
    if (NULL == inTaskDescriptor->mNextTaskInListByDate) { // Last descriptor ?
      taskList->mLastTask = inTaskDescriptor->mPreviousTaskInListByDate ;
    }else{
      inTaskDescriptor->mNextTaskInListByDate->mPreviousTaskInListByDate = inTaskDescriptor->mPreviousTaskInListByDate ;
    }
    if (NULL == inTaskDescriptor->mPreviousTaskInListByDate) { // First descriptor ?
      taskList->mFirstTask = inTaskDescriptor->mNextTaskInListByDate ;
    }else{
      inTaskDescriptor->mPreviousTaskInListByDate->mNextTaskInListByDate = inTaskDescriptor->mNextTaskInListByDate ;
    }
    inTaskDescriptor->mPreviousTaskInListByDate = NULL ;
    inTaskDescriptor->mNextTaskInListByDate = NULL ;
    inTaskDescriptor->mMyTaskListByDate = NULL ;
  }
}

//---------------------------------------------------------------------------*
