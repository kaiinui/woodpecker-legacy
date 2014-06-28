var W=window,E=W.Element,P="prototype";

W.$$ = function(s, c){
    return (c ? c : document)['querySelectorAll'](s);
};

W.NodeList[P].each = Array[P].forEach;
W.NodeList[P].forEach = Array[P].forEach;

E[P].find=function(q){
    return $$(q, this);
};

E[P].attr=function(key, value){
    if(value){
        this.setAttribute(key, value);
        return this;
    }else{
        return this.getAttribute(key);
    }
};

E[P].css=function(prop, value){
    if(value){
        this.style[prop]=value;
        return this;
    }else{
        return this.style[prop];
    }
};

E[P].on=function(type, callback){
    this.addEventListener(type, callback);
    return this;
};