import 'package:redux/redux.dart';
import 'package:syphon/global/print.dart';
import 'package:syphon/storage/index.dart';
import 'package:syphon/store/auth/actions.dart';
import 'package:syphon/store/auth/storage.dart';
import 'package:syphon/store/crypto/actions.dart';
import 'package:syphon/store/crypto/storage.dart';
import 'package:syphon/store/index.dart';
import 'package:syphon/store/media/actions.dart';
import 'package:syphon/store/rooms/actions.dart';
import 'package:syphon/store/rooms/storage.dart';

///
/// Storage Middleware
///
/// Save to storage based on which redux actions are fired
///
dynamic storageMiddleware<State>(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  switch (action.runtimeType) {
    // auth store
    case SetUser:
      printInfo(
        '[storageMiddleware] saving auth ${action.runtimeType.toString()}',
      );
      saveAuth(store.state.authStore, storage: Storage.main);
      break;
    // media store
    case UpdateMediaCache:
      // printInfo(
      //   '[storageMiddleware] saving media ${action.runtimeType.toString()}',
      // );
      // saveMedia(action.mxcUri, action.data, storage: Storage.main);
      break;
    case UpdateRoom:
      // TODO: create a mutation like SetSyncing to distinguish small but important room mutations
      if (action.syncing == null) {
        printInfo(
          '[storageMiddleware] saving room ${action.runtimeType.toString()}',
        );
        final room = store.state.roomStore.rooms[action.id];
        saveRoom(room, storage: Storage.main);
      }
      break;
    // crypto store - CUD ops
    case SetOlmAccountBackup:
    case SetDeviceKeysOwned:
    case ToggleDeviceKeysExist:
    case SetDeviceKeys:
    case SetOneTimeKeysClaimed:
    case SetOneTimeKeysCounts:
    case AddInboundKeySession:
    case AddOutboundKeySession:
    case AddOutboundMessageSession:
    case ResetCrypto:
      printInfo(
        '[storageMiddleware] saving crypto ${action.runtimeType.toString()}',
      );
      saveCrypto(store.state.cryptoStore, storage: Storage.main);
      break;

    default:
      break;
  }
}