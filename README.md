# 🎮 Mario Tiles - Assembly Piano Game

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Assembly](https://img.shields.io/badge/Language-AVR%20Assembly-blue.svg)](https://www.microchip.com/)
[![Platform](https://img.shields.io/badge/Platform-ATmega328P-red.svg)](https://www.arduino.cc/)

> Rhythm-based piano game coded in pure AVR Assembly for ATmega328P microcontroller, featuring the Super Mario Bros. theme song.

---

## 🎯 Overview

**Mario Tiles** is an embedded rhythm game inspired by Piano Tiles, developed entirely in AVR Assembly. The game challenges players to press the correct keys displayed on an LED matrix screen in time with the Super Mario Bros. theme music.

### Game Modes

**🆓 Free Mode**  
Practice piano keys at your own pace. Each keypad button plays a musical note (C5-E6 range).

**🏆 Level Mode**  
Time-attack mode: press the displayed key within **3 seconds** or lose. Includes scoring system and high score persistence via EEPROM.

---

## 🛠️ Hardware Requirements

| Component | Description | Connection |
|-----------|-------------|------------|
| **Microcontroller** | ATmega328P (Arduino Uno) | - |
| **LED Matrix** | 8×16 display with shift registers | PB3-5 (Data/Latch/Clock) |
| **4×4 Keypad** | Matrix keypad | PD0-7 (Rows/Columns) |
| **Joystick** | Analog 2-axis + button | AD0 (Y-axis), PB2 (Button) |
| **Buzzer** | Piezo buzzer | PB1 (PWM) |
| **Switch** | SPST toggle | PB0 |
| **Status LEDs** | Visual indicators | PC2-3 |

**Schematic:** [`docs/board_schematic.png`](docs/board_schematic.png)

---

## 📌 Pin Configuration
```assembly
; ===== PORT B =====
; PB0 - Switch (Power control)
; PB1 - Buzzer (Timer0 PWM)
; PB2 - Joystick button (PCINT2)
; PB3 - LED Matrix Data
; PB4 - LED Matrix Latch
; PB5 - LED Matrix Clock

; ===== PORT C =====
; PC0 - Joystick X-axis (ADC0)
; PC1 - Joystick Y-axis (ADC1) 
; PC2 - Upper LED indicator
; PC3 - Lower LED indicator

; ===== PORT D =====
; PD0-PD3 - Keypad rows
; PD4-PD7 - Keypad columns
```

---

## 🚀 Installation

### Prerequisites
- **Microchip Studio** (formerly Atmel Studio) 7.0+
- **AVR toolchain** (avr-gcc, avrdude)
- USB cable for Arduino Uno

### Build & Upload

#### Option 1: Microchip Studio
1. Open `src/mario_tiles.asm` in Microchip Studio
2. Build → Build Solution (F7)
3. Upload via built-in programmer

#### Option 2: Command Line
```bash
# Clone repository
git clone https://github.com/GlodiSala/mario-tiles-asm.git
cd mario-tiles-asm

# Assemble
avr-as -mmcu=atmega328p -o mario_tiles.o src/mario_tiles.asm

# Link
avr-ld -o mario_tiles.elf mario_tiles.o

# Generate HEX
avr-objcopy -O ihex mario_tiles.elf mario_tiles.hex

# Upload to Arduino (replace COM3 with your port)
avrdude -c arduino -p m328p -P COM3 -b 115200 -U flash:w:mario_tiles.hex:i
```

---

## 🎮 How to Play

### Starting the Game
1. Set switch (PB0) to **HIGH**
2. Menu appears on LED matrix:
```
   FREE   →
   LEVEL
```

### Navigation
- **Joystick UP/DOWN**: Move cursor
- **Joystick PRESS**: Select mode / Exit to menu

### Free Mode
Press any key on the 4×4 keypad to play musical notes.

**Keypad Layout:**
```
[7=C5 ] [8=C#5] [9=D5 ] [F=D#5]
[4=E5 ] [5=F5 ] [6=F#5] [E=G5 ]
[1=G#5] [2=A5 ] [3=A#5] [D=B5 ]
[A=C6 ] [0=C#6] [B=D6 ] [C=E6 ]
```

### Level Mode
- A key character appears on screen (e.g., **"7"**)
- Press the matching key within **3 seconds**
- **Success**: +1 point, Mario theme plays, next key
- **Failure**: Game Over screen + final score

---

## 🔬 Technical Details

### Memory Map
```assembly
; SRAM Screen Buffer (0x0100-0x0115)
0x0100-0x0115: 16 character blocks for LED matrix

; EEPROM (0x0000)
0x0000: High score (persistent)
```

### Interrupt Service Routines

| ISR | Vector | Trigger | Purpose |
|-----|--------|---------|---------|
| **SW_ISR** | 0x0006 | PCINT0 (PB0/PB2) | Switch state / Joystick press |
| **ADC_ISR** | 0x002A | ADC Complete | Joystick position detection |
| **Timer0_ISR** | 0x0020 | Timer0 OVF | Buzzer PWM generation |
| **Timer2_ISR** | 0x0012 | Timer2 OVF | 100ms timing system |

### Audio Synthesis
```assembly
; Note frequency formula (Timer0 Fast PWM):
OCR0A = 0xFF - (62500 / frequency_Hz)

; Example: A4 (440 Hz)
.equ A4 = (0xFF - (62500 / 440)) ; = 113

; Supported range: C4 (261 Hz) to C7 (2093 Hz)
```

### Keypad Scanning Algorithm
```assembly
CHECK_KEYBOARD macro:
    Step1: 
        ; Set PD0-3 LOW (outputs), PD4-7 HIGH (inputs w/ pull-up)
        OUT DDRD, 0b11110000
        OUT PORTD, 0b00001111
        IN R1, PIND  ; Read columns
    
    Step2:
        ; Swap: PD4-7 outputs, PD0-3 inputs
        OUT DDRD, 0b00001111
        OUT PORTD, 0b11110000
        IN R2, PIND  ; Read rows
    
    ; XOR results → unique pattern per key
    EOR R2, R1
```

---

## 📁 Project Structure
```
mario-tiles-asm/
├── src/
│   └── mario_tiles.asm          # Main game code (~1400 lines)
├── docs/
│   ├── project_report.pdf       # Technical report
│   └── board_schematic.png      # Hardware diagram
├── include/
│   └── m328pdef.inc             # ATmega328P register definitions
├── README.md
├── LICENSE
└── .gitignore
```

---

## ✨ Features

✅ Two game modes (Free/Level)  
✅ Full Super Mario Bros. theme encoded in note tables  
✅ EEPROM high score persistence  
✅ Real-time keyboard scanning (2-step matrix algorithm)  
✅ 8×16 LED matrix rendering (multiplexed @60Hz)  
✅ Joystick navigation with ADC  
✅ PWM buzzer audio (16 musical notes)  
✅ 3-second countdown timer for challenges  

---

## 👥 Authors

**Jian HUO** · **Glodi SALA MANGITUKA**

*Electrical Engineering Students*  
ULB (Université Libre de Bruxelles) / VUB (Vrije Universiteit Brussel)

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---

## 🔗 Resources

- [ATmega328P Datasheet](https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf)
- [AVR Instruction Set Manual](https://ww1.microchip.com/downloads/en/devicedoc/atmel-0856-avr-instruction-set-manual.pdf)
- [Full Project Report](docs/project_report.pdf)

---

<div align="center">

**🎮 Made with Assembly & Passion 🎮**


</div>
