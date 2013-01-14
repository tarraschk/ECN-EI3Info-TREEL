//---------------------------------------------------------------------------*

#include "semaphore.h"
#include "services.h"
#include "lists-management.h"

//---------------------------------------------------------------------------*

#include <stddef.h>

//---------------------------------------------------------------------------*
//                                                                           *
//   I N I T    S E M A P H O R E                                            *
//                                                                           *
//---------------------------------------------------------------------------*

void init_semaphore (semaphore * inSemaphore,
                     const uint32 inInitialValue) {
  initTaskList (& inSemaphore->mWaitingTaskList) ;
  inSemaphore->mValue = inInitialValue ;
}

//---------------------------------------------------------------------------*
//                                                                           *
//   V    O P E R A T I O N                                                  *
//                                                                           *
//---------------------------------------------------------------------------*

void usr_V (semaphore * inSemaphore) ;

//---------------------------------------------------------------------------*

void swi_V (semaphore * inSemaphore) {
  const bool found = kernel_firstWaitingTaskBecomesReady (& inSemaphore->mWaitingTaskList, 1) ;
  if (! found) {
    inSemaphore->mValue ++ ; 
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   P    O P E R A T I O N                                                  *
//                                                                           *
//---------------------------------------------------------------------------*

void usr_P (semaphore * inSemaphore) ;

//---------------------------------------------------------------------------*

void swi_P (semaphore * inSemaphore) {
  if (inSemaphore->mValue > 0) {
    inSemaphore->mValue -- ;
  }else{
    kernel_runningTaskWaitsOnFIFOList (& inSemaphore->mWaitingTaskList) ;
  }
}

//---------------------------------------------------------------------------*
//                                                                           *
//   P    U N T I L    O P E R A T I O N                                     *
//                                                                           *
//---------------------------------------------------------------------------*

bool usr_P_until (semaphore * inSemaphore,
                  const uint32 inDeadline) ;

//---------------------------------------------------------------------------*

bool swi_P_until (semaphore * inSemaphore,
                  const uint32 inDeadline) {
  const bool result = inSemaphore->mValue > 0 ;
  if (result) {
    inSemaphore->mValue -- ;
  }else if (inDeadline > uptime ()) {
    kernel_runningTaskWaitsOnLists (& inSemaphore->mWaitingTaskList, false, inDeadline) ;
  }
  return result ;
}

//---------------------------------------------------------------------------*
