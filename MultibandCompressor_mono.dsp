import("effect.lib");
import("filter.lib");
import("music.lib");

not(x) 	= abs(x-1);
mute		= not(checkbox("[0] mute [tooltip: Mute the whole band]"));
bypass(switch, block) = _ <: select2(switch, _, block);
bswitch	= checkbox("[0] bypass  [tooltip: Bypass the compressor, but not the bandpass filter]");

//Stereo
//process =   (_,_)<: hgroup("", gcomp1s , gcomp2s , gcomp3s, gcomp4s, gcomp5s) :>(_,_); 
gcomp1s = vgroup("[1] C1",bandpass1s:bypass2(bswitch,compressor_stereo(ratio,-push1,attack,release)):*(Makeup1),*(Makeup1));
gcomp2s = vgroup("[1] C2",bandpass2s:bypass2(bswitch,compressor_stereo(ratio,-push2,attack,release)):*(Makeup2),*(Makeup2));
gcomp3s = vgroup("[1] C3",bandpass3s:bypass2(bswitch,compressor_stereo(ratio,-push3,attack,release)):*(Makeup3),*(Makeup3));
gcomp4s = vgroup("[1] C4",bandpass4s:bypass2(bswitch,compressor_stereo(ratio,-push4,attack,release)):*(Makeup4),*(Makeup4));
gcomp5s = vgroup("[1] C5",bandpass5s:bypass2(bswitch,compressor_stereo(ratio,-push5,attack,release)):*(Makeup5),*(Makeup5));

//MONO
process =   _<: hgroup("", gcomp1m , gcomp2m , gcomp3m, gcomp4m, gcomp5m) :>_;
gcomp1m = vgroup("[1] C1",bandpass1:bypass(bswitch,compressor_mono(ratio,-push1,attack,release)): *(Makeup1));
gcomp2m = vgroup("[1] C2",bandpass2:bypass(bswitch,compressor_mono(ratio,-push2,attack,release)): *(Makeup2));
gcomp3m = vgroup("[1] C3",bandpass3:bypass(bswitch,compressor_mono(ratio,-push3,attack,release)): *(Makeup3));
gcomp4m = vgroup("[1] C4",bandpass4:bypass(bswitch,compressor_mono(ratio,-push4,attack,release)): *(Makeup4));
gcomp5m = vgroup("[1] C5",bandpass5:bypass(bswitch,compressor_mono(ratio,-push5,attack,release)): *(Makeup5));

hifr1			=hslider("[8] Low Shelf (hz)" ,80 , 20, 20000, 1);
lowfr2			=hslider("[7] Low2 (hz)",80,20,20000,1);
hifr2			=hslider("[8] High2 (hz)",210,20,20000,1);
lowfr3			=hslider("[7] Low3 (hz)",210,20,20000,1);
hifr3			=hslider("[8] High3 (hz)",1700,20,20000,1);
lowfr4			=hslider("[7] Low4 (hz)",1700,20,20000,1);
hifr4			=hslider("[8] High4 (hz)",5000,20,20000,1);
lowfr5			=hslider("[7] High Shelf (hz)",5000,20,20000,1);

bandpass1 	= lowpass(3,hifr1) ;
bandpass2 	= lowpass(3,hifr2) : highpass(3,lowfr2);
bandpass3 	= lowpass(3,hifr3) : highpass(3,lowfr3);
bandpass4 	= lowpass(3,hifr4) : highpass(3,lowfr4);
bandpass5 	= highpass(3,lowfr5);

bandpass1s = (bandpass1,bandpass1);
bandpass2s = (bandpass2,bandpass2);
bandpass3s = (bandpass3,bandpass3);
bandpass4s = (bandpass4,bandpass4);
bandpass5s = (bandpass5,bandpass5);

ratio 		= hslider("[9] Ratio [tooltip: Compression ratio]",2,1,100,1);
attack		= hslider("[A] Attack (sec) [tooltip: Time before the compressor starts to kick in]", 0.012, 0, 1, 0.001);
release 	= hslider("[B] Release (sec) [tooltip: Time before the compressor releases the sound]", 1.25, 0, 10, 0.01);

push1 		= hslider("[5] Makeup1 (db) [tooltip: Post amplification and threshold]"   , 13, -50, +50, 0.1) ; // threshold-=push ;  makeup+=push
push2 		= hslider("[5] Makeup2 (db) [tooltip: Post amplification and threshold]"   , 10, -50, +50, 0.1) ; // threshold-=push ;  makeup+=push
push3 		= hslider("[5] Makeup3 (db) [tooltip: Post amplification and threshold]"   , 4,  -50, +50, 0.1) ; // threshold-=push ;  makeup+=push
push4 		= hslider("[5] Makeup4 (db) [tooltip: Post amplification and threshold]"   , 8,  -50, +50, 0.1) ; // threshold-=push ;  makeup+=push
push5 		= hslider("[5] Makeup5 (db) [tooltip: Post amplification and threshold]"   , 11, -50, +50, 0.1) ; // threshold-=push ;  makeup+=push
safe 	= hslider("[6] Makeup-Threshold (db) [tooltip: Threshold correction, an anticlip measure]" , 2, 0, +10, 0.1) ; // makeup-=safe

Makeup1	=  mute* (not(bswitch)*(push1-safe)  : db2linear : smooth(0.999));
Makeup2	=  mute* (not(bswitch)*(push2-safe)  : db2linear : smooth(0.999));
Makeup3	=  mute* (not(bswitch)*(push3-safe)  : db2linear : smooth(0.999));
Makeup4	=  mute* (not(bswitch)*(push4-safe)  : db2linear : smooth(0.999));
Makeup5	=  mute* (not(bswitch)*(push5-safe)  : db2linear : smooth(0.999));

//Low end headsets: 13,10,4,8,11 (split 80,210,1700,5000)
//Mid-high end headsets: 17,20.5,20,10.5,10 (split 44,180,800,5000)
