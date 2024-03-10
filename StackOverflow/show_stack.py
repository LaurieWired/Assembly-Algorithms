import tkinter as tk
from tkinter import ttk
import tkinter.font as font
import threading
import time
import os
import sys

class FileWatcherGUI:
    def __init__(self, root, stack_limit):
        self.root = root
        self.stack_limit = int(stack_limit)  # Convert stack limit to integer, in KB
        self.root.title("Stack Pointer Visualizer")
        
        self.frame = ttk.Frame(self.root, padding="10")
        self.frame.pack(fill=tk.BOTH, expand=True)
        
        myFont = font.Font(size=15)
        
        self.label = ttk.Label(self.frame, text="Waiting for data...", font=myFont)
        self.label.pack()

        # Configure style for a red progress bar
        style = ttk.Style(self.root)
        style.theme_use('default')  # Use default theme as a baseline for customization
        style.configure("Red.Vertical.TProgressbar", troughcolor='blue', background='gray', thickness=30)

        # Initialize the progress bar for current SP value
        self.progress_sp = ttk.Progressbar(self.frame, length=300, mode='determinate',
                                           orient='vertical', style="Red.Vertical.TProgressbar")
        self.progress_sp.pack()
        self.progress_sp['maximum'] = 100  # Use a percentage scale

        # Read original SP value
        self.original_sp = self.read_original_sp()
        
        # Start the background thread
        self.stop_thread = False
        self.thread = threading.Thread(target=self.update_label)
        self.thread.start()
        
        # Ensure the thread stops when the GUI is closed
        self.root.protocol("WM_DELETE_WINDOW", self.on_closing)

    def read_original_sp(self):
        """Wait for original_sp.txt to exist and read the hex value."""
        while not os.path.exists("original_sp.txt"):
            time.sleep(1)  # Wait for the file to be created
        with open("original_sp.txt", "r") as file:
            return file.read().strip()  # Read and return the hex value

    def update_label(self):
        """Background thread function to update the label and progress bar."""
        while not self.stop_thread:
            try:
                with open("latest_sp.txt", "r") as file:
                    latest_sp_hex = file.read().strip()
                    if latest_sp_hex:
                        latest_sp = int(latest_sp_hex, 16)
                        original_sp = int(self.original_sp, 16)

                        # Calculate minimum stack pointer value
                        min_sp_value = original_sp - (self.stack_limit * 1024)
                        min_sp_value_hex = hex(min_sp_value)

                        # Normalize the current SP position for the progress bar
                        sp_range = original_sp - min_sp_value
                        current_sp_position = latest_sp - min_sp_value
                        if sp_range > 0:
                            sp_percentage = (current_sp_position / sp_range) * 100
                        else:
                            sp_percentage = 0
                        self.progress_sp['value'] = sp_percentage
                        
                        # Update the GUI with the new stack pointer info
                        self.label.config(text=f"Stack Pointer: {latest_sp_hex}\nMin Stack: {min_sp_value_hex}")
            except Exception as e:
                self.label.config(text=f"Error: {e}")
            time.sleep(1)

    def on_closing(self):
        """Handle the GUI closing event."""
        self.stop_thread = True
        self.thread.join()
        self.root.destroy()

def main():
    if len(sys.argv) > 1:
        stack_limit = sys.argv[1]
    else:
        stack_limit = "Unknown"
    
    root = tk.Tk()
    app = FileWatcherGUI(root, stack_limit)
    root.mainloop()

if __name__ == "__main__":
    main()

