import 'dart:ffi';

import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audio_player_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';


class MusicPlayerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _Backgroung(),
          Column(
            children: <Widget>[
              SafeArea(child: CustomAppBar()),
              _ImagenDiscoDuracion(),
              _TituloPlay(),
              Expanded(child: _Letra())
            ],
          ),
        ],
      ),
   );
  }
}

class _Backgroung extends StatelessWidget {
  const _Backgroung({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height*0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333e),
            Color(0xff201e28)
          ]
        )
      ),
    );
  }
}

class _Letra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics= getLyrics();
    final estilo= TextStyle(fontSize: 20,color: Colors.white.withOpacity(0.6));
    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        itemExtent: 42, 
        diameterRatio: 1.5,
        children: lyrics.map((e) => Text(e,style: estilo,)).toList()
      ),
    );
  }
}

class _TituloPlay extends StatefulWidget {
  @override
  __TituloPlayState createState() => __TituloPlayState();
}

class __TituloPlayState extends State<_TituloPlay> with SingleTickerProviderStateMixin {

  bool isPlaying = false;
  bool firsTime = true;
  AnimationController playAnimation;

  final assetsAudioPlayer = new AssetsAudioPlayer.newPlayer();

  @override
  void initState() {
    this.playAnimation = new AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open(){
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context,listen: false);

    assetsAudioPlayer.open(
      Audio("assets/Breaking-Benjamin-Far-Away.mp3"),
      showNotification: true,
    );

    assetsAudioPlayer.currentPosition.listen((duration) { 
      audioPlayerModel.current=duration;
    });

    assetsAudioPlayer.current.listen((playingAudio) { 
      audioPlayerModel.songDuration=playingAudio.audio.duration;
    });

    assetsAudioPlayer.playlistFinished.listen((finished){
      if (finished) {
        this.playAnimation.stop();
        audioPlayerModel.controller.stop();
        this.isPlaying=false;
      }
    });
    assetsAudioPlayer.isPlaying.listen((playing){
      if (playing) {
        this.playAnimation.forward();
        audioPlayerModel.controller.repeat();
        this.isPlaying=true;
      }else{
        this.playAnimation.reverse();
        audioPlayerModel.controller.stop();
        this.isPlaying=false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("Far Away", style: TextStyle(fontSize: 30,color:Colors.white.withOpacity(0.8)),),
              Text("Breaking Benjamin", style: TextStyle(fontSize: 15,color:Colors.white.withOpacity(0.5)),)
            ],
          ),
          Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Color(0xfff8cb51),
            onPressed: (){
               final audioPlayerModel= Provider.of<AudioPlayerModel>(context,listen: false);
              if (this.isPlaying) {
                this.playAnimation.reverse();
                audioPlayerModel.controller.stop();
                this.isPlaying=false;
              } else {
                this.playAnimation.forward();
                audioPlayerModel.controller.repeat();
                this.isPlaying=true;
              }
              if(firsTime){
                this.open();
                firsTime=false;
              }else{
                assetsAudioPlayer.playOrPause();
              }
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: this.playAnimation
            )
          )
        ],
      ),
    );
  }
}

class _ImagenDiscoDuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top:70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _ImagenDisco(),
          _BarraProgreso(),
        ],
      ),
    );
  }
}

class _BarraProgreso extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color:Colors.white.withOpacity(0.4));
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;
    return Container(
      child: Column(
        children: <Widget>[
          Text('${audioPlayerModel.songTotalDuration}',style:estilo),
          SizedBox(height: 10,),
          Stack(
            children: <Widget>[
              Container(
                height: 230,
                width: 3,
                color:Colors.white.withOpacity(0.1)
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 230 * porcentaje,
                  width: 3,
                  color:Colors.white.withOpacity(0.8)
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Text('${audioPlayerModel.currentSecond}',style:estilo),
        ],
      ),
    );
  }
}

class _ImagenDisco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel= Provider.of<AudioPlayerModel>(context);
    return Container(
      width: 250,
      height: 250,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1e1c24)
          ]
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SpinPerfect(
              duration: Duration(seconds: 10),
              animate: false,
              infinite: true,
              manualTrigger: true,
              controller: (animationController)=>audioPlayerModel.controller=animationController,
              child: Image(image: AssetImage('assets/aurora.jpg'))
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color:Colors.black38,
                borderRadius: BorderRadius.circular(100)
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color:Color(0xff1c1c25),
                borderRadius: BorderRadius.circular(100)
              ),
            )
          ],
        ),
      ),
    );
  }
}