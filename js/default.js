---
permalink: /common/js/default.js
---
"use strict";

$(document).ready(function(){
	$('.raw_source').click(function(e){
		e.preventDefault();
		var _main = $('main');
		var _this = $(this);
		var _parent = $(this).parent();
		var _raw = _this.data('raw');
		var _rawset = _parent.hasClass('active');


		if (_rawset) {
			_raw.hide();
			_main.show();
			_parent.removeClass('active');

		} else {
			_main.hide();
			if (_raw) {
				_raw.show();
			} else {
				_raw = $('<div>Loading...</div>');
				_raw.insertAfter(_main);
				
				$.get(_this.attr('href'), function(data){
					_raw.remove();
					_raw = $('<pre></pre>');
					_raw.insertAfter(_main);
					_raw.text(data);
					_this.data('raw', _raw);
				}).fail(function(){
			  	   _raw.text('Error loading ' + _this.attr('href'));
			    });

				_this.data('raw', _raw);
			}
			_parent.addClass('active');
		}

		_this.data('rawset', _rawset);
	});
});