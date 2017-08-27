These scripts are targeted at Ubuntu & tested on 16.04, 17.04, 17.10.

They automate the checkout/setup process for their respective project
so it's about as easy as just running the script and waiting.

The scripts should pull all necessary dependencies as well including Qt.

# Dependencies
```
sudo apt-get install subversion git wget build-essential
```
# Configuration
## Plex Media Player
The script has a few defines of which only 1 ought to require tweaking potentially:

*Only change if necessary:*
* `QT_ROOT="/opt/Qt5.9.1"`
* `QT_SUBPATH="/5.9.1/gcc_64"`
* `PMP_ROOT="$HOME/git/pmp"`

*Adjust the `CORE_COUNT` param to suit your needs:*
* `CORE_COUNT="16"`

# Usage
## Checkout
### Git
* `mkdir git && cd git` (Optional)
* `git clone https://github.com/Enigma0/build-scripts.git`
### Subversion
* `mkdir svn && cd svn` (Optional)
* `svn checkout https://github.com/Enigma0/build-scripts.git/trunk/ build-scripts`

## Building
## Plex Media Player
* `cd build-scripts` (or `git`/`svn` subfolder)
* `./build_pmp.sh Release` (or use `Debug`)

# Customization
## Plex Media Player
`plexmediaplayer.desktop` is copied into `/usr/share/applications/` with icons located at `/usr/share/icons/`

Choose from 3 bundled icons or use your own:
* Plex.png
* Plex_square.png
* Plex_shadow.png
