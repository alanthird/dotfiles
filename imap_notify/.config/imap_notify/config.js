var child_process = require('child_process');

function getStdout(cmd) {
    var stdout = child_process.execSync(cmd);
    return stdout.toString().trim();
}

exports.host = "imap.soverin.net"
exports.port = 993;
exports.tls = true;
exports.tlsOptions = { "rejectUnauthorized": false };
exports.username = getStdout("~/.local/bin/ask-netrc login smtp.soverin.net");
exports.password = getStdout("~/.local/bin/ask-netrc password smtp.soverin.net");
exports.onNotify = "~/.local/bin/email-sync.sh"
exports.onNotifyPost = {"mail": "dunstify 'New email!'"}
exports.boxes = [ "INBOX" ];
