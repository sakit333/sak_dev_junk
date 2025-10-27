#!/bin/bash
# Bigger-font, highlighted banners + hacker-style animated DevOps installation demo
# - Bigger ASCII banners in a cyan highlight box
# - Bold green banner text
# - Fake logs, spinner, separators, ENTER between tools
# - No external dependencies

# Colors (bold + hacker style)
BOLD='\033[1m'
BRIGHT_GREEN='\033[1;92m'   # brighter green for banners
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BRIGHT_CYAN='\033[1;96m'    # for stronger box
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
GRAY='\033[1;30m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
REVERSE='\033[7m'

# Spinner animation (uses kill -0 to check process)
spinner() {
  local pid=$1
  local delay=0.08
  local spinstr="|/-\\"
  while kill -0 "$pid" 2>/dev/null; do
    for ch in $(echo -n "$spinstr" | sed -e 's/./& /g'); do
      printf " [%c]  " "$ch"
      sleep "$delay"
      printf "\b\b\b\b\b\b"
    done
  done
  printf "    \b\b\b\b"
}

# Slow typing (used for credit box and logs if needed)
slow_print() {
  local text="$1"
  local delay="${2:-0.004}"
  for (( i=0; i<${#text}; i++ )); do
    printf "%s" "${text:$i:1}"
    sleep "$delay"
  done
  printf "\n"
}

# Fake installation logs
fake_logs=(
  "[INFO] Checking dependencies..."
  "[INFO] Downloading required binaries..."
  "[INFO] Verifying SHA256 checksums..."
  "[INFO] Configuring environment variables..."
  "[INFO] Applying permissions..."
  "[INFO] Building core components..."
  "[INFO] Patching system settings..."
  "[INFO] Cleaning up temporary files..."
  "[INFO] Finalizing installation..."
)

show_fake_logs() {
  for line in "${fake_logs[@]}"; do
    echo -e "${GRAY}${line}${NC}"
    sleep 0.22
  done
}

# Highlighted credit box (used after banners)
show_credit_box() {
  echo -e "${BOLD}${BRIGHT_CYAN}"
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo -e "║ ${YELLOW}${BOLD}👨‍💻By Akshay Kumar${NC}${BRIGHT_CYAN}${BOLD} — DevOps Engineer & Corporate Trainer   ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}\n"
}


# Very large banners (bigger "font size" feel)
# Each banner prints inside a cyan frame with bright green bold text
big_banner_box() {
  local tool="$1"
  # prepare the ascii block for the tool
  case "$tool" in
    "AWS")
      read -r -d '' block <<'AWSBLOCK'
      
 █████╗ ██╗    ██╗███████╗
██╔══██╗██║    ██║██╔════╝
███████║██║ █╗ ██║███████╗
██╔══██║██║███╗██║╚════██║
██║  ██║╚███╔███╔╝███████║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝
                                                                                                                                    
AWSBLOCK
      ;;
    "Git")
      read -r -d '' block <<'GITBLOCK'

 ██████╗ ██╗████████╗       ██╗        ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗ 
██╔════╝ ██║╚══██╔══╝       ██║       ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗
██║  ███╗██║   ██║       ████████╗    ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝
██║   ██║██║   ██║       ██╔═██╔═╝    ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗
╚██████╔╝██║   ██║       ██████║      ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝
 ╚═════╝ ╚═╝   ╚═╝       ╚═════╝       ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                                      
GITBLOCK
      ;;
    "Maven")
      read -r -d '' block <<'MAVENBLOCK'

███╗   ███╗ █████╗ ██╗   ██╗███████╗███╗   ██╗
████╗ ████║██╔══██╗██║   ██║██╔════╝████╗  ██║
██╔████╔██║███████║██║   ██║█████╗  ██╔██╗ ██║
██║╚██╔╝██║██╔══██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║
██║ ╚═╝ ██║██║  ██║ ╚████╔╝ ███████╗██║ ╚████║
╚═╝     ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝
                                                
MAVENBLOCK
      ;;
    "Jenkins")
      read -r -d '' block <<'JENKINSBLOCK'

     ██╗███████╗███╗   ██╗██╗  ██╗██╗███╗   ██╗███████╗
     ██║██╔════╝████╗  ██║██║ ██╔╝██║████╗  ██║██╔════╝
     ██║█████╗  ██╔██╗ ██║█████╔╝ ██║██╔██╗ ██║███████╗
██   ██║██╔══╝  ██║╚██╗██║██╔═██╗ ██║██║╚██╗██║╚════██║
╚█████╔╝███████╗██║ ╚████║██║  ██╗██║██║ ╚████║███████║
 ╚════╝ ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
                                                                                                        
JENKINSBLOCK
      ;;
    "Docker")
      read -r -d '' block <<'DOCKERBLOCK'

██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝
██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║
╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                 
DOCKERBLOCK
      ;;
    "Linux")
      read -r -d '' block <<'LINUXBLOCK'

██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
                                      
LINUXBLOCK
      ;;
    "ShellScripting")
      read -r -d '' block <<'SHELLSCRIPTINGBLOCK'

███████╗██╗  ██╗███████╗██╗     ██╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗██╗███╗   ██╗ ██████╗ 
██╔════╝██║  ██║██╔════╝██║     ██║     ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝ 
███████╗███████║█████╗  ██║     ██║     ███████╗██║     ██████╔╝██║██████╔╝   ██║   ██║██╔██╗ ██║██║  ███╗
╚════██║██╔══██║██╔══╝  ██║     ██║     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ██║██║╚██╗██║██║   ██║
███████║██║  ██║███████╗███████╗███████╗███████║╚██████╗██║  ██║██║██║        ██║   ██║██║ ╚████║╚██████╔╝
╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                                                                                                          
SHELLSCRIPTINGBLOCK
      ;;
    "Ansible")
      read -r -d '' block <<'ANSIBLEBLOCK'

 █████╗ ███╗   ██╗███████╗██╗██████╗ ██╗     ███████╗
██╔══██╗████╗  ██║██╔════╝██║██╔══██╗██║     ██╔════╝
███████║██╔██╗ ██║███████╗██║██████╔╝██║     █████╗  
██╔══██║██║╚██╗██║╚════██║██║██╔══██╗██║     ██╔══╝  
██║  ██║██║ ╚████║███████║██║██████╔╝███████╗███████╗
╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝╚═════╝ ╚══════╝╚══════╝
                                                                                                                                                        
ANSIBLEBLOCK
      ;;
    "Terraform")
      read -r -d '' block <<'TERRAFORMBLOCK'

████████╗███████╗██████╗ ██████╗  █████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗
╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔═══██╗██╔══██╗████╗ ████║
   ██║   █████╗  ██████╔╝██████╔╝███████║█████╗  ██║   ██║██████╔╝██╔████╔██║
   ██║   ██╔══╝  ██╔══██╗██╔══██╗██╔══██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║
   ██║   ███████╗██║  ██║██║  ██║██║  ██║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║
   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝
                                                                                                                                                                                       
TERRAFORMBLOCK
      ;;
    "Kubernets")
      read -r -d '' block <<'KUBERNETESBLOCK'

██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ███╗   ██╗███████╗████████╗███████╗███████╗
██║ ██╔╝██║   ██║██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝
█████╔╝ ██║   ██║██████╔╝█████╗  ██████╔╝██╔██╗ ██║█████╗     ██║   █████╗  ███████╗
██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██╔══██╗██║╚██╗██║██╔══╝     ██║   ██╔══╝  ╚════██║
██║  ██╗╚██████╔╝██████╔╝███████╗██║  ██║██║ ╚████║███████╗   ██║   ███████╗███████║
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝
                                                                                                                                                                                              
KUBERNETESBLOCK
      ;;
    "Tomcat")
      read -r -d '' block <<'TOMCATBLOCK'

████████╗ ██████╗ ███╗   ███╗ ██████╗ █████╗ ████████╗
╚══██╔══╝██╔═══██╗████╗ ████║██╔════╝██╔══██╗╚══██╔══╝
   ██║   ██║   ██║██╔████╔██║██║     ███████║   ██║   
   ██║   ██║   ██║██║╚██╔╝██║██║     ██╔══██║   ██║   
   ██║   ╚██████╔╝██║ ╚═╝ ██║╚██████╗██║  ██║   ██║   
   ╚═╝    ╚═════╝ ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   
                                                                                                                                                         
TOMCATBLOCK
      ;;
    "Nginx")
      read -r -d '' block <<'NGINXBLOCK'

███╗   ██╗ ██████╗ ██╗███╗   ██╗██╗  ██╗
████╗  ██║██╔════╝ ██║████╗  ██║╚██╗██╔╝
██╔██╗ ██║██║  ███╗██║██╔██╗ ██║ ╚███╔╝ 
██║╚██╗██║██║   ██║██║██║╚██╗██║ ██╔██╗ 
██║ ╚████║╚██████╔╝██║██║ ╚████║██╔╝ ██╗
╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                                                                          
NGINXBLOCK
      ;;
    "Prometheus")
      read -r -d '' block <<'PROMETHEUSBLOCK'

██████╗ ██████╗  ██████╗ ███╗   ███╗███████╗████████╗██╗  ██╗███████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔════╝╚══██╔══╝██║  ██║██╔════╝██║   ██║██╔════╝
██████╔╝██████╔╝██║   ██║██╔████╔██║█████╗     ██║   ███████║█████╗  ██║   ██║███████╗
██╔═══╝ ██╔══██╗██║   ██║██║╚██╔╝██║██╔══╝     ██║   ██╔══██║██╔══╝  ██║   ██║╚════██║
██║     ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗   ██║   ██║  ██║███████╗╚██████╔╝███████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝
                                                                                                                                                                                          
PROMETHEUSBLOCK
      ;;
    "Grafana")
      read -r -d '' block <<'GRAFANABLOCK'

 ██████╗ ██████╗  █████╗ ███████╗ █████╗ ███╗   ██╗ █████╗ 
██╔════╝ ██╔══██╗██╔══██╗██╔════╝██╔══██╗████╗  ██║██╔══██╗
██║  ███╗██████╔╝███████║█████╗  ███████║██╔██╗ ██║███████║
██║   ██║██╔══██╗██╔══██║██╔══╝  ██╔══██║██║╚██╗██║██╔══██║
╚██████╔╝██║  ██║██║  ██║██║     ██║  ██║██║ ╚████║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                                                                                                                             
GRAFANABLOCK
      ;;
    "Nexus")
      read -r -d '' block <<'NEXUSBLOCK'

███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
                                                                                                                                        
NEXUSBLOCK
      ;;
    "Devops")
      read -r -d '' block <<'DEVOPSBLOCK'

██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗
██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝
██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗
██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║
██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║
╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝
                                                                                                                                            
DEVOPSBLOCK
      ;;
    *)
      block="$tool"
      ;;
  esac

  # Compute max line length for box width
  local maxlen=0
  while IFS= read -r ln; do
    (( ${#ln} > maxlen )) && maxlen=${#ln}
  done <<< "$block"

  local pad=4
  local width=$((maxlen + pad*2))

  # Print top border
  printf "${BOLD}${BRIGHT_CYAN}"
  printf "╔"
  for ((i=0;i<width;i++)); do printf "═"; done
  printf "╗\n"

  # Print block lines centered
  while IFS= read -r ln; do
    # trim trailing spaces to keep alignment
    ln="${ln% }"
    # compute left padding to center
    local left=$(( (width - ${#ln}) / 2 ))
    printf "║"
    for ((i=0;i<left;i++)); do printf " "; done
    printf "${BOLD}${BRIGHT_GREEN}%s${BOLD}${BRIGHT_CYAN}" "$ln"
    # remaining padding
    local right=$(( width - left - ${#ln} ))
    for ((i=0;i<right;i++)); do printf " "; done
    printf "║\n"
  done <<< "$block"

  # Print bottom border and reset color
  printf "╚"
  for ((i=0;i<width;i++)); do printf "═"; done
  printf "╝\n"
  printf "${NC}\n"

  # Credit box below banner
  show_credit_box
}

# Different separator styles (rotates)
separator() {
  local idx=$1
  case $(( idx % 4 )) in
    0)
      echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
      ;;
    1)
      echo -e "${YELLOW}-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --${NC}"
      ;;
    2)
      echo -e "${MAGENTA}··· ••• ··· ••• ··· ••• ··· ••• ··· ••• ··· ••• ··· ···${NC}"
      ;;
    3)
      # matrix-like noise line (random bits)
      local line=""
      for i in {1..60}; do
        if (( RANDOM % 6 == 0 )); then
          line+="."
        else
          line+=$((RANDOM%2))
        fi
      done
      echo -e "${GREEN}${line}${NC}"
      ;;
  esac
}

clear
# Header
echo -e "${BRIGHT_CYAN}${BOLD}"
echo "============================================================"
echo -e "${BRIGHT_GREEN}        💻 Welcome to the World of DevOps"
echo -e "${BRIGHT_CYAN}============================================================${NC}"
echo ""
echo -e "${YELLOW}${BOLD}👋 Hello, I'm ${MAGENTA}Akshay Kumar${NC}"
echo -e "${CYAN}${BOLD}🚀 DevOps Engineer & Corporate Trainer${NC}"
echo -e "${GREEN}${BOLD}🏢 Working with the Corp DevOps Team${NC}"
echo ""
echo -e "${BRIGHT_GREEN}${BOLD}Let's automate, innovate, and collaborate!${NC}"
echo ""
echo -e "${BLUE}${BOLD}“Empowering automation, one script at a time.”${NC}"
echo ""
echo -e "${BRIGHT_CYAN}${BOLD}============================================================${NC}"
sleep 5

# Tools (AWS removed)
tools=("AWS" "Git" "Maven" "Jenkins" "Docker" "Linux" "ShellScripting" "Ansible" "Terraform" "Kubernets" "Tomcat" "Nginx" "Prometheus" "Grafana" "Nexus" "Devops")

# Installation simulation
idx=0
for tool in "${tools[@]}"; do
  separator "$idx"
  # Print a very visible highlighted tool title (before install) as well
  clear
  echo -e "${BRIGHT_CYAN}${BOLD}----------------------------------------------------------"
  echo -e " "
  echo -e "${BRIGHT_CYAN}${BOLD}>>> Preparing to install: ${BRIGHT_GREEN}${BOLD}$tool${NC}\n"
  echo -e "${YELLOW}${BOLD}${tool} is started installing...${NC}"
  # spawn a background sleeper to simulate activity, pass its pid to spinner
  ( for i in {1..24}; do sleep 0.12; done ) &
  pid=$!
  spinner "$pid"
  wait "$pid" 2>/dev/null

  show_fake_logs
  echo -e "${GREEN}${BOLD}${tool} installation completed successfully!${NC}\n"

  # show big highlighted banner (large font + box)
  big_banner_box "$tool"

  # After banner, ask user to press ENTER to continue to next tool (except last)
  if [ "$idx" -lt $(( ${#tools[@]} - 1 )) ]; then
    echo -e "${BLUE}${BOLD}Press ENTER to proceed to the next installation...${NC}"
    read -r
  else
    # small pause after final tool
    sleep 0.8
  fi

  idx=$((idx+1))
done

# Extra Git line
# echo -e "${MAGENTA}${BOLD}instaaltion of git is done${NC}"
sleep 0.6


# ==========================
# 💻 DevOps Footer Banner
# ==========================
echo -e "${BRIGHT_CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo -e "║${BRIGHT_GREEN}${BOLD}               💻  D E V O P S               ${BRIGHT_CYAN}║"
echo "╠══════════════════════════════════════════════╣"
echo -e "║${YELLOW}${BOLD}     🚀 Automate | Innovate | Collaborate      ${BRIGHT_CYAN}║"
echo "╠══════════════════════════════════════════════╣"
echo -e "║${MAGENTA}${BOLD}        Scripted with ❤️  by ${YELLOW}sak_shetty       ${BRIGHT_CYAN}║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

