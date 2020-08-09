import React from 'react';

import { Upload, Button } from 'antd';
import { UploadOutlined } from '@ant-design/icons';
import './App.css';
import JSZip from 'jszip';
// import FileSaver from 'file-saver';
import uuid from './util/uuid.js';
import axios from 'axios';

let uploadPromise = null
const compressDir = (fileList) => {
  const zip = new JSZip(); //新建zip对象
  fileList.forEach( file => {
    file.uid = uuid()
    console.log(file.uid)
    const folders = file.webkitRelativePath.split('/') // [ "999", "666", "差旅费报销.pdf" ]
    let zipNode = zip
    const lastIndex = folders.length - 1
    folders.forEach((name, index) => {
      // 如果是文件 则直接新建文件
      if(index === lastIndex) {
        zipNode.file(name, file)
        return true
      }
      // 判断有没有这个文件夹
      let findItem = Object.keys(zipNode.files).some(key => {
        if(zipNode.files[key].name === name) {
          zipNode = zipNode.files[key]
          return true
        }
        return false
      })
      // 没有这个文件夹 要新建文件夹 然后往下走
      if(!findItem) {
        zipNode = zipNode.folder(name)
      }
    })
  })
  console.log("zip", zip)
  // zip.generateAsync({
  //   type:"blob",
  // }).then(content => {
  //   FileSaver.saveAs(content, 'test.zip')
  //   // resolve(content)
  //   console.log("content", content)
  // })
  return zip.generateAsync({
    type:"blob"
  })
}
const props = {
  name: 'file',
  action: 'http://121.199.42.23:8000/upload',
  headers: {
    authorization: 'authorization-text',
  },
  beforeUpload (file, fileList) {
    if(uploadPromise === null){
      // uploadPromise = new Promise((resolve, reject) => {
      //   compressDir(fileList, resolve, reject)
      // })
      uploadPromise = compressDir(fileList)
      return uploadPromise
    } else {
      return false
    }
    // return compressDir(fileList)
  },
  customRequest (info) {
    console.log(info)
    axios.post(info.action, new FormData().append('file', info.file))
    // compressDir()
  }
};

function App() {
  return (
    <div className="App">
      <Upload {...props} directory={true} id="fileUploadInput">
        <Button>
          <UploadOutlined /> Click to Upload
        </Button>
      </Upload>
    </div>
  );
}

export default App;
