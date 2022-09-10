import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Movie {
  late int? adults;
  late String backdrop_path;
  late int id;
  late String original_language;
  late String original_title;
  late String overiew;
  late double popularity;
  late String poster_path;
  late String release_date;
  late String title;
  late bool video;
  late double vote_average;
  late int vote_count;

  Movie({
    required this.adults,
    required this.backdrop_path,
    required this.id,
    required this.original_language,
    required this.original_title,
    required this.overiew,
    required this.popularity,
    required this.poster_path,
    required this.release_date,
    required this.title,
    required this.video,
    required this.vote_average,
    required this.vote_count,
});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        adults: json['adults'],
        backdrop_path: json['backdrop_path'],
        id: json['id'],
        original_language: json['original_language'],
        original_title: json['original_title'],
        overiew: json['overview'],
        popularity: json['popularity'],
        poster_path: json['poster_path'],
        release_date: json['release_date'],
        title: json['title'],
        video: json['video'],
        vote_average: json['vote_average'],
        vote_count: json['vote_count'],
    );
  }

}

Future <List<Movie>> fetchMovie() async {
  final response = await http
      .get(Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=2c92ba2889f24e9d701516c4f53dbc53&language=en-US&page=1'));
  // print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body)['results'] as List)
        .map((e) => Movie.fromJson(e))
        .toList();
    // return Movie.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
class OneMovieContainer extends StatefulWidget {
  const OneMovieContainer({Key? key}) : super(key: key);

  @override
  State<OneMovieContainer> createState() => _OneMovieContainerState();
}

class _OneMovieContainerState extends State<OneMovieContainer> {
  // Future<Album> fetchAlbum() async {
  //   final response = await http
  //       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Album.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }
  late Future<Movie> futureMovie;

  @override
  void initState() {
    super.initState();
    // var d = fetchMovie();
    // print(d);
    check();
  }
  void check() async {
    var d = await fetchMovie();
    print(d[1].poster_path);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white30,
      ),
      // height: 300,
      child: FutureBuilder<List<Movie>>(
        future: fetchMovie(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data as List<Movie>;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    top: 5.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 5.0,
                  ),
                  child: MovieContainer(
                    poster: movies[index].poster_path,
                    title: movies[index].title,
                    overview: movies[index].overiew,
                    popularity: movies[index].popularity,
                      movie: movies[index],
                    index: index,
                  ),
                );
              }
            );
          }
          else {
            return Container(
              child: Text("This is just test"),
            );
          }
          if(snapshot.hasError) {
            print(snapshot.error.toString());
            return Text('error');
          }
        },
      )
    );
  }
}

class MovieContainer extends StatefulWidget {
  const MovieContainer({Key? key,required this.index, required this.movie, required this.poster, required this.title, required this.overview, required this.popularity}) : super(key: key);
  final String poster;
  final String title;
  final String overview;
  final double popularity;
  final Movie movie;
  final int index;
  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {

  @override
  Widget build(BuildContext context) {
    print(widget.movie.poster_path);
    print(widget.index);
    return Container(
      width: 300,
      padding: EdgeInsets.all(10.0),
      height: 450.0,
      alignment:Alignment.center,
      decoration: const BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.blue,
        //     offset: Offset(15, 15),
        //   )
        // ],
        color: Colors.white70,
        border: Border(
          top: BorderSide(
            color: Colors.black54,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          right: BorderSide(
            color: Colors.black54,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            color: Colors.black54,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          left: BorderSide(
            color: Colors.black54,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )
      ),
      child: Row(
        children: [
          Container(
            width: 170,
            height: 330,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500/${widget.poster}',
                ),
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Column(
          //     children : const<Widget> [
          //       Text("data")
          //     ]
          //   )
          // ),
          Container(
            width: 170,
            height: 330,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:  [
                  Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: Text(
                        widget.overview
                      // "Take me down to the river bend take me down to the fighting end Wash the poisin from of my skin show me how to be whole again fly me up in the silver wing past the black where siren sing warm me up in the novice glow. Drop me down to the dream below."
                    ),
                  ),
                   const SizedBox(
                     height: 10.0,
                   ),
                   Text("Popularity: ${widget.popularity}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
