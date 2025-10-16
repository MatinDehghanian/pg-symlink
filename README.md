# pg-symlink — Shortcut “pg” for pasarguard

A small utility that lets users run:

```bash
pg restart
```
Instead of:

```bash
pasarguard restart
```

You can install it directly via Bash (no cloning needed) — ideal for simple, fast user installation.

---

## 🚀 Installation (Option: Bash / curl)
Run this single command in the terminal:

```bash
bash <(curl -s https://raw.githubusercontent.com/MatinDehghanian/pg-symlink/main/setup_pg_shortcut.sh)
```

### What does it do?
- Downloads the `setup_pg_shortcut.sh` script from GitHub.
- Pipes it into bash for execution.
- Prompts the user to choose:
	- **User alias** (no sudo, alias added to `~/.bashrc` or `~/.zshrc`)
	- **System-wide symlink** (requires sudo, creates `/usr/local/bin/pg`)

---

## ✅ After installation
If alias mode: run

```bash
source ~/.bashrc
# or
source ~/.zshrc
```
So the alias becomes active in the current shell.

Then you can run commands like:

```bash
pg restart
pg status
```

---

## ⚙️ Uninstall
If alias mode was used:

```bash
sed -i '/alias pg=/d' ~/.bashrc 2>/dev/null
sed -i '/alias pg=/d' ~/.zshrc 2>/dev/null
```

If symlink mode was used:

```bash
sudo rm -f /usr/local/bin/pg
```

---

## 🧠 Notes & Caveats
- Must have `pasarguard` installed and in your PATH before running the installer.
- The installer script uses `#!/usr/bin/env bash`, so it requires bash to be installed.
- This method is less transparent than cloning — users won’t see script contents unless you provide them (but they can inspect via GitHub).
- Use HTTPS link and `curl -s` (silent) to reduce noise. But check your script often for security if remote-running becomes a habit.

---

## 📂 Example

```bash
$ bash <(curl -s https://raw.githubusercontent.com/MatinDehghanian/pg-symlink/main/setup_pg_shortcut.sh)
🔍 Checking for 'pasarguard' command...
✅ Found pasarguard at: /usr/local/bin/pasarguard

How do you want to install the shortcut?
1) User-only alias  (fast, no sudo)
2) System-wide symlink (sudo required, works for all users)
Enter choice [1 or 2]: 2

⚙️  Creating system-wide symlink at /usr/local/bin/pg...
✅ Symlink created successfully.

Now you can use: pg restart
```

---

## 📝 Author & License
Matin Dehghanian  
MIT License
Feel free to fork, adapt, improve.