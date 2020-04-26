import 'package:Tether/store/index.dart';

import './room/model.dart';

List<Room> rooms(AppState state) {
  return state.roomStore.roomList;
}

Room room({AppState state, String id}) {
  if (state.roomStore.rooms == null) return Room();
  return state.roomStore.rooms[id];
}

List<Room> sortedPrioritizedRooms(Map rooms) {
  final List<Room> sortedList =
      rooms != null ? List<Room>.from(rooms.values) : [];

  // sort descending
  sortedList.sort((a, b) {
    // Prioritze if a direct chat
    if (a.direct && !b.direct) {
      return -1;
    }
    if (!a.direct && b.direct) {
      return 1;
    }
    // Otherwise, use timestamp
    if (a.lastUpdate > b.lastUpdate) {
      return -1;
    }
    if (a.lastUpdate < b.lastUpdate) {
      return 1;
    }

    return 0;
  });

  return sortedList;
}