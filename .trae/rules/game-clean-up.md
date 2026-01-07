if the game has a back button that would make the page go back to the main index page or somthing out of its folder remove it e.g     <a href="../index.html" class="back-btn">← Back</a>
    <div class='webgl-content wrap'>
        <div id='gameContainer' style='width:100%;height:100%;margin:0;'></div>
example 2
    <style>
      .back-btn { position:absolute; top:20px; left:20px; z-index:999; text-decoration:none; background:rgba(0,0,0,0.5); color:#fff; padding:10px 20px; border-radius:8px; font-family:sans-serif; font-weight:bold; border: 1px solid rgba(255,255,255,0.2); transition: 0.2s; backdrop-filter: blur(5px); }
      .back-btn:hover { background:rgba(255,255,255,0.1); }
    </style>
    <a href="../../index.html" class="back-btn">← Back</a>
    <button class="help-btn overlay-btn" onclick="showHelp()">Settings & Help</button>
could break another persons website so we remove it
always change the title of the game to be the name of the game and not include a website name in the title e.g <title>Quizcool — Slope</title> becomes <title>Slope</title> also 
