# Repackage-mozc-w-ut

Script for re-packaging mozc debs with UT for Ubuntu/Debian.

Thanks for [@utuhiro78](https://github.com/utuhiro78), the mozc-ut auther.

# Required

* Docker

# Usage

```
git clone https://github.com/yukkeorg/repackage-mozc-w-ut.git
cd repackage-mozc-w-ut
make
cd packages
sudo dpkg -i *.deb
```

# License

Scripts in this project are under the UNLICENSE.  

**but, packages created by this scripts comply with thire own licenses.**
