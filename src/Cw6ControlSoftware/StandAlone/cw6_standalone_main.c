/*
 * MATLAB Compiler: 4.1 (R14SP1)
 * Date: Wed Jul 02 19:52:49 2008
 * Arguments: "-B" "macro_default" "-o" "Cw6_Standalone" "-m" "-W" "main" "-T"
 * "link:exe" "-v" "Cw6" "AutoAdjustGain" "Cw6LoadSubjInfo.m" "Cw6_BackEnd.m"
 * "Cw6_MenuFunctions.m" "GUIChangeDetector_callback.m" "GetExtinctions.m"
 * "SendML2Cw6.m" "SetLaser.m" "Cw6.fig" "loadCw6ConfigFile.m" "saveNIRSData.m"
 * "validatesystem.m" "NIRS_timer_main_callback.m" "PlotSDG.m"
 * "localStopTimer.m" "plotmainwindow.m" "LaunchSplash.m" "LayOutFunction.m"
 * "UITree_ted.m" "createDetTab.m" "createSrctab.m" "getjframe.m"
 * "uicomponent.m" "LoadSDG.m" "RegisterSubject.fig" "RegisterSubject.m"
 * "SaveComments.m" "RealTimeFilterSetupMenu.fig" "RealTimeFilterSetupMenu.m"
 * "processRTfunctions.m" "-a" "Splash.jpg" "-a" "cw6.cfg" "-d"
 * "D:\Cw6ControlSoftware\StandAlone" 
 */

#include <stdio.h>
#include "mclmcr.h"
#ifdef __cplusplus
extern "C" {
#endif
extern const unsigned char __MCC_Cw6_Standalone_public_data[];
extern const char *__MCC_Cw6_Standalone_name_data;
extern const char *__MCC_Cw6_Standalone_root_data;
extern const unsigned char __MCC_Cw6_Standalone_session_data[];
extern const char *__MCC_Cw6_Standalone_matlabpath_data[];
extern const int __MCC_Cw6_Standalone_matlabpath_data_count;
extern const char *__MCC_Cw6_Standalone_classpath_data[];
extern const int __MCC_Cw6_Standalone_classpath_data_count;
extern const char *__MCC_Cw6_Standalone_mcr_runtime_options[];
extern const int __MCC_Cw6_Standalone_mcr_runtime_option_count;
extern const char *__MCC_Cw6_Standalone_mcr_application_options[];
extern const int __MCC_Cw6_Standalone_mcr_application_option_count;
#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


static int mclDefaultPrintHandler(const char *s)
{
    return fwrite(s, sizeof(char), strlen(s), stdout);
}

static int mclDefaultErrorHandler(const char *s)
{
    int written = 0, len = 0;
    len = strlen(s);
    written = fwrite(s, sizeof(char), len, stderr);
    if (len > 0 && s[ len-1 ] != '\n')
        written += fwrite("\n", sizeof(char), 1, stderr);
    return written;
}

bool Cw6_StandaloneInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
    if (_mcr_inst != NULL)
        return true;
    if (!mclmcrInitialize())
        return false;
    if (!mclInitializeComponentInstance(&_mcr_inst,
                                        __MCC_Cw6_Standalone_public_data,
                                        __MCC_Cw6_Standalone_name_data,
                                        __MCC_Cw6_Standalone_root_data,
                                        __MCC_Cw6_Standalone_session_data,
                                        __MCC_Cw6_Standalone_matlabpath_data,
                                        __MCC_Cw6_Standalone_matlabpath_data_count,
                                        __MCC_Cw6_Standalone_classpath_data,
                                        __MCC_Cw6_Standalone_classpath_data_count,
                                        __MCC_Cw6_Standalone_mcr_runtime_options,
                                        __MCC_Cw6_Standalone_mcr_runtime_option_count,
                                        true, NoObjectType, ExeTarget, NULL,
                                        error_handler, print_handler))
        return false;
    return true;
}

bool Cw6_StandaloneInitialize(void)
{
    return Cw6_StandaloneInitializeWithHandlers(mclDefaultErrorHandler,
                                                mclDefaultPrintHandler);
}

void Cw6_StandaloneTerminate(void)
{
    if (_mcr_inst != NULL)
        mclTerminateInstance(&_mcr_inst);
}

int main(int argc, const char **argv)
{
    int _retval;
    if (!mclInitializeApplication(__MCC_Cw6_Standalone_mcr_application_options,
                                  __MCC_Cw6_Standalone_mcr_application_option_count))
        return 0;
    
    if (!Cw6_StandaloneInitialize())
        return -1;
    _retval = mclMain(_mcr_inst, argc, argv, "cw6", 1);
    if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
    Cw6_StandaloneTerminate();
    mclTerminateApplication();
    return _retval;
}
