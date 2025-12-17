# 🚀 Space Ship Project (SSP)

A space shooter game built across multiple platforms and technologies, showcasing the same gameplay experience in JavaScript, Rust, and Playdate.


## 🎮 Play Now

| Version | Technology | Play Link |
|---------|-----------|-----------|
| JavaScript | Vanilla JS + Canvas | [**Play Now →**](https://ssp-js.joel.am) |
| Rust | Bevy Game Engine | [**Play Now →**](https://ssp-rust.joel.am) |
| Playdate | Lua + Playdate SDK | *On-device only* |


## 📦 Project Versions

### 🌐 JavaScript Version

The original implementation built with vanilla JavaScript and HTML5 Canvas.

![JavaScript Version Demo](./gifs/js.gif)

**Features:**
- Pure JavaScript implementation
- Canvas-based rendering
- Responsive controls
- Enemy AI and spawning system
- Multiple weapon types
- Collision detection

**Play online:** [https://ssp-js.joel.am](https://ssp-js.joel.am)

**Tech Stack:**
- Vanilla JavaScript
- HTML5 Canvas API
- CSS3


### ⚙️ Rust Version

A high-performance reimplementation using the Bevy game engine, compiled to WebAssembly.

![Rust Version Demo](./gifs/rust.gif)

**Features:**
- Built with [Bevy](https://bevy.org/) game engine
- Entity Component System (ECS) architecture
- WebAssembly compilation for browser deployment
- Optimized rendering and physics
- Similar gameplay to JavaScript version

**Play online:** [https://ssp-rust.joel.am](https://ssp-rust.joel.am)

**Tech Stack:**
- Rust
- Bevy Game Engine
- WebAssembly (WASM)


### 🎮 Playdate Version

A portable version designed for the [Playdate](https://play.date/) handheld console.

![Playdate Version Demo](./gifs/playdate.gif)

**Features:**
- Optimized for Playdate's 400×240 1-bit display
- Crank and button controls
- Lua-based implementation
- Portable gaming experience
- Black and white aesthetic

**Tech Stack:**
- Lua
- Playdate SDK



## 🛠️ Development

Each version is contained in its own directory:

- `/javascript` - JavaScript/Canvas version
- `/rust` - Rust/Bevy version  
- `/playdate` - Playdate/Lua version

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
