package ;

import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;

/**
 * Simple multitouch example - tested with iOS
 * @author James Frost (@frosty - http://www.jamesfrost.co.uk)
 */

class Main extends Sprite 
{
	// Keep track of whether multitouch is supported on this device
	private var multiTouchSupported : Bool;
	// Store our 
	private var touches : Map<Int,Sprite>;
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// Add an FPS counter
        var fps : FPS = new FPS();
        addChild(fps);
        
        // Declare our touches hash
		touches = new Map<Int,Sprite>();
		
		// Find out whether multitouch is supported
		multiTouchSupported = Multitouch.supportsTouchEvents;
		if (multiTouchSupported)
		{
			// If so, set the input mode and hook up our event handlers
			// TOUCH_POINT means simple touch events will be dispatched, 
			// rather than gestures or mouse events
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		trace("Using multitouch: " + multiTouchSupported);
	}
	
	private function onTouchBegin(e:TouchEvent):Void 
	{
		trace("onTouchBegin");

		// Create a new sprite with a random colour
		var touchSprite = new Sprite();
		var fill = (Std.int (Math.random () * 0xFFFFFF) );
		touchSprite.graphics.beginFill(fill);
		touchSprite.graphics.drawCircle(0, 0, Lib.current.stage.dpiScale * 50);
		touchSprite.graphics.endFill();

		// Move the sprite to the same position as the touch
		touchSprite.x = e.stageX;
		touchSprite.y = e.stageY;
	
		addChild(touchSprite);

		// Put the sprite into our touches array, referenced by touch ID
		touches.set(e.touchPointID, touchSprite);
	}

	private function onTouchMove(e:TouchEvent):Void 
	{
		trace("onTouchMove");

		// Find the matching sprite in our touches array
		var touchSprite : Sprite = touches.get(e.touchPointID);

		// Update its position
		touchSprite.x = e.stageX;
		touchSprite.y = e.stageY;
	}
	
	private function onTouchEnd(e:TouchEvent):Void 
	{
		trace("onTouchEnd");

		// Find the matching sprite in our touches array
		var touchSprite : Sprite = touches.get(e.touchPointID);
		
		// Remove the sprite from the stage and the array
		removeChild(touchSprite);
		touches.remove(e.touchPointID);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
		stage.align = openfl.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	
}