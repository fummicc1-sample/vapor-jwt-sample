import Foundation
import Atoms

struct UserAtom: StateAtom, Hashable {
	func defaultValue(context: Context) -> User? {
		nil
	}
}
