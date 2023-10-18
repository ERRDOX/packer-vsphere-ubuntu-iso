# packer-ubuntu-vsphere-iso

This GitHub repository contains a Packer template that automates the creation of a virtual machine template on vSphere using Ubuntu 22.04. With this template, you can easily build standardized and reproducible Ubuntu  virtual machine images for your vSphere infrastructure.

With this repo VM templates for the following Ubuntu systems can be built.

- Ubuntu Server 22.04

Ubuntu ISO files gets download automatically from public sources.

## How to use this repo

### Pre-requesites

Download or `git clone https://github.com/saleroun/packer-vsphere-ubuntu-iso` this repo and make sure you have [Packer](https://www.packer.io/downloads) Version 1.7.1 or later installed. If you don't know Packer, it's a single commandline binary which only needs to be on your `PATH`.

### Step 1: Adjust variables

Rename the file [variables.pkrvars.hcl.template](variables.pkrvars.hcl.sample) to `variables.pkrvars.hcl` and adjust the variables for your VMware vSphere environment. Some documentation on each variable is inside the sample file.
```bash
mv variables.pkrvars.hcl.template variables.pkrvars.hcl
vim variables.pkrvars.hcl
```

### Step 2: Init Packer

Init Packer by using the following command. (Spot the dot at the end of the command!)
```bash
packer init .
```

### Step 3: Build a VM Template

To build a VM template run one of the provided `build`-scripts.   
For example to build a Ubuntu Server 22.04 template run:
```bash
./build-2204.sh
```
If you are on a Windows machine then use the `build-*.ps1` files.


### Optional: Template default credentials

the default credentials after a successful build are   
Username: `ubuntu`   
Password: `ubuntu`  

If you would like to change the default ćredentials before a packer build, then you need to edit the following files:

- **variables.pkrvars.hcl**
- **user-data**

To generate an encypted password for [user-data](./html/user-data) use the following command:
```bash
mkpasswd -m SHA-512 --rounds=4096
```
