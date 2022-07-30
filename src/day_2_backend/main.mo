import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Char "mo:base/Char";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {
type Pattern = {#char : Char; #text : Text; #predicate : (Char -> Bool)};

  // public func nat_converter(n: Nat8): async Nat {
  //   return Nat8.toNat(n);
  // };

  // public func test(): async () {
  //   let a : Text = "Motoko";

  //   for (char in a.chars()) {
  //     Debug.print(debug_show(char));
  //     // return char;
  //   };
  // };

  // public func num_char(t : Text) : async Nat {
  //   return t.size();
  // };
  
  // use # to concat two string

  // public func uni_to_char (n : Nat32) : async Text {
  //   let char = Char.fromNat32(n);
  //   return Char.toText(char);
  // }


  public func nat_to_nat8 (n : Nat) : async Nat8 {
      return Nat8.fromNat(n);
  };
  public func max_number_with_n_bits (n : Nat) : async Text {
      // var a : Nat64.fromNat(n);
      // var m : Nat64 = 1;
      return Nat64.toText(1<<Nat64.fromNat(n) - 1);
  };
  public func decimal_to_bits (m : Nat) : async Text {
      var n : Nat = m;
      if (n == 0) return "0";
      var res : Text = "";
      while (n > 0) {
        res := Nat.toText(Nat.rem(n, 2)) # res;
        n := Nat.div(n, 2);
      };
      return res;
  };
  public func capitalize_character (n : Char) : async Char {
    if (Char.isLowercase(n)) {
      return Char.fromNat32(Char.toNat32(n)-32);
    }; 
    return n;
  };

  private func uppercase_character (n : Char) : Char {
    if (Char.isLowercase(n)) {
      return Char.fromNat32(Char.toNat32(n)-32);
    }; 
    return n;
  };

  private func lowercase_text (n : Char) : Char {
    if (Char.isUppercase(n)) {
      return Char.fromNat32(Char.toNat32(n)+32);
    }; 
    return n;
  };
  public func capitalize_text (n : Text) : async Text {
    var iter : Iter.Iter<Char> = Text.toIter(Text.map(n, lowercase_text));
    return switch (iter.next()) {
      case null "empty input";
      case (?c) Text.fromChar(uppercase_character(c)) # Text.fromIter(iter);
    };
  };
  public func is_inside (t : Text, c: Char) : async Bool {
    return Text.contains(t, #char c);
  };
  public func trim_whitespace (n : Text) : async Text {
    return Text.trim(n, #char ' ');
  };
  public func duplicated_character (n : Text) : async Text {
    var res : Text = "";
    for (c in n.chars()) {
      if (Text.contains(res, #char c)) return Text.fromChar(c);
      res #= Text.fromChar(c);
    };
    return res;
  };
  public func size_in_bytes (n : Text) : async Nat {
    return Text.encodeUtf8(n).size();
  };
  public func bubble_sort (n : [Nat]) : async [Nat] {
    let a : [var Nat] = Array.tabulateVar<Nat>(n.size(), func i { n[i] });
    let r = Iter.range(0, n.size()-1);
    
    for (i in r) {
      // var ok = false;
      let rij = Iter.range(1, n.size()-1);
      for (j in rij) {
        if (a[j-1] > a[j]) {
          a[j] += a[j-1];
          a[j-1] := a[j] - a[j-1];
          a[j] := a[j] - a[j-1];
          // ok := true;
        };
      };
      // if (ok == false) break; 
    };
    return Array.freeze(a);
  };
  public func nat_opt_to_nat (n : ?Nat, m : Nat) : async Nat {
    switch (n) { 
      case null {return m;};  
      case (?n) {return n;}; 
    }
  };
  public func day_of_the_week (n : Nat) : async ?Text {
    let d = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Sartuday", "Sunday"];
    // try {d[n-1]} catch (e) { return "null";}
    if (n >= 1 and n <= 7) return ?d[n-1];
    return null
  };
  public func populate_array (n : [?Nat]) : async [Nat] {
    return Array.map<?Nat, Nat>(n, func i { 
      switch (i) {
        case null { return 0; };
        case (?i) { return i; };
      } 
    });
  };
  public func sum_of_array (n : [Nat]) : async Nat {
    Array.foldLeft<Nat, Nat>(n, 0, func (s, i) {
      s + i
    })
  };
  public func squared_array (n : [Nat]) : async [Nat] {
    Array.map<Nat, Nat>(n, func i { 
      i ** 2
    })
  };
  public func increase_by_index (n : [Nat]) : async [Nat] {
    Array.mapEntries<Nat, Nat>(n, func (s, i) {
      s + i + 1
    })
  };
  private func contains<A> (n : [A], a : A, f : (A, A) -> Bool) : Bool {
    Array.foldLeft<A, Bool>(n, false, func (y, x) {
      y or f(a, x)
    })
  };

  public func nat8_contains (n : [Nat8], a : Nat8) : async Bool {
    contains<Nat8>(n, a, func (x, y) { x == y})
  }

};
