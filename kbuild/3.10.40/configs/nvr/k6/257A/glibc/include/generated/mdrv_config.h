#define CONFIG_ON 841
#define CONFIG_OFF 1889
#define CONFIG_CNT CONFIG_ON+CONFIG_OFF
const char kernel_config_do_set[][100]=
{
#include "do_config_item.h"
};
const char kernel_config_not_set[][100]=
{
#include "not_set_item.h"
};
