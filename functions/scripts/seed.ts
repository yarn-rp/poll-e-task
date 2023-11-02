import * as admin from "firebase-admin";
import * as fs from "fs";
import * as path from "path";

const LOCALHOST = "localhost";

const firebaseConfigPath = path.join("./../", "firebase.json"); // adjust the path as needed
let emulatorHost = `${LOCALHOST}:8080`; // default value

try {
  const firebaseConfig = JSON.parse(fs.readFileSync(firebaseConfigPath, "utf8"));
  if (firebaseConfig.emulators && firebaseConfig.emulators.firestore) {
    const { port } = firebaseConfig.emulators.firestore;
    emulatorHost = `${LOCALHOST}:${port}`;
  }
} catch (error) {
  console.error("Error reading firebase.json:", error);
}

process.env.FIRESTORE_EMULATOR_HOST = emulatorHost;
// TODO(yarn-rp): receive project id from command line
process.env.GCLOUD_PROJECT = "polletask-dev";

admin.initializeApp();

const seedFirestore = async () => {
  const db = admin.firestore();

  const platforms = [
    {
      auth: {
        type: "oauth2",
        url: "https://auth.atlassian.com/authorize?audience=api.atlassian.jcom&client_id=go6jWIm4a4CI09cNNGqdI7swLJuawOXu&scope=read:me%20offline_access%20read:jira-work%20read:jira-user%20write:jira-work%20manage:jira-webhook&redirect_uri=http://localhost:3000/integrations/jira/create&state=120384019238401923840129384&response_type=code&prompt=consent",
      },
      description: "Jira",
      iconUrl: "https://static-00.iconduck.com/assets.00/jira-icon-512x512-kkop6eik.png",
      id: "jira",
      name: "Jira",
      type: "task",
    },
    {
      auth: {
        type: "oauth2",
        url: "https://github.com/login/oauth/authorize?scope=user,repo&client_id=55a08be7f48b99c70fe1",
      },
      description: "Github",
      iconUrl: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
      id: "github",
      name: "Github",
      type: "task",
    },
    {
      auth: {
        type: "oauth2",
        url: "https://accounts.google.com/o/oauth2/v2/auth?client_id=333437725100-fkatvvanoa1o7lt9kfbb6ievgpkslroi.apps.googleusercontent.com&redirect_uri=http://localhost:3000/integrations/google-calendar/create&response_type=code&access_type=offline&scope=https://www.googleapis.com/auth/calendar.events%20https://www.googleapis.com/auth/calendar%20https://www.googleapis.com/auth/userinfo.profile",
      },
      description: "Google Calendar",
      iconUrl: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png",
      id: "google-calendar",
      name: "Google Calendar",
      type: "event",
    },
  ];

  console.info("Seeding Platforms Started on port", emulatorHost);
  // save platforms
  platforms.map(async (platform) => {
    await db.collection("platforms").doc(platform.id).set(platform);
  });

  console.log("Seeding Platforms Complete");
};

seedFirestore();
