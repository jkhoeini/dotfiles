import { createClient } from "anytypeHelper@v1";

export function main(args) {
  var client = createClient({
    apiBaseUrl: env.ANYTYPE_API_URL,
    apiKey: env.ANYTYPE_API_KEY,
    spaceId: env.ANYTYPE_SPACE_ID
  });

  var report = {
    object_types: [],
    collections: [],
    home_page_items: [],
    task_related_objects: []
  };

  // 1. Get all types and filter for task-related ones
  var types = client.getTypes();
  if (!types.error) {
    for (var i = 0; i < types.length; i++) {
      var type = types[i];
      var isTaskRelated = type.key.toLowerCase().includes("task") ||
                          type.key.toLowerCase().includes("todo") ||
                          type.key.toLowerCase().includes("project") ||
                          type.name.toLowerCase().includes("task") ||
                          type.name.toLowerCase().includes("todo") ||
                          type.name.toLowerCase().includes("project");
      if (isTaskRelated) {
        report.object_types.push({
          key: type.key,
          name: type.name,
          description: type.description || "no description"
        });
      }
    }
  }

  // 2. Search for task objects
  var taskObjects = client.search("task");
  if (!taskObjects.error && taskObjects.length > 0) {
    for (var i = 0; i < taskObjects.length; i++) {
      var obj = taskObjects[i];
      report.task_related_objects.push({
        name: obj.name,
        type: obj.type ? obj.type.name : "unknown",
        id: obj.id
      });
    }
  }

  // 3. Get all objects (no filter) to find collections and home page
  var allObjects = client.getObjects();
  if (!allObjects.error) {
    for (var i = 0; i < allObjects.length; i++) {
      var obj = allObjects[i];

      // Check if it's a collection
      if (obj.type && obj.type.key === "collection") {
        report.collections.push({
          name: obj.name,
          id: obj.id
        });
      }

      // Check if it's on home page (look for pinned or dashboard objects)
      if (obj.layout === "dashboard" || (obj.type && obj.type.key === "dashboard")) {
        report.home_page_items.push({
          name: obj.name,
          type: obj.type ? obj.type.name : "unknown",
          id: obj.id
        });
      }
    }
  }

  // 4. Look for objects with status properties (common in task management)
  var statusObjects = client.search("status");
  if (!statusObjects.error && statusObjects.length > 0) {
    console.log("Found " + statusObjects.length + " objects with status property");
  }

  // 5. Get property names to understand available fields
  var props = client.getProperties();
  if (!props.error) {
    var taskProps = [];
    for (var i = 0; i < props.length; i++) {
      var prop = props[i];
      if (prop.key.toLowerCase().includes("task") ||
          prop.key.toLowerCase().includes("status") ||
          prop.key.toLowerCase().includes("due") ||
          prop.key.toLowerCase().includes("priority")) {
        taskProps.push(prop.key);
      }
    }
    if (taskProps.length > 0) {
      report.task_properties = taskProps;
    }
  }

  return report;
}
