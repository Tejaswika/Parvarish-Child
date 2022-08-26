import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardKidsResources extends StatefulWidget {
  String title;
  List<dynamic> resources;
  bool isExpanded;
  Function callback;
  CardKidsResources({
    Key? key,
    required this.title,
    required this.resources,
    this.isExpanded = false,
    required this.callback,
  }) : super(key: key);

  @override
  State<CardKidsResources> createState() => _CardKidsResourcesState();
}

class _CardKidsResourcesState extends State<CardKidsResources> {
  late final Uri url;
  List<Widget> generateResourceLinks() {
    if (!widget.isExpanded) {
      return [const SizedBox.shrink()];
    }
    List<Widget> resourceLinks = [];
    widget.resources.forEach(
      (resource) => resourceLinks.add(
        TextButton(
          onPressed: ()async {
   url = Uri.parse(resource);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
          },

          child: Text(resource.toString()),
      ),
    )
    );
    return resourceLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      //defaut color is white
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){widget.callback(widget.title);},
          child: ListTile(tileColor: const Color.fromARGB(255, 163, 81, 180),
            
            leading: Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white,),),
            trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
          ),
          ...generateResourceLinks()
        ],
      ),
    );
  }
}
