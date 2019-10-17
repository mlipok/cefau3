#cs
	file: dialog_handler.au3
	author: wuuyi123
#ce

; ==================================================
; // CefFileDialogCallback
; ==================================================

with _AutoItObject_Class()

	.AddProperty('__ptr')
	.AddProperty('__type', 1, 'CefFileDialogCallback')

	.AddMethod('Continue', 	'__CefFileDialogCallback_Continue')
	.AddMethod('Cancel', 	'__CefFileDialogCallback_Cancel')

	global $__CefFileDialogCallback = .Object

endwith

; ==================================================

func CefFileDialogCallback_Create($ptr)
	local $self = _AutoItObject_Create($__CefFileDialogCallback)
	$self.__ptr = $ptr
	return $self
endfunc

; ==================================================

func __CefFileDialogCallback_Continue($self, $selected_accept_filter = null, $file_paths = null)
	dllcall($__Cefau3Dll__, 'none:cdecl', 'CefFileDialogCallback_Continue', 'ptr', $self.__ptr, 'int', $selected_accept_filter, 'ptr', $file_paths)
endfunc

func __CefFileDialogCallback_Cancel($self)
	dllcall($__Cefau3Dll__, 'none:cdecl', 'CefFileDialogCallback_Cancel', 'ptr', $self.__ptr)
endfunc

; ==================================================
; // CefDialogHandler
; ==================================================

global $__CefDialogHandler = null

$__CefDialogHandler = _AutoItObject_Create()

_AutoItObject_AddProperty($__CefDialogHandler, '__ptr')
_AutoItObject_AddProperty($__CefDialogHandler, '__type', 1, 'CefDialogHandler')

_AutoItObject_AddMethod($__CefDialogHandler, 'OnFileDialog', '__CefDialogHandler_OFD')

global const $__CefDialogHandler__OFD	= Cef_CallbackRegister(__CefDialogHandler__OFD, 'int', 'ptr;ptr;int;ptr;ptr;ptr;int;ptr')

; ==================================================

func CefDialogHandler_Create($ptr = null)
	local $self = _AutoItObject_Create($__CefDialogHandler)
	if ($ptr == null) then $ptr = dllcall($__Cefau3Dll__, 'ptr:cdecl', 'CefDialogHandler_Create')[0]
	$self.__ptr = $ptr
	return $self
endfunc

; ==================================================

func __CefDialogHandler_OFD($self, $func = null)
	if @numparams == 1 then return dllcall($__Cefau3Dll__, 'str:cdecl', 'CefDialogHandler_Get_OFD', 'ptr', $self.__ptr)[0]

	dllcall($__Cefau3Dll__, 'none:cdecl', 'CefDialogHandler_Set_OFD', 'ptr', $self.__ptr, 'str', funcname($func))
	dllcall($__Cefau3Dll__, 'none:cdecl', 'CefDialogHandler_OFD', 'ptr', $self.__ptr, 'ptr', funcname($func) ? $__CefDialogHandler__OFD : null)
endfunc

; ==================================================

func __CefDialogHandler__OFD($self, $browser, $mode, $title, $default_file_path, $accept_filters, $selected_accept_filter, $callback)
	$self = dllcall($__Cefau3Dll__, 'str:cdecl', 'CefDialogHandler_Get_OFD', 'ptr', $self)[0]
	$browser = CefBrowser_Create($browser)
	;$mode
	$title = CefString_Create($title)
	$default_file_path = CefString_Create($default_file_path)
	$accept_filters = CefStringList_Create($selected_accept_filter)
	;$selected_accept_filter
	$callback = CefFileDialogCallback_Create($callback)

	return call($self, $browser, $mode, $title, $default_file_path, $accept_filters, $selected_accept_filter, $callback)
endfunc