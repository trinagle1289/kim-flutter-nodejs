import * as fs from "node:fs";

let dirPath = "../../resources/video/20240321/";

fs.readdir(dirPath, function (err, files) {
  if (err) {
    return console.log("Read Path Error");
  }
  files.forEach(function (file) {
    console.log(file);
  });
});
