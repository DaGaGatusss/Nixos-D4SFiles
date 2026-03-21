// src/bin/bateria.rs
// Bloque de batería para i3blocks
// Usa la crate `battery` para leer estado real de la batería

use battery::{Manager, State};

fn color_for(percent: f32) -> &'static str {
    if percent < 10.0 { "#FFFFFF" }
    else if percent < 20.0 { "#FF3300" }
    else if percent < 30.0 { "#FF6600" }
    else if percent < 40.0 { "#FF9900" }
    else if percent < 50.0 { "#FFCC00" }
    else if percent < 60.0 { "#FFFF00" }
    else if percent < 70.0 { "#FFFF33" }
    else if percent < 80.0 { "#FFFF66" }
    else { "#FFFFFF" }
}

fn format_time(seconds: f32) -> String {
    let total_mins = (seconds / 60.0) as u32;
    let hours = total_mins / 60;
    let mins  = total_mins % 60;
    format!("{}:{:02}", hours, mins)
}

fn main() {
    let manager = match Manager::new() {
        Ok(m) => m,
        Err(_) => {
            println!("Sin batería");
            println!("N/A");
            println!("#FF0000");
            return;
        }
    };

    let mut batteries = match manager.batteries() {
        Ok(b) => b,
        Err(_) => {
            println!("Error leyendo batería");
            println!("ERR");
            println!("#FF0000");
            return;
        }
    };

    let battery = match batteries.next() {
        Some(Ok(b)) => b,
        _ => {
            println!("Sin batería");
            println!("N/A");
            println!("#FF0000");
            return;
        }
    };

    let percent   = battery.state_of_charge().value * 100.0;
    let state     = battery.state();
    let color     = color_for(percent);

    let estado_icon = match state {
        State::Charging    => "⚡ ",
        State::Discharging => "",
        State::Full        => "🔌 ",
        State::Unknown     => "? ",
        _                  => "",
    };

    let tiempo = match state {
        State::Discharging => {
            battery.time_to_empty()
                .map(|t| format!(" ({})", format_time(t.value)))
                .unwrap_or_default()
        }
        State::Charging => {
            battery.time_to_full()
                .map(|t| format!(" ({})", format_time(t.value)))
                .unwrap_or_default()
        }
        _ => String::new(),
    };

    // Línea 1: texto completo con pango markup
    println!(
        "{}<span color='{}'>{:.0}%</span>{}",
        estado_icon, color, percent, tiempo
    );
    // Línea 2: texto corto
    println!("{}{:.0}%", estado_icon, percent);
    // Línea 3: color
    println!("{}", color);

    // Exit code 33 = fondo rojo en i3blocks (batería crítica)
    if percent < 10.0 {
        std::process::exit(33);
    } 
}
