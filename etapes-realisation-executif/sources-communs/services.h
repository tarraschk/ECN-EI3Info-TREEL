//---------------------------------------------------------------------------*

#ifndef SERVICES_ROUTINES_DECLARED
#define SERVICES_ROUTINES_DECLARED

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
//   R O U T I N E S                                                         *
//                                                                           *
//-------------------------------------------------------------------------*

void initialiser_application (void) ;

//---------------------------------------------------------------------------*

void usr_create_task (task_descriptor * inTaskDescriptor,
                      const uint8 inPriority,
                      uint32 * inStackBufferAddress,
                      uint32 inStackBufferSize) ;

void swi_create_task (task_descriptor * inTaskDescriptor,
                      const uint8 inPriority,
                      uint32 * inStackBufferAddress,
                      uint32 inStackBufferSize) ;

//---------------------------------------------------------------------------*

void usr_start_task (task_descriptor * inTaskDescriptor,
                     routineTaskType inTaskCode,
                     const uint32 inArgument1,
                     const uint32 inArgument2) ;

void swi_start_task (task_descriptor * inTaskDescriptor,
                     routineTaskType inTaskCode,
                     const uint32 inArgument1,
                     const uint32 inArgument2) ;

//---------------------------------------------------------------------------*

void usr_close_task (task_descriptor * inTaskDescriptor) ;

void swi_close_task (task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*

uint32 current_task_count (void) ;

//---------------------------------------------------------------------------*

void usr_task_self_terminate (void) ;

void swi_task_self_terminate (void) ;

//---------------------------------------------------------------------------*
// Routines implemented by the scheduler                                     *
//---------------------------------------------------------------------------*

task_descriptor * kernel_runningTask (void) ;

//---------------------------------------------------------------------------*

void kernel_makeTaskReady (task_descriptor * inTaskDescriptor) ;

//---------------------------------------------------------------------------*

void kernel_selectTaskToRun (void) ;

//---------------------------------------------------------------------------*

void kernel_makeNoTaskRunning (void) ;

//---------------------------------------------------------------------------*

void usr_preempt (void) ;
void swi_preempt (void) ;

//---------------------------------------------------------------------------*
//   End of force C linking for C++ compilation                              *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif

