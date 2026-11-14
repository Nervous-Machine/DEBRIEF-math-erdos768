# Definitional trace of the formal statement of Erdős Problem #768

**For:** a mathematician willing to spend thirty to forty-five minutes deciding whether the claimant's formal statement of
Erdős Problem #768 says what Erdős asked. That is the one open question on this record that no machine settles; the
Lean development builds and its main theorem rests on the three standard axioms (finding E1). There is no third-party
formal statement of this problem, so the comparison is between the claimant's statement and the problem as posed.

**What this is.** The problem as posed, the formal statement verbatim, every definition it depends on down to Mathlib
and Lean core with file and line, a plain-language rendering of each piece, worked examples that Lean itself checked,
the places where Lean's conventions differ from the blackboard, and a sign-off checklist. The renderings are the reading
of the operating agent (Claude Code, for Nervous Machine) on 14 November 2026. They are an aid, not a check.

**What this is not.** Not an independent human semantic review, and it changes no standing. Gap EG2 stays open until a
person who is not an author signs the checklist at the end. It says nothing about the paper's argument or about whether
the Lean proof follows the paper (gap EG3).

**Sources, pinned.** Formal statement: `RequestProject/Main.lean` and `RequestProject/Defs.lean` in ericlisg/erdos768-lean
at commit `e46ab245f1e5eb2d1f0b184874c4e32e02ad16c9` (file hashes in `cycles/rerun-1/manifest.json`). Problem page:
https://www.erdosproblems.com/768 as read on 2026-11-14 (page last edited 14 September 2025). Mathlib at revision
`8f9d9cff6bd728b17a24e163c9402775d9e6a365` and Lean core `v4.28.0`, the versions the development pins and inside which
every line below was printed. Machine transcript: `cycles/trace-2/trace.txt`, produced by `lake env lean` on
`cycles/trace-2/Trace.lean` inside the built development. Pre-registration for this trace: `prereg_trace.yaml`.

---

## 0. Conventions a reviewer has to know

| convention | where | what it means here |
|---|---|---|
| `Real.log 0 = 0`, and `Real.log x = log |x|` for `x < 0` | `Mathlib/Analysis/SpecialFunctions/Log/Basic.lean` l.44 | the logarithm is total. In the statement every `log` is eventually applied to a large positive number, so this never bites; see D2. |
| `Real.sqrt x = 0` for `x < 0` | `Mathlib/Data/Real/Sqrt.lean`, `def sqrt` | total square root; same remark. |
| Division by zero is zero | all Lean fields | `x / 0 = 0`. `A(x)` is positive for `x ≥ 1` (example 2), so `x / A(x)` is a genuine quotient for large `x`. |
| `⌊x⌋₊` is the natural-number floor; negatives go to 0 | `Mathlib/Algebra/Order/Floor/Defs.lean` l.92 | `Finset.Icc 1 ⌊x⌋₊` is `{1, …, ⌊x⌋}`, empty for `x < 1` |
| `Nat.Prime p` is `Irreducible p` | `Mathlib/Data/Nat/Prime/Defs.lean` l.42 | a natural number at least 2 whose only divisors are 1 and itself |
| `d % p` is the remainder of natural division | Lean core | `d % p = 1` is `d ≡ 1 (mod p)` for `p ≥ 2` |
| `Finset.filter P s` keeps the elements of `s` satisfying `P`; `.card` counts them | `Mathlib/Data/Finset/Filter.lean` l.52 | the file opens `Classical`, so `P` need not be decidable |
| `Filter.Tendsto f atTop (nhds c)` | `Mathlib/Order/Filter/Defs.lean` l.319 (`map f l₁ ≤ l₂`); `atTop` at `Order/Filter/AtTopBot/Defs.lean` l.39; `nhds` at `Topology/Defs/Filter.lean` l.130 | the classical statement "f(x) → c as x → ∞" over the reals: for every ε > 0 there is X with `|f x − c| < ε` for all `x ≥ X` (Mathlib's `Metric.tendsto_atTop`) |
| `∀ᶠ x in atTop, P x` | `Filter.Eventually` | "P holds for all sufficiently large x" |

---

## Part A. The problem as posed

**A1. The problem page**, verbatim (erdosproblems.com/768, citing [Er74b]):

> Let $A \subset \mathbb{N}$ be the set of $n$ such that for every prime $p \mid n$ there exists some $d \mid n$ with $d > 1$
> such that $d \equiv 1 \pmod p$. Is it true that there exists some constant $c > 0$ such that for all large $N$
> $$\frac{|A \cap [1,N]|}{N} = \exp\bigl(-(c + o(1))\sqrt{\log N}\,\log\log N\bigr)?$$

The page adds that Erdős could prove $\exp(-c\sqrt{\log N}\log\log N) \le |A\cap[1,N]|/N$ for some $c > 0$ and
$|A \cap [1,N]|/N \le \exp(-(1+o(1))\sqrt{\log N \log\log N})$, and that he asked because $|A \cap [1,N]|$ bounds the
number of $n \le N$ that are orders of non-cyclic simple groups.

**What the trace does not check.** Whether the page's sentence is a faithful rendering of Erdős's 1974 paper. A reviewer
with the paper can sign or refuse checklist item A0; the rest of the checklist takes the page's sentence as the problem.

---

## Part B. The formal statement, verbatim

**B1. Definitions** (`RequestProject/Defs.lean` l.24, l.32, l.36, l.39):

```lean
def SylowDivisor (n : ℕ) : Prop :=
  ∀ p : ℕ, p.Prime → p ∣ n → ∃ d : ℕ, d ∣ n ∧ 1 < d ∧ d % p = 1

noncomputable def Acount (x : ℝ) : ℕ :=
  ((Finset.Icc 1 ⌊x⌋₊).filter SylowDivisor).card

noncomputable def c₀ : ℝ := 1 / (2 * Real.sqrt (Real.log 2))

noncomputable def Sscale (x : ℝ) : ℝ := Real.sqrt (Real.log x) * Real.log (Real.log x)
```

**B2. The main theorem** (`RequestProject/Main.lean`, theorem `Erdos768.erdos_768`):

```lean
theorem erdos_768 :
    Tendsto
      (fun x : ℝ =>
        Real.log (x / (Acount x : ℝ)) / (Real.sqrt (Real.log x) * Real.log (Real.log x)))
      atTop (nhds c₀)
```

**B3. The two halves it is deduced from** (same file), as the built development prints them:

```lean
Erdos768.lower_bound : ∀ (ε : ℝ), 0 < ε → ∀ᶠ (x : ℝ) in atTop, x * Real.exp (-(c₀ + ε) * Sscale x) ≤ ↑(Acount x)
Erdos768.upper_bound : ∀ (ε : ℝ), 0 < ε → ∀ᶠ (x : ℝ) in atTop, ↑(Acount x) ≤ x * Real.exp (-(c₀ - ε) * Sscale x)
```

Cycle 1 printed the axioms of all three: `propext`, `Classical.choice`, `Quot.sound` only.

---

## Part C. Every piece of B1 and B2, traced

| piece | Lean meaning, with source | agent's reading |
|---|---|---|
| `SylowDivisor n` | for every prime `p` dividing `n` there is a divisor `d` of `n` with `1 < d` and `d % p = 1` | "n is in A": the page's defining condition, word for word. `1 ∈ A` vacuously (example 1); no prime is in A; the smallest element above 1 is 12 (example 1). |
| `Acount x` | the number of `n` in `{1, …, ⌊x⌋}` with `SylowDivisor n` (§0 for floor and filter) | "$|A \cap [1, x]|$", for a real `x`; it is 0 for `x < 1` and 1 at `x = 1` (example 2) |
| `c₀` | `1 / (2 * √(log 2))` | the claimed constant, $c_0 = 1/(2\sqrt{\log 2}) \approx 0.6006$ (agent's arithmetic, not Lean's) |
| `Sscale x` | `√(log x) · log (log x)` | the page's scale $\sqrt{\log N}\,\log\log N$ |
| `fun x => log (x / Acount x) / (√(log x) * log (log x))` | the ratio of $\log\bigl(x / |A\cap[1,x]|\bigr)$ to the scale | "$\log(N / |A \cap [1,N]|) / (\sqrt{\log N}\log\log N)$" |
| `Tendsto … atTop (nhds c₀)` | §0 | "this ratio tends to $c_0$ as $x \to \infty$" |
| B3, `lower_bound` and `upper_bound` | for every ε > 0, eventually $x\,e^{-(c_0+\varepsilon)S(x)} \le A(x) \le x\,e^{-(c_0-\varepsilon)S(x)}$ | exactly "$A(x)/x = \exp(-(c_0 + o(1)) S(x))$", the page's form with $c = c_0$ |

**The one step a reviewer must make.** The page asks for $|A\cap[1,N]|/N = \exp(-(c+o(1))\sqrt{\log N}\log\log N)$.
Taking logarithms, this says $\log(N/|A\cap[1,N]|) = (c + o(1))\sqrt{\log N}\log\log N$, i.e. the ratio in B2 tends to
$c$. So B2 with $c = c_0$ is the page's statement with a named constant, and B3 is the same thing written as two
eventual inequalities. The agent believes this is routine; the reviewer signs A3 if they agree.

---

## Part D. Worked examples, checked by Lean

All from `cycles/trace-2/trace.txt`; the commands are in `cycles/trace-2/Trace.lean`.

1. `SylowDivisor 1` (vacuous); `¬ SylowDivisor 7` (a prime has no divisor `d > 1` with `d % 7 = 1`); `¬ SylowDivisor 6` (the prime 3 has no witness among 2, 3, 6); `SylowDivisor 12` (witness 3 for the prime 2, witness 4 for the prime 3). Each proved.
2. `Acount (1/2) = 0` and `Acount 1 = 1`, proved from the definitions.
3. `Real.log 0 = 0`; `Real.log (-2) = Real.log 2`; `Real.sqrt (-1) = 0`; `(1 : ℝ) / 0 = 0`; `⌊(-2.5 : ℝ)⌋₊ = 0`.
4. `c₀ = 1 / (2 * Real.sqrt (Real.log 2))` by definition, and `0 < c₀` (proved).
5. The statements B2 and B3 and the definitions B1 as the development prints them, plus `Filter.Tendsto` and `Nat.Prime`.

---

## Part E. Discrepancies and observations

| id | observation | kind | effect, in the agent's reading |
|---|---|---|---|
| D1 | The page counts $n \le N$ for an integer $N$; the formal statement takes a real `x` and counts `n ≤ ⌊x⌋`. | variable type | none: a limit along all real $x \to \infty$ implies the limit along integers, and the page's "for all large N" is about integers. The formal statement is at least as strong. |
| D2 | `Real.log`, `Real.sqrt` and division are total in Lean (§0), so the ratio in B2 is defined at every `x`, including `x ≤ 1` where it is meaningless on the blackboard. | Lean convention | none: `Tendsto … atTop` depends only on large `x`, where `log x > 0`, `log log x > 0` and `A(x) ≥ 1`. |
| D3 | `1 ∈ A` in the formal definition (no prime divides 1). The page's "$A \subset \mathbb{N}$" leaves the status of 1 to convention. | boundary | none: one element does not affect an asymptotic. |
| D4 | The page asks whether *some* $c > 0$ exists; the claim names $c = c_0 = 1/(2\sqrt{\log 2})$ and asserts the limit. | strength | the claim is stronger than the question; a reviewer should compare $c_0$ with the constant in the paper's abstract (arXiv 2606.24872), which the agent did not read for this trace. |
| D5 | The page's form is an equality with an $o(1)$; the formal statement is a limit of a ratio, and B3 is a pair of eventual inequalities for every ε. | form of the asymptotic | equivalent by taking logarithms (Part C); the reviewer confirms. |
| D6 | The problem page records no formal statement ("Formalised statement? No") and lists two people working on one. | record | none; if a third-party statement appears later, a machine comparison like the one in record 306 becomes possible and this trace should be extended. |
| D7 | The repository's README credits Aristotle (Harmonic) as the formalisation agent; the problem page lists GPT-5.5 Pro for the claim. | attribution | none on meaning; recorded in the mission README. |

No discrepancy that changes the meaning was seen by the agent. No anomaly is opened.

---

## Part F. Sign-off checklist

For a reviewer who is prepared to put their name to a reading. Each line is a yes/no. Send it with the **Semantic read**
issue form on this repository (it becomes a `read` cycle under your name), or anywhere public; the ledger records it by
date. Two independent signatures with no refusal close gap EG2; one refusal reopens it.

- [ ] A0 (optional, needs the 1974 paper): the page's sentence is Erdős's problem.
- [ ] A1: `SylowDivisor n` is the page's condition defining $A$ (D3).
- [ ] A2: `Acount x` is $|A \cap [1, x]|$ (D1, D2).
- [ ] A3: `Tendsto (fun x => log (x / Acount x) / (√(log x) · log (log x))) atTop (nhds c₀)` is "$|A\cap[1,N]|/N = \exp(-(c_0 + o(1))\sqrt{\log N}\log\log N)$" with $c_0 = 1/(2\sqrt{\log 2})$ (D4, D5).
- [ ] A4: $c_0$ is the constant the paper claims.

A reviewer who signs A1 to A3 has closed the semantic question for this problem; A4 ties the formal statement to the
paper. It would be the first such signature on this record.
