#!/usr/bin/env python3

import sys
import os
import subprocess
from pathlib import Path
from PySide6.QtWidgets import (QApplication, QMainWindow, QVBoxLayout, QHBoxLayout,
                             QWidget, QPushButton, QLabel, QScrollArea, QGridLayout,
                             QFileDialog, QMessageBox, QComboBox, QProgressBar)
from PySide6.QtCore import Qt, QThread, Signal, QSize
from PySide6.QtGui import QPixmap, QIcon

class WallpaperPreviewWidget(QLabel):
    """Custom widget to display wallpaper preview with click functionality"""

    clicked = Signal(str)

    def __init__(self, image_path):
        super().__init__()
        self.image_path = image_path
        self.setFixedSize(200, 120)
        self.setStyleSheet("border: 2px solid #333; border-radius: 5px;")
        self.setAlignment(Qt.AlignCenter)
        self.setScaledContents(True)

        # Load and scale the image
        pixmap = QPixmap(image_path)
        if not pixmap.isNull():
            scaled_pixmap = pixmap.scaled(196, 116, Qt.KeepAspectRatio, Qt.SmoothTransformation)
            self.setPixmap(scaled_pixmap)
        else:
            self.setText("Invalid Image")
            self.setStyleSheet("border: 2px solid #ff0000; border-radius: 5px; color: red;")

    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            self.clicked.emit(self.image_path)

    def enterEvent(self, event):
        self.setStyleSheet("border: 2px solid #00ffff; border-radius: 5px;")

    def leaveEvent(self, event):
        self.setStyleSheet("border: 2px solid #333; border-radius: 5px;")

class WallpaperSetterThread(QThread):
    """Thread to set wallpaper without blocking UI"""

    finished = Signal(bool, str)

    def __init__(self, image_path, monitor=None):
        super().__init__()
        self.image_path = image_path
        self.monitor = monitor

    def run(self):
        try:
            # First, try to start swww daemon if not running
            subprocess.run(["swww-daemon"], capture_output=True, timeout=2)

            # Wait a moment for daemon to start
            import time
            time.sleep(1)

            if self.monitor:
                cmd = ["swww", "img", self.image_path, "--outputs", self.monitor]
            else:
                cmd = ["swww", "img", self.image_path]

            result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)

            if result.returncode == 0:
                self.finished.emit(True, f"Wallpaper set successfully!")
            else:
                # Try fallback methods
                if self.try_fallback_methods():
                    self.finished.emit(True, f"Wallpaper set using fallback method!")
                else:
                    self.finished.emit(False, f"Error: {result.stderr}")
        except Exception as e:
            if self.try_fallback_methods():
                self.finished.emit(True, f"Wallpaper set using fallback method!")
            else:
                self.finished.emit(False, f"Error: {str(e)}")

    def try_fallback_methods(self):
        """Try alternative wallpaper setting methods"""
        try:
            # Try hyprpaper if available
            if subprocess.run(["which", "hyprpaper"], capture_output=True).returncode == 0:
                # Create a simple hyprpaper config
                config_path = "/tmp/hyprpaper.conf"
                with open(config_path, "w") as f:
                    f.write(f"preload = {self.image_path}\n")
                    f.write(f"wallpaper = ,{self.image_path}\n")

                result = subprocess.run(["hyprpaper", "-c", config_path],
                                      capture_output=True, timeout=5)
                if result.returncode == 0:
                    return True

            # Try feh for X11 fallback
            if subprocess.run(["which", "feh"], capture_output=True).returncode == 0:
                result = subprocess.run(["feh", "--bg-fill", self.image_path],
                                      capture_output=True, timeout=5)
                if result.returncode == 0:
                    return True

        except:
            pass
        return False

class HyprlandWallpaperSetter(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("NigelOS Wallpaper Setter")
        self.setMinimumSize(800, 600)

        # Default wallpaper directory
        self.wallpaper_dir = Path.home() / "Pictures" / "Wallpapers"

        self.init_ui()
        self.load_wallpapers()

    def init_ui(self):
        central_widget = QWidget()
        self.setCentralWidget(central_widget)

        layout = QVBoxLayout(central_widget)

        # Top controls
        controls_layout = QHBoxLayout()

        # Directory selection
        self.browse_btn = QPushButton("Browse Folder")
        self.browse_btn.clicked.connect(self.browse_folder)
        controls_layout.addWidget(self.browse_btn)

        # Current directory label
        self.dir_label = QLabel(f"Current: {self.wallpaper_dir}")
        controls_layout.addWidget(self.dir_label)

        controls_layout.addStretch()

        # Monitor selection
        monitor_label = QLabel("Monitor:")
        controls_layout.addWidget(monitor_label)

        self.monitor_combo = QComboBox()
        self.monitor_combo.addItem("All Monitors", "")
        self.load_monitors()
        controls_layout.addWidget(self.monitor_combo)

        layout.addLayout(controls_layout)

        # Progress bar (hidden by default)
        self.progress_bar = QProgressBar()
        self.progress_bar.setVisible(False)
        layout.addWidget(self.progress_bar)

        # Wallpaper grid
        self.scroll_area = QScrollArea()
        self.scroll_widget = QWidget()
        self.grid_layout = QGridLayout(self.scroll_widget)
        self.scroll_area.setWidget(self.scroll_widget)
        self.scroll_area.setWidgetResizable(True)
        layout.addWidget(self.scroll_area)

        # Status bar
        self.statusBar().showMessage("Ready")

    def load_monitors(self):
        """Load available monitors from hyprctl"""
        try:
            result = subprocess.run(["hyprctl", "monitors", "-j"],
                                  capture_output=True, text=True)
            if result.returncode == 0:
                import json
                monitors = json.loads(result.stdout)
                for monitor in monitors:
                    name = monitor.get('name', 'Unknown')
                    desc = monitor.get('description', name)
                    self.monitor_combo.addItem(f"{name} ({desc})", name)
        except Exception as e:
            print(f"Could not load monitors: {e}")

    def browse_folder(self):
        """Open folder browser to select wallpaper directory"""
        folder = QFileDialog.getExistingDirectory(
            self,
            "Select Wallpaper Folder",
            str(self.wallpaper_dir)
        )

        if folder:
            self.wallpaper_dir = Path(folder)
            self.dir_label.setText(f"Current: {self.wallpaper_dir}")
            self.load_wallpapers()

    def load_wallpapers(self):
        """Load wallpapers from the selected directory"""
        # Clear existing items
        for i in reversed(range(self.grid_layout.count())):
            self.grid_layout.itemAt(i).widget().setParent(None)

        if not self.wallpaper_dir.exists():
            self.statusBar().showMessage(f"Directory {self.wallpaper_dir} does not exist")
            return

        # Supported image formats
        image_extensions = {'.jpg', '.jpeg', '.png', '.webp', '.bmp', '.gif', '.tiff'}

        # Find all image files
        image_files = []
        for ext in image_extensions:
            image_files.extend(self.wallpaper_dir.glob(f"*{ext}"))
            image_files.extend(self.wallpaper_dir.glob(f"*{ext.upper()}"))

        if not image_files:
            self.statusBar().showMessage("No wallpapers found in directory")
            return

        # Create preview widgets
        row, col = 0, 0
        max_cols = 4

        for image_file in sorted(image_files):
            try:
                preview = WallpaperPreviewWidget(str(image_file))
                preview.clicked.connect(self.set_wallpaper)

                # Add filename label
                name_label = QLabel(image_file.name)
                name_label.setAlignment(Qt.AlignCenter)
                name_label.setWordWrap(True)
                name_label.setMaximumWidth(200)

                # Create container widget
                container = QWidget()
                container_layout = QVBoxLayout(container)
                container_layout.addWidget(preview)
                container_layout.addWidget(name_label)
                container_layout.setSpacing(5)

                self.grid_layout.addWidget(container, row, col)

                col += 1
                if col >= max_cols:
                    col = 0
                    row += 1

            except Exception as e:
                print(f"Error loading {image_file}: {e}")

        self.statusBar().showMessage(f"Loaded {len(image_files)} wallpapers")

    def set_wallpaper(self, image_path):
        """Set the selected wallpaper"""
        monitor = self.monitor_combo.currentData()

        self.progress_bar.setVisible(True)
        self.progress_bar.setRange(0, 0)  # Indeterminate progress

        self.setter_thread = WallpaperSetterThread(image_path, monitor)
        self.setter_thread.finished.connect(self.on_wallpaper_set)
        self.setter_thread.start()

        self.statusBar().showMessage("Setting wallpaper...")

    def on_wallpaper_set(self, success, message):
        """Handle wallpaper setting completion"""
        self.progress_bar.setVisible(False)

        if success:
            self.statusBar().showMessage(message)
        else:
            self.statusBar().showMessage("Failed to set wallpaper")
            QMessageBox.warning(self, "Error", message)

def main():
    app = QApplication(sys.argv)

    # Check if any wallpaper backend is available
    backends_available = []

    if subprocess.run(["which", "swww"], capture_output=True).returncode == 0:
        backends_available.append("swww")
    if subprocess.run(["which", "hyprpaper"], capture_output=True).returncode == 0:
        backends_available.append("hyprpaper")
    if subprocess.run(["which", "feh"], capture_output=True).returncode == 0:
        backends_available.append("feh")

    if not backends_available:
        QMessageBox.critical(None, "Error",
                           "No wallpaper backend found! Please install one of:\n"
                           "- swww (recommended for Wayland/Hyprland)\n"
                           "- hyprpaper (for Hyprland)\n"
                           "- feh (for X11)")
        sys.exit(1)

    window = HyprlandWallpaperSetter()
    window.show()

    sys.exit(app.exec())

if __name__ == "__main__":
    main()