#!/bin/bash

ps -ef | grep P_file.sh | grep -v grep | awk '{print $2}' | xargs kill

ps -ef | grep V_file.sh | grep -v grep | awk '{print $2}' | xargs kill

ps -ef | grep map.sh | grep -v grep | awk '{print $2}' | xargs kill

ps -ef | grep P_pipe.sh | grep -v grep | awk '{print $2}' | xargs kill

ps -ef | grep V_pipe.sh | grep -v grep | awk '{print $2}' | xargs kill
