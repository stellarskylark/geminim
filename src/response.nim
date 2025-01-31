import asyncfile

type RespStatus* = enum
  StatusNull
  StatusCGI
  
  StatusInputRequired = "10"
  StatusSensitiveInput = "11"
  StatusSuccess = "20"
  StatusSuccessDir = "21"
  StatusRedirect = "30"
  StatusRedirectPerm = "31"
  StatusTempError = "40"
  StatusServerUnavailable = "41"
  StatusCGIError = "42"
  StatusProxyError = "43"
  StatusSlowDown = "44"
  StatusError = "50"
  StatusNotFound = "51"
  StatusGone = "52"
  StatusProxyRefused = "53"
  StatusMalformedRequest = "59"
  StatusCertificateRequired = "60"
  StatusNotAuthorised = "61"
  StatusNotValid = "62"

type Response* = object
  meta*: string
  case code*: RespStatus
  of StatusSuccess:
    file*: AsyncFile
  of StatusSuccessDir:
    body*: string
  else: discard

{.push inline.}
proc strResp*(code: RespStatus, meta = ""): string =
  $code & ' ' & meta & "\r\n"

proc response*(code: RespStatus, meta = ""): Response =
  Response(code: code, meta: meta)
{.pop.}

const
  SuccessResp* = strResp(StatusSuccess, "text/gemini")
  TempErrorResp* = strResp(StatusTempError, "INTERNAL ERROR")
