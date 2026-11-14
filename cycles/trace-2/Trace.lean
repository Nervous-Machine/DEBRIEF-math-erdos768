import RequestProject.Main
open Filter
open scoped Classical
-- Worked examples for the reading guide (cycle 2). Each line is checked by Lean; nothing here is asserted by hand.
-- 1. Membership in A for small n. 1 is in A vacuously (no prime divides it). Primes are not in A. 6 is not; 12 is.
example : Erdos768.SylowDivisor 1 := by
  intro p hp hpd
  exact absurd (Nat.le_of_dvd one_pos hpd) (by simpa using hp.two_le)
example : ¬ Erdos768.SylowDivisor 7 := fun h => by
  obtain ⟨d, hd, h1, hm⟩ := h 7 (by norm_num) (by norm_num)
  have := Nat.le_of_dvd (by norm_num) hd
  interval_cases d <;> omega
example : ¬ Erdos768.SylowDivisor 6 := fun h => by
  obtain ⟨d, hd, h1, hm⟩ := h 3 (by norm_num) (by norm_num)
  have := Nat.le_of_dvd (by norm_num) hd
  interval_cases d <;> omega
example : Erdos768.SylowDivisor 12 := by
  intro p hp hpd
  have hle : p ≤ 12 := Nat.le_of_dvd (by norm_num) hpd
  interval_cases p
  all_goals first
    | exact absurd hp (by decide)
    | exact absurd hpd (by decide)
    | exact ⟨3, by decide⟩
    | exact ⟨4, by decide⟩
-- 2. The counting function at small arguments: A(x) = 0 for x < 1, and A(1) = 1 (only n = 1).
example : Erdos768.Acount (1/2 : ℝ) = 0 := by
  unfold Erdos768.Acount
  rw [Nat.floor_eq_zero.mpr (by norm_num : (1/2 : ℝ) < 1)]
  simp
example : Erdos768.Acount 1 = 1 := by
  have h : (Finset.Icc 1 ⌊(1 : ℝ)⌋₊).filter Erdos768.SylowDivisor = {1} := by
    rw [Nat.floor_one]
    ext n; simp only [Finset.mem_filter, Finset.mem_Icc, Finset.mem_singleton]
    constructor
    · rintro ⟨⟨h1, h2⟩, -⟩; omega
    · rintro rfl; exact ⟨⟨le_rfl, le_rfl⟩, fun p hp hpd => absurd (Nat.le_of_dvd one_pos hpd) (by simpa using hp.two_le)⟩
  unfold Erdos768.Acount
  rw [h]
  rfl
-- 3. Lean conventions at the edge, none of which touch a limit at infinity.
example : Real.log 0 = 0 := Real.log_zero
example : Real.log (-2) = Real.log 2 := by rw [Real.log_neg_eq_log]
example : Real.sqrt (-1) = 0 := Real.sqrt_eq_zero'.2 (by norm_num)
example : (1 : ℝ) / 0 = 0 := by simp
example : ⌊(-2.5 : ℝ)⌋₊ = 0 := Nat.floor_of_nonpos (by norm_num)
-- 4. The constant and the scale, and the statement as the built development prints it.
example : Erdos768.c₀ = 1 / (2 * Real.sqrt (Real.log 2)) := rfl
example : 0 < Erdos768.c₀ := by
  unfold Erdos768.c₀; positivity
#check @Erdos768.erdos_768
#check @Erdos768.lower_bound
#check @Erdos768.upper_bound
#print Erdos768.SylowDivisor
#print Erdos768.Acount
#print Erdos768.c₀
#print Erdos768.Sscale
#print Filter.Tendsto
#print Nat.Prime
