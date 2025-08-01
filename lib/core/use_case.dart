abstract interface class UseCase<Type, Params> {
  Type call(Params params);
}
