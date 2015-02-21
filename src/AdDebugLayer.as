package 
{
	import com.pozirk.ads.admob.AdEvent;
	import com.pozirk.ads.admob.AdMob;
	import com.pozirk.ads.admob.AdParams;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author rkardashov@gmail.com
	 */
	public class AdDebugLayer extends Sprite 
	{
		private var textDebug: TextField;
		private var admob: AdMob;
		
		public function AdDebugLayer() 
		{
			super();
			
			addChild(textDebug = new TextField(400, 300, ""));
			
			admob = new AdMob();
			admob.addEventListener(AdEvent.INIT_OK, onAdInitEvent);
			admob.addEventListener(AdEvent.INIT_FAIL, onAdInitEvent);
			admob.addEventListener(AdEvent.BANNER_SHOW_OK, onAdEvent);
			admob.addEventListener(AdEvent.BANNER_SHOW_FAIL, onAdEvent);
			admob.addEventListener(AdEvent.BANNER_LEFT_APP, onAdEvent);
			admob.addEventListener(AdEvent.BANNER_OPENED, onAdEvent);
			admob.addEventListener(AdEvent.BANNER_CLOSED, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_SHOW_OK, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_SHOW_FAIL, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_CACHE_OK, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_CACHE_FAIL, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_LEFT_APP, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_OPENED, onAdEvent);
			admob.addEventListener(AdEvent.INTERSTITIAL_CLOSED, onAdEvent);
			admob.init();
		}
		
		private function onAdInitEvent(e:AdEvent):void 
		{
			textDebug.text += "ad: " + e.type + ", data: " + e._data + "\n";
			admob.show(
				"ca-app-pub-9490544475276999/2019968860",
				AdParams.SIZE_BANNER, 
				AdParams.HALIGN_CENTER, AdParams.VALIGN_MIDDLE,
				"03E16624F3988D91386C254027B22854");
		}
		
		private function onAdEvent(e: AdEvent): void 
		{
			//trace("admob: " + e.type);
			textDebug.text += "ad event: " + e.type + ", data: " + e._data + "\n";
		}
	}
}