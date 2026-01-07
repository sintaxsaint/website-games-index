# Website Games Index

This project hosts a collection of games accessible via a central `call.html` loader. It is designed to be hosted on GitHub Pages.

## How It Works

The system uses a `call.html` file to redirect users to specific games based on an ID parameter.

**URL Format:**
`https://<your-username>.github.io/<repo-name>/call.html?id=<GAME_ID>`

*   Replace `<GAME_ID>` with the numeric ID assigned to the game (e.g., `1`, `2`, `3`).

## Integration Guide

To add a new game, follow these strict rules:

1.  **Assign an ID**: IDs are sequential numeric strings (`1`, `2`, `3`...).
2.  **Create Folder**: Create a new folder for the game inside the `games/` directory.
    *   Example: `games/my-new-game/`
3.  **Update `call.html`**: Add the ID and path to the `games` object in the script.
    ```javascript
    const games = {
        "1": "games/test-game/index.html",
        "2": "games/my-new-game/index.html" // New game added here
    };
    ```
4.  **Update `index.html`**: Add the game to the list using the format: `Name : ID to call: <ID>`.
    ```html
    <li><a href="call.html?id=2">My New Game</a> : ID to call: 2</li>
    ```
5.  **Update `index/games list`**: Add the game to the registry file using the same format.
    ```text
    Test Game : ID to call: 1
    My New Game : ID to call: 2
    ```

## Usage Examples

### Direct Link
To link to "Test Game" (ID: 1):
`https://<your-username>.github.io/<repo-name>/call.html?id=1`

### Iframe Embedding
You can embed games on other websites using an iframe.

**Example Code:**
```html
<iframe 
    src="https://<your-username>.github.io/<repo-name>/call.html?id=1" 
    width="800" 
    height="600" 
    frameborder="0" 
    allowfullscreen>
</iframe>
```

## Rules Checklist
- [ ] Game is in its own folder inside `games/`.
- [ ] Game is added to `call.html` script.
- [ ] Game is listed in `index.html` with format `Name : ID to call: X`.
- [ ] Game is listed in `index/games list` with format `Name : ID to call: X`.
- [ ] ID is a sequential number.
