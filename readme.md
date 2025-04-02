# Handy PS1 Scripts

This repository contains PowerShell scripts for video compression and audio merging.

## Scripts

### compressAllVidFiles.ps1

This script compresses all MP4 video files in the current directory using `ffmpeg` with NVIDIA hardware acceleration. The compressed files are stored in a subfolder named `compressed`.

- **Input:** MP4 files in the current folder.
- **Output:** Compressed MKV files in the `compressed` folder.
- **Prerequisites:** [ffmpeg](https://ffmpeg.org/) should be installed and added to your system's PATH.

### MergeAudio.ps1

This script merges matching pairs of vocal and instrumental WAV files. It processes files based on specified naming conventions, applies volume adjustments, and then mixes the audio tracks using `ffmpeg`, outputting an OPUS file.

- **Input:** WAV files with names following the pattern (e.g., `1_s01e01_(Vocals).wav` and `1_s01e01_(Instrumental).wav`).
- **Output:** Merged OPUS audio file (e.g., `s01e01.opus`).
- **Prerequisites:** [ffmpeg](https://ffmpeg.org/) must be installed and accessible.

## Getting Started

1. Clone the repository:
   ```sh
   git clone <repository-url>
   ```
2. Change to the repository directory:
   ```sh
   cd <repository-directory>
   ```
3. Open the project in Visual Studio Code:
   ```sh
   code .
   ```

## Usage

- **Compress Video Files:**

  Open a PowerShell terminal at the project directory and run:
  ```ps1
  .\compressAllVidFiles.ps1
  ```

- **Merge Audio Files:**

  Open a PowerShell terminal at the project directory and run:
  ```ps1
  .\MergeAudio.ps1
  ```

Ensure that your input files are in the correct format and follow the required naming conventions.

## License

This project is provided as-is. Feel free to modify and distribute.
