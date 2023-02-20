import M "mo:matchers/Matchers";
import Library "../src/Library";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";

let suite = S.suite(
  "firstText",
  [
    S.test(
      "Is True",
      true,
      M.equals(T.bool(true)),
    ),
  ],
);

S.run(suite);
