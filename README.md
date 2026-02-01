# FranKIMstein BASIC

Commodore BASIC for FranKIMstein — a Commodore 1541 disk drive converted into a standalone computer.

## What is this?

This is a port of Commodore BASIC to run on a modified 1541 disk drive. Combined with the [FranKIMstein Kernal](https://github.com/commodoreihs/FranKIMstein_kernal), it provides:

- Full Commodore BASIC interpreter
- Disk operations: `LOAD`, `SAVE`, `FMT` (format)
- RS-232 serial terminal I/O
- 255 bytes of program space
- Programs save as standard Commodore PRG files

## Hardware Requirements

- Commodore 1541 disk drive
- FranKIMstein hardware modification (RS-232 interface via VIA1)
- FranKIMstein Kernal ROM at $E000-$FFFF
- This BASIC ROM at $C000-$DFFF

## Building

Requires [64tass](https://sourceforge.net/projects/tass64/) assembler.

```bash
64tass -b build.asm -o basic_c000.bin -L basic_c000.lst
```

This produces an 8KB ROM image for $C000-$DFFF.

## Memory Map

```
Zero Page:
  $00-$47   Disk controller variables
  $48-$5F   CHRGET routine (self-modifying code)
  $60-$7F   DOS variables
  $80-$F3   BASIC interpreter variables
  $F4-$FF   KIM-1 style monitor variables

RAM:
  $0100-$01FF  6502 Stack
  $0200-$02FF  Input buffer / GCR overflow
  $0300-$03FF  Disk buffer 0 (sector I/O)
  $0400        Zero byte before TXTTAB
  $0401-$04FF  BASIC program area (255 bytes)
  $0500-$05FF  Disk buffer 2 (FORMAT only)
  $0600-$065F  Disk variables
  $0660-$066B  BASIC vectors
  $0700-$07FF  BAM work area

ROM:
  $C000-$DFFF  BASIC ROM (this project)
  $E000-$FFFF  FranKIMstein Kernal
```

## BASIC Commands

### Disk Commands

| Command | Description | Example |
|---------|-------------|---------|
| `FMT` | Format a disk | `FMT"DISKNAME,ID"` |
| `SAVE` | Save program to disk | `SAVE"FILENAME"` |
| `LOAD` | Load program from disk | `LOAD"FILENAME"` |

### Supported BASIC Statements

Most Commodore BASIC 2.0 statements are supported including:

`END`, `FOR`, `NEXT`, `DATA`, `INPUT#`, `INPUT`, `DIM`, `READ`, `LET`, `GOTO`, `RUN`, `IF`, `RESTORE`, `GOSUB`, `RETURN`, `REM`, `STOP`, `ON`, `WAIT`, `DEF`, `POKE`, `PRINT#`, `PRINT`, `CONT`, `LIST`, `CLR`, `CMD`, `SYS`, `OPEN`, `CLOSE`, `GET`, `NEW`

### Supported BASIC Functions

`SGN`, `INT`, `ABS`, `USR`, `FRE`, `POS`, `RND`, `PEEK`, `LEN`, `STR$`, `VAL`, `ASC`, `CHR$`, `LEFT$`, `RIGHT$`, `MID$`, `TAB`, `SPC`

### Not Supported

The following require ROM space that isn't available:
- `SQR`, `LOG`, `EXP`, `COS`, `SIN`, `TAN`, `ATN` (transcendental functions)
- `VERIFY` (no verify mode for LOAD)

## Kernal Dependencies

This BASIC ROM requires FranKIMstein Kernal with these entry points:

| Entry Point | Address | Function |
|-------------|---------|----------|
| `GETCH` | $E177 | Get character from terminal |
| `OUTCH` | $E198 | Output character to terminal |
| `CRLF` | $E1F8 | Output CR/LF |
| `PRTBYT` | $E20B | Print byte as hex |
| `BSAVE` | $F7F3 | Save file to disk |
| `BLOAD` | $F809 | Load file from disk |
| `BFORMAT` | $F81F | Format disk |

**Important:** If you modify the kernal, these addresses may change. Update `declare.asm` accordingly.

## Files

| File | Description |
|------|-------------|
| `build.asm` | Main build file — includes all others |
| `declare.asm` | Constants, zero page, and RAM declarations |
| `init.asm` | Cold/warm start, CHRGET template |
| `diskio.asm` | LOAD, SAVE, FMT command implementations |
| `tokens.asm` | Token tables and statement dispatch |
| `token2.asm` | Keyword tokenization |
| `kernal_stubs.asm` | Kernal interface stubs |
| `code1.asm` - `code25.asm` | BASIC interpreter (from various MS BASIC sources) |
| `trig.asm` | Stub for removed trig functions |

## License

This is a derivative work of Commodore BASIC. For educational and hobbyist use.

## See Also

- [FranKIMstein Kernal](https://github.com/commodoreihs/FranKIMstein_kernal) — Required companion ROM
- [Original FranKIMstein Video](https://www.youtube.com/watch?v=6loDwvG4CP8) — Hardware build and KIM-1 monitor demo
