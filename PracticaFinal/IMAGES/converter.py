from PIL import Image

img = Image.open('intro.png')
pixels = img.load() 
width, height = img.size

i = 0

print(f"{width}, {height}")

for y in range(height):      # columna
    for x in range(width):   # linea
        r, g, b, a = pixels[x, y]

        if i == 0: 
            print("            DC.L     ", end="")

        if i == 7:
            print(f"${b:02x}{g:02x}{r:02x}")
            i = 0

        else:
            print(f"${b:02x}{g:02x}{r:02x}", end=", ")
            i += 1