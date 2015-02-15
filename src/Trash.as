package 
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class Trash extends Sprite 
	{
		public function Trash() 
		{
			//addChild(new Quad(15, 15, 0xCE098E));
			addChild(Assets.getImage("trash"));
			alignPivot(HAlign.CENTER, VAlign.BOTTOM);
			GameEvents.subscribe(GameEvents.LITTER, onTrash);
			GameEvents.subscribe(GameEvents.TRASH_TO_CAN, onTrash);
			rotation = Math.random() * Math.PI * 2;
		}
		
		private function onTrash(e: Event, t: Trash): void 
		{
			if (t == this)
			{
				/*Starling.juggler.tween(this, 1.0,
					{
						rotation: rotation + Math.random() - 0.5,
						transition: Transitions.LINEAR
					}
				)*/
				rotation = rotation + Math.random() - 0.5;
				//if (e.type == GameEvents.LITTER)
				GameEvents.unsubscribe(GameEvents.LITTER, onTrash);
				if (e.type == GameEvents.TRASH_TO_CAN)
					GameEvents.unsubscribe(GameEvents.TRASH_TO_CAN, onTrash);
			}
		}
	}
}
