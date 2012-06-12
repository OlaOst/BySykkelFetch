import std.conv;
import std.datetime;
import std.net.curl;
import std.stdio;
import std.xml;


void main(string args[])
{
  string racksResponse = cast(string)get("http://smartbikeportal.clearchannel.no/public/mobapp/maq.asmx/getRacks");

  auto racksRaw = "<stations>" ~ decode(getResponseData(racksResponse)) ~ "</stations>";
  auto xml = new Document(racksRaw);
  
  int[] rackIds;
  foreach (element; xml.elements)
  {
    if (element.tag.name == "station")
    {
      rackIds ~= to!int(to!string(element.items[0]));
    }
  }
  
  auto timeStamp = Clock.currTime.toISOString();  
  
  auto file = File(timeStamp ~ ".txt", "w");
  
  foreach (rackId; rackIds)
  {
    file.writeln(to!string(getRack(rackId)));
  }
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
