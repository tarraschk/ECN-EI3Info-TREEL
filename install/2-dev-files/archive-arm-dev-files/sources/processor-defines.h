#ifndef PROCESSOR_DEFINES
#define PROCESSOR_DEFINES

//---------------------------------------------------------------------------*

    typedef   signed        char sint8 ;
    typedef unsigned        char uint8 ;
    typedef                short sint16 ;
    typedef unsigned       short uint16 ;
    typedef                  int sint32 ;
    typedef unsigned         int uint32 ;
    typedef           long  long sint64 ;
    typedef unsigned  long  long uint64 ;

//---------------------------------------------------------------------------*

#ifndef __cplusplus
  #ifndef bool
    #define bool uint8
    #define true ((bool) 1)
    #define false ((bool) 0)
  #endif
#endif

//---------------------------------------------------------------------------*

#endif
