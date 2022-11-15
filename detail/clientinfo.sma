#include <amxmodx>
#include <amxmisc>

#define MAX_IPV4_LENGTH 22

enum _:ClientInfo {
  Nickname[MAX_NAME_LENGTH + 1],
  AuthId[MAX_AUTHID_LENGTH + 1],
  IPv4[MAX_IP_LENGTH + 1]
}

new const g_ePlayer[MAX_PLAYERS + 1][ClientInfo];

public client_connect(id)
{
  get_user_name(id, g_ePlayer[id][Nickname], MAX_NAME_LENGTH);
  get_user_authid(id, g_ePlayer[id][AuthId], MAX_AUTHID_LENGTH);
  get_user_ip(id, g_ePlayer[id][IPv4], MAX_IPV4_LENGTH, 1)
}