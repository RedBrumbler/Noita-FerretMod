import os
from PIL import Image

# This file generates ragdoll pieces for a killed ferret.
# Noita expects each sprite to be the same size as the original sprite, and it also expects a file that contains the local mod filepaths to each piece.
# Ferret pieces are split up head, torso_right, torso_left, tail. therefore we get 4 pieces and 4 files.
# the pieces are generated from the first frame of the `stand` animation
# each folder in this resources folder is checked for images and gets turned into ferret pieces

# get the folder in which this script resides, since it lives next to the sprites
script_dir = os.path.dirname(__file__)

# method to get a copy of the frame where we clip @ coords w/ size
def clip(image, clip_coords: tuple[int, int], clip_size: tuple[int, int]) -> Image:
    x, y = clip_coords; w, h = clip_size
    clipped_image = Image.new("RGBA", image.size)
    x2 = x + w;y2 = y + h
    clipped_image.paste(image.crop((x, y, x2, y2)), (clip_coords))
    return clipped_image

def ragdoll_gen():
    # each folder in here is sprites for a ferret
    for ferret in os.listdir(script_dir):
        ferret_folder = os.path.join(script_dir, ferret)
        # check whether this is a folder
        if not os.path.isdir(ferret_folder):
            continue

        # get the stand animation to generate pieces
        stand_file_path = os.path.join(ferret_folder, "stand.png")

        if not os.path.exists(stand_file_path):
            continue

        # read in stnad image and split off the first frame with crop
        stand = Image.open(stand_file_path).convert("RGBA").crop((0, 0, 20, 20))

        tail_img = clip(stand, (0, 0), (4, 20))
        torso_left_img = clip(stand, (4, 0), (4, 20))
        torso_right_img = clip(stand, (8, 0), (4, 20))
        head_img = clip(stand, (12, 0), (5, 20))

        # output folder
        localpath = f"ferret_mod/files/ferret_ragdolls/{ferret}"
        modpath = f"mods/{localpath}"

        output_folder_path = os.path.join(os.path.dirname(script_dir), localpath)
        if (not os.path.exists(output_folder_path)):
            os.makedirs(output_folder_path)

        # image paths
        head_path = os.path.join(output_folder_path, "head.png")
        torso_right_path = os.path.join(output_folder_path, "torso_right.png")
        torso_left_path = os.path.join(output_folder_path, "torso_left.png")
        tail_path = os.path.join(output_folder_path, "tail.png")

        head_img.save(head_path)
        torso_right_img.save(torso_right_path)
        torso_left_img.save(torso_left_path)
        tail_img.save(tail_path)

        # make filenames txt for this ferret
        with open(os.path.join(output_folder_path, "filenames.txt"), "w") as filenames:

            filenames.write(
                '\n'.join([
                    f"{modpath}/head.png",
                    f"{modpath}/torso_right.png",
                    f"{modpath}/torso_left.png",
                    f"{modpath}/tail.png",
                ])
            )


if __name__ == "__main__":
    ragdoll_gen()
