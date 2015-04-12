/*

  Junction Object Constructor
 */

/*

  @param {string, object} selector
    The selector to find or element to wrap
  @param {object} context
    The context in which to match the selector
  @returns junction
  @this window
 */
var junction, _$, _junction, __bind = function (fn, me) {
    return function () {
        return fn.apply(me, arguments);
    };
};

junction = function (selector, context) {
    var domFragment, element, elements, m, match, returnElements, rquickExpr, selectorType;
    selectorType = typeof selector;
    returnElements = [];
    if (selector) {
        if (selectorType === "string" && selector.indexOf("<") === 0) {
            domFragment = document.createElement("div");
            domFragment.innerHTML = selector;
            return junction(domFragment).children().each(function () {
                return domFragment.removeChild(this);
            });
        } else if (selectorType === "function") {
            return junction.ready(selector);
        } else if (selectorType === "string") {
            if (context) {
                return junction(context).find(selector);
            }
            rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/;
            if (match = rquickExpr.exec(selector)) {
                if ((m = match[1])) {
                    elements = [document.getElementById(m)];
                } else if (match[2]) {
                    elements = document.getElementsByTagName(selector);
                } else if ((m = match[3])) {
                    elements = document.getElementsByClassName(m);
                }
            } else {
                elements = document.querySelectorAll(selector);
            }
            returnElements = (function () {
                var _i, _len, _results;
                _results = [];
                for (_i = 0, _len = elements.length; _i < _len; _i++) {
                    element = elements[_i];
                    _results.push(element);
                }
                return _results;
            })();
        } else if (Object.prototype.toString.call(selector) === "[object Array]" || selectorType === "object" && selector instanceof window.NodeList) {
            returnElements = (function () {
                var _i, _len, _results;
                _results = [];
                for (_i = 0, _len = selector.length; _i < _len; _i++) {
                    element = selector[_i];
                    _results.push(element);
                }
                return _results;
            })();
        } else {
            returnElements = returnElements.concat(selector);
        }
    }
    returnElements = junction.extend(returnElements, junction.fn);
    returnElements.selector = selector;
    return returnElements;
};

junction.fn = {};

junction.state = {};

junction.plugins = {};

junction.extend = function (first, second) {
    var key;
    for (key in second) {
        if (second.hasOwnProperty(key)) {
            first[key] = second[key];
        }
    }
    return first;
};

window["junction"] = junction;

_junction = window.junction;

_$ = window.$;

junction.noConflict = function (deep) {
    if (window.$ === junction) {
        window.$ = _$;
    }
    if (deep && window.junction === junction) {
        window.junction = _junction;
    }
    return junction;
};


/*

  Iterates over `junction` collections.

  @param {function} callback The callback to be invoked on
    each element and index
  @return junction
  @this junction
 */

junction.fn.each = function (callback) {
    return junction.each(this, callback);
};

junction.each = function (collection, callback) {
    var item, val, _i, _len;
    for (_i = 0, _len = collection.length; _i < _len; _i++) {
        item = collection[_i];
        val = callback.call(item, _i, item);
        if (val === false) {
            break;
        }
    }
    return collection;
};


/*

  Check for array membership.

  @param {object} element The thing to find.
  @param {object} collection The thing to find the needle in.
  @return {boolean}
  @this window
 */

junction.inArray = function (element, collection) {
    var exists, index, item, _i, _len;
    exists = -1;
    for (index = _i = 0, _len = collection.length; _i < _len; index = ++_i) {
        item = collection[index];
        if (collection.hasOwnProperty(index) && collection[index] === element) {
            exists = index;
        }
    }
    return exists;
};

junction.state.ready = false;

junction.readyQueue = [];


/*

  Bind callbacks to be run with the DOM is "ready"

  @param {function} fn The callback to be run
  @return junction
  @this junction
 */

junction.ready = function (fn) {
    if (junction.ready && fn) {
        fn.call(document);
    } else if (fn) {
        junction.readyQueue.push(fn);
    } else {
        junction.runReady();
    }
    return [document];
};

junction.fn.ready = function (fn) {
    junction.ready(fn);
    return this;
};

junction.runReady = function () {
    if (!junction.state.ready) {
        while (junction.readyQueue.length) {
            junction.readyQueue.shift().call(document);
        }
        return junction.state.ready = true;
    }
};


/*

  If DOM is already ready at exec time, depends on the browser.
  From:
  https://github.com/mobify/mobifyjs/blob/
  526841be5509e28fc949038021799e4223479f8d/src/capture.js#L128
 */

if ((document.attachEvent ? document.readyState === "complete" : document.readyState !== "loading")) {
    junction.runReady();
} else {
    if (!window.document.addEventListener) {
        window.document.attachEvent("DOMContentLoaded", junction.runReady);
        window.document.attachEvent("onreadystatechange", junction.runReady);
    } else {
        window.document.addEventListener("DOMContentLoaded", junction.runReady, false);
        window.document.addEventListener("onreadystatechange", junction.runReady, false);
    }
    window.addEventListener("load", junction.runReady, false);
}


/*
@class Debouncer

@author
  James E Baxley III
  NewSpring Church

@version 0.3

@note
  Handles debouncing of events via requestAnimationFrame
    @see http://www.html5rocks.com/en/tutorials/speed/animations/
 */

junction._debounce = (function () {
    function _debounce(data) {
        this.data = data;
        this.handleEvent = __bind(this.handleEvent, this);
        this.requestTick = __bind(this.requestTick, this);
        this.update = __bind(this.update, this);
        console.log(this.data);
        window.requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame;
        this.callback = this.data;
        this.ticking = false;
    }

    _debounce.prototype.update = function () {
        this.callback && this.callback();
        return this.ticking = false;
    };

    _debounce.prototype.requestTick = function () {
        if (!this.ticking) {
            requestAnimationFrame(this.rafCallback || (this.rafCallback = this.update.bind(this)));
            return this.ticking = true;
        }
    };

    _debounce.prototype.handleEvent = function () {
        return this.requestTick();
    };

    return _debounce;

})();

junction.debounce = function (callback) {
    return new this._.debounce(callback);
};


/*

  @function flatten()

  @param {Array} single or multilevel array

  @return {Array} a flattened version of an array.

  @note
    Handy for getting a list of children from the nodes.
 */

junction.flatten = function (array) {
    var element, flattened, _i, _len;
    flattened = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
        element = array[_i];
        if (element instanceof Array) {
            flattened = flattened.concat(this.flatten(element));
        } else {
            flattened.push(element);
        }
    }
    return flattened;
};

junction.flattenObject = (function (_this) {
    return function (object) {
        var array, value;
        array = [];
        for (value in object) {
            if (object.hasOwnProperty(value)) {
                array.push(object[value]);
            }
        }
        return array;
    };
})(this);


/*

@function getKeys()

@param {Object}
@param {value}

@return {Array} array of keys that match on a certain value

@note
  helpful for searching objects


@todo add ability to search string and multi level
 */

junction.getKeys = function (obj, val) {
    var element, objects;
    objects = [];
    for (element in obj) {
        if (!obj.hasOwnProperty(element)) {
            continue;
        }
        if (obj[element] === "object") {
            objects = objects.concat(this.getKeys(obj[element], val));
        } else {
            if (obj[element] === val) {
                objects.push(element);
            }
        }
    }
    return objects;
};


/*

  @function getQueryVariable()

  @param {Val}

  @return {Array} array of query values in url string matching the value
 */

junction.getQueryVariable = function (val) {
    var query, results, vars;
    query = window.location.search.substring(1);
    vars = query.split("&");
    results = vars.filter(function (element) {
        var pair;
        pair = element.split("=");
        if (decodeURIComponent(pair[0]) === val) {
            return decodeURIComponent(pair[1]);
        }
    });
    return results;
};

junction.isElement = function (el) {
    if (typeof HTMLElement === "object") {
        return el instanceof HTMLElement;
    } else {
        return el && typeof el === "object" && el !== null && el.nodeType === 1 && typeof el.nodeName === "string";
    }
};


/*

@function isElementInView()

@param {Element} element to check against

@return {Boolean} if element is in view
 */

junction.isElementInView = function (element) {
    var coords;
    if (element instanceof jQuery) {
        element = element.get(0);
    }
    coords = element.getBoundingClientRect();
    return (Math.abs(coords.left) >= 0 && Math.abs(coords.top)) <= (window.innerHeight || document.documentElement.clientHeight);
};


/*

  @function isMobile()

  @return {Boolean} true if Mobile
 */

junction.isMobile = (function (_this) {
    return function () {
        return /(Android|iPhone|iPad|iPod|IEMobile)/g.test(navigator.userAgent);
    };
})(this);


/*

@function last()

@param {Array}
@param {Val} ** optional

@return {Val} last value of array or value certain length from end
 */

junction.last = function (array, back) {
    return array[array.length - (back || 0) - 1];
};


/*

@function truthful()

@param {Array} any array to be tested for true values

@return {Array} array without false values

@note
  Handy for triming out all falsy values from an array.
 */

junction.truthful = function (array) {
    var item, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
        item = array[_i];
        if (item) {
            _results.push(item);
        }
    }
    return _results;
};


/*

  Get data attached to the first element or set data values on
  all elements in the current set

  @param {string} name The data attribute name
  @param {any} value The value assigned to the data attribute
  @return {any|junction}
  @this junction
 */

junction.fn.data = function (name, value) {
    if (name !== void 0) {
        if (value !== void 0) {
            return this.each(function () {
                if (!this.junctionData) {
                    this.junctionData = {};
                }
                this.junctionData[name] = value;
            });
        } else {
            if (this[0] && this[0].junctionData) {
                return this[0].junctionData[name];
            } else {
                return void 0;
            }
        }
    } else {
        if (this[0]) {
            return this[0].junctionData || {};
        } else {
            return void 0;
        }
    }
};


/*

  Remove data associated with `name` or all the data, for each
  element in the current set

  @param {string} name The data attribute name
  @return junction
  @this junction
 */

junction.fn.removeData = function (name) {
    return this.each(function () {
        if (name !== void 0 && this.junctionData) {
            this.junctionData[name] = void 0;
            delete this.junctionData[name];
        } else {
            this[0].junctionData = {};
        }
    });
};


/*

  Make an HTTP request to a url.

  NOTE** the following options are supported:

  - *method* - The HTTP method used with the request. Default: `GET`.
  - *data* - Raw object with keys and values to pass with request
      Default `null`.
  - *async* - Whether the opened request is asynchronouse. Default `true`.
  - *success* - Callback for successful request and response
      Passed the response data.
  - *error* - Callback for failed request and response.
  - *cancel* - Callback for cancelled request and response.

  @param {string} url The url to request.
  @param {object} options The options object, see Notes.
  @return junction
  @this junction
 */

junction.ajax = function (url, options) {
    var req, settings, xmlHttp;
    xmlHttp = function () {
        var e;
        try {
            return new XMLHttpRequest();
        } catch (_error) {
            e = _error;
            return new ActiveXObject("Microsoft.XMLHTTP");
        }
    };
    req = xmlHttp();
    settings = junction.extend({}, junction.ajax.settings);
    if (options) {
        junction.extend(settings, options);
    }
    if (!url) {
        url = settings.url;
    }
    if (!req || !url) {
        return;
    }
    req.open(settings.method, url, settings.async);
    if (req.setRequestHeader) {
        req.setRequestHeader("X-Requested-With", "XMLHttpRequest");
    }
    req.onreadystatechange = function () {
        var res;
        if (req.readyState === 4) {
            res = (req.responseText || "").replace(/^\s+|\s+$/g, "");
            if (req.status.toString().indexOf("0") === 0) {
                return settings.cancel(res, req.status, req);
            } else if (req.status.toString().match(/^(4|5)/) && RegExp.$1) {
                return settings.error(res, req.status, req);
            } else {
                return settings.success(res, req.status, req);
            }
        }
    };
    if (req.readyState === 4) {
        return req;
    }
    req.send(settings.data || null);
    return req;
};

junction.ajax.settings = {
    success: function () {},
    error: function () {},
    cancel: function () {},
    method: "GET",
    async: true,
    data: null
};


/*

  Helper function wrapping a call to [ajax](ajax.js.html)
  using the `GET` method.

  @param {string} url The url to GET from.
  @param {function} callback Callback to invoke on success.
  @return junction
  @this junction
 */

junction.get = function (url, callback) {
    return junction.ajax(url, {
        success: callback
    });
};


/*

  Load the HTML response from `url` into the current set of elements.

  @param {string} url The url to GET from.
  @param {function} callback Callback to invoke after HTML is inserted.
  @return junction
  @this junction
 */

junction.fn.load = function (url, callback) {
    var args, intCB, self;
    self = this;
    args = arguments;
    intCB = function (data) {
        self.each(function () {
            junction(this).html(data);
        });
        if (callback) {
            callback.apply(self, args);
        }
    };
    junction.ajax(url, {
        success: intCB
    });
    return this;
};


/*

  Helper function wrapping a call to [ajax](ajax.js.html)
  using the `POST` method.

  @param {string} url The url to POST to.
  @param {object} data The data to send.
  @param {function} callback Callback to invoke on success.
  @return junction
  @this junction
 */

junction.post = function (url, data, callback) {
    return junction.ajax(url, {
        data: data,
        method: "POST",
        success: callback
    });
};


/*

  Add elements matching the selector to the current set.

  @param {string} selector The selector for the elements to add from the DOM
  @return junction
  @this junction
 */

junction.fn.add = function (selector) {
    var ret;
    ret = [];
    this.each(function () {
        ret.push(this);
    });
    junction(selector).each(function () {
        ret.push(this);
    });
    return junction(ret);
};


/*

  Add a class to each DOM element in the set of elements.

  @param {string} className The name of the class to be added.
  @return junction
  @this junction
 */

junction.fn.addClass = function (className) {
    var classes;
    classes = className.replace(/^\s+|\s+$/g, "").split(" ");
    return this.each(function () {
        var klass, regex, withoutClass, _i, _len;
        for (_i = 0, _len = classes.length; _i < _len; _i++) {
            klass = classes[_i];
            if (this.className !== void 0) {
                klass = klass.trim();
                regex = new RegExp("(?:^| )(" + klass + ")(?: |$)");
                withoutClass = !this.className.match(regex);
                if (this.className === "" || withoutClass) {
                    if (this.className === "") {
                        this.className += "" + klass;
                    } else {
                        this.className += " " + klass;
                    }
                    return;
                }
            }
        }
    });
};


/*

  Insert an element or HTML string after each element in the current set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction
 */

junction.fn.after = function (fragment) {
    if (typeof fragment === "string" || fragment.nodeType !== void 0) {
        fragment = junction(fragment);
    }
    if (fragment.length > 1) {
        fragment = fragment.reverse();
    }
    return this.each(function (index) {
        var insertEl, piece, _i, _len;
        for (_i = 0, _len = fragment.length; _i < _len; _i++) {
            piece = fragment[_i];
            insertEl = (index > 0 ? piece.cloneNode(true) : piece);
            this.parentNode.insertBefore(insertEl, this.nextSibling);
            return;
        }
    });
};


/*

  Insert an element or HTML string as the last child of each element in the set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction
 */

junction.fn.append = function (fragment) {
    if (typeof fragment === "string" || fragment.nodeType !== void 0) {
        fragment = junction(fragment);
    }
    return this.each(function (index) {
        var element, piece, _i, _len;
        for (_i = 0, _len = fragment.length; _i < _len; _i++) {
            piece = fragment[_i];
            element = (index > 0 ? piece.cloneNode(true) : piece);
            this.appendChild(element);
            return;
        }
    });
};


/*

  Insert the current set as the last child of the elements
  matching the selector.

  @param {string} selector The selector after which to append the current set.
  @return junction
  @this junction
 */

junction.fn.appendTo = function (selector) {
    return this.each(function () {
        junction(selector).append(this);
    });
};


/*

  Get the value of the first element of the set or set
  the value of all the elements in the set.

  @param {string} name The attribute name.
  @param {string} value The new value for the attribute.
  @return {junction|string|undefined}
  @this {junction}
 */

junction.fn.attr = function (name, value) {
    var nameStr;
    nameStr = typeof name === "string";
    if (value !== void 0 || !nameStr) {
        return this.each(function () {
            var i;
            if (nameStr) {
                this.setAttribute(name, value);
            } else {
                for (i in name) {
                    if (name.hasOwnProperty(i)) {
                        this.setAttribute(i, name[i]);
                    }
                }
            }
        });
    } else {
        if (this[0]) {
            return this[0].getAttribute(name);
        } else {
            return void 0;
        }
    }
};


/*

  Insert an element or HTML string before each
  element in the current set.

  @param {string|HTMLElement} fragment The HTML or HTMLElement to insert.
  @return junction
  @this junction
 */

junction.fn.before = function (fragment) {
    if (typeof fragment === "string" || fragment.nodeType !== undefined) {
        fragment = junction(fragment);
    }
    return this.each(function (index) {
        var insertEl, piece, _i, _len;
        for (_i = 0, _len = fragment.length; _i < _len; _i++) {
            piece = fragment[_i];
            insertEl = (index > 0 ? piece.cloneNode(true) : piece);
            this.parentNode.insertBefore(insertEl, this);
            return;
        }
    });
};


/*

  Get the children of the current collection.
  @return junction
  @this junction
 */

junction.fn.children = function () {
    var returns;
    returns = [];
    this.each(function () {
        var children, i, _results;
        children = this.children;
        i = -1;
        _results = [];
        while (i++ < children.length - 1) {
            if (junction.inArray(children[i], returns) === -1) {
                _results.push(returns.push(children[i]));
            } else {
                _results.push(void 0);
            }
        }
        return _results;
    });
    return junction(returns);
};


/*

  Clone and return the current set of nodes into a
  new `junction` object.

  @return junction
  @this junction
 */

junction.fn.clone = function () {
    var returns;
    returns = [];
    this.each(function () {
        returns.push(this.cloneNode(true));
    });
    return junction(returns);
};


/*

  Find an element matching the selector in the
  set of the current element and its parents.

  @param {string} selector The selector used to identify the target element.
  @return junction
  @this junction
 */

junction.fn.closest = function (selector) {
    var returns;
    returns = [];
    if (!selector) {
        return junction(returns);
    }
    this.each(function () {
        var $self, element;
        element = void 0;
        $self = junction(element = this);
        if ($self.is(selector)) {
            returns.push(this);
            return;
        }
        while (element.parentElement) {
            if (junction(element.parentElement).is(selector)) {
                returns.push(element.parentElement);
                break;
            }
            element = element.parentElement;
        }
    });
    return junction(returns);
};


/*

  Get the compute style property of the first
  element or set the value of a style property
  on all elements in the set.

  @method _setStyle
  @param {string} property The property being used to style the element.
  @param {string|undefined} value The css value for the style property.
  @return {string|junction}
  @this junction
 */

junction.fn.css = function (property, value) {
    if (!this[0]) {
        return;
    }
    if (typeof property === "object") {
        return this.each(function () {
            var key;
            for (key in property) {
                if (property.hasOwnProperty(key)) {
                    junction._setStyle(this, key, property[key]);
                }
            }
        });
    } else {
        if (value !== undefined) {
            return this.each(function () {
                junction._setStyle(this, property, value);
            });
        }
        return junction._getStyle(this[0], property);
    }
};

junction.cssExceptions = {
    'float': ['cssFloat', 'styleFloat']
};

(function () {
    var convertPropertyName, cssExceptions, vendorPrefixes, _getStyle;
    convertPropertyName = function (str) {
        return str.replace(/\-([A-Za-z])/g, function (match, character) {
            return character.toUpperCase();
        });
    };
    _getStyle = function (element, property) {
        return window.getComputedStyle(element, null).getPropertyValue(property);
    };
    cssExceptions = junction.cssExceptions;
    vendorPrefixes = ["", "-webkit-", "-ms-", "-moz-", "-o-", "-khtml-"];

/*
  
    Private function for getting the computed
    style of an element.
  
    NOTE** Please use the [css](../css.js.html) method instead.
  
    @method _getStyle
    @param {HTMLElement} element The element we want the style property for.
    @param {string} property The css property we want the style for.
   */
    return junction._getStyle = function (element, property) {
        var convert, exception, prefix, value, _i, _j, _len, _len1, _ref;
        if (cssExceptions[property]) {
            _ref = cssExceptions[property];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                exception = _ref[_i];
                value = _getStyle(element, exception);
                if (value) {
                    return value;
                }
            }
        }
        for (_j = 0, _len1 = vendorPrefixes.length; _j < _len1; _j++) {
            prefix = vendorPrefixes[_j];
            convert = convertPropertyName(prefix + property);
            value = _getStyle(element, convert);
            if (convert !== property) {
                value = value || _getStyle(element, property);
            }
            if (prefix) {
                value = value || _getStyle(element, prefix);
            }
            if (value) {
                return value;
            }
        }
        return void 0;
    };
})();

(function () {
    var convertPropertyName, cssExceptions;
    convertPropertyName = function (str) {
        return str.replace(/\-([A-Za-z])/g, function (match, character) {
            return character.toUpperCase();
        });
    };
    cssExceptions = junction.cssExceptions;

/*
  
    Private function for setting the style of an element.
  
    NOTE** Please use the [css](../css.js.html) method instead.
  
    @method _setStyle
    @param {HTMLElement} element The element we want to style.
    @param {string} property The property being used to style the element.
    @param {string} value The css value for the style property.
   */
    return junction._setStyle = function (element, property, value) {
        var convertedProperty, exception, _i, _len, _ref;
        convertedProperty = convertPropertyName(property);
        element.style[property] = value;
        if (convertedProperty !== property) {
            element.style[convertedProperty] = value;
        }
        if (cssExceptions[property]) {
            _ref = cssExceptions[property];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                exception = _ref[_i];
                element.style[exception] = value;
                return;
            }
        }
    };
})();


/*

  Private function for setting/getting the offset
  property for height/width.

  NOTE** Please use the [width](width.js.html)
  or [height](height.js.html) methods instead.

  @param {junction} set The set of elements.
  @param {string} name The string "height" or "width".
  @param {float|undefined} value The value to assign.
  @return junction
  @this window
 */

junction._dimension = function (set, name, value) {
    var offsetName;
    if (value === undefined) {
        offsetName = name.replace(/^[a-z]/, function (letter) {
            return letter.toUpperCase();
        });
        return set[0]["offset" + offsetName];
    } else {
        value = (typeof value === "string" ? value : value + "px");
        return set.each(function () {
            this.style[name] = value;
        });
    }
};


/*

  Returns the indexed element wrapped in a new `junction` object.

  @param {integer} index The index of the element to wrap and return.
  @return junction
  @this junction
 */

junction.fn.eq = function (index) {
    if (this[index]) {
        return junction(this[index]);
    }
    return junction([]);
};


/*

  Filter out the current set if they do *not*
  match the passed selector or the supplied callback returns false

  @param {string,function} selector The selector or boolean return value callback used to filter the elements.
  @return junction
  @this junction
 */

junction.fn.filter = function (selector) {
    var returns;
    returns = [];
    this.each(function (index) {
        var context, filterSelector;
        if (typeof selector === "function") {
            if (selector.call(this, index) !== false) {
                returns.push(this);
            }
        } else {
            if (!this.parentNode) {
                context = junction(document.createDocumentFragment());
                context[0].appendChild(this);
                filterSelector = junction(selector, context);
            } else {
                filterSelector = junction(selector, this.parentNode);
            }
            if (junction.inArray(this, filterSelector) > -1) {
                returns.push(this);
            }
        }
    });
    return junction(returns);
};


/*

  Find descendant elements of the current collection.

  @param {string} selector The selector used to find the children
  @return junction
  @this junction
 */

junction.fn.find = function (selector) {
    var returns;
    returns = [];
    this.each(function () {
        var e, elements, found, m, match, rquickExpr, _i, _len, _results;
        try {
            rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/;
            if (match = rquickExpr.exec(selector)) {
                if ((m = match[1])) {
                    elements = [document.getElementById(m)];
                } else if (match[2]) {
                    elements = this.getElementsByTagName(selector);
                } else if ((m = match[3])) {
                    elements = this.getElementsByClassName(m);
                }
            } else {
                elements = this.querySelectorAll(selector);
            }
        } catch (_error) {
            e = _error;
            return false;
        }
        _results = [];
        for (_i = 0, _len = elements.length; _i < _len; _i++) {
            found = elements[_i];
            _results.push(returns = returns.concat(found));
        }
        return _results;
    });
    return junction(returns);
};


/*

  Returns the first element of the set wrapped in a new `shoestring` object.

  @return junction
  @this junction
 */

junction.fn.first = function () {
    return this.eq(0);
};


/*

  Returns the raw DOM node at the passed index.

  @param {integer} index The index of the element to wrap and return.
  @return HTMLElement
  @this junction
 */

junction.fn.get = function (index) {
    return this[index];
};


/*

  Returns a boolean if elements have the class passed

  @param {string} selector The selector to check.
  @return {boolean}
  @this {junction}
 */

junction.fn.hasClass = function (className) {
    var returns;
    returns = false;
    this.each(function () {
        var regex;
        regex = new RegExp(" " + className + " ");
        return returns = regex.test(" " + this.className + " ");
    });
    return returns;
};


/*

  Gets the height value of the first element or
  sets the height for the whole set.

  @param {float|undefined} value The value to assign.
  @return junction
  @this junction
 */

junction.fn.height = function (value) {
    return junction._dimension(this, "height", value);
};


/*

  Gets or sets the `innerHTML` from all the elements in the set.

  @param {string|undefined} html The html to assign
  @return {string|junction}
  @this junction
 */

junction.fn.html = function (html) {
    var pile, set;
    set = function (html) {
        var part, _i, _len;
        if (typeof html === "string") {
            return this.each(function () {
                this.innerHTML = html;
            });
        } else {
            part = "";
            if (typeof html.length !== "undefined") {
                for (_i = 0, _len = html.length; _i < _len; _i++) {
                    part = html[_i];
                    part += part.outerHTML;
                    return;
                }
            } else {
                part = html.outerHTML;
            }
            return this.each(function () {
                this.innerHTML = part;
            });
        }
    };
    if (typeof html !== "undefined") {
        return set.call(this, html);
    } else {
        pile = "";
        this.each(function () {
            pile += this.innerHTML;
        });
        return pile;
    }
};

(function () {
    var _getIndex;
    return _getIndex = function (set, test) {
        var element, item, _i, _len;
        for (_i = 0, _len = set.length; _i < _len; _i++) {
            item = set[_i];
            element = (set.item ? set.item(item) : item);
            if (test(element)) {
                return result;
            }
            if (element.nodeType === 1) {
                result++;
            }
        }
        return -1;

/*
    
      Find the index in the current set for the passed
      selector. Without a selector it returns the
      index of the first node within the array of its siblings.
    
      @param {string|undefined} selector The selector used to search for the index.
      @return {integer}
      @this {junction}
     */
        return junction.fn.index = function (selector) {
            var children, self;
            self = this;
            if (selector === undefined) {
                children = ((this[0] && this[0].parentNode) || document.documentElement).childNodes;
                return _getIndex(children, function (element) {
                    return self[0] === element;
                });
            } else {
                return _getIndex(self, function (element) {
                    return element === (junction(selector, element.parentNode)[0]);
                });
            }
        };
    };
})();


/*

  Insert the current set after the elements matching the selector.

  @param {string} selector The selector after which to insert the current set.
  @return junction
  @this junction
 */

junction.fn.insertAfter = function (selector) {
    return this.each(function () {
        junction(selector).after(this);
    });
};


/*

  Insert the current set after the elements matching the selector.

  @param {string} selector The selector after which to insert the current set.
  @return junction
  @this junction
 */

junction.fn.insertBefore = function (selector) {
    return this.each(function () {
        junction(selector).before(this);
    });
};


/*

  Checks the current set of elements against
  the selector, if one matches return `true`.

  @param {string} selector The selector to check.
  @return {boolean}
  @this {junction}
 */

junction.fn.is = function (selector) {
    var returns;
    returns = false;
    this.each(function () {
        if (junction.inArray(this, junction(selector)) > -1) {
            returns = true;
        }
    });
    return returns;
};


/*

  Returns the last element of the set wrapped in a new `shoestring` object.

  @return junction
  @this junction
 */

junction.fn.last = function () {
    return this.eq(this.length - 1);
};


/*

  Returns a `junction` object with the set of siblings of each element in the original set.

  @return junction
  @this junction
 */

junction.fn.next = function () {
    var returns;
    returns = [];
    this.each(function () {
        var child, children, found, index, item, _i, _len, _results;
        children = junction(this.parentNode)[0].childNodes;
        found = false;
        _results = [];
        for (index = _i = 0, _len = children.length; _i < _len; index = ++_i) {
            child = children[index];
            item = children.item[index];
            if (found && item.nodeType === 1) {
                returns.push(item);
            }
            if (item === this) {
                found = true;
            }
            _results.push(false);
        }
        return _results;
    });
    return junction(returns);
};


/*

  Removes elements from the current set.

  @param {string} selector The selector to use when removing the elements.
  @return junction
  @this junction
 */

junction.fn.not = function (selector) {
    var returns;
    returns = [];
    this.each(function () {
        var found;
        found = junction(selector, this.parentNode);
        if (junction.inArray(this, found) === -1) {
            returns.push(this);
        }
    });
    return junction(returns);
};


/*

  Returns an object with the `top` and `left`
  properties corresponging to the first elements offsets.

  @return object
  @this junction
 */

junction.fn.offset = function () {
    return {
        top: this[0].offsetTop,
        left: this[0].offsetLeft
    };
};


/*

  Returns the set of first parents for each element
  in the current set.

  @return junction
  @this junction
 */

junction.fn.parent = function () {
    var returns;
    returns = [];
    this.each(function () {
        var parent;
        parent = (this === document.documentElement ? document : this.parentNode);
        if (parent && parent.nodeType !== 11) {
            returns.push(parent);
        }
    });
    return junction(returns);
};


/*

  Returns the set of all parents matching the
  selector if provided for each element in the current set.

  @param {string} selector The selector to check the parents with.
  @return junction
  @this junction
 */

junction.fn.parents = function (selector) {
    var returns;
    returns = [];
    this.each(function () {
        var current, match;
        current = this;
        match;
        while (current.parentElement && !match) {
            current = current.parentElement;
            if (selector) {
                if (current === junction(selector)[0]) {
                    match = true;
                    if (junction.inArray(current, returns) === -1) {
                        returns.push(current);
                    }
                }
            } else {
                if (junction.inArray(current, returns) === -1) {
                    returns.push(current);
                }
            }
        }
    });
    return junction(returns);
};


/*

  Add an HTML string or element before the children
  of each element in the current set.

  @param {string|HTMLElement} fragment The HTML string or element to add.
  @return junction
  @this junction
 */

junction.fn.prepend = function (fragment) {
    if (typeof fragment === "string" || fragment.nodeType !== undefined) {
        fragment = junction(fragment);
    }
    return this.each(function (index) {
        var insertEl, piece, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = fragement.length; _i < _len; _i++) {
            piece = fragement[_i];
            insertEl = (index > 0 ? piece.cloneNode(true) : piece);
            if (this.firstChild) {
                _results.push(this.insertBefore(insertEl, this.firstChild));
            } else {
                _results.push(this.appendChild(insertEl));
            }
        }
        return _results;
    });
};


/*

  Add each element of the current set before the
  children of the selected elements.

  @param {string} selector The selector for the elements to add the current set to..
  @return junction
  @this junction
 */

junction.fn.prependTo = function (selector) {
    return this.each(function () {
        junction(selector).prepend(this);
    });
};


/*

  Returns a `junction` object with the set of *one*
  sibling before each element in the original set.

  @return junction
  @this junction
 */

junction.fn.prev = function () {
    var returns;
    returns = [];
    this.each(function () {
        var child, children, found, index, item, _i, _results;
        children = junction(this.parentNode)[0].childNodes;
        found = false;
        _results = [];
        for (index = _i = children.length - 1; _i >= 0; index = _i += -1) {
            child = children[index];
            item = children.item[index];
            if (found && item.nodeType === 1) {
                returns.push(item);
            }
            if (item === this) {
                found = true;
            }
            _results.push(false);
        }
        return _results;
    });
    return junction(returns);
};


/*

  Returns a `junction` object with the set of *all*
  siblings before each element in the original set.

  @return junction
  @this junction
 */

junction.fn.prevAll = function () {
    var returns;
    returns = [];
    this.each(function () {
        var $previous;
        $previous = junction(this).prev();
        while ($previous.length) {
            returns.push($previous[0]);
            $previous = $previous.prev();
        }
    });
    return junction(returns);
};


/*

  Gets the property value from the first element
  or sets the property value on all elements of the currrent set.

  @param {string} name The property name.
  @param {any} value The property value.
  @return {any|junction}
  @this junction
 */

junction.fn.prop = function (name, value) {
    if (!this[0]) {
        return;
    }
    name = junction.propFix[name] || name;
    if (value !== undefined) {
        return this.each(function () {
            this[name] = value;
        });
    } else {
        return this[0][name];
    }
};

junction.propFix = {
    "class": "className",
    "contenteditable": "contentEditable",
    "for": "htmlFor",
    "readonly": "readOnly",
    "tabindex": "tabIndex"
};


/*

  Remove the current set of elements from the DOM.

  @return junction
  @this junction
 */

junction.fn.remove = function () {
    return this.each(function () {
        if (this.parentNode) {
            this.parentNode.removeChild(this);
        }
    });
};


/*

  Remove an attribute from each element in the current set.

  @param {string} name The name of the attribute.
  @return junction
  @this junction
 */

junction.fn.removeAttr = function (name) {
    return this.each(function () {
        this.removeAttribute(name);
    });
};


/*

  Remove a class from each DOM element in the set of elements.

  @param {string} className The name of the class to be removed.
  @return junction
  @this junction
 */

junction.fn.removeClass = function (className) {
    var classes;
    classes = className.replace(/^\s+|\s+$/g, "").split(" ");
    return this.each(function () {
        var klass, newClassName, regex, _i, _len;
        for (_i = 0, _len = classes.length; _i < _len; _i++) {
            klass = classes[_i];
            if (this.className !== undefined) {
                regex = new RegExp("(^|\\s)" + klass + "($|\\s)", "gmi");
                newClassName = this.className.replace(regex, " ");
                this.className = newClassName.replace(/^\s+|\s+$/g, "");
            }
            return;
        }
    });
};


/*

  Remove a proprety from each element in the current set.

  @param {string} name The name of the property.
  @return junction
  @this junction
 */

junction.fn.removeProp = function (property) {
    var name;
    name = junction.propFix[property] || property;
    return this.each(function () {
        this[name] = undefined;
        delete this[name];
    });
};


/*

  Replace each element in the current set with that argument HTML string or HTMLElement.

  @param {string|HTMLElement} fragment The value to assign.
  @return junction
  @this junction
 */

junction.fn.replaceWith = function (fragment) {
    var framgent, returns;
    if (typeof fragment === "string") {
        fragment = junction(fragment);
    }
    returns = [];
    if (fragment.length > 1) {
        framgent = framgent.reverse();
    }
    this.each(function (index) {
        var clone, insertEl, piece, _i, _len;
        clone = this.cloneNode(true);
        returns.push(clone);
        if (!this.parentNode) {
            return;
        }
        if (fragment.length === 1) {
            insertEl = (index > 0 ? fragment[0].cloneNode(true) : fragment[0]);
            return this.parentNode.replaceChild(insertEl, this);
        } else {
            for (_i = 0, _len = fragment.length; _i < _len; _i++) {
                piece = fragment[_i];
                insertEl = (index > 0 ? piece.cloneNode(true) : piece);
                this.parentNode.insertBefore(insertEl, this.nextSibling);
                return;
            }
            return this.parentNode.removeChild(this);
        }
    });
    return junction(retunrs);
};

junction.inputTypes = ["text", "hidden", "password", "color", "date", "datetime", "email", "month", "number", "range", "search", "tel", "time", "url", "week"];

junction.inputTypeTest = new RegExp(junction.inputTypes.join("|"));


/*

  Serialize child input element values into an object.

  @return junction
  @this junction
 */

junction.fn.serialize = function () {
    var data;
    data = {};
    junction("input, select", this).each(function () {
        var name, type, value;
        type = this.type;
        name = this.name;
        value = this.value;
        if (junction.inputTypeTest.test(type) || (type === "checkbox" || type === "radio") && this.checked) {
            data[name] = value;
        } else if (this.nodeName === "select") {
            data[name] = this.options[this.selectedIndex].nodeValue;
        }
    });
    return data;
};


/*

  Get all of the sibling elements for each element in the current set.

  @return junction
  @this junction
 */

junction.fn.siblings = function () {
    var el, siblings;
    if (!this.length) {
        return junction([]);
    }
    siblings = [];
    el = this[0].parentNode.firstChild;
    while (true) {
        if (el.nodeType === 1 && el !== this[0]) {
            siblings.push(el);
        }
        el = el.nextSibling;
        if (!el) {
            break;
        }
    }
    return junction(siblings);
};


/*

  Recursively retrieve the text content of the each element in the current set.

  @return junction
  @this junction
 */

junction.fn.text = function () {
    var getText;
    getText = function (elem) {
        var i, node, nodeType, text;
        text = "";
        nodeType = elem.nodeType;
        i = 0;
        if (!nodeType) {
            while (node = elem[i++]) {
                text += getText(node);
            }
        } else if (nodeType === 1 || nodeType === 9 || nodeType === 11) {
            if (typeof elem.textContent === "string") {
                return elem.textContent;
            } else {
                elem = elem.firstChild;
                while (elem) {
                    ret += getText(elem);
                    elem = elem.nextSibling;
                }
            }
        } else if (nodeType === 3 || nodeType === 4) {
            return elem.nodeValue;
        }
        return text;
    };
    return getText(this);
};


/*

  Toggles class of elements in selector

  @param {string} className Class to be toggled
  @return junction
  @this junction
 */

junction.fn.toggleClass = function (className) {
    if (this.hasClass(className)) {
        return this.removeClass(className);
    } else {
        return this.addClass(className);
    }
};


/*

  Get the value of the first element or set the value
  of all elements in the current set.

  @param {string} value The value to set.
  @return junction
  @this junction
 */

junction.fn.val = function (value) {
    var el;
    if (value !== undefined) {
        return this.each(function () {
            var i, inArray, newIndex, optionSet, options, values;
            if (this.tagName === "SELECT") {
                options = this.options;
                values = [];
                i = options.length;
                values[0] = value;
                while (i--) {
                    options = options[i];
                    inArray = junction.inArray(option.value, values) >= 0;
                    if ((option.selected = inArray)) {
                        optionSet = true;
                        newIndex = i;
                    }
                }
                if (!optionSet) {
                    return this.selectedIndex = -1;
                } else {
                    return this.selectedIndex = newIndex;
                }
            } else {
                return this.value = value;
            }
        });
    } else {
        el = this[0];
        if (el.tagName === "SELECT") {
            if (el.selectedIndex < 0) {
                return "";
            }
        } else {
            return el.value;
        }
    }
};


/*

  Gets the width value of the first element or
  sets the width for the whole set.

  @param {float|undefined} value The value to assign.
  @return junction
  @this junction
 */

junction.fn.width = function (value) {
    return junction._dimension(this, "width", value);
};


/*

  Wraps the child elements in the provided HTML.

  @param {string} html The wrapping HTML.
  @return junction
  @this junction
 */

junction.fn.wrapInner = function (html) {
    return this.each(function () {
        var inH;
        inH = this.innerHTML;
        this.innerHTML = "";
        junction(this).append(junction(html).html(inH));
    });
};


/*

  Bind a callback to an event for the currrent set of elements.

  @param {string} evt The event(s) to watch for.
  @param {object,function} data Data to be included
    with each event or the callback.
  @param {function} originalCallback Callback to be
    invoked when data is define.d.
  @return junction
  @this junction
 */

junction.fn.bind = function (evt, data, originalCallback) {
    var addToEventCache, docEl, encasedCallback, evts, initEventCache;
    initEventCache = function (el, evt) {
        if (!el.junctionData) {
            el.junctionData = {};
        }
        if (!el.junctionData.events) {
            el.junctionData.events = {};
        }
        if (!el.junctionData.loop) {
            el.junctionData.loop = {};
        }
        if (!el.junctionData.events[evt]) {
            return el.junctionData.events[evt] = [];
        }
    };
    addToEventCache = function (el, evt, eventInfo) {
        var obj;
        obj = {};
        obj.isCustomEvent = eventInfo.isCustomEvent;
        obj.callback = eventInfo.callfunc;
        obj.originalCallback = eventInfo.originalCallback;
        obj.namespace = eventInfo.namespace;
        el.junctionData.events[evt].push(obj);
        if (eventInfo.customEventLoop) {
            return el.junctionData.loop[evt] = eventInfo.customEventLoop;
        }
    };
    if (typeof data === "function") {
        originalCallback = data;
        data = null;
    }
    evts = evt.split(" ");
    docEl = document.documentElement;
    encasedCallback = function (e, namespace, triggeredElement) {
        var originalPreventDefault, preventDefaultConstructor, result, returnTrue;
        if (e._namespace && e._namespace !== namespace) {
            return;
        }
        e.data = data;
        e.namespace = e._namespace;
        returnTrue = function () {
            return true;
        };
        e.isDefaultPrevented = function () {
            return false;
        };
        originalPreventDefault = e.preventDefault;
        preventDefaultConstructor = function () {
            if (originalPreventDefault) {
                return function () {
                    e.isDefaultPrevented = returnTrue;
                    originalPreventDefault.call(e);
                };
            } else {
                return function () {
                    e.isDefaultPrevented = returnTrue;
                    e.returnValue = false;
                };
            }
        };
        e.target = triggeredElement || e.target || e.srcElement;
        e.preventDefault = preventDefaultConstructor();
        e.stopPropagation = e.stopPropagation ||
        function () {
            e.cancelBubble = true;
        };
        result = originalCallback.apply(this, [e].concat(e._args));
        if (!result) {
            e.preventDefault();
            e.stopPropagation();
        }
        return result;
    };
    return this.each(function () {
        var customEventCallback, customEventLoop, domEventCallback, evnObj, evnt, namespace, oEl, split, _i, _len;
        oEl = this;
        for (_i = 0, _len = evts.length; _i < _len; _i++) {
            evnt = evts[_i];
            split = evnt.split(".");
            evt = split[0];
            namespace = (split.length > 0 ? split[1] : null);
            domEventCallback = function (originalEvent) {
                if (oEl.ssEventTrigger) {
                    originalEvent._namespace = oEl.ssEventTrigger._namespace;
                    originalEvent._args = oEl.ssEventTrigger._args;
                    oEl.ssEventTrigger = null;
                }
                return encasedCallback.call(oEl, originalEvent, namespace);
            };
            customEventCallback = null;
            customEventLoop = null;
            initEventCache(this, evt);
            if ("addEventListener" in this) {
                this.addEventListener(evt, domEventCallback, false);
            } else if (this.attachEvent) {
                if (this["on" + evt] !== void 0) {
                    this.attachEvent("on" + evt, domEventCallback);
                }
            }
            evnObj = {
                callfunc: customEventCallback || domEventCallback,
                isCustomEvent: !! customEventCallback,
                customEventLoop: customEventLoop,
                originalCallback: originalCallback,
                namespace: namespace
            };
            addToEventCache(this, evt, evnObj);
            return;
        }
    });
};

junction.fn.on = junction.fn.bind;


/**
 @license
 Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
 This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
 The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
 The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
 Code distributed by Google as part of the polymer project is also
 subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
 */

(function (global) {

    /**
     Schedules |dispatchCallback| to be called in the future.
     @param {MutationObserver} observer
     */
    var JsMutationObserver, MutationRecord, Registration, clearRecords, copyMutationRecord, currentRecord, dispatchCallbacks, forEachAncestorAndObserverEnqueueRecord, getRecord, getRecordWithOldValue, isScheduled, recordRepresentsCurrentMutation, recordWithOldValue, registrationsTable, removeTransientObserversFor, scheduleCallback, scheduledObservers, selectRecord, sentinel, setImmediate, setImmediateQueue, uidCounter, wrapIfNeeded;
    scheduleCallback = function (observer) {
        var isScheduled;
        scheduledObservers.push(observer);
        if (!isScheduled) {
            isScheduled = true;
            setImmediate(dispatchCallbacks);
        }
    };
    wrapIfNeeded = function (node) {
        return window.ShadowDOMPolyfill && window.ShadowDOMPolyfill.wrapIfNeeded(node) || node;
    };
    dispatchCallbacks = function () {
        var anyNonEmpty, isScheduled, observers, scheduledObservers;
        isScheduled = false;
        observers = scheduledObservers;
        scheduledObservers = [];
        observers.sort(function (o1, o2) {
            return o1.uid_ - o2.uid_;
        });
        anyNonEmpty = false;
        observers.forEach(function (observer) {
            var queue;
            queue = observer.takeRecords();
            removeTransientObserversFor(observer);
            if (queue.length) {
                observer.callback_(queue, observer);
                anyNonEmpty = true;
            }
        });
        if (anyNonEmpty) {
            dispatchCallbacks();
        }
    };
    removeTransientObserversFor = function (observer) {
        observer.nodes_.forEach(function (node) {
            var registrations;
            registrations = registrationsTable.get(node);
            if (!registrations) {
                return;
            }
            registrations.forEach(function (registration) {
                if (registration.observer === observer) {
                    registration.removeTransientObservers();
                }
            });
        });
    };

    /**
     This function is used for the "For each registered observer observer (with
     observer's options as options) in target's list of registered observers,
     run these substeps:" and the "For each ancestor ancestor of target, and for
     each registered observer observer (with options options) in ancestor's list
     of registered observers, run these substeps:" part of the algorithms. The
     |options.subtree| is checked to ensure that the callback is called
     correctly.
     
     @param {Node} target
     @param {function(MutationObserverInit):MutationRecord} callback
     */
    forEachAncestorAndObserverEnqueueRecord = function (target, callback) {
        var j, node, options, record, registration, registrations;
        node = target;
        while (node) {
            registrations = registrationsTable.get(node);
            if (registrations) {
                j = 0;
                while (j < registrations.length) {
                    registration = registrations[j];
                    options = registration.options;
                    if (node !== target && !options.subtree) {
                        j++;
                        continue;
                    }
                    record = callback(options);
                    if (record) {
                        registration.enqueue(record);
                    }
                    j++;
                }
            }
            node = node.parentNode;
        }
    };

    /**
     The class that maps to the DOM MutationObserver interface.
     @param {Function} callback.
     @constructor
     */
    JsMutationObserver = function (callback) {
        this.callback_ = callback;
        this.nodes_ = [];
        this.records_ = [];
        this.uid_ = ++uidCounter;
    };

    /**
     @param {string} type
     @param {Node} target
     @constructor
     */
    MutationRecord = function (type, target) {
        this.type = type;
        this.target = target;
        this.addedNodes = [];
        this.removedNodes = [];
        this.previousSibling = null;
        this.nextSibling = null;
        this.attributeName = null;
        this.attributeNamespace = null;
        this.oldValue = null;
    };
    copyMutationRecord = function (original) {
        var record;
        record = new MutationRecord(original.type, original.target);
        record.addedNodes = original.addedNodes.slice();
        record.removedNodes = original.removedNodes.slice();
        record.previousSibling = original.previousSibling;
        record.nextSibling = original.nextSibling;
        record.attributeName = original.attributeName;
        record.attributeNamespace = original.attributeNamespace;
        record.oldValue = original.oldValue;
        return record;
    };

    /**
     Creates a record without |oldValue| and caches it as |currentRecord| for
     later use.
     @param {string} oldValue
     @return {MutationRecord}
     */
    getRecord = function (type, target) {
        var currentRecord;
        return currentRecord = new MutationRecord(type, target);
    };

    /**
     Gets or creates a record with |oldValue| based in the |currentRecord|
     @param {string} oldValue
     @return {MutationRecord}
     */
    getRecordWithOldValue = function (oldValue) {
        var recordWithOldValue;
        if (recordWithOldValue) {
            return recordWithOldValue;
        }
        recordWithOldValue = copyMutationRecord(currentRecord);
        recordWithOldValue.oldValue = oldValue;
        return recordWithOldValue;
    };
    clearRecords = function () {
        var currentRecord, recordWithOldValue;
        currentRecord = recordWithOldValue = undefined;
    };

    /**
     @param {MutationRecord} record
     @return {boolean} Whether the record represents a record from the current
     mutation event.
     */
    recordRepresentsCurrentMutation = function (record) {
        return record === recordWithOldValue || record === currentRecord;
    };

    /**
     Selects which record, if any, to replace the last record in the queue.
     This returns |null| if no record should be replaced.
     
     @param {MutationRecord} lastRecord
     @param {MutationRecord} newRecord
     @param {MutationRecord}
     */
    selectRecord = function (lastRecord, newRecord) {
        if (lastRecord === newRecord) {
            return lastRecord;
        }
        if (recordWithOldValue && recordRepresentsCurrentMutation(lastRecord)) {
            return recordWithOldValue;
        }
        return null;
    };

    /**
     Class used to represent a registered observer.
     @param {MutationObserver} observer
     @param {Node} target
     @param {MutationObserverInit} options
     @constructor
     */
    Registration = function (observer, target, options) {
        this.observer = observer;
        this.target = target;
        this.options = options;
        this.transientObservedNodes = [];
    };
    registrationsTable = new WeakMap();
    setImmediate = void 0;
    if (/Trident|Edge/.test(navigator.userAgent)) {
        setImmediate = setTimeout;
    } else if (window.setImmediate) {
        setImmediate = window.setImmediate;
    } else {
        setImmediateQueue = [];
        sentinel = String(Math.random());
        window.addEventListener("message", function (e) {
            var queue;
            if (e.data === sentinel) {
                queue = setImmediateQueue;
                setImmediateQueue = [];
                queue.forEach(function (func) {
                    func();
                });
            }
        });
        setImmediate = function (func) {
            setImmediateQueue.push(func);
            window.postMessage(sentinel, "*");
        };
    }
    isScheduled = false;
    scheduledObservers = [];
    uidCounter = 0;
    JsMutationObserver.prototype = {
        observe: function (target, options) {
            var i, registration, registrations;
            target = wrapIfNeeded(target);
            if (!options.childList && !options.attributes && !options.characterData || options.attributeOldValue && !options.attributes || options.attributeFilter && options.attributeFilter.length && !options.attributes || options.characterDataOldValue && !options.characterData) {
                throw new SyntaxError();
            }
            registrations = registrationsTable.get(target);
            if (!registrations) {
                registrationsTable.set(target, registrations = []);
            }
            registration = void 0;
            i = 0;
            while (i < registrations.length) {
                if (registrations[i].observer === this) {
                    registration = registrations[i];
                    registration.removeListeners();
                    registration.options = options;
                    break;
                }
                i++;
            }
            if (!registration) {
                registration = new Registration(this, target, options);
                registrations.push(registration);
                this.nodes_.push(target);
            }
            registration.addListeners();
        },
        disconnect: function () {
            this.nodes_.forEach((function (node) {
                var i, registration, registrations;
                registrations = registrationsTable.get(node);
                i = 0;
                while (i < registrations.length) {
                    registration = registrations[i];
                    if (registration.observer === this) {
                        registration.removeListeners();
                        registrations.splice(i, 1);
                        break;
                    }
                    i++;
                }
            }), this);
            this.records_ = [];
        },
        takeRecords: function () {
            var copyOfRecords;
            copyOfRecords = this.records_;
            this.records_ = [];
            return copyOfRecords;
        }
    };
    currentRecord = void 0;
    recordWithOldValue = void 0;
    Registration.prototype = {
        enqueue: function (record) {
            var lastRecord, length, recordToReplaceLast, records;
            records = this.observer.records_;
            length = records.length;
            if (records.length > 0) {
                lastRecord = records[length - 1];
                recordToReplaceLast = selectRecord(lastRecord, record);
                if (recordToReplaceLast) {
                    records[length - 1] = recordToReplaceLast;
                    return;
                }
            } else {
                scheduleCallback(this.observer);
            }
            records[length] = record;
        },
        addListeners: function () {
            this.addListeners_(this.target);
        },
        addListeners_: function (node) {
            var options;
            options = this.options;
            if (options.attributes) {
                node.addEventListener("DOMAttrModified", this, true);
            }
            if (options.characterData) {
                node.addEventListener("DOMCharacterDataModified", this, true);
            }
            if (options.childList) {
                node.addEventListener("DOMNodeInserted", this, true);
            }
            if (options.childList || options.subtree) {
                node.addEventListener("DOMNodeRemoved", this, true);
            }
        },
        removeListeners: function () {
            this.removeListeners_(this.target);
        },
        removeListeners_: function (node) {
            var options;
            options = this.options;
            if (options.attributes) {
                node.removeEventListener("DOMAttrModified", this, true);
            }
            if (options.characterData) {
                node.removeEventListener("DOMCharacterDataModified", this, true);
            }
            if (options.childList) {
                node.removeEventListener("DOMNodeInserted", this, true);
            }
            if (options.childList || options.subtree) {
                node.removeEventListener("DOMNodeRemoved", this, true);
            }
        },

        /**
         Adds a transient observer on node. The transient observer gets removed
         next time we deliver the change records.
         @param {Node} node
         */
        addTransientObserver: function (node) {
            var registrations;
            if (node === this.target) {
                return;
            }
            this.addListeners_(node);
            this.transientObservedNodes.push(node);
            registrations = registrationsTable.get(node);
            if (!registrations) {
                registrationsTable.set(node, registrations = []);
            }
            registrations.push(this);
        },
        removeTransientObservers: function () {
            var transientObservedNodes;
            transientObservedNodes = this.transientObservedNodes;
            this.transientObservedNodes = [];
            transientObservedNodes.forEach((function (node) {
                var i, registrations;
                this.removeListeners_(node);
                registrations = registrationsTable.get(node);
                i = 0;
                while (i < registrations.length) {
                    if (registrations[i] === this) {
                        registrations.splice(i, 1);
                        break;
                    }
                    i++;
                }
            }), this);
        },
        handleEvent: function (e) {
            var addedNodes, changedNode, name, namespace, nextSibling, oldValue, previousSibling, record, removedNodes, target;
            e.stopImmediatePropagation();
            switch (e.type) {
            case "DOMAttrModified":
                name = e.attrName;
                namespace = e.relatedNode.namespaceURI;
                target = e.target;
                record = new getRecord("attributes", target);
                record.attributeName = name;
                record.attributeNamespace = namespace;
                oldValue = (e.attrChange === MutationEvent.ADDITION ? null : e.prevValue);
                forEachAncestorAndObserverEnqueueRecord(target, function (options) {
                    if (!options.attributes) {
                        return;
                    }
                    if (options.attributeFilter && options.attributeFilter.length && options.attributeFilter.indexOf(name) === -1 && options.attributeFilter.indexOf(namespace) === -1) {
                        return;
                    }
                    if (options.attributeOldValue) {
                        return getRecordWithOldValue(oldValue);
                    }
                    return record;
                });
                break;
            case "DOMCharacterDataModified":
                target = e.target;
                record = getRecord("characterData", target);
                oldValue = e.prevValue;
                forEachAncestorAndObserverEnqueueRecord(target, function (options) {
                    if (!options.characterData) {
                        return;
                    }
                    if (options.characterDataOldValue) {
                        return getRecordWithOldValue(oldValue);
                    }
                    return record;
                });
                break;
            case "DOMNodeRemoved":
                this.addTransientObserver(e.target);
                break;
            case "DOMNodeInserted":
                target = e.relatedNode;
                changedNode = e.target;
                addedNodes = void 0;
                removedNodes = void 0;
                if (e.type === "DOMNodeInserted") {
                    addedNodes = [changedNode];
                    removedNodes = [];
                } else {
                    addedNodes = [];
                    removedNodes = [changedNode];
                }
                previousSibling = changedNode.previousSibling;
                nextSibling = changedNode.nextSibling;
                record = getRecord("childList", target);
                record.addedNodes = addedNodes;
                record.removedNodes = removedNodes;
                record.previousSibling = previousSibling;
                record.nextSibling = nextSibling;
                forEachAncestorAndObserverEnqueueRecord(target, function (options) {
                    if (!options.childList) {
                        return;
                    }
                    return record;
                });
            }
            clearRecords();
        }
    };
    global.JsMutationObserver = JsMutationObserver;
    if (!global.MutationObserver) {
        global.MutationObserver = JsMutationObserver;
    }
})(this);

(function () {
    var MutationObsever, mutationHandler, myObserver, obsConfig;
    MutationObsever = window.MutationObserver || window.WebKitMutationObserver;
    if (!MutationObsever) {
        return;
    }
    mutationHandler = function (mutations) {
        var changed, whiteList, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = mutations.length; _i < _len; _i++) {
            changed = mutations[_i];
            whiteList = ["HEAD", "HTML", "BODY", "TITLE", "SCRIPT"];
            if (whiteList.indexOf(changed.target.nodeName) > -1 || changed.addedNodes.length === 0) {
                continue;
            }
            _results.push(junction.updateModels(changed.target));
        }
        return _results;
    };
    myObserver = new MutationObsever(mutationHandler);
    obsConfig = {
        childList: true,
        characterData: true,
        attributes: true,
        subtree: true
    };
    myObserver.observe(document, obsConfig);
})();


/*

  Bind a callback to an event for the currrent
  set of elements, unbind after one occurence.

  @param {string} event The event(s) to watch for.
  @param {function} callback Callback to invoke on the event.
  @return junction
  @this junction
 */

junction.fn.one = function (event, callback) {
    var evts;
    evts = event.split(" ");
    return this.each(function () {
        var $t, cbs, thisevt, _i, _len;
        cbs = {};
        $t = junction(this);
        for (_i = 0, _len = evts.length; _i < _len; _i++) {
            thisevt = evts[_i];
            cbs[thisevt] = function (e) {
                var j;
                $t = junction(this);
                for (j in cbs) {
                    $t.unbind(j, cbs[j]);
                }
                return callback.apply(this, [e].concat(e._args));
            };
            $t.bind(thisevt, cbs[thisevt]);
            return;
        }
    });
};


/*

  Trigger an event on each of the DOM elements in the current set.

  @param {string} event The event(s) to trigger.
  @param {object} args Arguments to append to callback invocations.
  @return junction
  @this junction
 */

junction.fn.trigger = function (event, args) {
    var evts;
    evts = event.split(" ");
    return this.each(function () {
        var evnt, evt, namespace, split, _i, _len;
        for (_i = 0, _len = evts.length; _i < _len; _i++) {
            evnt = evts[_i];
            split = evnt.split(".");
            evt = split[0];
            namespace = (split.length > 0 ? split[1] : null);
            if (evt === "click") {
                if (this.tagName === "INPUT" && this.type === "checkbox" && this.click) {
                    this.click();
                    return false;
                }
            }
            if (document.createEvent) {
                event = document.createEvent("Event");
                event.initEvent(evt, true, true);
                event._args = args;
                event._namespace = namespace;
                this.dispatchEvent(event);
            } else if (document.createEventObject) {
                if (("" + this[evt]).indexOf("function") > -1) {
                    this.ssEventTrigger = {
                        _namespace: namespace,
                        _args: args
                    };
                    this[evt]();
                } else {
                    document.documentElement[evt] = {
                        el: this,
                        _namespace: namespace,
                        _args: args
                    };
                }
            }
        }
    });
};


/*

  Trigger an event on the first element in the set,
  no bubbling, no defaults.

  @param {string} event The event(s) to trigger.
  @param {object} args Arguments to append to callback invocations.
  @return junction
  @this junction
 */

junction.fn.triggerHandler = function (event, args) {
    var bindings, e, el, i, ret;
    e = event.split(" ")[0];
    el = this[0];
    ret - void 0;
    if (document.createEvent && el.shoestringData && el.shoestringData.events && el.shoestringData.events[e]) {
        bindings = el.shoestringData.events[e];
        for (i in bindings) {
            if (bindings.hasOwnProperty(i)) {
                event = document.createEvent("Event");
                event.initEvent(e, true, true);
                event._args = args;
                args.unshift(event);
                ret = bindings[i].originalCallback.apply(event.target, args);
            }
        }
    }
    return ret;
};


/*

  Unbind a previous bound callback for an event.

  @param {string} event The event(s) the callback was bound to..
  @param {function} callback Callback to unbind.
  @return junction
  @this junction
 */

junction.fn.unbind = function (event, callback) {
    var evts, unbind, unbindAll;
    unbind = function (e, namespace, cb) {
        var bnd, bound, match, matched, _i, _j, _len, _len1, _results;
        matched = [];
        bound = this.junctionData.events[e];
        if (!bound.length) {
            return;
        }
        for (_i = 0, _len = bound.length; _i < _len; _i++) {
            bnd = bound[_i];
            if (!namespace || namespace === bnd.namespace) {
                if (cb === void 0 || cb === bnd.originalCallback) {
                    if (window["removeEventListener"]) {
                        this.removeEventListener(e, bnd.callback, false);
                    } else if (this.detachEvent) {
                        this.detachEvent("on" + e, bnd.callback);
                        if (bound.length === 1 && this.junctionData.loop && this.junctionData.loop[e]) {
                            document.documentElement.detachEvent("onpropertychange", this.junctionData.loop[e]);
                        }
                    }
                    matched.push(bound.indexOf(bnd));
                }
            }
            return;
        }
        _results = [];
        for (_j = 0, _len1 = matched.length; _j < _len1; _j++) {
            match = matched[_j];
            _results.push(this.junctionData.events[e].splice(matched.indexOf(match), 1));
        }
        return _results;
    };
    unbindAll = function (namespace, cb) {
        var evtKey;
        for (evtKey in this.junctionData.events) {
            unbind.call(this, evtKey, namespace, cb);
        }
    };
    evts = (event ? event.split(" ") : []);
    return this.each(function () {
        var evnt, evt, namespace, split, _i, _len, _results;
        if (!this.junctionData || !this.junctionData.events) {
            return;
        }
        if (!evts.length) {
            return unbindAll.call(this);
        } else {
            _results = [];
            for (_i = 0, _len = evts.length; _i < _len; _i++) {
                evnt = evts[_i];
                split = evnt.split(".");
                evt = split[0];
                namespace = (split.length > 0 ? split[1] : null);
                if (evt) {
                    _results.push(unbind.call(this, evt, namespace, callback));
                } else {
                    _results.push(unbindAll.call(this, namespace, callback));
                }
            }
            return _results;
        }
    });
};

junction.fn.off = junction.fn.unbind;

junction.addModel = function (scope, model, attr, cb, force) {
    var target, _i, _len, _ref;
    _ref = scope.querySelectorAll(attr);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        target = _ref[_i];
        this.nameSpace(target, attr, model, force);
    }
    if (scope.querySelectorAll(attr).length) {
        if (typeof cb === "function") {
            return cb();
        }
    }
};

junction.addPlugin = function (name, obj, attr, cb) {
    var plugin, savePlugin, _i, _len, _ref;
    savePlugin = (function (_this) {
        return function (name, obj, attr, cb) {
            return _this['plugins'][name] = {
                _id: name,
                model: obj,
                attr: attr,
                callback: cb
            };
        };
    })(this);
    if (this.plugins.length) {
        _ref = this.plugins;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            plugin = _ref[_i];
            if (plugin._id === obj.name) {
                savePlugin(name, obj, attr, cb);
            }
            this.addModel(document, obj, attr, cb);
            return;
        }
    } else {
        savePlugin(name, obj, attr, cb);
    }
    return this.addModel(document, obj, attr, cb);
};

junction.nameSpace = function (target, attribute, obj, force) {
    var originalAttr, params;
    originalAttr = attribute.replace(/[\[\]']+/g, '');
    params = target.attributes[originalAttr].value.split(',');
    params = params.map(function (param) {
        return param.trim();
    });
    attribute = originalAttr.split('-');
    if (!this[attribute[1]]) {
        this[attribute[1]] = {};
    }
    if (!this[attribute[1]][params[0]] || force) {
        this[attribute[1]][params[0]] = null;
        return this[attribute[1]][params[0]] = new obj(target, originalAttr);
    }
};

junction.updateModels = function (scope, force) {
    var plugin, _i, _len, _ref, _results;
    _ref = this.flattenObject(this['plugins']);
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        plugin = _ref[_i];
        _results.push(this.addModel(scope, plugin.model, plugin.attr, false, force));
    }
    return _results;
};