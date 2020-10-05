JSONObject json;
void setup() {
  
   
}

void draw() {
  
  println(getFollowers());
  exit();
}

int getFollowers() {
  json = loadJSONObject("https://www.instagram.com/thegreeneyl/?__a=1");
  int i = json.getJSONObject("graphql").getJSONObject("user").getJSONObject("edge_followed_by").getInt("count");
  return i;
}
