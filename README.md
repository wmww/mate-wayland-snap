# egmde-snap

Sample project for snapping up egmde.

## From the snap store

    sudo snap install --classic --beta egmde

## Run as X11 app desktop

    snap run egmde

## Run as desktop session

Log out and select "egmde" session when logging back in.

## Build & install

If you want to build it yourself this needs Ubuntu 18.04LTS.

Add the mir-team/release PPA *(or the /dev PPA for extra adventure)*:

    sudo add-apt-repository ppa:mir-team/release

Build and install snap:

    snapcraft 
    snap install --dangerous --classic ./egmde_0.1_amd64.snap
