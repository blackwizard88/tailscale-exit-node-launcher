# Tailscale Exit Node Launcher

A small graphical Linux launcher for quickly selecting, changing, or disabling a Tailscale exit node.

**Languages:** [English](#english) | [Magyar](#magyar)

> [!NOTE]
> This is an independent community project. It is not affiliated with, maintained by, or endorsed by Tailscale Inc.

---

# English

## What it does

Tailscale Exit Node Launcher provides a simple Zenity-based graphical interface for switching between the exit nodes currently available to your Tailscale client.

The launcher:

- discovers available Tailscale exit nodes automatically
- shows the currently selected exit node
- lets you select another exit node from a graphical list
- lets you disable exit-node routing
- uses your existing Tailscale installation and configuration
- installs a launcher entry into the Linux application menu
- does not assume a particular Linux distribution

The project does **not** install or configure Tailscale itself.

## Requirements

You need:

- Linux
- Tailscale installed and connected to a tailnet
- Bash
- Zenity
- Python 3
- `pkexec` / Polkit if changing the exit node requires elevated privileges

The installer checks for the required commands and reports missing dependencies rather than assuming a specific package manager.

Examples for installing Zenity:

**Fedora / Nobara**
```bash
sudo dnf install zenity
```

**Debian / Ubuntu / Linux Mint**
```bash
sudo apt install zenity
```

**Arch Linux**
```bash
sudo pacman -S zenity
```

**openSUSE**
```bash
sudo zypper install zenity
```

Package names and availability can vary by distribution.

## Installation

Download or clone the repository, open a terminal in the project directory, then run:

```bash
chmod +x install.sh
./install.sh
```

The installer places the application files in your user account and creates an application-menu entry. System-wide installation is not required.

After installation, look for **Tailscale Exit Node Launcher** in your desktop environment's application menu.

## Usage

Start **Tailscale Exit Node Launcher** from the application menu.

The launcher reads the current Tailscale status, discovers exit nodes available to your client, and presents them in a graphical selection window.

Choose an exit node to route traffic through it, or choose the option to disable the currently selected exit node.

If your Tailscale configuration permits the operation as your normal user, no privilege prompt is needed. If necessary, the launcher can fall back to Polkit/`pkexec`.

## Uninstallation

From the project directory:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

This removes the files installed by this project from your user account. It does **not** uninstall Tailscale or modify your tailnet configuration.

## Project files

```text
tailscale-exit-node-launcher/
├── install.sh
├── uninstall.sh
├── tailscale-exit-node.sh
├── tailscale-exit-node.desktop.in
└── README.md
```

## Troubleshooting

### No exit nodes are shown

Check that Tailscale is running and that your client can see at least one device advertising itself as an exit node.

You can inspect the current state with:

```bash
tailscale status
```

### Zenity is missing

Install the `zenity` package using your distribution's package manager, then run the installer again.

### Permission prompt appears

Depending on your Tailscale setup and system permissions, changing the exit node may require authorization through Polkit. This is expected when the operation is not permitted directly for the current user.

### The launcher does not appear in the application menu

Log out and back in, or restart your desktop shell/application menu. The installer creates the desktop entry in the standard per-user applications directory.

## Privacy and security

The launcher works with the local Tailscale client. It does not require a separate account, API key, or cloud service of its own.

Review shell scripts before running them if you downloaded the project from an untrusted mirror or modified source.

## License

Licensed under the [MIT License](LICENSE).

Tailscale is a trademark of Tailscale Inc. This project is independent and is not affiliated with or endorsed by Tailscale Inc.

---

# Magyar

## Mire való?

A Tailscale Exit Node Launcher egy egyszerű, Zenity-alapú grafikus Linux launcher, amellyel gyorsan válthatsz a Tailscale kliensed számára elérhető exit node-ok között.

A launcher:

- automatikusan megkeresi az elérhető Tailscale exit node-okat
- megmutatja a jelenleg kiválasztott exit node-ot
- grafikus listából enged másik exit node-ot választani
- lehetővé teszi az exit node használatának kikapcsolását
- a már meglévő Tailscale telepítésedet és beállításaidat használja
- bejegyzést készít a Linux alkalmazásmenüjébe
- nem feltételez konkrét Linux-disztribúciót

A projekt magát a **Tailscale-t nem telepíti és nem konfigurálja**.

## Követelmények

Szükséges:

- Linux
- telepített és egy tailnethez csatlakoztatott Tailscale
- Bash
- Zenity
- Python 3
- `pkexec` / Polkit, ha az exit node módosításához emelt jogosultság szükséges

A telepítő ellenőrzi a szükséges parancsokat. Ha valamelyik hiányzik, jelzi azt ahelyett, hogy egy konkrét csomagkezelőt feltételezne.

Példák a Zenity telepítésére:

**Fedora / Nobara**
```bash
sudo dnf install zenity
```

**Debian / Ubuntu / Linux Mint**
```bash
sudo apt install zenity
```

**Arch Linux**
```bash
sudo pacman -S zenity
```

**openSUSE**
```bash
sudo zypper install zenity
```

A csomagnevek és az elérhetőség disztribúciónként eltérhetnek.

## Telepítés

Töltsd le vagy klónozd a repositoryt, nyiss terminált a projekt könyvtárában, majd futtasd:

```bash
chmod +x install.sh
./install.sh
```

A telepítő a saját felhasználói fiókod alá helyezi az alkalmazás fájljait, és létrehozza az alkalmazásmenü-bejegyzést. Rendszerszintű telepítésre nincs szükség.

Telepítés után keresd a **Tailscale Exit Node Launcher** alkalmazást az asztali környezeted alkalmazásmenüjében.

## Használat

Indítsd el a **Tailscale Exit Node Launcher** alkalmazást az alkalmazásmenüből.

A launcher lekéri a Tailscale aktuális állapotát, megkeresi a kliensed számára elérhető exit node-okat, majd grafikus választóablakban megjeleníti őket.

Válassz egy exit node-ot a rajta keresztüli forgalomirányításhoz, vagy válaszd az exit node kikapcsolását.

Ha a Tailscale beállításaid lehetővé teszik a műveletet normál felhasználóként, nincs szükség jogosultságkérésre. Ha szükséges, a launcher Polkit/`pkexec` segítségével kérhet engedélyt.

## Eltávolítás

A projekt könyvtárából:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Ez eltávolítja a projekt által a felhasználói fiókodba telepített fájlokat. A **Tailscale-t nem távolítja el**, és a tailneted konfigurációját sem törli.

## A projekt fájljai

```text
tailscale-exit-node-launcher/
├── install.sh
├── uninstall.sh
├── tailscale-exit-node.sh
├── tailscale-exit-node.desktop.in
└── README.md
```

## Hibaelhárítás

### Nem jelenik meg egyetlen exit node sem

Ellenőrizd, hogy a Tailscale fut-e, és a kliensed lát-e legalább egy exit node-ként meghirdetett eszközt.

Az aktuális állapotot például így nézheted meg:

```bash
tailscale status
```

### Hiányzik a Zenity

Telepítsd a `zenity` csomagot a disztribúciód csomagkezelőjével, majd futtasd újra a telepítőt.

### Jogosultságkérő ablak jelenik meg

A Tailscale és a rendszer jogosultsági beállításaitól függően az exit node megváltoztatásához Polkit-hitelesítésre lehet szükség. Ez normális, ha a műveletet a jelenlegi felhasználó közvetlenül nem hajthatja végre.

### Nem jelenik meg a launcher az alkalmazásmenüben

Jelentkezz ki és vissza, vagy indítsd újra az asztali környezet alkalmazásmenüjét. A telepítő a szabványos felhasználói alkalmazáskönyvtárban hozza létre a desktop bejegyzést.

## Adatvédelem és biztonság

A launcher a helyi Tailscale klienssel dolgozik. Nem igényel külön fiókot, API-kulcsot vagy saját felhőszolgáltatást.

Ha nem megbízható tükörről vagy módosított forrásból töltötted le a projektet, futtatás előtt érdemes átnézni a shell scripteket.

## Licenc

A projekt az [MIT License](LICENSE) feltételei szerint használható.

A Tailscale a Tailscale Inc. védjegye. Ez egy független közösségi projekt, amely nem áll kapcsolatban a Tailscale Inc.-kel, és a Tailscale Inc. nem támogatja vagy hagyta jóvá.
