const ssbkeys = require('ssb-keys')
const protobuf = require('protocol-buffers')

const protodefs = `
syntax = "proto3";

message Message {
  string author    = 1;
  int64  seq       = 2;
  int64  timestamp = 3;
  string previous  = 4;
  string type      = 5;
  bytes content    = 6;
}

message Post {
  string title    = 1;
  string text     = 2;
  string channel  = 3;
  string root     = 4;
  string branch   = 5;
  string mentions = 6;
  string recps    = 7;
}

message Contact {
  string contact = 1;
  bool following = 2;
  bool blocking  = 3;
}

message Vote {
  string link   = 1;
  int64  value  = 2;
  string reason = 3;
}

message About {
  string about = 1;
  string name  = 2;
  string image = 3;
}`

let protos = protobuf(protodefs)

const clean = (obj) => {
  Object.keys(obj).forEach((key) => (obj[key] === null || obj[key] === undefined || obj[key] === "" || obj[key] === [] ) && delete obj[key]);
  return obj
}

function make(keys, type, content, seq, previous, timestamp) {
    let encoder = null
    if (type === 'post') {
      encoder = protos.Post
    } else if (type === 'about') {
      encoder = protos.About
    } else if (type === 'contact') {
      encoder = protos.Contact
    } else if (type === 'vote') {
      encoder = protos.Vote
    }
    content = clean(content)
    let encoded = encoder.encode(content)
    let msg = {
      type: type,
      author: keys.id,
      seq: (seq + 1),
      previous: previous,
      timestamp: timestamp,
      content: encoded
    }
    let msg_encoded = protos.Message.encode(msg)
    console.log(msg_encoded)
    let hash = ssbkeys.hash(msg_encoded)
    console.log("hash")
    console.log(hash)
    console.log(msg)
    let sig = ssbkeys.sign(keys, hash)
    console.log(sig)
    msg.content = content
    msg.key = '~' + hash.toString('base64')+'.sha256'
    msg.sig = sig
    console.log(msg)
    console.log(JSON.stringify(msg))
}

let mykeys = {"curve":"ed25519","public":"F/ppD+ctQ9QBAQeUEohuozajzt0svgGCDgNaRBWNl9g=.ed25519","private":"/uDfKp30mfOj9ZL0xiOdCprCJIF6Y66zuCsSfxeNUO8X+mkP5y1D1AEBB5QSiG6jNqPO3Sy+AYIOA1pEFY2X2A==.ed25519","id":"@F/ppD+ctQ9QBAQeUEohuozajzt0svgGCDgNaRBWNl9g=.ed25519"}
make(mykeys, "post", {title: "hello", text: ""}, 0, "abc", 10000)




