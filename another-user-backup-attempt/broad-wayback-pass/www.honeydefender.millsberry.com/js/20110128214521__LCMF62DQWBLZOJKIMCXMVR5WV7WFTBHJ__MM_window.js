/*!
 * MM.window 
 * - utilities for dealing with the browser window
 * @author Miller Medeiros <http://www.millermedeiros.com/>
 * @version 0.2 (2010/01/26)
 * Released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
(function(){
	
	this.MM = this.MM || {};
	MM.window = MM.window || {};
	
	//local storage for performance improvement
	var doc = document,
		win = window,
		mmwin = MM.window;
	
	/**
	 * Get window innerWidth
	 * @return {int} innerWidth
	 * @static
	 */
	mmwin.getInnerWidth = function(){
		return (win.innerWidth)? win.innerWidth : ((doc.documentElement.clientWidth)? doc.documentElement.clientWidth : doc.body.clientWidth);
	};
	
	/**
	 * Get window innerHeight
	 * @return {int} innerHeight
	 * @static
	 */
	mmwin.getInnerHeight = function(){
		return (win.innerHeight)? win.innerHeight : ((doc.documentElement.clientHeight)? doc.documentElement.clientHeight : doc.body.clientHeight);
	};
	
	/**
	 * Get window scrollTop
	 * @return {int} scrollTop
	 * @static
	 */
	mmwin.getScrollTop = function(){
		return doc.body.scrollTop ? doc.body.scrollTop : (win.pageYOffset ? win.pageYOffset : (doc.body.parentElement ? doc.body.parentElement.scrollTop : 0));
	};
	
	/**
	 * Get window scrollLeft
	 * @return {int} scrollLeft
	 * @static
	 */
	mmwin.getScrollLeft = function(){
		return doc.body.scrollLeft ? doc.body.scrollLeft : (win.pageXOffset ? win.pageXOffset : (doc.body.parentElement ? doc.body.parentElement.scrollLeft : 0));
	};
	
	/**
	 * Get total width of the document
	 * @return {int} document width
	 * @static
	 */
	mmwin.getDocumentWidth = function(){
		return Math.max(doc.documentElement.scrollWidth, mmwin.getInnerWidth());
	};
	
	/**
	 * Get total height of the document
	 * @return {int} document height
	 * @static
	 */
	mmwin.getDocumentHeight = function(){
		return Math.max(doc.documentElement.scrollHeight, mmwin.getInnerHeight());
	};
	
})();