import 'dart:developer';

import"package:flutter/material.dart";

class page2 extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        appBar: AppBar(
          title: Text("caasho"),
        ),
        body: Column(
        
        
          children: [
          // padding: const EdgeInsets.symmetric(horizontal:45.0),
          // margin: EdgeInsets.all(45.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal:45.0),
            margin: EdgeInsets.all(70.0),
            child:Text("selecet Card icon",
           
           style:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
              color: Colors.black
              ),
          ),
          
          ),
          Row(
         
          
          children:[
            
           Container(
              margin: EdgeInsets.all(20.0),
              padding:EdgeInsets.all(15.0), 
              decoration: BoxDecoration(
              color: Colors.grey,
             borderRadius: BorderRadius.circular(13)),
          
             
          child:Icon(
                Icons.search,
                color: Colors.black,
                size: 60.0,
          )
           ),
             Container(
             margin: EdgeInsets.all(20.0),
             padding:EdgeInsets.all(15.0),
             decoration: BoxDecoration(
              color: Colors.grey,
             borderRadius: BorderRadius.circular(13)), 
          
          
            child:Icon(
                Icons.photo,
                color: Colors.black,
                size: 60.0,
            ),
             ),
             
               Container(
                  margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              
             borderRadius: BorderRadius.circular(13)),
             padding:EdgeInsets.all(15.0), 
          
             child:Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 60.0,
                
            )
               ),

               
           
            
            ],
          ),
          ]
    ),
      ),
    );
    

          
  
  }
    
          

   
  }
          
  
       
        
      
        
      
      
      
        
      

  


        
        
          
          
          
        
  
