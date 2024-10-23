/// This script avoid cache conflict when the old version is present in cache
/// but a new version is already deployed.

/// The mechanism is simple:
///  - it compares the cached version of the website and the online one by making a real request

console.log("Entering version check");

const MANIFEST = "flutter-app-manifest";
const TEMP = "flutter-temp-cache";
const CACHE_NAME = "flutter-app-cache";

const CORE = [
  "main.dart.js",
  "index.html",
  "flutter_bootstrap.js",
  "assets/AssetManifest.bin.json",
  "assets/FontManifest.json",
];

async function getVersion({isOnline=false}) {
  console.log("Getting online version...");
  /// Get online version
  var version = [];
  try {
      var response = await fetch(new Request("version.json",{
          cache: isOnline ? "no-store" : "only-if-cached",
          mode:"same-origin",
      }));

      if (response.ok) {
        var data =  await response.json();
              console.log('Successfully got version.json', isOnline ? " online." : " from cache.", "\n version:", data);
              // Handle data
              version[0] = data.version;
              version[1] = data.build_number;
              console.log(isOnline ? "Online" : "Cache", " version is", version);
          
      } else {
          // handle case where there's no cached response
          console.log("No version.json file got from ", isOnline ? "online" : "cache", " resource", response);
      }
  } catch (error) {
      // Handling error
      console.log("Error getting ", isOnline ? " online" : " local", " version.json:", error);
      return;
  }
  console.log("[getVersion] Version is:", version);
  return version;
}

async function checkCache() {
  var onlineVersion = await getVersion({
      isOnline: true
  });
  var cachedVersion = await getVersion({
      isOnline: false
  });

  console.log("Online version is :", onlineVersion);
  console.log("Cached version is :", cachedVersion);

  if (onlineVersion && cachedVersion) {
      if (onlineVersion != cachedVersion) {
          /// In case the two version is different
          /// empty cache
          console.log("Clearing cache");
          await caches.delete(MANIFEST);
          await caches.delete(CACHE_NAME);
          await caches.delete(TEMP);
      } else {
          console.log("The app is up to date.");
      }
  }
}

(async () => {
  await checkCache();
})();

{{flutter_js}}
{{flutter_build_config}}

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');
const userConfig = renderer ? {'renderer': renderer} : {};

_flutter.loader.load({config: userConfig,
    serviceWorkerSettings: {
      serviceWorkerVersion: {{flutter_service_worker_version}},
    },
});