JSONObject json;
void setup() {
  json = loadJSONObject("https://www.instagram.com/thegreeneyl/?__a=1");
   
}

void draw() {
  int i = json.getJSONObject("graphql").getJSONObject("user").getJSONObject("edge_followed_by").getInt("count");
  println(i);
  exit();
}
