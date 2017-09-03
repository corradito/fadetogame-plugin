// Layout User Options
class UserConfig </ help="A plugin that fades the screen when transitioning to and from a game." /> {
	</ label="Run Time",
		help="The amount of time in milliseconds to run the fade.",
		order=1 />
	runTime="500";
}

// Load Debug Module
local log = null;
if (fe.load_module("Debug")) log = Log();

// FadeToGame
class FadeToGame {
	config = null;
	runTime = 0;
	shade = null;
	
	constructor() {
		config = fe.get_config();
		runTime = config["runTime"].tointeger();
		
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
				if (ttime < runTime) {
					// Fade Out
					shade.alpha = (255 * (ttime - runTime)) / runTime;
					return true;
				}
				break;
			case Transition.FromGame:
				shade.visible = true;
				if (ttime < runTime) {
					// Fade In
					shade.alpha = (255 * (runTime - ttime)) / runTime;
					return true;
				}
				break;
		}
		return false;
	}
}
fe.plugin["FadeToGame"] <- FadeToGame();
