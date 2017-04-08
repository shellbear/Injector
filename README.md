# Injector

![Logo](https://unicrack.files.wordpress.com/2014/10/usb-foto-jpg.png?w=200)

By [ShellBear](https://github.com/ShellBear).

## Description
**Injector** Shell script wich allow you to inject malicious code into an USB device on OSX

## Installation

Add this on your Terminal :

```git
git clone https://github.com/ShellBear/Injector
```

Run the script directly:

```/bin/sh
sh injector.sh
```

## How it's works ?

Injector will automaticatly detect USB device when connected and will automaticatly select a random file, create a copy of it with the same name and icon but the new file will contains malicious code and allow you to execute any command you cant.
Caution: When opening malicious file it will open a terminal and quits after 2 seconds which can alert User.

### Known Issues

If you discover any bugs, feel free to create an issue on GitHub fork and
send us a pull request.


## Author

* ShellBear (https://github.com/ShellBear)
Blogspot (http://shellbearblog.blogspot.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

Use it as you want but not for evil project, and Mention me in case of use.
