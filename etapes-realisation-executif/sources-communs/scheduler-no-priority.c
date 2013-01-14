//---------------------------------------------------------------------------*
//                                                                           *
//   Scheduler without priority                                              *
//                                                                           *
//---------------------------------------------------------------------------*

#include "task-descriptor.h"
#include "task-list.h"
#include "services.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   R U N N I N G    T A S K                                                *
//                                                                           *
//---------------------------------------------------------------------------*

static task_descriptor * gRunningTask ;
task_context * gRunningTaskContextSaveAddress ; // Shared with assembly code (arm_context.s)

//---------------------------------------------------------------------------*

task_descriptor * kernel_runningTask (void) {
  return gRunningTask ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   R E A D Y    T A S K    L I S T                                         *
//                                                                           *
//---------------------------------------------------------------------------*

static task_list gReadyTaskList ;

//---------------------------------------------------------------------------*
//                                                                           *
//   M A K E    T A S K    R E A D Y                                         *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_makeTaskReady (task_descriptor * inTaskDescriptor) {
  if (NULL != inTaskDescriptor) {
    inTaskDescriptor->mState = TASK_READY ;
    insertTaskAtTail (& gReadyTaskList, inTaskDescriptor) ;
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//  M A K E    N O    T A S K    R U N N I N G                               *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_makeNoTaskRunning (void) {
  gRunningTask = NULL ;
  gRunningTaskContextSaveAddress = NULL ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//  S E L E C T    T A S K    T O    R U N                                   *
//                                                                           *
//---------------------------------------------------------------------------*

void kernel_selectTaskToRun (void) {
  if (NULL == gRunningTask) {
    gRunningTask = removeTaskAtHead (& gReadyTaskList) ;
    if (NULL != gRunningTask) {
      gRunningTask->mState = TASK_RUNNING ;
      gRunningTaskContextSaveAddress = & (gRunningTask->mTaskContext) ;
    }
  }
}

//---------------------------------------------------------------------------*
