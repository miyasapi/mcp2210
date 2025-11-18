import sys
from PySide6.QtWidgets import QApplication, QWidget

app = QApplication(sys.argv)
window = QWidget()
window.setWindowTitle("はじめてのPySide6アプリ")
window.setGeometry(100, 100, 400, 200) # x, y, width, height
window.show()
sys.exit(app.exec_())