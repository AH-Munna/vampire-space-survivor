# Vampire Space Survivor

A 2D space-themed survival roguelite game built with Godot 4. Survive against endless waves of enemies, collect gems, level up, and upgrade your ship to become an unstoppable force.

## 🎮 Features

*   **Endless Survival:** Fight off increasing hordes of enemies in a massive space arena.
*   **Upgrade System:** Unlock powerful upgrades like Multishot, Fire Rate, and Homing Bullets.
*   **Powerups:** Collect Heal, Magnet, and Bomb powerups to turn the tide of battle.
*   **Dynamic Difficulty:** Enemy spawn rates increase as you survive longer.
*   **Special Upgrades:** Compulsory upgrades at specific levels (Max HP, Homing Bullets) to guide progression.

## 🛠️ Development Journey

This project was a labor of love and a significant learning experience. Over the course of several days, I built this engine from scratch, facing and overcoming numerous challenges:

*   **Godot 4 Migration:** Adapting to the new syntax and node structures in Godot 4.
*   **System Architecture:** Designing a decoupled system where the Player, Enemies, and Managers interact via Signals rather than hard dependencies.
*   **Balancing Act:** Tuning the `SpawnManager` to ensure the game feels fair but challenging. The difficulty curve required multiple iterations to get right, especially the spike after Level 10.
*   **The "Magnet" Challenge:** Implementing the gem collection mechanic was trickier than expected. I had to rewrite the physics logic multiple times to ensure gems felt "weighty" yet responsive when the Magnet powerup was active.
*   **Scene Corruption:** Battled with Godot's `.tscn` file structure, specifically when `sub_resource` tags were misplaced, causing the Player scene to vanish. Fixing that required manually editing the scene file text.

## 🚀 How to Run

1.  Download Godot 4.x.
2.  Import the `project.godot` file.
3.  Run the project (F5).

## 📜 Credits

*   **Engine:** Godot Engine 4
*   **Assets:** Custom & Open Source Assets
*   **Developer:** Ah Munna
