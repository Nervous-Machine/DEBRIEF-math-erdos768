# DEBRIEF-math-erdos768

A DEBRIEF mission record (protocol https://github.com/Nervous-Machine/DEBRIEF) for **The claimed solution of Erdős Problem #768 (density of integers with a witness divisor for every prime factor)**.

**Standing.** Certified 0. Accepted 0. Refuted 0. Open gaps 3. This record is at tier zero: the claim and its public artifacts are pinned, the checks still owed are listed, and nothing has been run or read yet. The first contribution is open.

## The problem

Let A be the set of positive integers n such that for every prime p dividing n there is a divisor d of n, greater than one, with d congruent to one modulo p. Erdős showed the proportion of such n up to N lies between two bounds of the shape exp(minus a constant times the square root of log N times log log N), and asked whether the proportion has that shape with a single exact constant c. The set bounds the number of possible orders of non-cyclic simple groups.

Source: https://www.erdosproblems.com/768 (posed: Erdős (1974)).

## The claim

**Eric Li**, using GPT-5.5 Pro (as listed by the claimant), submitted 2026-07-17 at https://www.erdosproblems.com/forum/thread/768/proof-claims.

The claim is that the limit exists and the constant is one over two times the square root of log 2. The lower bound uses primes in disjoint logarithmic intervals with a fourth-moment argument from the multiplicative large sieve; the upper bound uses canonical witness divisors, a compression map with an injective reconstruction theorem for its fibres, and growing divisor moments. The author reports that the main theorem and its complete proof were checked in Lean 4.

Artifacts, pinned:

- an arXiv preprint: arXiv:2606.24872v2 "A Resolution of Erdős Problem 768: the Sylow Divisor Condition" (published 2026-06-23, last revised 2026-07-13)
- a public repository: github.com/ericlisg/erdos768-lean at commit e46ab245f1e5eb2d1f0b184874c4e32e02ad16c9 (2026-08-02); licence Apache-2.0; 38 Lean files; has a lakefile

Status on the problem page as of 2026-11-14: listed as one proof claim; not marked accepted by the site.

## What is owed

Each open gap is in `ASKS.md` with what closes it and who could act. In order:

1. **The Lean development has not been built or kernel-checked by anyone outside the claimant** (EG1): A rerun of the Lean build on an independent machine, written down first.
2. **Do the formal statements say what the problem asks?** (EG2): A reading of the formal statement against the problem as posed, by someone who did not write it.
3. **No independent mathematician has reported reading the proof, and there is no referee report** (EG3): Someone in the field reads it and says, under their name, what holds and what does not.

## Contributing

- **Rerun** (if there is a Lean development): copy `prereg_rerun.yaml`, fill in your predictions, register it with `tools/prereg.py register` from the protocol repository and commit it *before* running anything. Run. Report with the **Rerun report** issue form; it becomes a `rerun` cycle under your name.
- **Read**: a trace (reading guide) does not exist yet. Writing one is itself a `trace` cycle. Once it exists, the **Semantic read** form takes signatures and refusals.
- **Anything else**: open a plain issue.

Rules and templates: https://github.com/Nervous-Machine/DEBRIEF/blob/main/CONTRIBUTING.md. Every contribution is one dated cycle under your own name and goes into `CITATION.cff` and the next release.

## Layout

```
ledger/erdos768.json   the ledger (protocol 0.1.0)
claim.yaml            the pinned claim this record was opened from
SCORECARD.md / ASKS.md  generated from the ledger
prereg_rerun.yaml     a pre-registration template for the first rerun (unregistered)
cycles/               contributed cycles, one file each
```

## Words

This record never calls the claim proved, verified or a theorem. It records what was claimed, what was checked by whom under what rule, and what is still open. Nothing here has standing until a cycle gives it one.
