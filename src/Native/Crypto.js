var _schroffl$elm_password_manager$Native_Crypto = (function() {
  var subtle = window.crypto.subtle,
      toElmList = _elm_lang$core$Native_List.fromArray,
      Scheduler = _elm_lang$core$Native_Scheduler,
      Ok = _elm_lang$core$Result$Ok,
      Err = _elm_lang$core$Result$Err;

  var keys = [];

  function str2ab(str) {
    var buf = new ArrayBuffer(str.length * 2),
        view = new Uint16Array(buf);

    for(var i=0; i<str.length; i++)
      view[i] = str.charCodeAt(i);

    return buf;
  }

  function ab2str(buf) {
    var view = new Uint16Array(buf);

    return String.fromCharCode.apply(null, view)
  }

  function generateKey(password, salt) {
    return Scheduler.nativeBinding(function(cb) {
      var pwBuf = str2ab(password),
          saltBuf = str2ab(salt);

      subtle
        .importKey('raw', pwBuf, { 'name': 'PBKDF2' }, false, [ 'deriveKey' ])
        .then(function (baseKey) {
          return subtle.deriveKey(
            { 'name': 'PBKDF2', 'salt': saltBuf, 'iterations': 10000, 'hash': 'SHA-512' },
            baseKey,
            { 'name': 'AES-GCM', 'length': 128 },
            true,
            [ 'encrypt', 'decrypt' ]
          );
        })
        .then(function(key) {
          let keyId = keys.push(key) - 1;

          cb(Scheduler.succeed(keyId));
        })
        .catch(function(err) {
          cb(Scheduler.fail(err.toString()));
        });
    });
  }

  function generateIV() {
    try {
      var buf = new Uint16Array(8);
      crypto.getRandomValues(buf);
      return Ok(toElmList(Array.from(buf)));
    } catch(e) {
      return Err(e.toString());
    }
  }

  return {
    'generateKey': F2(generateKey),
    'generateIV': generateIV
  };
})();