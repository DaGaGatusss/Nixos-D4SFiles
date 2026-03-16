{ config, pkgs, ... }:

let
  battScript = pkgs.writeScript "batt.py" ''
    #!/usr/bin/env python3
    from subprocess import check_output

    status = check_output(['acpi'], universal_newlines=True)

    if not status:
        fulltext = "<span color='red'><span font='FontAwesome'>\uf00d \uf240</span></span>"
        percentleft = 100
    else:
        batteries = status.split("\n")
        state_batteries = []
        commasplitstatus_batteries = []
        percentleft_batteries = []
        for battery in batteries:
            if battery != "":
                state_batteries.append(battery.split(": ")[1].split(", ")[0])
                commasplitstatus = battery.split(", ")
                percentleft_batteries.append(int(commasplitstatus[1].rstrip("%\n")))
                commasplitstatus_batteries.append(commasplitstatus)

        state = state_batteries[0]
        commasplitstatus = commasplitstatus_batteries[0]
        percentleft = int(sum(percentleft_batteries) / len(percentleft_batteries))

        FA_LIGHTNING = "<span color='yellow'><span font='FontAwesome'>\uf0e7</span></span>"
        FA_PLUG = "<span font='FontAwesome'>\uf1e6</span>"

        fulltext = ""
        timeleft = ""

        if state == "Discharging":
            time = commasplitstatus[-1].split()[0]
            time = ":".join(time.split(":")[0:2])
            timeleft = " ({})".format(time)
        elif state == "Full":
            fulltext = FA_PLUG + " "
        elif state == "Unknown":
            fulltext = "<span font='FontAwesome'>\uf128</span> "
        else:
            fulltext = FA_LIGHTNING + " " + FA_PLUG + " "

        def color(percent):
            if percent < 10:  return "#FFFFFF"
            if percent < 20:  return "#FF3300"
            if percent < 30:  return "#FF6600"
            if percent < 40:  return "#FF9900"
            if percent < 50:  return "#FFCC00"
            if percent < 60:  return "#FFFF00"
            if percent < 70:  return "#FFFF33"
            if percent < 80:  return "#FFFF66"
            return "#FFFFFF"

        form = "<span color=\"{}\">{}</span>"
        fulltext += form.format(color(percentleft), str(percentleft) + "%")
        fulltext += timeleft

    print(fulltext)
    print(fulltext)
    if percentleft < 10:
        exit(33)
  '';

  cpuBin = pkgs.runCommand "i3blocks-cpu" { buildInputs = [ pkgs.gcc ]; } ''
    mkdir -p $out/bin
    cat > cpu.c << 'CSRC'
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <unistd.h>
    #include <getopt.h>

    #define RED "#FF7373"
    #define ORANGE "#FFA500"

    typedef unsigned long long int ulli;

    void display(const char *label, double used, int warning, int critical, int decimals) {
      if (critical != 0 && used > critical)
        printf("%s<span color='%s'>", label, RED);
      else if (warning != 0 && used > warning)
        printf("%s<span color='%s'>", label, ORANGE);
      else
        printf("%s<span>", label);
      printf("%*.*lf%%</span>\n", decimals + 3 + 1, decimals, used);
    }

    ulli get_usage(ulli *used_jiffies) {
      FILE *fd = fopen("/proc/stat", "r");
      ulli user, nice, sys, idle, iowait, irq, sirq, steal, guest, nguest;
      if (!fd) { perror("Couldn't open /proc/stat\n"); exit(1); }
      if (fscanf(fd, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
                 &user, &nice, &sys, &idle, &iowait, &irq, &sirq, &steal, &guest, &nguest) != 10) {
        perror("Couldn't read jiffies\n"); exit(1);
      }
      fclose(fd);
      *used_jiffies = user + nice + sys + irq + sirq + steal + guest + nguest;
      return *used_jiffies + idle + iowait;
    }

    int main(int argc, char *argv[]) {
      int warning = 50, critical = 80, t = 1, decimals = 0;
      char *label = "";
      int c;
      char *envvar = NULL;

      envvar = getenv("REFRESH_TIME");  if (envvar) t = atoi(envvar);
      envvar = getenv("WARN_PERCENT");  if (envvar) warning = atoi(envvar);
      envvar = getenv("CRIT_PERCENT");  if (envvar) critical = atoi(envvar);
      envvar = getenv("DECIMALS");      if (envvar) decimals = atoi(envvar);
      envvar = getenv("LABEL");         if (envvar) label = envvar;

      while (c = getopt(argc, argv, "ht:w:c:d:l:"), c != -1) {
        switch (c) {
          case 't': t = atoi(optarg); break;
          case 'w': warning = atoi(optarg); break;
          case 'c': critical = atoi(optarg); break;
          case 'd': decimals = atoi(optarg); break;
          case 'l': label = optarg; break;
        }
      }

      ulli old_total, old_used;
      old_total = get_usage(&old_used);

      while (1) {
        ulli used, total;
        sleep(t);
        total = get_usage(&used);
        display(label, 100.0 * (used - old_used) / (total - old_total), warning, critical, decimals);
        fflush(stdout);
        old_total = total;
        old_used = used;
      }
      return 0;
    }
    CSRC
    gcc -O2 -o $out/bin/cpu cpu.c
  '';

in
{
  home.file = {
    ".config/i3blocks/config".text = ''
      separator=true
      separator_block_width=15
      align=center
      markup=pango
      border_top=0
      border_bottom=0
      border_left=0
      border_right=0
      color=#eeeeee

      [cpu]
      command=${cpuBin}/bin/cpu
      interval=persist
      markup=pango
      color=#dfd932
      min_width=50
      align=right

      [memoria]
      command=$HOME/.config/i3blocks/memoria.sh
      interval=30
      color=#52aeff

      [ip]
      command=ip addr | grep 192 | awk '{print $2}' | sed 's/\/.*//g'
      interval=60
      color=#91E78B

      [volume]
      command=$HOME/.config/i3blocks/volume.sh
      LABEL=VOL
      interval=once
      signal=10
      color=#ffa252

      [battery]
      command=${battScript}
      markup=pango
      interval=30

      [time]
      command=date +'%d/%m/%Y %H:%M'
      interval=1
    '';

    ".config/i3blocks/memoria.sh" = {
      executable = true;
      text = ''
        #!/bin/sh
        TYPE="''${BLOCK_INSTANCE:-mem}"
        awk -v type=$TYPE '
        /^MemTotal:/  { mem_total=$2 }
        /^MemFree:/   { mem_free=$2 }
        /^Buffers:/   { mem_free+=$2 }
        /^Cached:/    { mem_free+=$2 }
        /^SwapTotal:/ { swap_total=$2 }
        /^SwapFree:/  { swap_free=$2 }
        END {
          if (type == "swap") {
            used=(swap_total-swap_free)/1024/1024
            total=swap_total/1024/1024
          } else {
            used=(mem_total-mem_free)/1024/1024
            total=mem_total/1024/1024
          }
          pct=0
          if (total > 0) { pct=used/total*100 }
          printf("%.1fG/%.1fG (%.f%%)\n", used, total, pct)
          printf("%.f%%\n", pct)
          if      (pct > 90) { print("#FF0000") }
          else if (pct > 80) { print("#FFAE00") }
          else if (pct > 70) { print("#FFF600") }
        }
        ' /proc/meminfo
      '';
    };

    ".config/i3blocks/volume.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
        MUTE=$(pactl get-sink-mute @DEFAULT_SINK@)

        if [ "$MUTE" = "Mute: yes" ]; then
            echo "MUTED"
            echo "MUTED"
            echo "#FF0000"
        else
            echo "VOL ''${VOLUME}%"
            echo "''${VOLUME}%"
            if [ "$VOLUME" -ge 70 ]; then
                echo "#ffffff"
            elif [ "$VOLUME" -ge 30 ]; then
                echo "#ffa252"
            else
                echo "#FF6600"
            fi
        fi
      '';
    };
  };
}
