import tkinter as tk
import time
import threading
from PIL import Image, ImageTk
from math import pi, sin, cos

def read_fibonacci_from_file(label, canvas, circle, root, spiral_distance):
    angle = 0
    last_number = None
    same_number_count = 0
    circle_radius = 50  # Should be the same as in main()

    while same_number_count < 5:
        try:
            with open("nums.txt", "r") as file:
                for last_line in file:
                    pass
                current_number = last_line.strip()
                
                if current_number == last_number:
                    same_number_count += 1
                else:
                    same_number_count = 0
                    last_number = current_number

                    label.config(text=current_number)
                    x = root.winfo_width() / 2 + spiral_distance * cos(angle)
                    y = root.winfo_height() / 2 + spiral_distance * sin(angle)
                    
                    # Update label position
                    label.place(x=x, y=y, anchor="center")
                    
                    # Update circle position
                    canvas.coords(circle, x - circle_radius, y - circle_radius, x + circle_radius, y + circle_radius)

                    angle += pi / 4
        except Exception as e:
            print(f"Error reading file: {e}")
            label.config(text="Error")
        time.sleep(0.1)
        

def main():
    root = tk.Tk()
    root.title("Fibonacci Sequence")
    
    window_width = root.winfo_screenwidth()
    window_height = root.winfo_screenheight()
    root.geometry(f"{window_width}x{window_height}+0+0")
    
    bg_image_path = "spiral.png"
    bg_image = Image.open(bg_image_path)
    bg_photo = ImageTk.PhotoImage(bg_image)
    
    canvas = tk.Canvas(root, width=window_width, height=window_height)
    canvas.pack(fill="both", expand=True)
    canvas.create_image(window_width // 2, window_height // 2, image=bg_photo)
    
    # Create a canvas circle for the background of the number
    circle_radius = 50  # Adjust the radius as needed
    circle = canvas.create_oval(
        window_width // 2 - circle_radius, 
        window_height // 2 - circle_radius, 
        window_width // 2 + circle_radius, 
        window_height // 2 + circle_radius, 
        fill='pink'
    )

    # Create a label for the Fibonacci number
    fib_label = tk.Label(root, text="", font=("Helvetica", 35), fg='black', bg='pink')
    fib_label.place(x=window_width // 2, y=window_height // 2, anchor="center")
    
    spiral_distance = 200
    threading.Thread(target=read_fibonacci_from_file, args=(fib_label, canvas, circle, root, spiral_distance), daemon=True).start()    
    root.mainloop()


if __name__ == "__main__":
    main()
