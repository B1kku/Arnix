import QtQuick
import QtQuick.Controls

import Quickshell.Services.Pipewire

Rectangle {
  id: root
  PwObjectTracker {
    objects: [Pipewire.defaultAudioSource]
  }
  color: (Pipewire.defaultAudioSource?.audio.muted) ? "red" : "green"
}
