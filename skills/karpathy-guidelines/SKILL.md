---
name: karpathy-guidelines
description: Apply Andrej Karpathy's LLM coding guidelines — think before coding, simplicity first, surgical changes, goal-driven execution. Use when starting any non-trivial coding task.
user-invocable: false
---

# Karpathy LLM Coding Guidelines

Derived from Andrej Karpathy's observations on common LLM coding pitfalls.

## 1. Think Before Coding

- State assumptions explicitly before implementing
- If a request has multiple interpretations, present them — don't silently pick one
- If something is unclear, stop and name what's confusing
- Surface tradeoffs before committing to an approach

## 2. Simplicity First

- Write the minimum code that solves the stated problem
- No features beyond what was asked
- No speculative error handling, abstractions, or future-proofing
- Litmus test: would a senior engineer call this overcomplicated?

## 3. Surgical Changes

- Touch only what you must to fulfill the request
- Match existing style and conventions, even if you'd do it differently
- Clean up only unused code *your* changes created — don't delete pre-existing dead code unless asked
- Avoid reformatting or restructuring unrelated code

## 4. Goal-Driven Execution

- Convert vague requests into concrete, verifiable success criteria before starting
- Define what "done" looks like and how to verify it
- Loop until those criteria are met — don't declare success without checking
