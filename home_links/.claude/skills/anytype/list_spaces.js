import { createClient } from "anytypeHelper@v1";

export function main(args) {
  console.log("API URL: " + env.ANYTYPE_API_URL);
  console.log("Space ID: " + env.ANYTYPE_SPACE_ID);
  console.log("API Key: " + (env.ANYTYPE_API_KEY ? "set" : "not set"));

  var client = createClient({
    apiBaseUrl: env.ANYTYPE_API_URL,
    apiKey: env.ANYTYPE_API_KEY,
    spaceId: env.ANYTYPE_SPACE_ID
  });

  var spaces = client.listSpaces();
  return spaces;
}
