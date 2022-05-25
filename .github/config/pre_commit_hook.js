const { execSync } = require('node:child_process');

exports.preCommit = (props) => {
  execSync(
    'npm install', {
      stdio: ['inherit', 'inherit', 'inherit'],
      encoding: 'utf-8'
    }
  );
}
