# ---------------------------------------------------------------------------
# Dell Inspiron 16 5645 fan control
# ---------------------------------------------------------------------------

PREFIX        ?= /usr/local
BINDIR        ?= $(PREFIX)/bin
SYSTEMD_DIR   ?= /etc/systemd/system

SERVICE       := fan-control.service
DAEMON        := fan-control-daemon
CLIENT        := fan
WATCH         := fan-watch

# Source files live next to this Makefile.
SRC_DIR       := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DAEMON_SRC    := $(SRC_DIR)fan-control-daemon
CLIENT_SRC    := $(SRC_DIR)fan
SERVICE_SRC   := $(SRC_DIR)fan-control.service
WATCH_SRC     := $(SRC_DIR)fan-watch.sh

# Use sudo unless we're already root.
SUDO          := $(shell [ "$$(id -u)" -eq 0 ] || echo sudo)

INSTALL       := install
INSTALL_PROG  := $(INSTALL) -m 0755 -o root -g root
INSTALL_UNIT  := $(INSTALL) -m 0644 -o root -g root

.PHONY: all install install-bin install-service uninstall \
        reload enable disable status clean help

all: help

help:
	@echo "Targets:"
	@echo "  install     Install daemon, client, watcher and systemd unit; enable + start service"
	@echo "  uninstall   Stop + disable + remove service, daemon, client and watcher"
	@echo "  reload      Reload systemd units"
	@echo "  enable      Enable and start the service"
	@echo "  disable     Stop and disable the service"
	@echo "  status      Show service status"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX=$(PREFIX)  BINDIR=$(BINDIR)  SYSTEMD_DIR=$(SYSTEMD_DIR)"

# ---------------------------------------------------------------------------
# install
# ---------------------------------------------------------------------------
install: install-bin install-service
	@echo ">> Reloading systemd and (re)starting $(SERVICE)"
	$(SUDO) systemctl daemon-reload
	$(SUDO) systemctl enable $(SERVICE)
	$(SUDO) systemctl restart $(SERVICE)
	@echo ">> Installed. Try: fan status"

install-bin: $(DAEMON_SRC) $(CLIENT_SRC) $(WATCH_SRC)
	@echo ">> Installing $(DAEMON), $(CLIENT) and $(WATCH) into $(BINDIR)"
	$(SUDO) $(INSTALL) -d $(BINDIR)
	$(SUDO) $(INSTALL_PROG) "$(DAEMON_SRC)" "$(BINDIR)/$(DAEMON)"
	$(SUDO) $(INSTALL_PROG) "$(CLIENT_SRC)" "$(BINDIR)/$(CLIENT)"
	$(SUDO) $(INSTALL_PROG) "$(WATCH_SRC)"  "$(BINDIR)/$(WATCH)"

install-service: $(SERVICE_SRC)
	@echo ">> Installing $(SERVICE) into $(SYSTEMD_DIR)"
	$(SUDO) $(INSTALL) -d $(SYSTEMD_DIR)
	$(SUDO) $(INSTALL_UNIT) "$(SERVICE_SRC)" "$(SYSTEMD_DIR)/$(SERVICE)"

# ---------------------------------------------------------------------------
# uninstall
# ---------------------------------------------------------------------------
uninstall:
	@echo ">> Stopping and disabling $(SERVICE) (if present)"
	-$(SUDO) systemctl stop    $(SERVICE)
	-$(SUDO) systemctl disable $(SERVICE)
	@echo ">> Removing service unit"
	-$(SUDO) rm -f "$(SYSTEMD_DIR)/$(SERVICE)"
	$(SUDO) systemctl daemon-reload
	@echo ">> Removing binaries"
	-$(SUDO) rm -f "$(BINDIR)/$(DAEMON)"
	-$(SUDO) rm -f "$(BINDIR)/$(CLIENT)"
	-$(SUDO) rm -f "$(BINDIR)/$(WATCH)"
	@echo ">> Removing socket (if any)"
	-$(SUDO) rm -f /run/fan-control.sock
	@echo ">> Uninstalled."

# ---------------------------------------------------------------------------
# convenience targets
# ---------------------------------------------------------------------------
reload:
	$(SUDO) systemctl daemon-reload

enable:
	$(SUDO) systemctl enable --now $(SERVICE)

disable:
	$(SUDO) systemctl disable --now $(SERVICE)

status:
	systemctl status $(SERVICE) --no-pager || true

# ---------------------------------------------------------------------------
# cleanup
# ---------------------------------------------------------------------------
clean:
	@echo "Nothing to build; nothing to clean."

