// src/bin/cpu.rs
// Bloque de CPU para i3blocks
// Formato de salida i3blocks:
//   línea 1: texto completo (con pango markup)
//   línea 2: texto corto
//   línea 3: color hex

use std::thread;
use std::time::Duration;
use sysinfo::System;

const COLOR_NORMAL:   &str = "#dfd932";
const COLOR_WARNING:  &str = "#FFA500";
const COLOR_CRITICAL: &str = "#FF7373";

const WARN_PERCENT: f32 = 50.0;
const CRIT_PERCENT: f32 = 80.0;

fn color_for(percent: f32) -> &'static str {
    if percent > CRIT_PERCENT {
        COLOR_CRITICAL
    } else if percent > WARN_PERCENT {
        COLOR_WARNING
    } else {
        COLOR_NORMAL
    }
}

fn main() {
    let mut sys = System::new();
    loop {
        sys.refresh_cpu_all();
        let usage = sys.global_cpu_usage();
        let color = color_for(usage);

        // Solo una línea por ciclo para interval=persist
        println!("<span color='{}'>{:.0}%</span>", color, usage);

        thread::sleep(sysinfo::MINIMUM_CPU_UPDATE_INTERVAL);
    }
}
