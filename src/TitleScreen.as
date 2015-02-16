package 
{
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class TitleScreen extends Sprite 
	{
		private var howToPlay: Sprite;
		private var bgImg:Image;
		
		public function TitleScreen() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var bg: Quad = new Quad(stage.stageWidth, stage.stageHeight, 0xED715F);
			addChild(bg);
			bg.x = globalToLocal(new Point()).x;
			bg.y = globalToLocal(new Point()).y;
			
			bgImg = Assets.getImage("title_bg");
			bgImg.alignPivot();
			bgImg.x = 320;
			bgImg.y = 240;
			addChild(bgImg);
			
			/*var btn: Button;
			addChild(btn = new Button(Assets.getTexture("btn_start")));
			btn.x = 320 - 140;
			btn.y = 300;
			btn.alignPivot();
			btn.addEventListener(Event.TRIGGERED, onShowHowToPlay);
			*/
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
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				removeEventListener(TouchEvent.TOUCH, onTouch);
				removeChild(bgImg);
				howToPlay.visible = true;
			}
		}
		
		private function onBtnReadyTriggered(e:Event):void 
		{
			(e.currentTarget as Button).removeEventListener(Event.TRIGGERED, onBtnReadyTriggered);
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
