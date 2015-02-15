package 
{
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Doggy extends Sprite 
	{
		private var animBark: MovieClip;
		private var animJump: MovieClip;
		private var dt:Number = 0;
		private var targetTime:Number = 7.0;
		
		public function Doggy() 
		{
			super();
			addChild(animBark = Assets.getAnim("doggy_bark_"));
			animBark.fps = 30;
			Starling.current.juggler.add(animBark);
			//animBark.visible = false;
			animBark.play();
			addChild(animJump = Assets.getAnim("doggy_jump_"));
			Starling.current.juggler.add(animJump);
			animJump.visible = false;
			animJump.play();
			animJump.fps = 30;
			alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			x = Game.TRASH_CAN_X + 100;
			y = Game.FLOOR_Y + 65;
			scaleX = -1;
			//changeState();
			touchable = false;
			GameEvents.subscribe(GameEvents.PAUSE, onPause);
			GameEvents.subscribe(GameEvents.RESUME, onResume);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void 
		{
			dt += e.passedTime;
			if (dt > targetTime)
			{
				animBark.visible = !animBark.visible;
				animJump.visible = !animJump.visible;
				if (animJump.visible)
					targetTime = 1.0
				else
					targetTime = 4.0 + Math.random() * 2.0;
					dt = 0;
			}
		}
		
		private function onPause(e: Event):void 
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			animBark.pause();
			animJump.pause();
		}
		private function onResume(e: Event):void 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
			animBark.play();
			animJump.play();
		}
	}
}
