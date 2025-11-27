# Sprite Fix Guide

Since the sprites for Gems and Powerups look "messed up" (showing parts of multiple sprites or the wrong size), you can easily fix this in the Godot Editor.

## 1. Open the Scene
1.  In the **FileSystem** panel (bottom left), navigate to `src/items/`.
2.  Double-click `Powerup.tscn` (or `Gem.tscn` if that's also broken) to open it.

## 2. Select the Sprite
1.  In the **Scene** tree (top left), click on the `Sprite2D` node.
2.  Look at the **Inspector** panel (right side).

## 3. Adjust Animation Frames
Under the **Animation** section in the Inspector:

*   **Hframes:** This is the number of columns in the sprite sheet.
*   **Vframes:** This is the number of rows.

**To fix the "half cut" look:**
*   Try increasing these numbers. For example, if it's set to `4` and looks too big/cut, try setting both to `8`.
*   The goal is to make the grid match the actual individual icons in the texture.

## 4. Test the Frame
*   Change the **Frame** property (slider or number) to see if different icons appear correctly centered.
*   If the icon looks perfect (not cut off, correct size), you've found the right Hframes/Vframes settings!

## 5. Save
*   Press `Ctrl + S` to save the scene.

## 6. Repeat for Other Scenes
*   Do the same for `Gem.tscn` if needed.
