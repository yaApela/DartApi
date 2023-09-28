import 'dart:async';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../utils/response_model.dart';

class AppTokenController extends Controller {
  @override
  FutureOr<RequestOrResponse?> handle(Request request) {
    try {
      final header = request.raw.headers.value(HttpHeaders.authorizationHeader);

      final token = const AuthorizationBearerParser().parse(header);

      final jwtClaim = verifyJwtHS256Signature(token ?? "", "SECRET_KEY");

      jwtClaim.validate();
      return request;
    } on JwtException catch (e) {
      return Response.serverError(body: ModelResponse(message: e.message));
    }
  }
}
