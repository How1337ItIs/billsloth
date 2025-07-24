# SweatyPedals streaming automation and Linux-compatible techniques for Bill Sloth

## SweatyPedals' unique streaming automation approach

**Joey Moya (SweatyPedals)** represents an extreme example of streaming automation, maintaining the **#2 longest subathon on Twitch with 600+ continuous days** of 24/7 streaming. His unique setup combines fitness and gaming by playing video games while pedaling on a stationary bike, requiring sophisticated automation to manage continuous content delivery.

SweatyPedals' automation centers around **Apollo and Artemis streaming software**, which he uses for remote streaming to various devices. His technical expertise is evident in his comprehensive 4,000+ word guide detailing PC streaming to handheld devices, virtual display configuration, and advanced AutoHotkey scripting. The automation includes **subathon timer systems** that automatically add time when subscribers join, custom donation tracking overlays, and automated scene switching between games, sleep periods, and breaks.

His multi-platform strategy involves simultaneous streaming to Twitch, Kick, and TikTok, with **StreamElements** providing the backbone for overlays and chat automation. The setup includes sophisticated error handling - when temporarily banned from Twitch, his system seamlessly switched to Kick streaming. For hardware control, he uses **MSI Afterburner with RTSS** for performance monitoring with hotkey toggles, and **Tailscale VPN** for remote streaming capabilities.

## Current streaming automation landscape (2024-2025)

The streaming automation ecosystem has evolved significantly, with **Advanced Scene Switcher** emerging as the most powerful OBS plugin for complex automation. This free, cross-platform tool uses a macro system with conditions and actions, supporting triggers from audio levels, window titles, timers, and even MQTT messages. **MIDI control has become mainstream**, with the obs-midi-mg plugin providing cross-platform support for scene switching, audio mixing, and source control using controllers like the Novation Launchkey Mini or Behringer X-Touch Mini.

**Voice control adoption remains limited but growing**, with VoiceMacro on Windows and experimental Linux solutions using Rhasspy or custom Python scripts. The trend toward **local processing over cloud dependencies** reflects privacy concerns and reliability requirements, with tools like Streamer.bot offering powerful automation without cloud connections. **Touch Portal** has emerged as the leading Stream Deck alternative, transforming smartphones into control surfaces with drag-and-drop interfaces supporting up to 110 buttons.

Chat automation has become increasingly sophisticated with **AI-powered moderation** and context-aware responses. StreamChat AI and similar services offer personality customization and proactive viewer engagement, while traditional options like Nightbot and Fossabot remain popular for their reliability and extensive feature sets.

## Linux-compatible streaming automation solutions

Linux provides robust alternatives for every major streaming automation tool. **OBS Studio Portable for Linux** bundles 50+ plugins including Advanced Scene Switcher, with full PipeWire audio capture support for application-specific routing. The **streamdeck-ui project** enables full Elgato Stream Deck functionality on Linux, while software alternatives like Deckboard transform mobile devices into control surfaces.

For audio routing, **PipeWire has become the modern standard**, offering low-latency processing with compatibility layers for PulseAudio and JACK applications. Professional users can leverage **Carla** as a plugin host for complex audio processing chains. **MIDI control on Linux** works through JACK with a2jmidid bridging ALSA MIDI devices, enabling full integration with obs-midi-mg or custom Python scripts using the mido library.

Voice control options include **Rhasspy**, a fully offline voice assistant supporting 16+ languages with MQTT and WebSocket APIs for OBS integration. For chat monitoring, **Chatty** provides a Java-based Twitch client with extensive moderation tools, while terminal enthusiasts can use custom Python scripts with the obsws-python library for complete automation control.

## ADHD-friendly implementation strategies

The research reveals critical patterns for ADHD-friendly streaming automation: **single-command complex actions** that bundle multiple steps, **immediate multi-modal feedback** through visual notifications and audio cues, and **predictable routines** that reduce decision fatigue. A well-designed system should start the entire streaming setup with one command, automatically configuring audio routing, launching OBS with the correct profile, initializing controllers, and starting break reminder systems.

**Visual status systems** using persistent tmux sessions or desktop widgets provide always-visible streaming status, reducing anxiety about whether systems are running correctly. **Break reminder systems** implement Pomodoro-style intervals with gentle notifications combining visual alerts, audio cues, and automatic scene switching to break screens. These systems should wait for user acknowledgment before returning to the main scene, respecting the user's pace.

**MIDI controllers with tactile feedback** like the Novation Launchkey Mini or Behringer X-Touch Mini work exceptionally well for ADHD users. Large, obvious buttons for critical functions (start/stop streaming, mute) combined with LED feedback create a physical control surface that reduces cognitive load. Faders for gradual controls (volume adjustments) provide more intuitive control than binary switches.

## Specific implementations for Bill Sloth

Based on SweatyPedals' techniques and Linux compatibility research, here are practical module additions for the Bill Sloth streaming module:

**1. Automated Setup Module**: Create a master script that configures PipeWire audio routing, launches OBS with specific profiles, initializes MIDI controllers, and starts all monitoring systems with a single command. This mirrors SweatyPedals' approach but uses Linux-native tools.

**2. Activity-Based Scene Switching**: Implement window detection using xdotool to automatically switch OBS scenes based on active applications. When the terminal is focused, switch to "Coding" scene; when a game launches, switch to "Gaming" scene. Include gentle transitions with notification sounds to avoid jarring changes.

**3. MIDI Control Integration**: Use the obs-midi-mg plugin with a Behringer X-Touch Mini for physical control. Map large buttons to critical functions with LED feedback, and use motorized faders for audio control. Implement error handling that provides visual feedback when commands fail.

**4. Voice Control with Fallbacks**: Deploy Rhasspy for offline voice control with simple, memorable commands like "start streaming" or "take a break." Include text-based fallbacks when voice recognition fails, displaying numbered command options for quick keyboard selection.

**5. Comprehensive Break System**: Implement a multi-modal break reminder that combines desktop notifications, audio alerts, and automatic OBS scene switching. Use 25-minute intervals with 5-minute breaks, but make the system flexible enough to acknowledge user readiness before resuming.

**6. Status Dashboard**: Create a persistent status display showing OBS status, audio routing configuration, time until next break, and current scene. Use tmux or a simple GTK window that remains visible on a secondary monitor or as a desktop widget.

## Linux-specific technical implementation

To implement SweatyPedals' Apollo/Artemis-style remote streaming on Linux, use **Sunshine** (the open-source Moonlight streaming host) combined with **WireGuard** or Tailscale for secure remote access. For AutoHotkey-style automation, use **Python with python-xlib** or **AutoKey** for GUI automation scripts.

Audio routing should leverage **PipeWire's** application-specific capture capabilities, creating dedicated sinks for streaming, monitoring, and recording. Use **qpwgraph** or **Helvum** for visual audio routing configuration. For advanced audio processing, **Carla** can host LV2/VST plugins for compression, EQ, and effects.

Scene automation through **Advanced Scene Switcher** should utilize its macro system for complex conditions: switch scenes based on audio levels, specific window titles, time of day, or external triggers via MQTT. Configure automatic game detection using window title matching, with fallback scenes for unexpected situations.

## Recommended module architecture

The Bill Sloth streaming module should follow a modular architecture with clear separation of concerns:

```
bill-sloth-streaming/
├── core/           # Base streaming functionality
├── automation/     # Scene switching, break reminders
├── control/        # MIDI, voice, and keyboard interfaces  
├── monitoring/     # Status displays and health checks
└── profiles/       # User-specific configurations
```

Each module should be independently configurable and optional, allowing users to adopt components based on their needs. Configuration should use JSON files for easy editing, with sensible ADHD-friendly defaults like 25-minute break intervals and high-contrast visual feedback.

The system should prioritize **reliability over features**, with robust error handling and fallback options for every automated component. When voice control fails, fall back to MIDI; when MIDI fails, fall back to keyboard shortcuts. This redundancy ensures streaming can continue even when individual components fail, reducing stress and cognitive load for ADHD users who may struggle with troubleshooting during live streams.