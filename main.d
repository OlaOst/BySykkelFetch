import std.conv;
import std.net.curl;
import std.stdio;
import std.xml;


void main(string args[])
{
  string racks = cast(string)get("http://smartbikeportal.clearchannel.no/public/mobapp/maq.asmx/getRacks");
  
  writeln(getRack(1));
  writeln(getRack(2));
  writeln(getRack(3));
  writeln(getRack(4));
  writeln(getRack(5));
  writeln(getRack(6));
}


string getResponseData(string raw)
{
  check(raw);
  
  auto xml = new Document(raw);
  
  assert(xml.tag.name == "string");
  assert(xml.items.length > 0);
  
  return to!string(xml.items[0]);
}


struct Rack
{
  int id;
  
  int readyBikes;
  int emptyLocks;
  bool online;
  
  //string description;
  //string latitude;
  //string longitute;
}


Rack getRack(int rackId)
{
  string raw = cast(string)get("http://smartbikeportal.clearchannel.no/public/mobapp/maq.asmx/getRack?id=" ~ to!string(rackId));
    
  auto rackRaw = decode(getResponseData(raw));
  
  Rack rack;
  rack.id = rackId;
  
  auto xml = new Document(rackRaw);
  
  foreach (element; xml.elements)
  {
    if (element.tag.name == "ready_bikes")
      rack.readyBikes = to!int(to!string(element.items[0]));
      
    if (element.tag.name == "empty_locks")
      rack.emptyLocks = to!int(to!string(element.items[0]));
      
    if (element.tag.name == "online")
      rack.online = to!int(to!string(element.items[0])) == 1;
  }
  
  return rack;
}
