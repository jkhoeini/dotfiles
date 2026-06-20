import { createClient } from "anytypeHelper@v1";

export function main(args) {
  var client = createClient({
    apiBaseUrl: env.ANYTYPE_API_URL,
    apiKey: env.ANYTYPE_API_KEY,
    spaceId: env.ANYTYPE_SPACE_ID
  });

  // Search for objects with "values" or "home"
  var results = client.search("values OR core values OR system of values");

  if (results.error) {
    console.log("Search error: " + results.error);
    return results;
  }

  console.log("Found " + results.length + " results");

  // Get details for each result
  var details = [];
  for (var i = 0; i < results.length; i++) {
    var obj = client.getObject(results[i].id);
    if (obj) {
      details.push({
        name: obj.name,
        type: obj.type.name,
        text: results[i].text
      });
    }
  }

  return details;
}
