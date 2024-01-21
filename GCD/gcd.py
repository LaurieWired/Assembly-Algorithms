import tkinter as tk
from PIL import Image, ImageTk

def read_gcd_from_file(label, canvas, circle, root):
    circle_radius = 50  # Should be the same as in main()

    try:
        with open("nums.txt", "r") as file:
            # Read the first line only
            current_number = file.readline().strip()
            label.config(text=current_number)

            # Update position of label and circle
            x = 150  # You can adjust this to change the initial position
            y = 250  # You can adjust this to change the initial position
            label.place(x=x, y=y, anchor="center")
            canvas.coords(circle, x - circle_radius, y - circle_radius, 
                          x + circle_radius, y + circle_radius)
    except Exception as e:
        print(f"Error reading file: {e}")
        label.config(text="Error")

def main():
    root = tk.Tk()
    root.title("GCD Calculator")

    # Get screen width and height
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()

    # Set the geometry for the window to full screen
    root.geometry(f"{screen_width}x{screen_height}+0+0")

    # Load and resize the background image
    bg_image_path = "euclid.png"
    bg_image = Image.open(bg_image_path)
    bg_image = bg_image.resize((screen_width, screen_height), Image.LANCZOS)
    bg_photo = ImageTk.PhotoImage(bg_image)

    # Create a canvas that fills the whole window and set the background image
    canvas = tk.Canvas(root, width=screen_width, height=screen_height)
    canvas.pack(fill="both", expand=True)
    canvas.create_image(0, 0, image=bg_photo, anchor="nw")

    # Create a canvas circle for the background of the number
    circle_radius = 50
    circle = canvas.create_oval(
        screen_width // 2 - circle_radius, 
        screen_height // 2 - circle_radius, 
        screen_width // 2 + circle_radius, 
        screen_height // 2 + circle_radius, 
        fill='white',
        outline='white'
    )

    # Create a label for displaying the number
    gcd_label= tk.Label(root, text="", font=("Helvetica", 40), fg='black', bg='white')
    gcd_label.place(x=screen_width // 2, y=screen_height // 2, anchor="center")

    # Call the function to read the number from the file and update the label
    read_gcd_from_file(gcd_label, canvas, circle, root)

    root.mainloop()

if __name__ == "__main__":
    main()
