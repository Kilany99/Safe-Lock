
# 🔐 8086 Microprocessor-Based Safe Lock System

A digital safe lock system implemented using an Intel 8086 Microprocessor, a 4x4 matrix keypad for input, and a 16x2 LCD for displaying status and feedback. This project demonstrates fundamental principles of embedded systems, assembly programming, and peripheral interfacing using the 8255 Programmable Peripheral Interface (PPI).

-----

## ✨ Features

  * **4-Digit Password Security:** Users enter a 4-digit numeric password for access control.
  * **Interactive Keypad Input:** Utilizes a common 4x4 matrix keypad for user input.
  * **LCD Display Interface:** Provides clear visual feedback on a 16x2 LCD, displaying prompts like "PASSWORD", "WRONG :(", "Correct :)", "New Password", and "Done".
  * **Configurable Password:** The default password can be easily set within the assembly code's memory initializations.
  * **Limited Access Attempts:** Implements a security measure allowing a limited number of incorrect password attempts (3 tries) before locking out.
  * **Password Change/Reset:** After successful authentication, the system offers functionality to reset or change the current password.
  * **Visual Feedback:** Asterisks (`*`) are displayed for entered password digits, and specific messages indicate correct or incorrect attempts.
  * **"Appear" Feature:** A special key allows temporarily showing the entered password characters for verification.
  * **"Delete" (Backspace) Feature:** Allows correcting entered digits before confirmation.
  * **"Exit" & "Reset" Functions:** Special keys for resetting the system state or initiating a password change.
  * **Door Lock Control (Implied):** The system is designed to provide an output signal (e.g., to a relay) upon correct password entry, simulating the unlocking of a safe or door.
  * **Pure 8086 Assembly:** The entire system logic is implemented in low-level 8086 assembly language, offering deep insights into microprocessor programming.
  * **8255 PPI Interfacing:** Leverages the 8255 PPI chip to manage communication with both the keypad (input) and the LCD (output).

-----

## ⚙️ Hardware Components

  * **Intel 8086 Microprocessor:** The core processing unit.
  * **8255 Programmable Peripheral Interface (PPI):** Configured for mode 0, facilitating I/O operations with the keypad and LCD.
      * Port A: Likely used for LCD data lines.
      * Port B: Likely used for LCD control signals (RS, E) and possibly the lock output.
      * Port C: Used for keypad row and column scanning.
  * **4x4 Matrix Keypad:** For numeric input from 0-9 and control keys.
  * **16x2 LCD Display (HD44780 compatible):** For displaying user interface and system status.
  * **Power Supply:** Appropriate power supply for the components.
  * **(Optional) Door Lock Mechanism/Relay:** To demonstrate the physical locking/unlocking action.

-----

## 💻 Software & Development Environment

  * **Assembler:** Any 8086-compatible assembler (e.g., MASM - Microsoft Macro Assembler, NASM).
  * **Emulator/Simulator:** An 8086 emulator (e.g., EMU8086, DOSBox with a suitable environment) is highly recommended for testing and simulation.
  * **Text Editor:** For writing the assembly code.

-----

## 📖 Code Overview

The project's core logic is contained within a single assembly file, structured with clear procedures for various functionalities.

### Key Definitions

  * `PORTA EQU 00H`, `PORTB EQU 02H`, `PORTC EQU 04H`, `CONTROL_REG EQU 06H`: I/O port addresses for the 8255 PPI.

### Default Password

  * The initial password is hardcoded in memory locations `0004H` to `0007H` (e.g., `1111`).

### Registers Usage

  * `DI`: Used to refer to the row of the keypad during scanning.
  * `SI`: Tracks the number of digits currently entered in the password.
  * `BX`: Stores the remaining number of password entry attempts.
  * `DX`: Acts as a flag to indicate the validity/status of the entered password or system state.

### Main Procedures

  * **`RESTART`:** Main loop for continuously scanning the keypad and processing input.
  * **`CHECK`:** Procedure for decoding keypad input, identifying the pressed key, and routing to the appropriate handling logic.
  * **`DELAY`:** Utility procedure for creating time delays.
  * **`HALT`:** Procedure to wait for a key to be released.
  * **`PRINTCHAR`:** Displays a single character on the LCD.
  * **`ENABLEOFDATA`, `ENABLEOFCOMMAND`:** Procedures for controlling the LCD's data and command enable signals.
  * **`SAVEPASSWORD`:** Stores the entered password digits into sequential memory locations.
  * **`CLEARLCD`:** Clears the LCD display.
  * **`PRINTPASSWORD`, `PRINTWRONGPASSWORD`, `PRINTTRUEPASSWORD`, `PRINTDONE`, `PRINTNEWPASSWORD`:** Procedures for displaying specific messages on the LCD.
  * **`ERRORPROC`:** Handles the system lockout state after too many failed attempts.

-----

## 🚀 How It Works (Simplified Logic Flow)

1.  **Initialization:** The 8255 PPI is configured, and the LCD is initialized for 8-bit, 2-line mode with cursor on.
2.  **Password Prompt:** The LCD displays `* PASSWORD *`.
3.  **Keypad Scanning:** The system continuously scans the 4x4 keypad by cycling through rows and reading columns.
4.  **Input Processing:** When a key press is detected:
      * Digits (`0-9`): Are saved to memory, and an asterisk (`*`) is displayed on the LCD for each digit.
      * `Confirm` Key: Checks the entered 4-digit password against the stored password.
          * If correct: Displays `Correct :)`, activates the lock output, and enters an access-granted state.
          * If incorrect: Decrements the attempt counter, displays `Wrong :( [tries remaining]`, and prompts for re-entry.
      * `Delete` Key: Acts as a backspace, erasing the last entered asterisk.
      * `Appear` Key: Temporarily reveals the entered password digits on the LCD.
      * `Exit` Key: If access is granted, resets the system to the initial password entry state.
      * `Reset` Key: If access is granted, allows the user to set a new 4-digit password.
5.  **Error State:** If the user exhausts all password attempts, the system enters an error state, displaying `More 3 try :(`, and freezes.

-----

## ⚙️ Assembly and Simulation

To assemble and run this project:

1.  **Save the Code:** Save the provided assembly code as an `.asm` file (e.g., `safe_lock.asm`).
2.  **Assemble:** Use an 8086 assembler (like MASM) to assemble the code:
    ```bash
    MASM safe_lock.asm
    ```
    This will generate an `.obj` file.
3.  **Link (if necessary):** Depending on your assembler and setup, you might need to link the object file:
    ```bash
    LINK safe_lock.obj
    ```
    This will create an executable (`.exe` or `.com` file).
4.  **Run in Emulator:** Load the executable into your preferred 8086 emulator (e.g., EMU8086) and configure the necessary I/O ports and peripherals (LCD, Keypad, PPI) as per the code's logic.

-----

## 🤝 Contribution

This project is for educational purposes, demonstrating a basic embedded system design. Feel free to fork the repository and experiment with modifications or improvements\!

-----

## 📄 License

This project is open-source and available under the [MIT License](https://www.google.com/search?q=LICENSE).

