abstract class WalletStates{}
class PackageInitState extends WalletStates{}
class PackageLoadingState extends WalletStates{}
class PackageLoadedState extends WalletStates{}
class PackageEmptyState extends WalletStates{}
class PackageErrorState extends WalletStates{}

class PayLoadingState extends WalletStates {}
class PayLoadedState extends WalletStates {}

class HyperPayLoadingState extends WalletStates {}

class WalletLoadingState extends WalletStates{}
class TransactionsWalletEmptyState extends WalletStates{}
class WalletLoadedState extends WalletStates{}
class WalletErrorState extends WalletStates{}
class PaymentBrandChangeState extends WalletStates{}