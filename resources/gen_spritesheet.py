import os
from PIL import Image

# This file generates the big spritesheet used for ferret animations
# it's useful to automate this process since editing all the sprites happens in a program that only allows 1 animation at a time
# the 5 animations are just strips of frames, so we just paste them in the right order from top to bottom.
# each ferret has the same animation frames so it should work fine.
# if a ferret has more frames then it should handle that fine as well, since the size of the individual animations is taken into account

# TODO: make this file also generate a simple animation.xml file to simplify things. since we know a frame is 20x20 we should be able to calculate various things easily

# get the folder in which this script resides, since it lives next to the sprites
scriptdir = os.path.dirname(__file__)

def spritesheet_gen():
    # each folder in here is sprites for a ferret
    for ferret in os.listdir(scriptdir):
        ferret_folder = os.path.join(scriptdir, ferret)
        # check whether this is a folder
        if not os.path.isdir(ferret_folder):
            continue

        stand_file_path = os.path.join(ferret_folder, "stand.png")
        walk_file_path = os.path.join(ferret_folder, "walk.png")
        jump_file_path = os.path.join(ferret_folder, "jump.png")
        fall_file_path = os.path.join(ferret_folder, "fall.png")
        bite_file_path = os.path.join(ferret_folder, "bite.png")

        image_paths = [
            stand_file_path,
            walk_file_path,
            jump_file_path,
            fall_file_path,
            bite_file_path,
        ]

        localpath = f"ferret_mod/files/ferret_gfx/{ferret}.png"
        output_file_path = os.path.join(os.path.dirname(scriptdir), localpath)

        files_missing = False
        # check whether all expected file paths exist
        for path in image_paths:
            if not os.path.exists(path):
                files_missing = True
                break

        if files_missing:
            print(f"files were missing for {ferret}")
            continue

        max_x = 0; max_y = 0

        images = []
        for path in image_paths:
            img = Image.open(path).convert("RGBA")
            width, height = img.size
            max_x = max(max_x, width)
            max_y += height
            images.append(img)

        sprite_sheet = Image.new("RGBA", (max_x, max_y))
        write_x = 0; write_y = 0
        for image in images:
            width, height = img.size
            sprite_sheet.paste(image, (write_x, write_y))
            write_y += height

        sprite_sheet.save(output_file_path)

if __name__ == "__main__":
    spritesheet_gen()
