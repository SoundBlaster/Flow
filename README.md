# Flow

Agentic Workflow

> **Flow** is a text prompt-based agentic workflow for open source contribution.

## Ideology

Method is the linear _flow_ — the step-by-step execution of commands.

Each command is just a prompt.

**Flow** mimics a real-world software development process.

## Structure

**Flow** consists of basic commands defined as Markdown files:

1. SELECT
2. BRANCH
3. PLAN
4. EXECUTE
5. ARCHIVE
6. REVIEW
7. FOLLOW-UP
8. ARCHIVE-REVIEW
9. PR
10. CI-REVIEW

These commands are grouped under the **FLOW** meta-command, which serves as the entry point for every task.

## Source of Truth

`SPECS/Workflow.md` is the single source of truth for all project tasks.

## Current State

Files for the current task are temporarily placed in the `INPROGRESS/` folder. The `next.md` file logs the currently selected and executed task, along with lists of potential next tasks and previously completed ones.

## Skills

This workflow is enhanced by agent skills. These skills wrap prompts into CLI shortcuts. Skills are optional.
