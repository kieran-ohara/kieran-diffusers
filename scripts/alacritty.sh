#!/bin/bash -e

# Or else I have to use Terminal.app.
cd ~/
curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info
