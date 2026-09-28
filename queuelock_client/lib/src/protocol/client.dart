/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:queuelock_client/src/protocol/counter.dart' as _is6j3804;
import 'package:queuelock_client/src/protocol/greetings/greeting.dart'
    as _ie3edy0j;
import 'package:queuelock_client/src/protocol/join_receipt.dart' as _ibo6j1no;
import 'package:queuelock_client/src/protocol/ledger_entry.dart' as _ioekpgt9;
import 'package:queuelock_client/src/protocol/queue.dart' as _ikbmde1j;
import 'package:queuelock_client/src/protocol/queue_info.dart' as _ialgs5pa;
import 'package:queuelock_client/src/protocol/queue_status.dart' as _id8crpji;
import 'package:queuelock_client/src/protocol/ticket.dart' as _ib0v6epf;
import 'package:queuelock_client/src/protocol/verify_result.dart' as _i15e72h6;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Staff admin endpoints. MVP: owner-only; every call checks that the
/// signed-in user owns the queue.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Creates a queue owned by the signed-in user. [callTimeoutSec] is the
  /// per-queue "come to the counter" grace period (minimum 10 seconds).
  _ida.Future<_ikbmde1j.Queue> createQueue(
    String name, {
    required int callTimeoutSec,
  }) => caller.callServerEndpoint<_ikbmde1j.Queue>(
    'admin',
    'createQueue',
    {
      'name': name,
      'callTimeoutSec': callTimeoutSec,
    },
  );

  /// Adds a named counter to [queueId].
  _ida.Future<_is6j3804.Counter> addCounter(
    int queueId,
    String name,
  ) => caller.callServerEndpoint<_is6j3804.Counter>(
    'admin',
    'addCounter',
    {
      'queueId': queueId,
      'name': name,
    },
  );

  /// Opens, pauses or closes [queueId].
  _ida.Future<_ikbmde1j.Queue> setStatus(
    int queueId,
    _id8crpji.QueueStatus status,
  ) => caller.callServerEndpoint<_ikbmde1j.Queue>(
    'admin',
    'setStatus',
    {
      'queueId': queueId,
      'status': status,
    },
  );
}

/// Public audit endpoints. Anyone can recompute a queue's ledger chain
/// and check a receipt against it.
/// {@category Endpoint}
class EndpointAudit extends _isc.EndpointRef {
  EndpointAudit(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'audit';

  /// Ledger page after [afterSeq], up to [limit] entries (clamped 1-200).
  _ida.Future<List<_ioekpgt9.LedgerEntry>> ledger(
    String slug, {
    required int afterSeq,
    required int limit,
  }) => caller.callServerEndpoint<List<_ioekpgt9.LedgerEntry>>(
    'audit',
    'ledger',
    {
      'slug': slug,
      'afterSeq': afterSeq,
      'limit': limit,
    },
  );

  /// Recomputes the whole chain. `firstBadSeq` locates tampering exactly.
  _ida.Future<_i15e72h6.VerifyResult> verify(String slug) =>
      caller.callServerEndpoint<_i15e72h6.VerifyResult>(
        'audit',
        'verify',
        {'slug': slug},
      );

  /// Checks a customer-held `(seq, hash)` receipt against the chain.
  _ida.Future<bool> checkReceipt(
    String slug,
    int seq,
    String hash,
  ) => caller.callServerEndpoint<bool>(
    'audit',
    'checkReceipt',
    {
      'slug': slug,
      'seq': seq,
      'hash': hash,
    },
  );
}

/// Staff counter endpoints. The signed-in user must own the queue; the
/// owner can sign in on several devices and each device picks a counter.
/// {@category Endpoint}
class EndpointCounter extends _isc.EndpointRef {
  EndpointCounter(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'counter';

  /// Calls the longest-waiting ticket to [counterId]. Returns the called
  /// ticket, or null when nobody is waiting.
  _ida.Future<_ib0v6epf.Ticket?> callNext(int counterId) =>
      caller.callServerEndpoint<_ib0v6epf.Ticket?>(
        'counter',
        'callNext',
        {'counterId': counterId},
      );

  /// Moves a called ticket into service.
  _ida.Future<_ib0v6epf.Ticket> startServing(int ticketId) =>
      caller.callServerEndpoint<_ib0v6epf.Ticket>(
        'counter',
        'startServing',
        {'ticketId': ticketId},
      );

  /// Completes a serving ticket. With [callNext], the same counter
  /// immediately calls the next waiting ticket, which is returned
  /// (or null when nobody is waiting).
  _ida.Future<_ib0v6epf.Ticket?> complete(
    int ticketId, {
    required bool callNext,
  }) => caller.callServerEndpoint<_ib0v6epf.Ticket?>(
    'counter',
    'complete',
    {
      'ticketId': ticketId,
      'callNext': callNext,
    },
  );

  /// Takes a called (or serving) ticket out of the flow.
  _ida.Future<void> skip(int ticketId) => caller.callServerEndpoint<void>(
    'counter',
    'skip',
    {'ticketId': ticketId},
  );
}

/// Public customer endpoints. No sign-in; customers are identified by
/// ticket tokens. Thin: input validation lives here, rules in
/// [QueueService].
/// {@category Endpoint}
class EndpointQueue extends _isc.EndpointRef {
  EndpointQueue(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'queue';

  /// Joins the open queue [slug] with [nickname]. Returns the receipt;
  /// the token is shown to the customer exactly once.
  _ida.Future<_ibo6j1no.JoinReceipt> join(
    String slug,
    String nickname,
  ) => caller.callServerEndpoint<_ibo6j1no.JoinReceipt>(
    'queue',
    'join',
    {
      'slug': slug,
      'nickname': nickname,
    },
  );

  /// Cancels the ticket identified by [token].
  _ida.Future<void> leave(String token) => caller.callServerEndpoint<void>(
    'queue',
    'leave',
    {'token': token},
  );

  /// Public queue view: row, waiting count, counters.
  _ida.Future<_ialgs5pa.QueueInfo> info(String slug) =>
      caller.callServerEndpoint<_ialgs5pa.QueueInfo>(
        'queue',
        'info',
        {'slug': slug},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_ie3edy0j.Greeting> hello(String name) =>
      caller.callServerEndpoint<_ie3edy0j.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    admin = EndpointAdmin(this);
    audit = EndpointAudit(this);
    counter = EndpointCounter(this);
    queue = EndpointQueue(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdmin admin;

  late final EndpointAudit audit;

  late final EndpointCounter counter;

  late final EndpointQueue queue;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'admin': admin,
    'audit': audit,
    'counter': counter,
    'queue': queue,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
