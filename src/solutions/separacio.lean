import topology.basic

open topological_space set filter
localized "notation `π` := nhds" in topological_space
localized "notation `π[` s `] ` x:100 := nhds_within x s" in topological_space

noncomputable theory
open classical

variables {X : Type} [topological_space X] [nonempty X]

class t0_space (X : Type) [topological_space X] : Prop :=
(t0 : β x y, x β  y β β (U : set X), is_open U β§ ((x β U β§ y β U) β¨ (x β U β§ y β U)) )

class t1_space (X : Type) [topological_space X] : Prop :=
(t1 : β x y, x β  y β β (U : set X), is_open U β§ x β U β§ y β U)

instance t1_space.t0_space [t1_space X] : t0_space X :=
begin
  -- sorry
  fconstructor,
  intros x y hxy,
  obtain β¨U, hU, hhβ©  := t1_space.t1 x y hxy,
  use U,
  split,
  { exact hU },
  { exact or.inl hh }
  -- sorry
end

lemma t1_iff_singleton_closed : t1_space X β β x, is_closed ({x} : set X) :=
begin
  -- sorry
  split,
  {
    introI,
    intro x,
    rw β is_open_compl_iff,
    have p : ββ {U : set X | (x β U) β§ (is_open U)} = {x}αΆ,
    { apply subset.antisymm; intros t ht,
      { rcases ht with β¨A, β¨hxA, hAβ©, htAβ©,
        rw [mem_compl_eq, mem_singleton_iff],
        intro h,
        exact hxA (by rwa h at htA) },
      { obtain β¨U, hU, hhβ© := t1_space.t1 t x (mem_compl_singleton_iff.mp ht),
        use U,
        split,
        { exact β¨hh.2, hUβ© },
        { exact hh.1 } } },
    rw β p,
    apply is_open_sUnion,
    intros B hB,
    exact hB.2,
  },
  {
    intro h,
    fconstructor,
    intros x y hxy,
    use {y}αΆ,
    split,
    { exact is_open_compl_iff.mpr (h y) },
    split,
    { exact mem_compl_singleton_iff.mpr hxy },
    { exact not_not.mpr rfl }
  }
  -- sorry
end

class t2_space (X : Type) [topological_space X] : Prop :=
(t2 : β x y, x β  y β β (U V: set X) (hU : is_open U) (hV: is_open V) (hUV : U β© V = β), x β U β§ y β V)

instance t2_space.t1_space [t2_space X] : t1_space X :=
begin
  -- sorry
  fconstructor,
  intros x y hxy,
  obtain β¨U, V, hU, hV, hUV, hβ© := t2_space.t2 x y hxy,
  use U,
  split,
  { exact hU },
  split,
  { exact h.1 },
  { intro con,
    have ht : y β (β : set X),
    {
      rw β hUV,
      exact β¨con, h.2β©
    },
    exact not_mem_empty y ht }
  -- sorry
end

variables (f : filter X) (x : X)

def filter_lim (f : filter X) (x : X) := f β€ π x β§ f β  β₯

def limit_unicity (X : Type) [topological_space X] [nonempty X] := 
      β (x y : X) (f : filter X) (hx : filter_lim f x) (hy : filter_lim f y), x=y

lemma t2_iff_unicity : t2_space X β limit_unicity X :=
begin
  -- sorry
  split,
  {
    introI,
    intros x y f hx hy,
    by_contradiction hxy,
    obtain β¨U, V, hU, hV, hUV, hhβ© := t2_space.t2 x y hxy,
    have hhU : U β f,
    { exact le_def.1 hx.1 U (is_open.mem_nhds hU hh.left) },
    have hhV : V β f,
    { exact le_def.1 hy.1 V (is_open.mem_nhds hV hh.right) },
    obtain hf := filter.inter_sets f hhU hhV,
    rw hUV at hf,
    exact hx.2 (empty_mem_iff_bot.1 hf)
  },
  {
    intro h1,
    fconstructor,
    intros x y hxy,
    by_contra,
    push_neg at h,
    have : π x β π y β  β₯,
    { intro t,
      rw β empty_mem_iff_bot at t,
      rw mem_inf_iff at t,
      obtain β¨Uβ, hUβ, Vβ, hVβ, hUVββ© := t,
      obtain β¨U, hU, hU_op, hxUβ© := mem_nhds_iff.1 hUβ,
      obtain β¨V, hV, hV_op, hyVβ© := mem_nhds_iff.1 hVβ,
      have : U β© V = β,
      { have : U β© V β β,
        { rw hUVβ,
          exact inter_subset_inter hU hV },
        exact subset_eq_empty this rfl },
      exact (h U V hU_op hV_op this hxU) hyV },
    have hx : π x β π y β€ π x,
    { apply le_def.2,
      intros T hT,
      exact mem_inf_of_left hT },
    have hy : π x β π y β€ π y,
    { apply le_def.2,
      intros T hT,
      exact mem_inf_of_right hT },
    exact hxy (h1 x y (π x β π y) β¨hx, thisβ© β¨hy, thisβ©),
  }
  -- sorry
end

class t2_5_space (X : Type) [topological_space X] : Prop :=
(t2_5 : β x y  (h : x β  y), β (U V: set X), is_open U β§  is_open V β§
                                            closure U β© closure V = β β§ x β U β§ y β V)

instance t2_5_space.t2_space [t2_5_space X] : t2_space X :=
begin
  -- sorry
  fconstructor,
  intros x y hxy,
  obtain β¨U, V, hU, hV, hUV, hβ© := t2_5_space.t2_5 x y hxy,
  use U,
  use V,
  split,
  { exact hU },
  split,
  { exact hV },
  split,
  { have : U β© V β β,
    { rw β hUV,
      exact inter_subset_inter subset_closure subset_closure },
    exact subset_eq_empty this rfl },
  { exact h }
  -- sorry
end

def regular_space (X : Type) [topological_space X] := β (x : X) (F : set X) (hF : is_closed F) (hxF : x β F), 
  β (U V : set X) (hU : is_open U) (hV : is_open V) (hUV : U β© V = β), x β U β§ F β V

class t3_space (X : Type) [topological_space X] extends t1_space X : Prop :=
(regular : regular_space X)

instance t3_space.t2_space [t3_space X] : t2_space X :=
begin
  -- sorry
  fconstructor,
  intros x y hxy,
  obtain hsingleton := (@t1_iff_singleton_closed X _ _).1 t3_space.to_t1_space,
  obtain β¨U, V, hU, hV, hUV, hβ© := t3_space.regular x {y} (hsingleton y) hxy,
  obtain hyV := singleton_subset_iff.mp h.2,
  exact β¨U, V, hU, hV, hUV, h.1, hyVβ©,
  -- sorry
end

instance t2_space.t2_5_space [t3_space X] : t2_5_space X :=
begin
  -- sorry
  fconstructor,
  intros x y hxy,
  obtain β¨U, V, hU, hV, hUV, hhβ©  := t2_space.t2 x y hxy,
  have hxcV : x β closure V,
  { rw closure_eq_compl_interior_compl,
    have : U β interior VαΆ,
    { have : U β VαΆ,
      { exact subset_compl_iff_disjoint.mpr hUV },
      exact interior_maximal this hU },
    tauto },
  obtain β¨A, B, hA, hB, hAB, hh2 β© := t3_space.regular x (closure V) (is_closed_closure) hxcV,
  have t : closure A β© closure V = β,
  {
    have hABc : A β BαΆ,
    { exact subset_compl_iff_disjoint.mpr hAB },
    have hBc_clos : is_closed BαΆ,
    { exact is_closed_compl_iff.mpr hB },
    have hcA_B: closure A β BαΆ,
    { exact closure_minimal hABc hBc_clos },
    have hB_emp : B β© BαΆ = β,
    { exact sdiff_self },
    have : closure A β© closure V β β,
    { rw [β hB_emp, inter_comm B BαΆ],
      exact inter_subset_inter hcA_B hh2.2 },
    exact subset_eq_empty this rfl
  },
  exact β¨A, V, hA, hV, t, hh2.1, hh.2β©,
  -- sorry
end

lemma inter_is_not_is_empty_intersection {X : Type} {x : X} {U V : set X}
  (hxU : x β U) (hUV : U β© V = β ) : x β V := disjoint_left.1 (disjoint_iff_inter_eq_empty.2 hUV) hxU

lemma t3_iff_t0_regular : t3_space X β t0_space X β§ regular_space X :=
begin
  -- sorry
  split,
  {
    introI,
    split,
    { exact t1_space.t0_space },
    { exact t3_space.regular }
  },
  {
    intro h,
    haveI := h.1,
    exact { t1:= 
    begin
      intros x y hxy,
      obtain β¨U, hU, hhβ© := t0_space.t0 x y hxy,
      cases hh,
      { exact β¨U, hU, hhβ© },
      {
        have h_not_in_com : y β UαΆ,
        { intro t,
          exact (not_mem_of_mem_compl t) hh.2 },
        obtain β¨V, T, hV, hT, hVT, hhhβ© := h.2 y UαΆ (is_closed_compl_iff.mpr hU) h_not_in_com,
        use T,
        split,
        { exact hT },
        split,
        { exact hhh.2 hh.1 },
        { exact inter_is_not_is_empty_intersection hhh.1 hVT }
      }
    end, regular := h.2 },
  }
  -- sorry
end

lemma regular_iff_filter_def : regular_space X β β{s:set X} {a}, is_closed s β a β s β βt, is_open t β§ s β t β§ π[t] a = β₯ :=
begin
  -- sorry
  split; intro h,
  {
    intros F x hF hxF,
    obtain β¨U, V, hU, hV, hUV, hhβ© := h x F hF hxF,
    use V,
    split,
    { exact hV },
    split,
    { exact hh.2 },
    { rw β empty_mem_iff_bot,
      have : β β π x β principal V,
      {
        rw mem_inf_iff,
        use U,
        split,
        { exact is_open.mem_nhds hU hh.1 },
        use V,
        split,
        { exact mem_principal_self V },
        { exact eq.symm hUV }
      },
      exact this }
  },
  {
    intros x F hF hxF,
    obtain β¨U, hU, hhβ© := h hF hxF,
    rw [β empty_mem_iff_bot] at hh,
    have hexU : β β π x β principal U,
    { exact hh.2 },
    rw mem_inf_iff at hexU,
    obtain β¨Tβ, hTβ, V, hV, hTVββ© := hexU,
    obtain β¨T, hTTβ, hTβ© := mem_nhds_iff.1 hTβ,
    use T,
    use U,
    split,
    { exact hT.1 },
    split,
    { exact hU },
    split,
    { have : T β© U β β,
      { rw hTVβ,
        exact inter_subset_inter hTTβ (mem_principal.mp hV) },
      exact subset_eq_empty this rfl },
    { exact β¨hT.2, hh.1β© }
  }
  -- sorry
end

lemma t3_iff_open_closure : t3_space X β t1_space X β§ (β (x : X) (U : set X) (hx : x β U) (hU : is_open U), 
    β (V : set X) (hV : is_open V), x β V β§ closure V β U) :=
begin
  -- sorry
  split,
  {
    introsI,
    split,
    { exact t2_space.t1_space },
    {
      intros x U hx hU,
      obtain β¨V, T, hV, hT, hVT, hβ© := t3_space.regular x UαΆ (is_closed_compl_iff.mpr hU) (not_not.mpr hx),
      use V,
      split,
      { exact hV },
      split,
      { exact h.1 },
      { have hclos_V_Tc : closure V β TαΆ,
        { obtain HTc_clo := is_closed_compl_iff.mpr hT,
          exact closure_minimal (subset_compl_iff_disjoint.mpr hVT) HTc_clo },
        have hTc_U : TαΆ β U,
        { exact compl_subset_comm.mp h.right },
        exact powerset_mono.mpr hTc_U hclos_V_Tc }
    },
  },
  {
    intro h,
    haveI := h.1,
    exact {t1 := t1_space.t1, regular := 
      begin
        intros x F hF hxF,
        obtain β¨U, hU, hhβ© := h.2 x FαΆ (mem_compl hxF) (is_open_compl_iff.mpr hF),
        use U,
        use (closure U)αΆ,
        split,
        { exact hU },
        split,
        { exact is_open_compl_iff.mpr is_closed_closure },
        split,
        { have sub_empt : U β© (closure U)αΆ β β,
          { rw β (closure U).inter_compl_self,
            exact (closure U)αΆ.inter_subset_inter_left subset_closure },
          exact subset_eq_empty sub_empt rfl },
        split,
        { exact hh.1 },
        { exact subset_compl_comm.mp hh.right }
      end},
  }
  -- sorry
end

def normal_space (X : Type) [topological_space X] := β (F T : set X) (hF : is_closed F) (hT : is_closed T) (hFT : F β© T = β),
        β (U V : set X) (hU : is_open U) (hV : is_open V) (hUV : U β© V = β), F β U β§ T β V

class t4_space (X : Type) [topological_space X] extends t1_space X : Prop :=
(normal : normal_space X)

instance t4_space.t3_space [t4_space X] : t3_space X :=
begin
  -- sorry
  exact {t1 := t1_space.t1, regular := 
  begin
    intros x F hF hxF,
    obtain hx := t1_iff_singleton_closed.1 t4_space.to_t1_space x,
    have : {x} β© F = β,
    { exact singleton_inter_eq_empty.2 hxF },
    obtain β¨U, V, hU, hV, hUV, hβ© := t4_space.normal {x} F hx hF this,
    have hhx : x β U,
    { exact singleton_subset_iff.mp h.left },
    exact β¨U, V, hU, hV, hUV, hhx, h.2β©
  end },
  -- sorry
end

lemma t4_iff_open_closure : t4_space X β t1_space X β§ (β (U K : set X) (hK : is_closed K) (hU : is_open U) (hKU: K β U),
        β (V : set X) (hV : is_open V), K β V β§ closure V β U) :=
begin
  -- sorry
  split,
  {
    introI,
    split,
    { exact t4_space.to_t1_space },
    {
      intros U K hK hU hKU,
      have : K β© UαΆ = β,
      { exact sdiff_eq_bot_iff.mpr hKU },
      obtain β¨V, T, hV, hT, hVT, hβ© := t4_space.normal K UαΆ hK (is_closed_compl_iff.mpr hU) this,
      use V,
      split,
      { exact hV },
      split,
      { exact h.1 },
      { have hV_Tc : V β TαΆ,
        { exact subset_compl_iff_disjoint.mpr hVT },
        have hT_clos : is_closed TαΆ,
        { exact is_closed_compl_iff.mpr hT },
        obtain hVclos_T_com := closure_minimal hV_Tc hT_clos,
        obtain hTcom_U := compl_subset_comm.mp h.right,
        exact powerset_mono.mpr hTcom_U hVclos_T_com }
    },
  },
  {
    intro h,
    haveI := h.1,
    exact {t1 := t1_space.t1, normal := 
    begin
      intros F K hF hK hFK,
      have hF_Kcom : F β KαΆ,
      { exact subset_compl_iff_disjoint.mpr hFK },
      obtain β¨U, hU, hhβ© := h.2 KαΆ F hF (is_open_compl_iff.mpr hK) hF_Kcom,
      use U,
      use (closure U)αΆ,
      split,
      { exact hU },
      split,
      { exact is_open_compl_iff.mpr is_closed_closure },
      split,
      { have : U β© (closure U)αΆ β β,
        { rw β (closure U).inter_compl_self,
          exact (closure U)αΆ.inter_subset_inter_left subset_closure },
        exact subset_eq_empty this rfl },
      split,
      { exact hh.1 },
      { exact subset_compl_comm.mp hh.right }
    end}
  }
  -- sorry
end