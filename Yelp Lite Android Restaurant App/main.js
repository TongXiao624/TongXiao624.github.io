
'use strict';

// [START gae_node_request_example]
const express = require('express');
const path = require("path");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.static(process.cwd()+"/frontend/dist/frontend/"));
app.get('/', function (req, res) {
  //res.send("Hello! This is my Node.js Express!");
  res.sendFile(process.cwd()+"/frontend/dist/frontend/index.html");
  console.log(process.cwd());
});

app.get('/searchJson',function (req,res){
  console.log(req.query.key);
  var response = {
    "term" : req.query.key,
    "location" : req.query.location,
    "radius" : req.query.distance,
    "categories" : req.query.category
  };
  if(response.categories == "Default"){
    response.categories  = "all";
  }
  if(parseInt(response.radius) > 40000){
    response.radius = "40000";
  }
  (function (){
    var https = require("https");
    var new_symbol = "term="+response.term+"&location="+response.location+"&radius="+response.radius+"&categories="+response.categories;
    var RcvMessage = ""; 
    var RcvList;
    var option={
      host : "api.yelp.com",
      path : "/v3/businesses/search?" + new_symbol,
      headers : {"Authorization":"Bearer DY77rAcLHjoj-2VcD_sc-X_mlABpjTLz6hLGwbLDGCYtTVGwfbWeTmfCmGC_0qUXjCzcqXld-gnXjjC8ATzuyg2XvzPw__GZTZ1Ho9YJiRVjov6Zdy5t0oCLeZcnY3Yx"},
      method : "GET"
    };
    //console.log("/v3/businesses/search?"+ new_symbol)
    var reqYelp=https.request(option, (resYelp) => {
      console.log("The Status Code is %i}",resYelp.statusCode);
      //console.log('The Headers are:', resYelp.headers);
      resYelp.on("data", function(chunk) {
        console.log(`The content is: ${chunk}`);
        RcvMessage += chunk;
      });
      resYelp.on("end", function() {
        console.log(`There's no DATA in RESPONSE now.`);
        res.send(RcvMessage);
      });
    });
    reqYelp.on('error', (e) => {
      console.error(`There exits some errors during the REQUEST: ${e.message}`);
    });
    reqYelp.end();
  })();
  //console.log(resList);
  //res.send(resList);
});

app.get('/autoMatch',function (req,res){
  var reqKey = req.query.key;
  console.log(reqKey);
  (function(){
    var https = require("https");
    var autoMsg = "";
    var option={
      host : "api.yelp.com",
      path : "/v3/autocomplete?text=" + reqKey,
      headers : {"Authorization":"Bearer DY77rAcLHjoj-2VcD_sc-X_mlABpjTLz6hLGwbLDGCYtTVGwfbWeTmfCmGC_0qUXjCzcqXld-gnXjjC8ATzuyg2XvzPw__GZTZ1Ho9YJiRVjov6Zdy5t0oCLeZcnY3Yx"},
      method : "GET"
    };
    var autoReq = https.request(option, (autoRes) =>{
      console.log("The Status Code is %i}",autoRes.statusCode);
      //console.log('The Headers are:', resYelp.headers);
      autoRes.on("data", (match) =>{
        console.log(`The content is: ${match}`)
        autoMsg += match;
      });
      autoRes.on("end",() =>{
        console.log(`There's no DATA in RESPONSE now.`);
        res.send(autoMsg);
      })
    });
    autoReq.on('error', (error) =>{
      console.error(`There exits some errors during the REQUEST: ${error.message}`);
    });
    autoReq.end();
  })();
});

app.get('/searchJson/reviews',function (req,res){
  console.log(reqid);
  var reqid = req.query.id;
  (function(){
    var https = require("https");
    var reviewMsg = "";
    var option={
      host : "api.yelp.com",
      path : "/v3/businesses/" + reqid + "/reviews",
      headers : {"Authorization":"Bearer DY77rAcLHjoj-2VcD_sc-X_mlABpjTLz6hLGwbLDGCYtTVGwfbWeTmfCmGC_0qUXjCzcqXld-gnXjjC8ATzuyg2XvzPw__GZTZ1Ho9YJiRVjov6Zdy5t0oCLeZcnY3Yx"},
      method : "GET"
    };
    var reviewReq = https.request(option, (reviewRes) =>{
      console.log("The Status Code is %i}",reviewRes.statusCode);
      //console.log('The Headers are:', resYelp.headers);
      reviewRes.on("data", (reviews) =>{
        console.log(`The content is: ${reviews}`)
        reviewMsg += reviews;
      });
      reviewRes.on("end",() =>{
        console.log(`There's no DATA in RESPONSE now.`);
        res.send(reviewMsg);
      })
    });
    reviewReq.on('error', (error) =>{
      console.error(`There exits some errors during the REQUEST: ${error.message}`);
    });
    reviewReq.end();
  })();
});

app.get('/searchJson/details',function (req,res){
  var reqId = req.query.id;
  console.log(reqId);
  (function(){
    var https = require("https");
    var detailMsg = "";
    var option={
      host : "api.yelp.com",
      path : "/v3/businesses/" + reqId,
      headers : {"Authorization":"Bearer DY77rAcLHjoj-2VcD_sc-X_mlABpjTLz6hLGwbLDGCYtTVGwfbWeTmfCmGC_0qUXjCzcqXld-gnXjjC8ATzuyg2XvzPw__GZTZ1Ho9YJiRVjov6Zdy5t0oCLeZcnY3Yx"},
      method : "GET"
    };
    var detailReq = https.request(option, (detailRes) =>{
      console.log("The Status Code is %i}",detailRes.statusCode);
      //console.log('The Headers are:', resYelp.headers);
      detailRes.on("data", (details) =>{
        console.log(`The content is: ${details}`)
        detailMsg += details;
      });
      detailRes.on("end",() =>{
        console.log(`There's no DATA in RESPONSE now.`);
        res.send(detailMsg);
      })
    });
    detailReq.on('error', (error) =>{
      console.error(`There exits some errors during the REQUEST: ${error.message}`);
    });
    detailReq.end();
  })();
});

// Start the server
const PORT = parseInt(process.env.PORT) || 8080;
const ADDRESS = process.env.ADDRESS || "192.168.137.1";
//const STATUS = parseInt(process.env.Status);
var server = app.listen(PORT, function(){
  //var hostName = server.address().address;
  console.log("App listening on address:https://%s:%i",ADDRESS,PORT);
  console.log('Press Ctrl+C to quit.');
  //console.log("The Server status now is %i",STATUS)
});
// [END gae_node_request_example]

module.exports = app;
