;;;
(autoload 'artist-mode "artist" "Enter artist-mode" t)

;; (defalias 'artist 'artist-mode)
(defalias 'graphic 'artist-mode)


;; Drawing with the mouse:

;;  mouse-2
;;  shift mouse-2	Pops up a menu where you can select what to draw with
;; 		mouse-1, and where you can do some settings (described
;; 		below).

;;  mouse-1
;;  shift mouse-1	Draws lines, rectangles or poly-lines, erases, cuts, copies
;; 		or pastes:

;; 		Operation	Not shifted		  Shifted
;; 		--------------------------------------------------------------
;;      Pen         fill-char at point        line from last point
;;                                                           to new point
;; 		--------------------------------------------------------------
;; 		Line		Line in any direction	  Straight line
;; 		--------------------------------------------------------------
;; 		Rectangle	Rectangle		  Square
;; 		--------------------------------------------------------------
;; 		Poly-line	Poly-line in any dir	  Straight poly-lines
;; 		--------------------------------------------------------------
;; 		Ellipses	Ellipses		  Circles
;; 		--------------------------------------------------------------
;; 		Text		Text (see thru)		  Text (overwrite)
;; 		--------------------------------------------------------------
;; 		Spray-can	Spray-can		  Set size for spray
;; 		--------------------------------------------------------------
;; 		Erase		Erase character		  Erase rectangle
;; 		--------------------------------------------------------------
;; 		Vaporize	Erase single line	  Erase connected
;; 							  lines
;; 		--------------------------------------------------------------
;; 		Cut		Cut rectangle		  Cut square
;; 		--------------------------------------------------------------
;; 		Copy		Copy rectangle		  Copy square
;; 		--------------------------------------------------------------
;; 		Paste		Paste			  Paste
;; 		--------------------------------------------------------------
;; 		Flood-fill	Flood-fill		  Flood-fill
;; 		--------------------------------------------------------------

;; 		* Straight lines can only go horizontally, vertically
;; 		  or diagonally.

;; 		* Poly-lines are drawn while holding mouse-1 down. When you
;; 		  release the button, the point is set. If you want a segment
;; 		  to be straight, hold down shift before pressing the
;; 		  mouse-1 button. Click mouse-2 or mouse-3 to stop drawing
;; 		  poly-lines.

;; 		* See thru for text means that text already in the buffer
;; 		  will be visible through blanks in the text rendered, while
;; 		  overwrite means the opposite.

;; 		* Vaporizing connected lines only vaporizes lines whose
;; 		  _endpoints_ are connected. See also the variable
;; 		  `artist-vaporize-fuzziness'.

;; 		* Cut copies, then clears the rectangle/square.

;; 		* When drawing lines or poly-lines, you can set arrows.
;; 		  See below under ``Arrows'' for more info.

;; 		* The mode line shows the currently selected drawing operation.
;; 		  In addition, if it has an asterisk (*) at the end, you
;; 		  are currently drawing something.

;; 		* Be patient when flood-filling -- large areas take quite
;; 		  some time to fill.


;;  mouse-3	Erases character under pointer
;;  shift mouse-3	Erases rectangle


;; Settings

;;  Set fill	Sets the character used when filling rectangles/squares

;;  Set line	Sets the character used when drawing lines

;;  Erase char	Sets the character used when erasing

;;  Rubber-banding	Toggles rubber-banding

;;  Trimming	Toggles trimming of line-endings (that is: when the shape
;; 		is drawn, extraneous white-space at end of lines is removed)

;;  Borders        Toggles the drawing of line borders around filled shapes.


;; Drawing with keys

;;  \\[artist-key-set-point]		Does one of the following:
;; 		For lines/rectangles/squares: sets the first/second endpoint
;; 		For poly-lines: sets a point (use C-u \\[artist-key-set-point] to set last point)
;; 		When erase characters: toggles erasing
;; 		When cutting/copying: Sets first/last endpoint of rect/square
;; 		When pasting: Pastes

;;  \\[artist-select-operation]	Selects what to draw

;;  Move around with \\[artist-next-line], \\[artist-previous-line], \\[artist-forward-char] and \\[artist-backward-char].

;;  \\[artist-select-fill-char]	Sets the charater to use when filling
;;  \\[artist-select-line-char]	Sets the charater to use when drawing
;;  \\[artist-select-erase-char]	Sets the charater to use when erasing
;;  \\[artist-toggle-rubber-banding]	Toggles rubber-banding
;;  \\[artist-toggle-trim-line-endings]	Toggles trimming of line-endings
;;  \\[artist-toggle-borderless-shapes]	Toggles borders on drawn shapes


;; Arrows

;;  \\[artist-toggle-first-arrow]		Sets/unsets an arrow at the beginning
;; 		of the line/poly-line

;;  \\[artist-toggle-second-arrow]		Sets/unsets an arrow at the end
;; 		of the line/poly-line


;; Selecting operation

;;  There are some keys for quickly selecting drawing operations:

;;  \\[artist-select-op-line]	Selects drawing lines
;;  \\[artist-select-op-straight-line]	Selects drawing straight lines
;;  \\[artist-select-op-rectangle]	Selects drawing rectangles
;;  \\[artist-select-op-square]	Selects drawing squares
;;  \\[artist-select-op-poly-line]	Selects drawing poly-lines
;;  \\[artist-select-op-straight-poly-line]	Selects drawing straight poly-lines
;;  \\[artist-select-op-ellipse]	Selects drawing ellipses
;;  \\[artist-select-op-circle]	Selects drawing circles
;;  \\[artist-select-op-text-see-thru]	Selects rendering text (see thru)
;;  \\[artist-select-op-text-overwrite]	Selects rendering text (overwrite)
;;  \\[artist-select-op-spray-can]	Spray with spray-can
;;  \\[artist-select-op-spray-set-size]	Set size for the spray-can
;;  \\[artist-select-op-erase-char]	Selects erasing characters
;;  \\[artist-select-op-erase-rectangle]	Selects erasing rectangles
;;  \\[artist-select-op-vaporize-line]	Selects vaporizing single lines
;;  \\[artist-select-op-vaporize-lines]	Selects vaporizing connected lines
;;  \\[artist-select-op-cut-rectangle]	Selects cutting rectangles
;;  \\[artist-select-op-copy-rectangle]	Selects copying rectangles
;;  \\[artist-select-op-paste]	Selects pasting
;;  \\[artist-select-op-flood-fill]	Selects flood-filling


;; Variables

;;  This is a brief overview of the different varaibles. For more info,
;;  see the documentation for the variables (type \\[describe-variable] <variable> RET).

;;  artist-rubber-banding		Interactively do rubber-banding or not
;;  artist-first-char		What to set at first/second point...
;;  artist-second-char		...when not rubber-banding
;;  artist-interface-with-rect	If cut/copy/paste should interface with rect
;;  artist-arrows			The arrows to use when drawing arrows
;;  artist-aspect-ratio		Character height-to-width for squares
;;  artist-trim-line-endings	Trimming of line endings
;;  artist-flood-fill-right-border	Right border when flood-filling
;;  artist-flood-fill-show-incrementally	Update display while filling
;;  artist-pointer-shape		Pointer shape to use while drawing
;;  artist-ellipse-left-char	Character to use for narrow ellipses
;;  artist-ellipse-right-char	Character to use for narrow ellipses
;;  artist-borderless-shapes       If shapes should have borders
;;  artist-picture-compatibility   Whether or not to be picture mode compatible
;;  artist-vaporize-fuzziness      Tolerance when recognizing lines
;;  artist-spray-interval          Seconds between repeated sprayings
;;  artist-spray-radius            Size of the spray-area
;;  artist-spray-chars             The spray-``color''
;;  artist-spray-new-chars         Initial spray-``color''

;; Hooks

;;  When entering artist-mode, the hook `artist-mode-init-hook' is called.
;;  When quitting artist-mode, the hook `artist-mode-exit-hook' is called.


(provide 'wuxch-artist)
