  var https = require('https');
    var fs = require('fs');
    var options = {
      key: fs.readFileSync('key.pem'),
      cert: fs.readFileSync('cert.pem')
    };
    var a = https.createServer(options, function (req, res) {
      res.writeHead(200);
      res.end(JSON.stringify({foo:"bar"}))
    }).listen(8000);
