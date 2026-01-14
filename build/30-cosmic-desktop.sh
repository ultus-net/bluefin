#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Install COSMIC Desktop Environment Alongside GNOME
###############################################################################
# This script installs System76's COSMIC desktop environment from their COPR
# repository while keeping GNOME installed. Users can switch between desktop
# environments at the GDM login screen.
#
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
#
# After installation, both GNOME and COSMIC sessions will be available at
# the GDM login screen (click the gear icon to select).
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install COSMIC Desktop"

# Install COSMIC desktop from System76's COPR
# Using isolated pattern to prevent COPR from persisting
copr_install_isolated "ryanabx/cosmic-epoch" \
    cosmic-session \
    cosmic-comp \
    cosmic-panel \
    cosmic-launcher \
    cosmic-applets \
    cosmic-settings \
    cosmic-files \
    cosmic-edit \
    cosmic-term \
    cosmic-workspaces

echo "COSMIC desktop installed successfully"
echo "::endgroup::"

echo "::group:: Configure Desktop Session"

# Create COSMIC session file for GDM
# COSMIC is a Wayland compositor, so the session file goes in wayland-sessions
mkdir -p /usr/share/wayland-sessions
cat > /usr/share/wayland-sessions/cosmic.desktop << 'COSMICDESKTOP'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
DesktopNames=COSMIC
X-LightDM-Session-Type=wayland
COSMICDESKTOP

echo "COSMIC session configured for GDM"
echo "::endgroup::"

echo "::group:: Install Additional Utilities"

# Install additional utilities that work well with COSMIC
# Note: flatpak is already installed in the base image
dnf5 install -y \
    kitty \
    xdg-desktop-portal-cosmic

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
echo "After booting, select 'COSMIC' or 'GNOME' session at the GDM login screen"
