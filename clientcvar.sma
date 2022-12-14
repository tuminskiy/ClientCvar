#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Client Cvar"
#define VERSION "1.0.0"
#define AUTHOR "Eneu"

#define MAX_CVAR_LENGTH 63
#define MAX_TARGET_LENGTH MAX_NAME_LENGTH

#include "detail/logs.sma"
#include "detail/clientinfo.sma"

public plugin_init()
{
  register_plugin(PLUGIN, VERSION, AUTHOR);
  
  LogsInit();
  
  register_concmd("gcc", "CmdGetClientCvar", ADMIN_BAN, "<name or #userid> <cvar>", -1, false);
}

public CmdGetClientCvar(const id, const lvl, const cid)
{
  if (!cmd_access(id, lvl, cid, 3, false) || read_argc() < 3) {
    return PLUGIN_CONTINUE;
  }

  static szTarget[MAX_TARGET_LENGTH + 1];
  read_argv(1, szTarget, MAX_TARGET_LENGTH);

  new const iTarget = cmd_target(id, szTarget, CMDTARGET_ALLOW_SELF);
  if (!iTarget) {
    return PLUGIN_HANDLED;
  }

  static szCvar[MAX_CVAR_LENGTH + 1];
  read_argv(2, szCvar, MAX_CVAR_LENGTH);

  new iParams[1];
  iParams[0] = id;

  LogCallGetClientCvar(id, iTarget, szCvar);

  query_client_cvar(iTarget, szCvar, "CmdGetClientCvar_Callback", 1, iParams);

  return PLUGIN_HANDLED;
}

public CmdGetClientCvar_Callback(const iTarget, const szCvar[], const szValue[], const iParams[])
{
  new const iCmdUserId = iParams[0];

  LogResultGetClientCvar(iCmdUserId, iTarget, szCvar, szValue);

  if (equal(szValue, "Bad CVAR request", MAX_CVAR_LENGTH)) {
    console_print(iCmdUserId, "Client %s (%s) doesn't have %s cvar^n",
      g_ePlayer[iTarget][Nickname], g_ePlayer[iTarget][AuthId],
      szCvar
    );
  } else {
    console_print(iCmdUserId, "Client %s (%s) has %s %s^n",
      g_ePlayer[iTarget][Nickname], g_ePlayer[iTarget][AuthId],
      szCvar, szValue
    );
  }

  return PLUGIN_HANDLED;
}


LogCallGetClientCvar(const iUser, const iTarget, const szCvar[])
{
  static msg[1024];

  format(msg, 1023, "%s <%s|%s> try to get cvar '%s' from %s <%s|%s>",
    g_ePlayer[iUser][Nickname], g_ePlayer[iUser][AuthId], g_ePlayer[iUser][IPv4],
    szCvar,
    g_ePlayer[iTarget][Nickname], g_ePlayer[iTarget][AuthId], g_ePlayer[iTarget][IPv4]
  );

  LogInfo(msg);
}

LogResultGetClientCvar(const iUser, const iTarget, const szCvar[], const szValue[])
{
  static msg[1024];

  format(msg, 1023, "%s <%s|%s> get cvar '%s' from %s <%s|%s> value: '%s'",
    g_ePlayer[iUser][Nickname], g_ePlayer[iUser][AuthId], g_ePlayer[iUser][IPv4],
    szCvar,
    g_ePlayer[iTarget][Nickname], g_ePlayer[iTarget][AuthId], g_ePlayer[iTarget][IPv4],
    szValue
  );

  LogInfo(msg);
}