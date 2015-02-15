package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	//keep your imports to a minimum!
	//avoid classes with embedded assets, like images or sounds.

	/*[SWF(width="960",height="640",frameRate="60",backgroundColor="#1a1a1a")]*/
	/**
	 * An example of a startup class that displays a preloader for a Starling
	 * app. Uses the <code>-frame</code> compiler argument to include the root
	 * Starling display object on the second frame of the SWF rather than on the
	 * first frame. The first frame loads quickly and can display things on the
	 * native display list while the second frame is still loading.
	 *
	 * <p>DO NOT import or reference anything in this class that you do not want
	 * to include in the first frame. Carefully consider any decision to
	 * import any class that has embedded assets like images or sounds. If you
	 * need embedded assets in the preloader, they should be separate from the
	 * rest of your embedded assets to keep the first frame nice and small.</p>
	 *
	 * <p>The following compiler argument is required to make this work:</p>
	 * <pre>-frame=two,com.example.StarlingRoot</pre>
	 *
	 * <p>Because our StarlingRoot class is a Starling display object, and
	 * because we don't import starling.core.Starling in this class, the
	 * Starling Framework will also be included on frame 2 instead of frame 1.</p>
	 */
	public class Preloader extends MovieClip
	{
		/**
		 * Just the height of the progress bar.
		 */
		private static const PROGRESS_BAR_HEIGHT:Number = 20;
		
		/**
		 * Constructor.
		 */
		public function Preloader()
		{
			//the document class must be a MovieClip so that things can go on
			//the second frame.
			this.stop();
			
			//we listen to ProgressEvent.PROGRESS to update the progress bar.
			this.loaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderInfo_progressHandler);
			
			//we listen to Event.COMPLETE to know when the SWF is completely loaded.
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}
		
		/**
		 * This is typed as Object so that the compiler doesn't include the
		 * starling.core.Starling class in frame 1. We'll access the Starling
		 * class dynamically once the SWF is completely loaded.
		 */
		private var _starling:Object;
		
		/**
		 * You'll get occasional progress updates here. event.bytesLoaded / event.bytesTotal
		 * will give you a value between 0 and 1. Multiply by 100 to get a value
		 * between 0 and 100. For the nearest integer, use Math.floor().
		 */
		private function loaderInfo_progressHandler(event:ProgressEvent):void
		{
			//this example draws a basic progress bar
			this.graphics.clear();
			this.graphics.beginFill(0);// xcccccc);
			this.graphics.drawRect(0, (this.stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2,
				this.stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
			this.graphics.endFill();
		}
		
		/**
		 * The entire SWF has finished loading when this listener is called.
		 */
		private function loaderInfo_completeHandler(event:Event):void
		{
			//get rid of the progress bar
			this.graphics.clear();
			
			//go to frame two because that's where the classes we need are located
			this.gotoAndStop(2);
			
			//getDefinitionByName() will let us access the classes without importing
			var RootType:Class = getDefinitionByName("Game") as Class;
			var StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			this._starling = new StarlingType(RootType, this.stage);
			//this._starling.showStats = true;
			this._starling.antiAliasing = 0;
			this._starling.start();
			
			//that's it!
		}
	}
}