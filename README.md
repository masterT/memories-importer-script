# Memories Importer Script

Simple `bash` script to import media using [elodie](https://github.com/jmathai/elodie).

Usage:

```
import.sh SOURCE DESTINATION
```

Environment variables:

|Name|Description|Default|
|----|-----------|-------|
|`ELODIE`|The path to the `elodie` script.|`elodie`|
|`ELODIE_APPLICATION_DIRECTORY`|The path to the `elodie` application that hold the `config.ini` configuration file and the database.|`~/.elodie/config.ini`|

## Example

```
$ ls -A1 /mnt/data/memories/import
hackerman.png
```

```
$ import.sh /mnt/data/memories/import /mnt/data/memories/library
Import 2021-09-15T12-40-34
mkdir: created directory '/mnt/data/memories/import/imports'
mkdir: created directory '/mnt/data/memories/import/imports/2021-09-15T12-40-34'
renamed '/mnt/data/memories/import/hackerman.png' -> '/mnt/data/memories/import/imports/2021-09-15T12-40-34/hackerman.png'
/mnt/data/memories/import/./imports/2021-09-15T12-40-34/hackerman.png -> /mnt/data/memories/library/2020-12-Dec/Unknown Location/2020-12-28_22-35-31-hackerman.png
****** SUMMARY ******
Metric      Count
--------  -------
Success         1
Error           0
```

```
$ ls -A1R /mnt/data/memories/import
/mnt/data/memories/import:
imports

/mnt/data/memories/import/imports:
2021-09-15T12-40-34

/mnt/data/memories/import/imports/2021-09-15T12-40-34:
import.log
```

### CRON

Using [CRON job](https://en.wikipedia.org/wiki/Cron) to run every minute with [file locking](https://en.wikipedia.org/wiki/File_locking) to prevent overlapping:

```
* * * * * ELODIE=... ELODIE_APPLICATION_DIRECTORY=... /usr/bin/flock -n /var/lock/import.lockfile /.../import.sh /mnt/data/memories/import /mnt/data/memories/library > /var/log/.../import.log 2>&1
```
