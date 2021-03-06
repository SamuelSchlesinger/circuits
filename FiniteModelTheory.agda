module FiniteModelTheory where

open import Basics
open import Vectors
open import Naturals

-- Based on Immerman's definitions in Descriptive Complexity Theory
record Vocabulary : Set where
  field
    r : N          -- Number of relational symbols
    R : Vector r N -- Arities of relational symbols
    s : N          -- Number of constant symbols

data RelationsFor : (size : N) -> (r : N) -> Vector r N -> Set where
  RCons :
    {r r0 size : N}
    {R : Vector r N}
    -> (m : N)
    -> Vector m (Vector r0 (Fin size))
    -> RelationsFor size r R
    -> RelationsFor size (S r) (Cons r0 R)
  RNil : {size : N} -> RelationsFor size 0 Nil

record Structure (v : Vocabulary) : Set where
  open Vocabulary
  field
    size : N -- Size of the universe, which we assume to be the natural numbers up to the size, without loss of generality.
    relations : RelationsFor size (r v) (R v)
    constants : Vector (s v) (Fin size)

-- The graph with specified source and target
graphVocab : Vocabulary
graphVocab = x where
  open Vocabulary
  x : Vocabulary
  r x = 1
  R x = Cons 2 Nil
  s x = 2

-- The vocabulary of binary strings
binaryStrings : Vocabulary
binaryStrings = x where
  open Vocabulary
  x : Vocabulary
  r x = 2
  R x = Cons 2 (Cons 1 Nil)
  s x = 0

data FO (v : Vocabulary) : Set where
  FO⊤ : FO v
  _FO=_ : N -> N -> FO v
  _FO∧_ : FO v -> FO v -> FO v
  FO¬ : FO v -> FO v
  FO∃ : FO v -> FO v
  FOR : (x : Fin (Vocabulary.r v)) -> Vector (index x (Vocabulary.R v)) N -> FO v

InterpretationInto : {vocab : Vocabulary} -> (structure : Structure vocab) -> Set
InterpretationInto structure = N -> Fin (Structure.size structure)
  
