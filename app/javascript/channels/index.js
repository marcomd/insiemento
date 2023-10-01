// Load all the channels within this directory and all subdirectories.
// Channel files must be named *_channel.js.

const channels = import.meta.glob('./**/*_channel.js', { eager: true })
channels.keys().forEach(channels)
