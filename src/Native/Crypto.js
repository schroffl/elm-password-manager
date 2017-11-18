var _schroffl$elm_password_manager$Native_Crypto = (function() {
  var subtle = window.crypto.subtle,
      ElmList = _elm_lang$core$Native_List,
      Scheduler = _elm_lang$core$Native_Scheduler;

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

  function ab2arr(buf) {
    var view = new Uint16Array(buf);

    return Array.from(view);
  }

  function getKey(keyId) {
    var key = keys[keyId];

    if(key instanceof CryptoKey) {
      return Promise.resolve(key);
    } else {
      return Promise.reject('Bad Key');
    }
  }

  function generateKey(password, salt, strength) {
    return Scheduler.nativeBinding(function(cb) {
      var pwBuf = str2ab(password),
          saltBuf = str2ab(salt),
          iterations = Math.pow(2, strength);

      subtle
        .importKey('raw', pwBuf, { 'name': 'PBKDF2' }, false, [ 'deriveKey' ])
        .then(function (baseKey) {
          return subtle.deriveKey(
            { 'name': 'PBKDF2', 'salt': saltBuf, 'iterations': iterations, 'hash': 'SHA-512' },
            baseKey,
            { 'name': 'AES-GCM', 'length': 128 },
            true,
            [ 'encrypt', 'decrypt' ]
          );
        })
        .then(function(key) {
          var keyId = keys.push(key) - 1;

          cb(Scheduler.succeed(keyId));
        })
        .catch(function(err) {
          cb(Scheduler.fail(err.toString()));
        });
    });
  }

  function generateIV() {
    return Scheduler.nativeBinding(function(cb) {
      try {
        var buf = new Uint16Array(8);
        
        crypto.getRandomValues(buf);

        var list = ElmList.fromArray(Array.from(buf));

        cb(Scheduler.succeed(list));
      } catch(e) {
        cb(Scheduler.fail(e.toString));
      }
    });
  }

  function encrypt(keyId, elmIv, str) {
    return Scheduler.nativeBinding(function(cb) {
      var ivArr = ElmList.toArray(elmIv),
          iv = new Uint16Array(ivArr),
          dataBuf = str2ab(str);

      getKey(keyId)
        .then(function(key) {
          return subtle.encrypt(
            { 'name': 'AES-GCM', 'iv': iv, 'length': 128 },
            key,
            dataBuf
          );
        })
        .then(ab2arr)
        .then(ElmList.fromArray)
        .then(Scheduler.succeed)
        .then(cb)
        .catch(function(e) {
          cb(Scheduler.fail(e.toString()));
        });
    });
  }

  function decrypt(keyId, elmIv, elmData) {
    return Scheduler.nativeBinding(function(cb) {
      var ivArr = ElmList.toArray(elmIv),
          iv = new Uint16Array(ivArr),
          dataArr = ElmList.toArray(elmData),
          dataBuf = new Uint16Array(dataArr);

      getKey(keyId)
        .then(function(key) {
          return subtle.decrypt(
            { 'name': 'AES-GCM', 'iv': iv, 'length': 128 },
            key,
            dataBuf
          );
        })
        .then(ab2str)
        .then(Scheduler.succeed)
        .then(cb)
        .catch(function(e) {
          cb(Scheduler.fail(e.toString()));
        });
    });
  }

  return {
    'generateKey': F3(generateKey),
    'generateIV': generateIV,
    'encrypt': F3(encrypt),
    'decrypt': F3(decrypt)
  };
})();