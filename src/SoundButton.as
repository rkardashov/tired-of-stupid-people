package 
{
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class SoundButton extends MovieClip //Button 
	{
		private var soundOn: Boolean = true;
		
		public function SoundButton() 
		{
			super(Assets.getTextures("sound_"));
			alignPivot();
			currentFrame = 0;
			//Starling.current.juggler.add(this);
			x = width * 1.5;
			y = height;
			//addEventListener(Event.TRIGGERED, onTriggered);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, TouchPhase.BEGAN))
				scaleX = scaleY = 0.85;
			
			if (e.getTouch(this, TouchPhase.ENDED))
			{
				soundOn = !soundOn;
				currentFrame = int(!soundOn);
				scaleX = scaleY = 1.0;
				Assets.playSound("sound_toggle");
				if (soundOn)
					toggleSound()
				else
					setTimeout(toggleSound, 250);
			}
		}
		
		private function onTriggered(e:Event):void 
		{
			// TODO: mute / unmute
			//isMuted != isMuted;
			/*if (muted)
				upState = Assets.getTexture("sound_off")
			else
				upState = Assets.getTexture("sound_on")*/
		}
		
		private function toggleSound():void 
		{
			SoundMixer.soundTransform = new SoundTransform(int(soundOn));
		}
	}
}