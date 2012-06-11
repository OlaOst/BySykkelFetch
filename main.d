import std.conv;
import std.net.curl;
import std.stdio;


void main(string args[])
{
  string racks = cast(string)get("http://smartbikeportal.clearchannel.no/public/mobapp/maq.asmx/getRacks");
  
  string rack = getRack(1);
  
  writeln(rack);
}



string getRack(int rackId)
{
  string raw = cast(string)get("http://smartbikeportal.clearchannel.no/public/mobapp/maq.asmx/getRack?id=" ~ to!string(rackId));
  
  return raw;
}