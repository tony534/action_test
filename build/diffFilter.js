const fs = require('fs');
const path = require('path');
const readline = require('readline');

const sourceDiffFileName = 'diff.txt';
const targetDiffFileName = 'newDiff.txt' ;
const statusDiffFileName = 'diffStatus.txt' ;
const tempFolder = 'temp' ;

function filterDiff(filterCallback){
  let rl1 = readline.createInterface({
    input: fs.createReadStream(path.join(__dirname, '..', tempFolder, statusDiffFileName))
  });

  let deletedFileSet = new Set();

  function removeDeletedFiles(line){
    if(line){
      if(line.match(/^D\s+/)){
        deletedFileSet.add(line.replace(/\w+\s+/, ''));
      }
    }
  }
  rl1.on('line', removeDeletedFiles)
  .on('close', ()=>{ 
    if(deletedFileSet.size > 0){
      filterCallback( deletedFileSet ) 
    }else{
      console.log('there is no deleted file');
      fs.renameSync(path.join(__dirname, '..', tempFolder, sourceDiffFileName), path.join(__dirname, '..', tempFolder, targetDiffFileName));
    }
  })
}

function filterCallback(deletedFileSet){
  let rl2 = readline.createInterface({
    input: fs.createReadStream(path.join(__dirname, '..', tempFolder, sourceDiffFileName)),
    output: fs.createWriteStream(path.join(__dirname,'..', tempFolder, targetDiffFileName))
  });

  rl2.on('line', deleteFile);
   
  function deleteFile(line){
     if(!deletedFileSet.has(line)){
        this.output.write(line + '\n');
     } 
  }
}

filterDiff(filterCallback);