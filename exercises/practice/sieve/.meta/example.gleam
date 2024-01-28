import gleam/list
import gleam/iterator
import gleam/bool

pub fn primes_up_to(upper_bound: Int) -> List(Int) {
  // 2 is the first prime number. Smaller input values are invalid.
  use <- bool.guard(when: upper_bound < 2, return: [])

  // Generate a list of all integers from 2 up to the upper bound.
  let possible_primes = list.range(from: 2, to: upper_bound)

  // Run the sieve algorithm on the list of possible primes.
  sieve([], [], possible_primes, upper_bound)
  |> list.reverse
}

fn sieve(
  primes: List(Int),
  composites: List(Int),
  candidates: List(Int),
  upper_bound: Int,
) -> List(Int) {
  // BASE CASE: If there are no more candidates, we're done.
  use <- bool.guard(when: list.is_empty(candidates), return: primes)
  let assert [next, ..rest] = candidates

  case list.contains(composites, next) {
    // If the next candidate is a multiple of one of our discovered primes, skip it
    True -> sieve(primes, composites, rest, upper_bound)

    // The next candidate is not a multiple of any of our discovered primes, so it's prime.
    False -> {
      // Generate a list from n^2 to the upper bound of the multiples of
      // our newly discovered prime.
      let multiples =
        iterator.iterate(next * next, fn(state) { state + next })
        |> iterator.take_while(fn(n) { n <= upper_bound })
        |> iterator.to_list

      // Add the newly discovered prime to the list of primes, and
      // add the multiples of the prime to the list of composites.
      sieve(
        [next, ..primes],
        list.append(composites, multiples),
        rest,
        upper_bound,
      )
    }
  }
}
