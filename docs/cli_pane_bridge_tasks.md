# CLI Pane Bridge - Task Graph

## Phase 0: Scaffold Creation ✅
- [x] Create task graph documentation
- [ ] Create stub launcher script (`bin/bill-sloth-claude-launcher.sh`)
- [ ] Create cross-platform wrappers (`bin/bsai.ps1`, `bin/bsai.sh`)
- [ ] Update Windows bootstrap for prerequisites
- [ ] Create documentation stub (`docs/cli_pane_bridge.md`)
- [ ] Commit scaffold and create draft PR

## Phase 1: Core Implementation
- [ ] Implement tmux session management in launcher
- [ ] Add Claude Code CLI integration with --dangerously-skip-permissions
- [ ] Create split-pane architecture (left: module, right: Claude)
- [ ] Test basic functionality with 3 representative modules
- [ ] Implement Windows Terminal fallback for native Windows

## Phase 2: Cross-Platform Support
- [ ] Test WSL2 compatibility 
- [ ] Implement Windows Terminal split-pane alternative
- [ ] Add platform detection and automatic fallback
- [ ] Create unified hotkey scheme
- [ ] Test on Ubuntu, WSL2, and native Windows

## Phase 3: Enhanced Integration
- [ ] Add module context awareness to Claude
- [ ] Implement automatic error detection and assistance
- [ ] Create hotkeys for quick Claude queries
- [ ] Add session persistence and resumption
- [ ] Optimize performance and resource usage

## Phase 4: Production Readiness
- [ ] Test all 30+ Bill Sloth modules
- [ ] Create comprehensive documentation
- [ ] Add fallback modes for problematic modules
- [ ] Performance benchmarking and optimization
- [ ] User acceptance testing

## Dependencies
- **tmux**: Required for Linux/WSL2 split-pane functionality
- **Windows Terminal**: Required for native Windows split-pane fallback
- **Claude Code CLI**: Core requirement for AI assistance
- **Bill Sloth modules**: Target integration scripts

## Success Criteria
- [ ] Cross-platform compatibility (Ubuntu, WSL2, Windows)
- [ ] Zero visual degradation of Bill Sloth modules
- [ ] Claude provides contextual assistance without interrupting flow
- [ ] <200ms additional latency for integration
- [ ] Graceful fallback when requirements not met