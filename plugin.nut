// Layout User Options
class UserConfig </ help="A plugin that fades the screen when transitioning to and from a game." /> {
	</ label="To Game Run Time",
		help="The amount of time in milliseconds to run the fade to game.",
		order=1 />
	toGameRunTime="500";
	</ label="From Game Run Time",
		help="The amount of time in milliseconds to run the fade from game.",
		order=2 />
	fromGameRunTime="500";
}

// Load Debug Module
local log = null;
if (fe.load_module("Debug")) log = Log();

// FadeToGame
class FadeToGame {
	config = null;
	toGameRunTime = 0;
	fromGameRunTime = 0;
	shade = null;
	
	constructor() {
		config = fe.get_config();
		toGameRunTime = config["toGameRunTime"].tointeger();
		fromGameRunTime = config["fromGameRunTime"].tointeger();
		
		shade = fe.add_image("white.png", 0, 0, fe.layout.width, fe.layout.height);
		shade.set_rgb(0, 0, 0);
		shade.visible = false;
		shade.zorder = 9999;
		
		fe.add_transition_callback(this, "transitions");
	}
	
	function transitions(ttype, var, ttime) {
		switch(ttype) {
			case Transition.ToGame:
				shade.visible = true;
				if (ttime < toGameRunTime) {
					// Fade Out
					shade.alpha = (255 * (ttime - toGameRunTime)) / toGameRunTime;
					return true;
				}
				break;
			case Transition.FromGame:
				shade.visible = true;
				if (ttime < fromGameRunTime) {
					// Fade In
					shade.alpha = (255 * (fromGameRunTime - ttime)) / fromGameRunTime;
					return true;
				}
				break;
		}
		return false;
	}
}
fe.plugin["FadeToGame"] <- FadeToGame();
