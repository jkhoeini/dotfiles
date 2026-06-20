import { requestChallenge } from "anytypeHelper@v1";

export function main() {
  var challenge = requestChallenge({
    baseUrl: env.ANYTYPE_API_URL || "http://127.0.0.1:31009"
  });
  console.log("Challenge response:");
  console.log(JSON.stringify(challenge, null, 2));
  return challenge;
}
