# 🚀 Space Ship Project (SSP)

A space shooter game built across multiple platforms and technologies, showcasing the same gameplay experience in JavaScript, Rust, and Playdate.


## 🎮 Play Now

| Version | Technology | Play Link |
|---------|-----------|-----------|
| JavaScript | Vanilla JS + Canvas | [**Play Now →**](https://ssp-js.joel.am) |
| Rust | Bevy Game Engine | [**Play Now →**](https://ssp-rust.joel.am) |
| PICO-8 | PICO-8 | [**Play Now →**](https://ssp-p8.joel.am) |
| Playdate | Playdate | *On-device only* |


## 📦 Versions

### 🌐 JavaScript

The original implementation using vanilla JavaScript and HTML5 Canvas with enemy AI, multiple weapons, and collision detection.

![JavaScript Version Demo](./gifs/js.gif)

**Tech:** Vanilla JavaScript • HTML5 Canvas • CSS3  
**Play online:** [https://ssp-js.joel.am](https://ssp-js.joel.am)


### ⚙️ Rust

Reimplementation using [Bevy](https://bevy.org/) game engine with ECS architecture, compiled to WebAssembly for browser deployment.

![Rust Version Demo](./gifs/rust.gif)

**Tech:** Rust • Bevy Game Engine • WebAssembly  
**Play online:** [https://ssp-rust.joel.am](https://ssp-rust.joel.am)


### 🕹️ PICO-8

Fantasy console version for [PICO-8](https://www.lexaloffle.com/pico-8.php) with retro 128×128 display, 16-color palette, and classic chiptune sound.

![Pico-8 Version Demo](./gifs/p8.gif)

**Tech:** Lua • PICO-8  
**Play online:** [https://ssp-p8.joel.am](https://ssp-p8.joel.am)


### 🎮 Playdate

Portable version for the [Playdate](https://play.date/) handheld console with 1-bit graphics, optimized for 400×240 display with crank and button controls.

![Playdate Version Demo](./gifs/playdate.gif)

**Tech:** Lua • Playdate SDK  
**Platform:** On-device only



## 🛠️ Development

Each version is contained in its own directory.

Refer to the README files in each directory for specific build and development instructions.

### Cloning the Repository

This repository uses [Git LFS](https://git-lfs.github.com/) for storing large media files (GIFs). To clone with all assets:

```bash
# Install Git LFS if you haven't already
brew install git-lfs  # macOS
# or: apt-get install git-lfs  # Linux
# or: download from https://git-lfs.github.com/

# Clone the repository
git clone https://github.com/Jcambass/ssp.git
cd ssp

# Ensure LFS files are pulled
git lfs pull
```

---
