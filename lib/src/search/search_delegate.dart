 
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart'; 
class DataSearch extends SearchDelegate{
  
  final peliculasProvider =  new PeliculasProvider();

  final peliculas = [
    'holis',
    'holis',
    'holis',
    'holis',
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar

    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query= '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izq de la appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress:  transitionAnimation,//tiempo en el qie se anima el icono
      ), 
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se van a mmostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text('hola'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias de busqueda
    /*final listaSugerida = (query.isEmpty) 
                        ? peliculasRecientes 
                        : peliculas.where(
                          (p)=> p.toLowerCase().startsWith(query.toLowerCase())
                          ).toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
        );
      }
    );*/

    if(query.isEmpty){return Container();}
    
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query), 
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas =  snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),                  
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  width: 50.0,
                  fit: BoxFit.cover
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId= '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList()
          );
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}