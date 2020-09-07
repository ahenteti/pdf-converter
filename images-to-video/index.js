const fs = require('fs');
const path = require('path');
var videoshow = require('videoshow');

if (process.argv.length <= 2) {
    console.log("Usage: " + __filename + " path/to/directory");
    process.exit(-1);
}

const dir = process.argv[2];
const audio = __dirname + '/audio.mp3'

const videoOptions = {
  loop: 15, // seconds
  transition: true,
  size: '1920x1080'
}

var audioParams = {
  fade: true,
  delay: 1 // seconds
}
 
fs.readdir(dir, function(err, files) {
    if(err) { throw new Error(err); } 
    const pdf = files.find(file => /\.pdf$/.test(file));
    const videoFilename = path.basename(pdf, '.pdf') + '.mp4';
    const images = files.filter(file => /\.png$/.test(file));
    videoshow(images, videoOptions)
      .audio(audio, audioParams)
      .save(videoFilename)
      .on('error', function (err) {
        console.error('Error:', err)
      })
      .on('end', function (output) {
        console.log('video created with success :)')
      })
});
