These scripts are targeted at Ubuntu & tested on 16.04, 17.04, 17.10.

They automate the checkout/setup process for their respective project
so it's about as easy as just running the script and waiting.

The scripts should pull all necessary dependencies as well.

# Dependencies

```
sudo apt-get install subversion git wget build-essential
```
# Configuration
## Plex Media Player

The script has 3 defines of which only 1 ought to require tweaking potentially:

* `QT_ROOT="/opt/Qt5.9.1"`          (Point to a different root as needed)
* `QT_SUBPATH="/5.9.1/gcc_64"`      (Should match QT_ROOT)
* `PMP_ROOT="$HOME/git/pmp"`        (Point to a different root as needed)
* `CORE_COUNT="16"`                 (Adjust the `CORE_COUNT` param to suit your needs)

# Usage
## Checkout
### Git
* `mkdir git && cd git` (Optional)
* `git clone https://github.com/Enigma0/build-scripts.git`
### Subversion
* `mkdir svn && cd svn` (Optional)
* `svn checkout https://github.com/Enigma0/build-scripts.git/trunk/ build-scripts`

## Plex Media Player
* `cd build-scripts` (or `git`/`svn` subfolder)
* `./build_pmp.sh Release` (or use `Debug`)
