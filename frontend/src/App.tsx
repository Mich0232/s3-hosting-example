import React from 'react';
import S3BucketLogo from './assets/aws-s3-logo.png'
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={S3BucketLogo} className="App-logo" alt="logo" />
        <p>
          This App is hosted on AWS S3 bucket.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
