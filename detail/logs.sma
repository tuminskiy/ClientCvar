#include <amxmodx>
#include <amxmisc>

#define MAX_LOGS_PATH_LENGTH 63

enum _:LogErrorType {
  iLogWarning = 1,
  iLogCritical = 2
}

new g_szErrorLogsPath[MAX_LOGS_PATH_LENGTH + 1];
new g_szInfoLogsPath[MAX_LOGS_PATH_LENGTH + 1];

LogsInit()
{
  get_localinfo("amxx_logs", g_szErrorLogsPath, MAX_LOGS_PATH_LENGTH);
  get_localinfo("amxx_logs", g_szInfoLogsPath, MAX_LOGS_PATH_LENGTH);

  format(g_szErrorLogsPath, MAX_LOGS_PATH_LENGTH, "%s/client_cvar_error_v%s.log", g_szErrorLogsPath, VERSION);
  format(g_szInfoLogsPath, MAX_LOGS_PATH_LENGTH, "%s/client_cvar_info_v%s.log", g_szInfoLogsPath, VERSION);

	if (!is_dedicated_server()) {
		LogError(iLogCritical, "ERROR: Server must be dedicated!");
	}

	if (!is_running("cstrike")) {
		LogError(iLogCritical, "ERROR: Server must be running cstrike mod!");
	}
}

LogInfo(const szText[])
{
  Log2File(g_szInfoLogsPath, szText);

  return 0;
}

LogError(const LogErrorType:iType, const szText[])
{
	Log2File(g_szErrorLogsPath, szText);

	switch (iType) {
		case iLogWarning: {
			server_print("[ClientCvar] %s", szText);
		}
		case iLogCritical: {
			set_fail_state(szText);
		}
		default: { }
	}
  
	return 0;
}

Log2File(const szFilePath[], const szText[])
{
  static szLog[256];

  get_time("[%d.%m.%Y %H:%M:%S] ", szLog, 22);
  add(szLog, 255, szText, 234);

  write_file(szFilePath, szLog);

  return 0;
}