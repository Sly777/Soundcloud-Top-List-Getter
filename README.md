Soundcloud Top Country List
==========================

This is created for Soundcloud Contest but you can use it on your projects easily.

You can use it for getting all information about Countries and Music Genres. It gives which countries are on top list on any genre. Also you can filter data with app options, get data in json format, create text file and get data with Geolocation of countries.

## Examples

This command does show all top countries of all genres in json format with geolocation info
**SCTopList -a -j -g**

This command does show all top countries of any similar genres
**SCTopList -s Rock**

Other examples:
**SCTopList -l 100 -c Rock**
**SCTopList -s Rock -f**

## Usage

Firstly, enter your **Soundcloud Client ID** to **SCTopList.rb**
After that, run this command : **bundle install**

**SCTopList [options]**

For help use: **SCTopList -h**

## Options

*  **-a, --all** :                      Show All Categories
*  **-s <similar>, --similar** :        Show Similar Categories
*  **-c <category>, --category** :      Show This Category Only
*  **-j, --json** :                     Show Data in JSON
*  **-g, --geo** :                      Show Data with Location Parameters
*  **-f, --file** :                     Create Report File
*  **-l <limit>, --limit** :            Max number of Categories (recommended)

## Author

[İlker Güller](http://ilkerguller.com/ "İlker Güller")