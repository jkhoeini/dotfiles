import { createClient } from "anytypeHelper@v1";

export function main(args) {
  var client = createClient({
    apiBaseUrl: env.ANYTYPE_API_URL,
    apiKey: env.ANYTYPE_API_KEY,
    spaceId: env.ANYTYPE_SPACE_ID
  });

  console.log("=== FETCHING HOME PAGE ===");
  var homeObjects = client.getObjects("page");
  if (homeObjects.error) {
    console.log("Error getting pages: " + homeObjects.error);
    return;
  }

  var homePage = null;
  for (var i = 0; i < homeObjects.length; i++) {
    if (homeObjects[i].name === "Home" || homeObjects[i].name === "home") {
      homePage = homeObjects[i];
      break;
    }
  }

  if (!homePage) {
    console.log("Home page not found. Available pages:");
    for (var i = 0; i < homeObjects.length; i++) {
      console.log("  - " + homeObjects[i].name + " (id: " + homeObjects[i].id + ")");
    }
    return;
  }

  console.log("\nHome Page: " + homePage.name + " (id: " + homePage.id + ")");

  // Get full home page content
  var homePageFull = client.getObject(homePage.id);
  if (!homePageFull) {
    console.log("Could not fetch home page content");
    return;
  }

  console.log("\n=== SEARCHING FOR TASKS ===");
  var taskResults = client.search("task");
  if (taskResults.error) {
    console.log("Error searching tasks: " + taskResults.error);
  } else {
    console.log("Found " + taskResults.length + " task-related items:");
    for (var i = 0; i < Math.min(taskResults.length, 10); i++) {
      console.log("  - " + taskResults[i].name + " (type: " + taskResults[i].type.name + ")");
    }
    if (taskResults.length > 10) {
      console.log("  ... and " + (taskResults.length - 10) + " more");
    }
  }

  console.log("\n=== ALL OBJECT TYPES ===");
  var allTypes = client.getTypes();
  if (allTypes.error) {
    console.log("Error getting types: " + allTypes.error);
    return;
  }

  console.log("Total types: " + allTypes.length);

  var taskRelatedTypes = [];
  for (var i = 0; i < allTypes.length; i++) {
    var typeName = allTypes[i].name.toLowerCase();
    if (typeName.includes("task") || typeName.includes("todo") || typeName.includes("goal") ||
        typeName.includes("project") || typeName.includes("action") || typeName.includes("issue")) {
      taskRelatedTypes.push(allTypes[i]);
    }
  }

  console.log("\nTask-related types found: " + taskRelatedTypes.length);
  for (var i = 0; i < taskRelatedTypes.length; i++) {
    var t = taskRelatedTypes[i];
    console.log("  - " + t.name + " (key: " + t.key + ")");

    // Get details about this type
    var typeDesc = client.describeType(t.key);
    if (typeDesc && typeDesc.properties) {
      console.log("    Properties: " + typeDesc.properties.map(function(p) { return p.name; }).join(", "));
    }
  }

  console.log("\n=== PROPOSAL ===");
  console.log("Based on your current setup, here's a recommended task management structure:");
  console.log("\n1. HIERARCHY:");
  console.log("   - Project (parent container)");
  console.log("   - Task (individual work items)");
  console.log("   - Subtask (granular breakdown)");
  console.log("\n2. KEY PROPERTIES:");
  console.log("   - Status: Backlog → In Progress → Review → Done");
  console.log("   - Priority: Urgent, High, Medium, Low");
  console.log("   - Assignee: Person responsible");
  console.log("   - Due Date: Deadline");
  console.log("   - Parent: Link to parent task/project");
  console.log("\n3. VIEWS:");
  console.log("   - My Tasks (filtered by Assignee = Me)");
  console.log("   - By Status (grouped by Status property)");
  console.log("   - By Project (grouped by Parent)");
  console.log("   - Upcoming (sorted by Due Date)");

  return {
    homePage: homePage,
    taskRelatedTypes: taskRelatedTypes,
    totalTypes: allTypes.length
  };
}
