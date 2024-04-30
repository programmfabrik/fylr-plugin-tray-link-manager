> This Plugin / Repo is being maintained by a community of developers.
There is no warranty given or bug fixing guarantee; especially not by
Programmfabrik GmbH. Please use the github issue tracking to report bugs
and self organize bug fixing. Feel free to directly contact the committing
developers.

# fylr-plugin-tray-link-manager
Create and manage tray-links for app-header

The plugin makes it possible to create tray entries in baseconfig and to provide them with text, a link and an icon, and to assign group permissions there.

## installation

The latest version of this plugin can be found [here](https://github.com/programmfabrik/fylr-plugin-tray-link-manager/releases/latest/download/trayLinkManager.zip).

The ZIP can be downloaded and installed using the plugin manager, or used directly (recommended).

Github has an overview page to get a list of [all release](https://github.com/programmfabrik/fylr-plugin-tray-link-manager/releases/).

## configuration

* baseconfig
  * name
  * url (e.g. "/lists/objecttype1")
  * icon (e.g. "fa-superpowers")
  * groups (choose from select)

The URL must always be a URL that can also be accessed via the main menu on the left. Otherwise the tray entry will not be displayed. So Url = root menu link without domain

## sources

The source code of this plugin is managed in a git repository at <https://github.com/programmfabrik/fylr-plugin-tray-link-manager>.
