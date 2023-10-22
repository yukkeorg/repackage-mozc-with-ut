# Repackage-mozc-w-ut

Script for re-packaging mozc debs with UT for Ubuntu/Debian.

Thanks for [@utuhiro78](https://github.com/utuhiro78), the mozc-ut auther.

## Required

* Docker

## Usage

``` sh
git clone https://github.com/yukkeorg/repackage-mozc-w-ut.git
cd repackage-mozc-w-ut
make
cd packages
sudo apt install ./*.deb
```

## License

Scripts are under the
<a rel="license"
   href="http://creativecommons.org/publicdomain/zero/1.0/">
  <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
</a>.

**but, packages created by this scripts comply with thire own licenses.**
