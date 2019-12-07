# nhk-proginfo
Get program lists from NHK's program list API.

## Description

NHK の番組表 API から番組表を取得します。

## Usage
```
Usage: nhk-prginfo.rb command
  command:
      help
    テキスト形式で出力
      list  area service YYYY-MM-DD
      genre area service genre-code YYYY-MM-DD
      info  area service program-id
      nowonair area service
    JSON 形式で出力
      jlist  area service YYYY-MM-DD
      jgenre area service genre-code YYYY-MM-DD
      jinfo  area service program-id
      jnowonair area service
```

## Installation
```
# make install
```
Configure Makefile to customize the destination directories if needed before "make install". You may also need to modify CONF_DIR and LIB_DIR in nhk-prginfo.rb.

## Configuration
```
/usr/local/etc/nhk-prginfo/apikey.conf
API Key: <Your API key>
API URL: <Your app URL>
```

## Requirement
You need to create an account at http://api-portal.nhk.or.jp/ , register your API URL and get your API key.

## License

You can copy, modify and redistrubute this program without permission except for constants.py and genre_code.rb in youzaka/ariblib/ directory.

## Thanks to

https://github.com/youzaka/ariblib

## Author

[Shimaden] (https://github.com/shimaden)
