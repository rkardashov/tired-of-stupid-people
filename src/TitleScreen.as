package 
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class TitleScreen extends Sprite 
	{
		private var howToPlay: Sprite;
		
		public function TitleScreen() 
		{
			super();
			addChild(Assets.getImage("title_bg"));
			var btn: Button;
			addChild(btn = new Button(Assets.getTexture("btn_start")));
			btn.x = 320 - 140;
			btn.y = 300;
			btn.alignPivot();
			//btn.addEventListener(Event.TRIGGERED, onStartTrigger);
			btn.addEventListener(Event.TRIGGERED, onShowHowToPlay);
			/*addChild(btn = new Button(Assets.getTexture("btn_how_to_play")));
			btn.x = 320 + 140;
			btn.y = 300;
			btn.alignPivot();
			btn.addEventListener(Event.TRIGGERED, onShowHowToPlay);
			*/
			//addChild(howToPlay = new Button(Assets.getTexture("bg_how_to_play")));
			//howToPlay =
			addChild(howToPlay = new Sprite());
			howToPlay.addChild(Assets.getImage("bg_how_to_play"));
			howToPlay.x = 320;
			howToPlay.y = 240;
			howToPlay.alignPivot();
			howToPlay.visible = false;
			var btnReady: Button = new Button(Assets.getTexture("btn_ready"));
			btnReady.x = 640 - btnReady.width * 2;
			btnReady.y = btnReady.height;
			howToPlay.addChild(btnReady);
			btnReady.addEventListener(Event.TRIGGERED, onBtnReadyTriggered);
		}
		
		private function onBtnReadyTriggered(e:Event):void 
		{
			howToPlay.visible = false;
			Assets.playSound("start");
			Starling.juggler.tween(this, 2,
			{
				alpha: 0,
				transition: Transitions.EASE_IN_OUT,
				onComplete: function(): void
				{
					visible = false;
					//x = 320 + 640;
					GameEvents.dispatch(GameEvents.GAME_START);
				}
			});
		}
		
		private function onShowHowToPlay(e:Event):void 
		{
			howToPlay.visible = true;
		}
	}
}
