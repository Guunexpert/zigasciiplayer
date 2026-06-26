# Zig ascii terminal

simple project to running ascii art on terminal with **Delta Timing** if using audio to prevent audio drift.

---

## Requirements & Dependencies

1. **Zig 0.14.1**
2. **FFmpeg**
3. **ASCII image converter CLI**
4. **Miniaudio C**

---

## Build from source

well if you want to make your own ASCII art follow this steps

### 1. Create Project Directory
Clone or create your own project directory and this is example for file structure
```text
your_own_project_folder/
├── build.zig
├── bad_apple.mp3             # bad apple mp3 (or your own mp3)
├── bad_apple_all.txt         # your final big ascii txt
└── src/
    ├── main.zig
    ├── miniaudio.c
    └── miniaudio.h
```

### 2. Generate Animated ASCII
if you want to make your own ASCII from any video 

1. Put your `any_video.mp4` inside your working folder or place anywhere (own folder)
2. Install the ASCII converter using Windows Terminal:
    ```bash
    winget install TheZoraiz.ascii-image-converter
    ```
3. Extract the video frames using FFmpeg (you can change the fps and canvas ratio/scale)
    ```bash
    mkdir temp_frames
    ffmpeg -i any_video.mp4 -vf "fps=15,scale=80:30" temp_frames/img_%04d.png
    ```
4. Create target text output folder
    ```bash
    mkdir txt_out
    ```
5. Converts all generated frames to text
    ```bash
    for %f in (temp_frames\*.png) do ascii-image-converter "%f" --save-txt txt_out
    ```
6. Combine all the text output too single big ASCII text with `SPLIT` flag to separated them
    ```bash
    for &f in (txt_out\*.txt) do (type "%f" >> name_your_text.txt & echo SPLIT >> name_your_text.txt)
    ```

---

## How to Run

Once your `name_your_text.txt` and `own_music.mp3` are done seated in your project folder time to run :3

```bash
# compile and play your own ASCII :)
zig build run
```
Press `CTRL+C` in your terminal to stop/kill process and exit

---