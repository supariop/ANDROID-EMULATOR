FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# --- Install minimal dependencies + OpenJDK 17 (required) ---
RUN apt-get update && apt-get install -y \
    wget unzip curl openjdk-17-jdk x11vnc xvfb libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# --- Install commandline tools ---
RUN mkdir -p $ANDROID_HOME/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /cmd.zip
RUN unzip /cmd.zip -d $ANDROID_HOME/cmdline-tools
RUN mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest
RUN rm /cmd.zip

# --- Accept licenses (works with Java 17) ---
RUN yes | sdkmanager --licenses

# --- Install minimal packages ---
RUN sdkmanager "platform-tools" \
               "platforms;android-22" \
               "system-images;android-22;default;x86" \
               "emulator"

# --- Create ultra-light AVD ---
RUN echo "no" | avdmanager create avd -n android5_x86 -k "system-images;android-22;default;x86"

# --- VNC password ---
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd "Clown80990@" /root/.vnc/passwd

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900

CMD ["/start.sh"]
