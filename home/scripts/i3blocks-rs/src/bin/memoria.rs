// src/bin/memoria.rs
// Bloque de memoria RAM para i3blocks

use sysinfo::System;

const COLOR_NORMAL:   &str = "#52aeff";
const COLOR_WARNING:  &str = "#FFF600";
const COLOR_HIGH:     &str = "#FFAE00";
const COLOR_CRITICAL: &str = "#FF0000";

fn color_for(percent: f64) -> &'static str {
    if percent > 90.0 {
        COLOR_CRITICAL
    } else if percent > 80.0 {
        COLOR_HIGH
    } else if percent > 70.0 {
        COLOR_WARNING
    } else {
        COLOR_NORMAL
    }
}

fn bytes_to_gb(bytes: u64) -> f64 {
    bytes as f64 / 1024.0 / 1024.0 / 1024.0
}

fn main() {
    let mut sys = System::new();
    sys.refresh_memory();

    let total = sys.total_memory();
    let used  = sys.used_memory();

    let total_gb  = bytes_to_gb(total);
    let used_gb   = bytes_to_gb(used);
    let percent   = if total > 0 {
        (used as f64 / total as f64) * 100.0
    } else {
        0.0
    };

    let color = color_for(percent);

    // Línea 1: texto completo
    println!("{:.1}G/{:.1}G ({:.0}%)", used_gb, total_gb, percent);
    // Línea 2: texto corto
    println!("{:.0}%", percent);
    // Línea 3: color
    println!("{}", color);
}
