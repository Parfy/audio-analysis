import ddf.minim.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioPlayer myAudio;
FFT         myAudioFFT;

int         myAudioRange     = 128;
int         myAudioMax       = 100;

float       myAudioAmp       = 20.0;
float       myAudioIndex     = 0.05;
float       myAudioIndexAmp  = myAudioIndex;
float       myAudioIndexStep = 0.025;

// ************************************************************************************

int         rectSize         = 2;
int         a                = 1;

int         stageMargin      = 100;
int         stageWidth       = (myAudioRange * rectSize) + (stageMargin * 2);
int         stageHeight      = 700;

float       xStart           = stageMargin;
float       yStart           = stageMargin;
int         xSpacing         = rectSize;

// ************************************************************************************

color       bgColor          = #333333;

// ************************************************************************************

void setup() {
	size(1024, 700);
	background(bgColor);

	minim   = new Minim(this);
	myAudio = minim.loadFile("Koreless_-_4D.wav");
	myAudio.play();

	myAudioFFT = new FFT(myAudio.bufferSize(), myAudio.sampleRate());
	myAudioFFT.linAverages(myAudioRange);

	/*

	https://en.wikipedia.org/wiki/Window_function

	myAudioFFT.window(FFT.NONE);

	myAudioFFT.window(FFT.BARTLETT);
	myAudioFFT.window(FFT.BARTLETTHANN);
	myAudioFFT.window(FFT.BLACKMAN);
	myAudioFFT.window(FFT.COSINE);
	myAudioFFT.window(FFT.GAUSS);
	myAudioFFT.window(FFT.HAMMING);
	myAudioFFT.window(FFT.HANN);
	myAudioFFT.window(FFT.LANCZOS);
	myAudioFFT.window(FFT.TRIANGULAR);

	*/
	myAudioFFT.window(FFT.COSINE);
}

void draw() {
	// background(bgColor);
  stroke(255, 100);
  strokeWeight(0.5);
  //translate(-a,0);

	myAudioFFT.forward(myAudio.mix);

	for (int i = 0; i < myAudioRange; ++i) {
		float tempIndexAvg = (myAudioFFT.getAvg(i) * myAudioAmp) * myAudioIndexAmp;
		 line(a, height/myAudioRange*i+50, a, height/myAudioRange*i-tempIndexAvg+50);

		myAudioIndexAmp+=myAudioIndexStep;
	}
	myAudioIndexAmp = myAudioIndex;

  a++;
  if(a > width){
    background(bgColor);
    a=0;
  }
  
	// when song is done, let's save an image and exit the sketch
	if (!myAudio.isPlaying()) {
		saveFrame("../01_window_NONE.png");
		exit();
	}
}

void stop() {
	myAudio.close();
	minim.stop();  
	super.stop();
}