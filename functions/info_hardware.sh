#!/bin/bash

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2019-2020, Andres Gongora <mail@andresgongora.com>.     |
##  | Copyright (c) 2019, Sami Olmari <sami@olmari.fi>.                     |
##  |                                                                       |
##  | This program is free software: you can redistribute it and/or modify  |
##  | it under the terms of the GNU General Public License as published by  |
##  | the Free Software Foundation, either version 3 of the License, or     |
##  | (at your option) any later version.                                   |
##  |                                                                       |
##  | This program is distributed in the hope that it will be useful,       |
##  | but WITHOUT ANY WARRANTY; without even the implied warranty of        |
##  | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
##  | GNU General Public License for more details.                          |
##  |                                                                       |
##  | You should have received a copy of the GNU General Public License     |
##  | along with this program. If not, see <http://www.gnu.org/licenses/>.  |
##  |                                                                       |
##  +-----------------------------------------------------------------------+


##
##	DESCRIPTION:
##	Network related functions for synth-shell-greeter
##
##



##==============================================================================
##
getNameCPU()
{
	## Get first instance of "model name" in /proc/cpuinfo, pipe into 'sed'
	## s/model name\s*:\s*//  remove "model name : " and accompanying spaces
	## s/\s*@.*//             remove anything from "@" onwards
	## s/(R)//                remove "(R)"
	## s/(TM)//               remove "(TM)"
	## s/CPU//                remove "CPU"
	## s/\s\s\+/ /            clean up double spaces (replace by single space)
	## p                      print final output
	local cpu=$(grep -m 1 "model name" /proc/cpuinfo |\
	            sed -n 's/model name\s*:\s*//;
	                    s/\s*@.*//;
	                    s/(R)//;
	                    s/(TM)//;
	                    s/CPU//;
	                    s/\s\s\+/ /;
	                    p')

	printf "$cpu"
}






##==============================================================================
##
getNameGPU()
{
	## DETECT GPU(s)set	
	local gpu_id=$(lspci 2>/dev/null | grep ' VGA ' | cut -d" " -f 1)

	## FOR ALL DETECTED IDs
	## Get the GPU name, but trim all buzzwords away
	echo -e "$gpu_id" | while read line ; do
	   	local gpu=$(lspci -v -s "$line" 2>/dev/null |\
		            head -n 1 |\
		            sed 's/^.*: //g;s/(.*$//g;
		                 s/Corporation//g;
		                 s/Core Processor//g;
		                 s/Series//g;
		                 s/Chipset//g;
		                 s/Graphics//g;
		                 s/processor//g;
		                 s/Controller//g;
		                 s/Family//g;
		                 s/Inc.//g;
		                 s/,//g;
		                 s/Technology//g;
		                 s/Mobility/M/g;
		                 s/Advanced Micro Devices/AMD/g;
		                 s/\[AMD\/ATI\]/ATI/g;
		                 s/Integrated Graphics Controller/HD Graphics/g;
		                 s/Integrated Controller/IC/g;
		                 s/  */ /g'
		           )

		## If GPU name still to long, remove anything between []
		if [ "${#gpu}" -gt 30 ]; then
			local gpu=$(echo "$gpu" | sed 's/\[.*\]//g' )
		fi


		printf "$gpu"
	done
}






##==============================================================================
##
getCPUUtilization()
{
	local avg_load=$(uptime | sed 's/^.*load average: //g')	
	printf "$avg_load"
}


