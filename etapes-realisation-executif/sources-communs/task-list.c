//---------------------------------------------------------------------------*
//                                                                           *
//  Task list                                                                *
//                                                                           *
//---------------------------------------------------------------------------*

#include "task-list.h"
#include "task-descriptor.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    T A S K    L I S T                                           *
//                                                                           *
//---------------------------------------------------------------------------*

void initTaskList (task_list * inTaskList) {
  inTaskList->mFirstTask = NULL ;
  inTaskList->mLastTask = NULL ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   I N S E R T    T A S K    A T    T A I L                                *
//                                                                           *
//---------------------------------------------------------------------------*

void insertTaskAtTail (task_list * inTaskList,
                       task_descriptor * inTaskDescriptor) {
  if (NULL != inTaskDescriptor) {
    inTaskDescriptor->mNextTaskInList = NULL ;
    inTaskDescriptor->mPreviousTaskInList = inTaskList->mLastTask ;
    if (NULL == inTaskList->mLastTask) {
      inTaskList->mFirstTask = inTaskDescriptor ;
    }else{
      inTaskList->mLastTask->mNextTaskInList = inTaskDescriptor ;
    }
    inTaskList->mLastTask = inTaskDescriptor ;
    inTaskDescriptor->mMyTaskList = inTaskList ;
    inTaskDescriptor->mIsInListOrderedByPriority = false ;
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   I N S E R T    T A S K    F O L L O W I N G   P R I O R I T Y           *
//                                                                           *
//---------------------------------------------------------------------------*

void insertTaskFollowingPriority (task_list * inTaskList,
                                  task_descriptor * inTaskDescriptor) {
  if (NULL != inTaskDescriptor) {
    inTaskDescriptor->mIsInListOrderedByPriority = true ;
    inTaskDescriptor->mMyTaskList = inTaskList ;
    inTaskDescriptor->mNextTaskInList = NULL ;
    inTaskDescriptor->mPreviousTaskInList = NULL ;
    if (NULL == inTaskList->mFirstTask) { // Empty List
      inTaskList->mLastTask = inTaskDescriptor ;
      inTaskList->mFirstTask = inTaskDescriptor ;
    }else if (inTaskList->mFirstTask->mPriority > inTaskDescriptor->mPriority) { // At beginning
      inTaskDescriptor->mNextTaskInList = inTaskList->mFirstTask ;
      inTaskList->mFirstTask->mPreviousTaskInList = inTaskDescriptor ;
      inTaskList->mFirstTask = inTaskDescriptor ;
    }else if (inTaskList->mLastTask->mPriority <= inTaskDescriptor->mPriority) { // At end
      inTaskDescriptor->mPreviousTaskInList = inTaskList->mLastTask ;
      inTaskList->mLastTask->mNextTaskInList = inTaskDescriptor ;
      inTaskList->mLastTask = inTaskDescriptor ;
    }else{ // Search sequentially from the end
      task_descriptor * t = inTaskList->mLastTask->mPreviousTaskInList ;
      while (t->mPriority > inTaskDescriptor->mPriority) {
        t = t->mPreviousTaskInList ;
      }
    //--- Insert after task t
      task_descriptor * taskAfter = t->mNextTaskInList ;
      taskAfter->mPreviousTaskInList = inTaskDescriptor ;
      t->mNextTaskInList = inTaskDescriptor ;
      inTaskDescriptor->mPreviousTaskInList = t ;
      inTaskDescriptor->mNextTaskInList = taskAfter ;
    }
  }
}

//---------------------------------------------------------------------------*

task_descriptor * taskAtHead (task_list * inTaskList) {
  return inTaskList->mFirstTask ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    T A S K    A T    H E A D                                *
//                                                                           *
//   Returns NULL if list is empty.                                          *
//                                                                           *
//---------------------------------------------------------------------------*

task_descriptor * removeTaskAtHead (task_list * inTaskList) {
  task_descriptor * t = inTaskList->mFirstTask ;
  if (NULL != t) {
    if (NULL == t->mNextTaskInList) { // Last descriptor ?
      inTaskList->mLastTask = t->mPreviousTaskInList ;
    }else{
      t->mNextTaskInList->mPreviousTaskInList = t->mPreviousTaskInList ;
    }
    if (NULL == t->mPreviousTaskInList) { // First descriptor ?
      inTaskList->mFirstTask = t->mNextTaskInList ;
    }else{
      t->mPreviousTaskInList->mNextTaskInList = t->mNextTaskInList ;
    }
    t->mMyTaskList = NULL ;
    t->mNextTaskInList = NULL ;
    t->mPreviousTaskInList = NULL ;
  }
  return t ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R E M O V E    F R O M    C U R R E N T    T A S K    L I S T           *
//                                                                           *
//---------------------------------------------------------------------------*

void removeFromCurrentTaskList (task_descriptor * inTaskDescriptor) {
  if ((NULL != inTaskDescriptor) && (NULL != inTaskDescriptor->mMyTaskList)) {
    task_list * taskList = inTaskDescriptor->mMyTaskList ;
    if (NULL == inTaskDescriptor->mNextTaskInList) { // Last descriptor ?
      taskList->mLastTask = inTaskDescriptor->mPreviousTaskInList ;
    }else{
      inTaskDescriptor->mNextTaskInList->mPreviousTaskInList = inTaskDescriptor->mPreviousTaskInList ;
    }
    if (NULL == inTaskDescriptor->mPreviousTaskInList) { // First descriptor ?
      taskList->mFirstTask = inTaskDescriptor->mNextTaskInList ;
    }else{
      inTaskDescriptor->mPreviousTaskInList->mNextTaskInList = inTaskDescriptor->mNextTaskInList ;
    }
    inTaskDescriptor->mPreviousTaskInList = NULL ;
    inTaskDescriptor->mNextTaskInList = NULL ;
    inTaskDescriptor->mMyTaskList = NULL ;
  }
}

//---------------------------------------------------------------------------*
