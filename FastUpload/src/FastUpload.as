package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	public class FastUpload extends Sprite
	{
		public function FastUpload()
		{
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x000000)
			sp.graphics.drawCircle(10,10,30)
			sp.graphics.endFill();
			this.addChild(sp);
			var mFileReference:FileReference=new FileReference();
			var swfTypeFilter:FileFilter = new FileFilter("SWF/JPG/PNG Files","*.jpeg; *.jpg;*.gif;*.png");
			sp.addEventListener(MouseEvent.CLICK,function():void{
				
				mFileReference.addEventListener(Event.SELECT, onFileSelected);
				
				var allTypeFilter:FileFilter = new FileFilter("All Files (*.*)","*.*");
				mFileReference.browse([swfTypeFilter, allTypeFilter]);
				
			});
			function onFileSelected(evt:Event):void{
				trace(evt.target);
				mFileReference.addEventListener(Event.COMPLETE, onFileLoaded);
				
				// This callback will be called if there's error during uploading
				mFileReference.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
				
				// Optional callback to track progress of uploading
				mFileReference.addEventListener(ProgressEvent.PROGRESS, onProgress);
				mFileReference.load();
			}
			function onFileLoaded():void{
				var img:Loader=new Loader();
				img.loadBytes(mFileReference.data);
				img.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
					trace("ok");
					var bp:Bitmap=new Bitmap();
					bp=Bitmap(img.content);
					
					//addChild(bp);
					
					var byteArray:ByteArray = new ByteArray(); 
					
					bp.bitmapData.encode(bp.bitmapData.rect, new flash.display.JPEGEncoderOptions(), byteArray);
									
					
					
					var loader:URLLoader = new URLLoader();
					
					
					var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
					var header2:URLRequestHeader = new URLRequestHeader("x-username", "namename");
					var request:URLRequest=new URLRequest("http://uploader.dev/item/upload");
					//request.url="http://joehwang.appwed.com:3000/item/upload"
					
					request.requestHeaders.push(header);
					request.requestHeaders.push(header2);
					request.method = URLRequestMethod.POST;
					//request.contentType="application/octet-stream"
					
					/*Content-type", "application/octet-stream不支援post參數，改用header帶
					var myData:URLVariables = new URLVariables();
					myData.firstName = "Kirill";
					myData.lastName = "Poletaev";
					myData.img=byteArray;
					request.data=myData;
					*/
					request.data = byteArray;
					loader.load(request);
					img.unload();
					
					
				})
				//var bitmapData:BitmapData = new BitmapData(640,480,false,0x00FF00);
				//bitmapData.setPixels(new Rectangle(),mFileReference.data);
				
				
				
				
				
				mFileReference.removeEventListener(Event.COMPLETE,onFileLoaded);
				
			
				//mFileReference.upload(request,"filename");
				
				
			}
			function imgloadComplete(evt:Event):void{
				
				//var tempData:BitmapData=new BitmapData(loader.width,loader.height,false,null);
				//tempData.draw(loader);
				//var bitmap:Bitmap=new Bitmap(tempData);
				addChild(evt.target.content);
				//evt.target.contentLoaderInfo.removeEventListener(Event.COMPLETE,
			}
			function onFileLoadError():void{
				
			}
			function onProgress():void{
				
			}
		}
	}
}