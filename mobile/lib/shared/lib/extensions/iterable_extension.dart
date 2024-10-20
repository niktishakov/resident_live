extension IndexedMapping<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int, E) fn) {
    int i = 0;
    return map((e) => fn(i++, e));
  }
}
