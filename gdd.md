# Game Design Document (GDD)

## 1. Storyline

In a freezing 2D side-view world, the protagonist's family is on the brink of death due to the lack of heat. The only solution: build a furnace. With a pickaxe in one hand and a sword in the other, the player sets out. However, ghostly creatures roam the surface, pushing the player to dig underground in search of coal, iron, and a rare mineral required to construct a working furnace. The deeper you go, the more dangerous the caves become — deadly falls and hostile lifeforms await.

## 2. Game Physics

- 2D side-scrolling with gravity.
- Falling from great heights causes death.
- Lava exists only deep underground.
- Block-based terrain: breakable and placeable blocks.
- Player can jump, climb using stairs, and build custom paths.

## 3. Interaction Mechanisms

- **Movement**: WASD keys.
- **Item selection**: Number keys 1–9.
- **Mining / Attacking / Placing**: Left click.
- **Cancel selection**: Right click.
- **Crafting**:
  - Press `Tab` for basic crafting.
  - Press `B` for advanced crafting menu.
- **Inventory system**: Items collected and crafted are stored in a bottom-bar.

## 4. AI Functionality

- **Ghosts**: Roam the surface, actively chase the player, pass through terrain.
- **Bat**: Harmless in behavior but contact causes damage and can kill.
- **AI behavior**: Advanced pathing and player detection, with aggressive or passive roles.

## 5. Resource and Crafting System

- **Basic Resources**:
  - **Coal**: Used for smelting and furnace construction.
  - **Iron**: Used for crafting tools and upgrades.
  - **Stone**: Used for building blocks and basic items.
- **Rare Mineral**: Required to complete the furnace and unlock deeper progression.
- **Craftable Items**:
  - **Stone Block**: Can be placed to build structures.
  - **Stairs**: Used for easier climbing and safer cave navigation.
  - **Furnace**: Essential structure to save the family.
- **Crafting Types**:
  - Basic crafting (`B`): Simple items.
  - Advanced crafting (`Tab`): Unlocks more complex recipes.

---

**Note**: The game balances survival and crafting with light exploration and danger. Smart resource gathering and strategic crafting are key to progressing through the cold, haunted world.
