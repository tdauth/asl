* Make all static members without m_talks dynamic.
* m_talks could be checked and created automatically in constructor (we don't need init anymore).
* Add static functions like enableAll, disableAll.
* Make ATalk unit-based and compliant to multiple players (force) who use them -> add struct ATalkPlayerData.