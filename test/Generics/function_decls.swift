// RUN: %target-parse-verify-swift

//===----------------------------------------------------------------------===//
// Generic function declarations
//===----------------------------------------------------------------------===//

func f0<T>(x: Int, y: Int, t: T) { }
func f1<T : Any>(x: Int, y: Int, t: T) { }
func f2<T : protocol<GeneratorType,Any>>(x: Int, y: Int, t: T) { }
func f3<T : () -> ()>(x: Int, y: Int, t: T) { } // expected-error{{expected a type name or protocol composition restricting 'T'}}
func f4<T>(x: T, y: T) { }

// Name lookup within local classes.
func f5<T, U>(x: T, y: U) {
  struct Local { // expected-error {{type 'Local' nested in generic function 'f5' is not allowed}}
    func f() {
      var t : T = 17 // expected-error{{'Int' is not convertible to 'T'}}
      var u : U = 17 // okay: refers to 'U' declared within the local class
    }
    typealias U = Int
  }
}

// Non-protocol type constraints.
func f6<T : Wonka>(x: T) {} // expected-error{{use of undeclared type 'Wonka'}}

// FIXME: The term 'inherit' is unfortunate here.
func f7<T : Int>(x: T) {} // expected-error{{inheritance from non-protocol, non-class type 'Int'}}

func f8<T> (x: Int) {} //expected-error{{There is no way to infer the generic parameter 'T' if it is not used in function signature}}

public class A<X> {
  init<T>(){} //expected-error{{There is no way to infer the generic parameter 'T' if it is not used in function signature}}
  public func f9<T, U>(x:T, y:X) {} //expected-error{{There is no way to infer the generic parameter 'U' if it is not used in function signature}}
  public func f10(x:Int) {}
  public func f11<T, U>(x:X, y:T) {} //expected-error{{There is no way to infer the generic parameter 'U' if it is not used in function signature}}
}
