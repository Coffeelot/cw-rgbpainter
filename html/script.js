let cwRGB = {}

$(document).ready(function(){
    $('.painter-container').hide();
    window.addEventListener('message', function(event){
        var eventData = event.data;
        if (eventData.action == "cwRGB") {
            if (eventData.toggle) {
                cwRGB.Open()
            }
        }
    });
});

var coatTypePrim = 1
var coatTypeSec = 1

var rP = 0
var gP = 0
var bP = 0
var rS = 0
var gS = 0
var bS = 0


function handleConfirm() {
    var primary = { rP, gP, bP }
    var secondary = { rS, gS, bS }
    $.post('https://cw-rgbpainter/attemptPaint', JSON.stringify({primary, secondary, coatPrimary: coatTypePrim, coatSecondary: coatTypeSec}), function(success){
        if (success) {
            console.log('successfully painted a vehicle')
        }
    })
    $('.painter-container').fadeOut(250);
}

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
      r: parseInt(result[1], 16),
      g: parseInt(result[2], 16),
      b: parseInt(result[3], 16)
    } : null;
}

function doColor(coat) {
    if(coat == 1) {
        coatType = coatTypePrim
        r = rP
        g = gP
        b = bP
    } else {
        coatType = coatTypeSec
        r = rS
        g = gS
        b = bS
    }
    $.post('https://cw-rgbpainter/handleColor', JSON.stringify({ r,g,b, coat: JSON.stringify(coat) , type:JSON.stringify(coatType) }), function(success){
        console.log('hmm', success)
    })
}

function handleChange(value, coat) {
    console.log('WOWOWO')
    var rgb = hexToRgb(value)
    var r = rgb.r;
    var g = rgb.g;
    var b = rgb.b;
    console.log(r, g, b, coat)
    let coatType = 1
    if(coat == 1) {
        coatType = coatTypePrim
        rP = r
        gP = g
        bP = b
    } else {
        coatType = coatTypeSec
        rS = r
        gS = g
        bS = b
    }
    doColor(coat)
}

function handleChangeCoatType(value, coat) {
    if(coat == 1) {
        coatTypePrim = value
        doColor(1)
    } else {
        coatTypeSec = value
        doColor(2)
    }
}

let goBack = function() {
    LoadCategoryList()
}

function rgbToHex(r, g, b) {
    return "#" + (1 << 24 | r << 16 | g << 8 | b).toString(16).slice(1);
  }

cwRGB.Open = function() {
    $.post('https://cw-rgbpainter/getOGcolors', function(colors){
        if (colors) {
            rP = colors.prim[0]
            gP = colors.prim[1]
            bP = colors.prim[2]
            rS = colors.sec[0]
            gS = colors.sec[1]
            bS = colors.sec[2]
            coatTypePrim = colors.primType
            coatTypeSec = colors.secType
            console.log('orignal coats', coatTypePrim, coatTypeSec)
            $('#colorPickerPrim').val(rgbToHex(rP,gP,bP));
            $('#colorPickerSec').val(rgbToHex(rS,gS,bS));
            $(`input[type=radio][name=prim][value=${coatTypePrim}]`).prop('checked', true);
            $(`input[type=radio][name=sec][value=${coatTypeSec}]`).prop('checked', true);
            $('.painter-container').fadeIn(950);            
        } else {
            rP = 0
            gP = 0
            bP = 0
            rS = 0
            gS = 0
            bS = 0
            coatTypePrim = 1
            coatTypeSec = 1
            $('.painter-container').fadeIn(950);
        }
    })
}

cwRGB.Close = function() {
    $('.painter-container').fadeOut(250);
    $.post('https://cw-rgbpainter/closePaint');
}

$(document).on('keydown', function(event) {
    switch(event.keyCode) {
        case 27:
            cwRGB.Close();
            break;
    }
});

$(document).click(function(event) { 
    var $target = $(event.target);
    if(!$target.closest('.app-container').length && 
    $('.app-container').is(":visible")) {
      cwRGB.Close()
    }        
  });