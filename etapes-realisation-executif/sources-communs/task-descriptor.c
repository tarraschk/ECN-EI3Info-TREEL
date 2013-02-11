//---------------------------------------------------------------------------*

#include "task-descriptor.h"
#include "services.h"
#include "task-list.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   D E S C R I P T O R    L I N K E D    L I S T                           *
//                                                                           *
//---------------------------------------------------------------------------*

static task_descriptor * gFirstTaskDescriptor ;
static task_descriptor * gLastTaskDescriptor ;

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    C O U N T                                                    *
//                                                                           *
//---------------------------------------------------------------------------*

static uint32 gTaskCount ;

//---------------------------------------------------------------------------*
//                                                                           *
//   Descriptor List: general case, several tasks                            *
//                                                                           *
//---------------------------------------------------------------------------*

//                                 |   |       |   |
//                                 *---*       *---*   *-------------------*
// (previous)                      | ∆ |<-...--+-* |<--+gLastTaskDescriptor|
//        *--------------------*   *---*       *---*   *-------------------*
// (next) |gFirstTaskDescriptor+-->| *-+--...->| ∆ |
//        *--------------------*   *---*       *---*
//                                 |   |       |   |

//---------------------------------------------------------------------------*
//                                                                           *
//   Descriptor List: one task                                               *
//                                                                           *
//---------------------------------------------------------------------------*

//                                 |   |
//                                 *---*   *-------------------*
// (previous)                      | ∆ |<--+gLastTaskDescriptor|
//        *--------------------*   *---*   *-------------------*
// (next) |gFirstTaskDescriptor+-->| ∆ |
//        *--------------------*   *---*
//                                 |   |

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    D E S C R I P T O R                                          *
//                                                                           *
//---------------------------------------------------------------------------*

void swi_create_task (task_descriptor * inTaskDescriptor,
                      const uint8 inPriority,
                      uint32 * inStackBufferAddress,
                      uint32 inStackBufferSize) {
//--- Store stack parameters
  inTaskDescriptor->mStackBufferAddress = inStackBufferAddress ;
  inTaskDescriptor->mStackBufferSize = inStackBufferSize ;
  inTaskDescriptor->mFreeStackSize = inStackBufferSize ;
//--- Task state
  inTaskDescriptor->mState = TASK_CREATED ;
//--- Task Priority
  inTaskDescriptor->mPriority = inPriority ;
//--- Task in list pointers
  inTaskDescriptor->mNextTaskInList = NULL ;
  inTaskDescriptor->mPreviousTaskInList = NULL ;
  inTaskDescriptor->mMyTaskList = NULL ;
//--- Task in list by date pointers
  inTaskDescriptor->mNextTaskInListByDate = NULL ;
  inTaskDescriptor->mPreviousTaskInListByDate = NULL ;
  inTaskDescriptor->mMyTaskListByDate = NULL ;
//--- Insert in descriptor list (at the end)
  inTaskDescriptor->mNextTaskDescriptor = NULL ;
  inTaskDescriptor->mPreviousTaskDescriptor = gLastTaskDescriptor ;
  if (NULL == gLastTaskDescriptor) {
    gFirstTaskDescriptor = inTaskDescriptor ;
  }else{
    gLastTaskDescriptor->mNextTaskDescriptor = inTaskDescriptor ;
  }
  gLastTaskDescriptor = inTaskDescriptor ;
  gTaskCount ++ ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   T A S K    S E L F   T E R M I N A T E                                  *
//                                                                           *
//---------------------------------------------------------------------------*

void swi_task_self_terminate (void) {
//--- Mark task as terminated
  task_descriptor * rt = kernel_runningTask () ;
  rt->mState = TASK_TERMINATED ;
  kernel_makeNoTaskRunning () ;
//--- Make ready all task waiting for terminaison of this task
//  while (kernel_firstWaitingTaskBecomesReady (& rt->mTaskWaitingForTerminaisonList, 1)) {
//  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   S T A R T    T A S K                                                    *
//                                                                           *
//---------------------------------------------------------------------------*

static void task_entry (routineTaskType inTaskRoutine,
                        const uint32 inArgument1,
                        const uint32 inArgument2) {
//--- Run user code
  inTaskRoutine (inArgument1, inArgument2) ;
//--- Self terminate
  usr_task_self_terminate () ;
}

//---------------------------------------------------------------------------*

static void kernel_set_task_context (task_context * inTaskContext,
                                     const size_t inStackPointerInitialValue,
                                     routineTaskType inTaskRoutine,
                                     const uint32 inArgument1,
                                     const uint32 inArgument2) {
//--- Initialize PC
  inTaskContext->mPC_USR = (uint32) task_entry ;
//--- Initialize R0
  inTaskContext->mR0 = (uint32) inTaskRoutine ;
//--- Initialize R1
  inTaskContext->mR1 = inArgument1 ;
//--- Initialize R2
  inTaskContext->mR2 = inArgument2 ;
//--- Initialize SP
  inTaskContext->mSP_USR = inStackPointerInitialValue ;
//--- Initialize CPSR
  inTaskContext->mCPSR = 0x10 ; // ARM USER MODE, IRQ and FIRQ interrupts enabled
}

//---------------------------------------------------------------------------*

void swi_start_task (task_descriptor * inTaskDescriptor,
                     routineTaskType inTaskRoutine,
                     const uint32 inArgument1,
                     const uint32 inArgument2) {
  if ((TASK_CREATED == inTaskDescriptor->mState) || (TASK_TERMINATED == inTaskDescriptor->mState)) {
  //--- Stack Pointer initial value
    const size_t spInitialValue = ((uint32) inTaskDescriptor->mStackBufferAddress) + inTaskDescriptor->mStackBufferSize ;
  //--- Initialize Context
    kernel_set_task_context (& (inTaskDescriptor->mTaskContext),
                             spInitialValue,
                             inTaskRoutine,
                             inArgument1,
                             inArgument2) ;
  //--- Make task ready
    kernel_makeTaskReady (inTaskDescriptor) ;
  }
}
 
//---------------------------------------------------------------------------*
//                                                                           *
//   C L O S E    T A S K                                                    *
//                                                                           *
//---------------------------------------------------------------------------*

void swi_close_task (task_descriptor * inTaskDescriptor) {
//--- Remove from descriptor list
  if (NULL == inTaskDescriptor->mNextTaskDescriptor) { // Last descriptor ?
    gLastTaskDescriptor = inTaskDescriptor->mPreviousTaskDescriptor ;
  }else{
    inTaskDescriptor->mNextTaskDescriptor->mPreviousTaskDescriptor = inTaskDescriptor->mPreviousTaskDescriptor ;
  }
  if (NULL == inTaskDescriptor->mPreviousTaskDescriptor) { // First descriptor ?
    gFirstTaskDescriptor = inTaskDescriptor->mNextTaskDescriptor ;
  }else{
    inTaskDescriptor->mPreviousTaskDescriptor->mNextTaskDescriptor = inTaskDescriptor->mNextTaskDescriptor ;
  }
  inTaskDescriptor->mNextTaskDescriptor = NULL ;
  inTaskDescriptor->mPreviousTaskDescriptor = NULL ;
  gTaskCount -- ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   C U R R E N T    T A S K    C O U N T                                   *
//                                                                           *
//---------------------------------------------------------------------------*

uint32 current_task_count (void) {
  return gTaskCount ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   P R E E M P T                                                           *
//                                                                           *
//---------------------------------------------------------------------------*

void swi_preempt (void) {
  task_descriptor * runningTask = kernel_runningTask () ;
  if (NULL != runningTask) {
    kernel_makeTaskReady (runningTask) ;
    kernel_makeNoTaskRunning () ;
  }
}

//---------------------------------------------------------------------------*
