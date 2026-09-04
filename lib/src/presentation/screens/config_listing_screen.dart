import 'package:boxy/slivers.dart';
import 'package:flutter/material.dart';
import 'package:local_config/src/local_config.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_routes.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/models/config_value.dart';
import 'package:local_config/src/presentation/notifiers/config_notifier.dart';
import 'package:local_config/src/presentation/theme_mode_scope.dart';
import 'package:local_config/src/presentation/widgets/callout.dart';
import 'package:local_config/src/presentation/widgets/clearable_search_bar.dart';
import 'package:local_config/src/presentation/widgets/dashed_l_connector.dart';
import 'package:local_config/src/presentation/widgets/extended_list_tile.dart';
import 'package:local_config/src/presentation/widgets/highlighted_text_rich.dart';
import 'package:local_config/src/presentation/widgets/root_aware_sliver_app_bar.dart';

class ConfigListingScreen extends StatefulWidget {
  const ConfigListingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigListingScreenState();
}

class _ConfigListingScreenState extends State<ConfigListingScreen> {
  final _textController = TextEditingController();

  final _scrollController = ScrollController();

  final _configNotifier = ConfigNotifier(configRepo: configRepo);

  static const _backToTopScrollOffsetThreshold = 600.0;

  var _showBackToTop = false;
  var _isScrollingToTop = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_query);
    _scrollController.addListener(_onScroll);
  }

  void _query() {
    _configNotifier.query(_textController.text);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final showBackToTop =
        !_isScrollingToTop &&
        _scrollController.offset > _backToTopScrollOffsetThreshold;
    if (showBackToTop != _showBackToTop) {
      setState(() => _showBackToTop = showBackToTop);
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    setState(() {
      _isScrollingToTop = true;
      _showBackToTop = false;
    });

    _scrollController
        .animateTo(
          0,
          duration: Durations.medium1,
          curve: Curves.easeInOut,
        )
        .whenComplete(() {
          if (!mounted) return;

          _isScrollingToTop = false;
          _onScroll();
        });
  }

  @override
  void dispose() {
    _textController.removeListener(_query);
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'local_config_add_parameter_fab',
        onPressed: () {
          Navigator.of(context).pushNamed(LocalConfigRoutes.configAdd);
        },
        tooltip: LocalConfigLocalizations.of(context)!.addParameter,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListenableBuilder(
        listenable: _configNotifier,
        builder: (context, child) {
          final hasLocalValue = _configNotifier.hasLocalValue;

          return Stack(
            children: [
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                interactive: true,
                radius: const Radius.circular(8),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const _AppBar(),
                    if (hasLocalValue)
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: _TopOverlay.reservedCalloutHeight,
                        ),
                      ),
                    if (_configNotifier.all.isEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            LocalConfig.instance.initialized
                                ? LocalConfigLocalizations.of(
                                    context,
                                  )!.noConfigs
                                : LocalConfigLocalizations.of(
                                    context,
                                  )!.uninitialized,
                          ),
                        ),
                      )
                    else ...[
                      SliverToBoxAdapter(child: SizedBox.square(dimension: 16)),
                      _SearchBar(controller: _textController),
                      SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
                      SliverToBoxAdapter(
                        child: SwitchListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          title: Text(
                            LocalConfigLocalizations.of(
                              context,
                            )!.showOnlyChanged,
                          ),
                          value: _configNotifier.showOnlyLocals,
                          onChanged: (value) {
                            _configNotifier.showOnlyLocals = value;
                          },
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
                      _List(
                        items: _configNotifier.filtered,
                        terms: _configNotifier.terms,
                        onResetTap: _configNotifier.reset,
                      ),
                    ],
                  ],
                ),
              ),
              _TopOverlay(
                showCallout: hasLocalValue,
                showBackToTop: _showBackToTop,
                onResetAllTap: _configNotifier.resetAll,
                onBackToTopTap: _scrollToTop,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return RootAwareSliverAppBar(
      // The full wordmark (assets/images/logo.png) bakes its "Local Config"
      // text in a near-white color meant for a dark app bar, so it's
      // unreadable in light mode. Only the icon mark is theme-agnostic;
      // the label is rendered as real text so it follows onSurface.
      title: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Image.asset(
            'assets/images/mark.png',
            package: 'local_config',
            height: 24,
          ),
          Text(
            LocalConfigLocalizations.of(context)!.localConfig,
            style: TextTheme.of(
              context,
            ).titleLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),

      floating: true,
      pinned: true,
      centerTitle: true,
      actionsPadding: EdgeInsets.only(right: 8),
      actions: const [_ThemeModeButton()],
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  IconData _iconFor(ThemeMode mode, Brightness platformBrightness) {
    return switch (mode) {
      ThemeMode.light => Icons.light_mode_outlined,
      ThemeMode.dark => Icons.dark_mode_outlined,
      ThemeMode.system =>
        platformBrightness == Brightness.dark
            ? Icons.dark_mode_outlined
            : Icons.light_mode_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = ThemeModeScope.of(context);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return ListenableBuilder(
      listenable: themeModeNotifier,
      builder: (context, _) {
        final mode = themeModeNotifier.themeMode;
        final localizations = LocalConfigLocalizations.of(context)!;

        return PopupMenuButton<ThemeMode>(
          tooltip: switch (mode) {
            ThemeMode.system => localizations.themeModeSystem,
            ThemeMode.light => localizations.themeModeLight,
            ThemeMode.dark => localizations.themeModeDark,
          },
          icon: Icon(_iconFor(mode, platformBrightness)),
          onSelected: themeModeNotifier.setThemeMode,
          itemBuilder: (context) => [
            _buildItem(
              value: ThemeMode.light,
              current: mode,
              icon: Icons.light_mode_outlined,
              label: localizations.themeModeLight,
            ),
            _buildItem(
              value: ThemeMode.dark,
              current: mode,
              icon: Icons.dark_mode_outlined,
              label: localizations.themeModeDark,
            ),
            _buildItem(
              value: ThemeMode.system,
              current: mode,
              icon: _iconFor(ThemeMode.system, platformBrightness),
              label: localizations.themeModeSystem,
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem<ThemeMode> _buildItem({
    required ThemeMode value,
    required ThemeMode current,
    required IconData icon,
    required String label,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        spacing: 16,
        children: [
          Icon(icon),
          Expanded(child: Text(label)),
          if (value == current) const Icon(Icons.check),
        ],
      ),
    );
  }
}

class _TopOverlay extends StatelessWidget {
  static const calloutHeight = Callout.defaultHeight;
  static const itemGap = 8.0;
  static const reservedCalloutHeight = calloutHeight + itemGap;
  static const _buttonHeight = 40.0;

  final bool showCallout;
  final bool showBackToTop;
  final Function()? onResetAllTap;
  final Function()? onBackToTopTap;

  const _TopOverlay({
    required this.showCallout,
    required this.showBackToTop,
    this.onResetAllTap,
    this.onBackToTopTap,
  });

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MediaQuery.paddingOf(context).top + kToolbarHeight;
    final visibleButtonTop = showCallout ? calloutHeight + itemGap : itemGap;
    const hiddenCalloutTop = -calloutHeight - itemGap;
    const hiddenButtonTop = -_buttonHeight - itemGap;

    return Positioned.fill(
      top: appBarHeight,
      child: ClipRect(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: Durations.medium1,
              curve: Curves.easeInOutCubic,
              top: showBackToTop ? visibleButtonTop : hiddenButtonTop,
              left: 0,
              right: 0,
              height: _buttonHeight,
              child: Center(
                child: IgnorePointer(
                  ignoring: !showBackToTop,
                  child: _BackToTopButton(onTap: onBackToTopTap),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Durations.medium1,
              curve: Curves.easeInOutCubic,
              top: showCallout ? 0 : hiddenCalloutTop,
              left: 16,
              right: 16,
              height: calloutHeight,
              child: IgnorePointer(
                ignoring: !showCallout,
                child: _ChangesAppliedCallout(onResetAllTap: onResetAllTap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangesAppliedCallout extends StatelessWidget {
  final Function()? onResetAllTap;

  const _ChangesAppliedCallout({this.onResetAllTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final extendedColorScheme = context.extendedColorScheme;
    final backgroundColor = Color.alphaBlend(
      extendedColorScheme.warningContainer,
      colorScheme.surface,
    );
    final borderColor = Color.alphaBlend(
      extendedColorScheme.onWarningContainer,
      colorScheme.surface,
    );

    return Callout.warning(
      icon: Icons.error,
      style: CalloutStyle(
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderRadius: BorderRadius.circular(16),
      ),
      text: LocalConfigLocalizations.of(context)!.changesApplied,
      trailing: TextButton(
        onPressed: onResetAllTap,
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(
            Theme.of(
              context,
            ).extension<ExtendedColorScheme>()?.warningContainer,
          ),
          foregroundColor: WidgetStatePropertyAll(
            Theme.of(context) //
                .extension<ExtendedColorScheme>()
                ?.warning,
          ),
        ),
        child: Text(
          LocalConfigLocalizations.of(context)!.revertAll,
        ),
      ),
    );
  }
}

class _BackToTopButton extends StatelessWidget {
  final Function()? onTap;

  const _BackToTopButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'local_config_back_to_top_fab',
      tooltip: LocalConfigLocalizations.of(context)!.backToTop,
      onPressed: onTap,
      child: const Icon(Icons.keyboard_arrow_up),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClearableSearchBar(
          controller: controller,
          hintText: LocalConfigLocalizations.of(context)!.search,
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final Set<String> terms;
  final List<MapEntry<String, ConfigValue>> items;
  final Function(String)? onResetTap;

  const _List({
    required this.items,
    this.terms = const {},
    this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 128),
      sliver: SliverContainer(
        background: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(16),
        sliver: SliverMainAxisGroup(
          slivers: [
            if (items.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(LocalConfigLocalizations.of(context)!.noResults),
                ),
              ),
            if (items.isNotEmpty)
              SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final item = items[index];
                  final (name, configValue) = (item.key, item.value);
                  final hasLocalValue = configValue.hasLocalValue;
                  final isCustom = configValue.isCustom;
                  // Free entries are just local values with no default to
                  // compare against, so they're styled identically to
                  // overridden ones.
                  final isChanged = hasLocalValue || isCustom;

                  return ExtendedListTile(
                    key: ValueKey(name),
                    style: isChanged
                        ? ExtendedListTileStyle(
                            tileColor: Theme.of(context)
                                .extension<ExtendedColorScheme>()
                                ?.warningContainer,
                            titleTextStyle: context
                                .extendedTextTheme
                                .codeBodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        : ExtendedListTileStyle(
                            titleTextStyle:
                                context.extendedTextTheme.codeBodyMedium,
                          ),
                    top: isChanged
                        ? Callout.warning(
                            style: CalloutStyle(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            icon: Icons.error,
                            text: LocalConfigLocalizations.of(context)!.changed,
                            trailing: TextButton(
                              onPressed: () => onResetTap?.call(name),
                              style: ButtonStyle(
                                overlayColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .extension<ExtendedColorScheme>()
                                      ?.warningContainer,
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Theme.of(context) //
                                      .extension<ExtendedColorScheme>()
                                      ?.warning,
                                ),
                              ),
                              child: Text(
                                LocalConfigLocalizations.of(context)!.revert,
                              ),
                            ),
                          )
                        : null,
                    title: Row(
                      spacing: 16,
                      children: [
                        Icon(configValue.type.displayIcon),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: HighlightText(
                              text: name,
                              terms: terms,
                              style: context.extendedTextTheme.codeBodyMedium
                                  ?.copyWith(
                                    fontWeight: isChanged
                                        ? FontWeight.bold
                                        : null,
                                  ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              LocalConfigRoutes.configEdit,
                              arguments: name,
                            );
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: LocalConfigLocalizations.of(context)!.edit,
                        ),
                      ],
                    ),

                    subtitle: DashedLConnector(
                      size: const Size(32, 24),
                      entries: [
                        if (isChanged)
                          DashedLEntry(
                            label: Chip(
                              label: Text(
                                LocalConfigLocalizations.of(
                                  context,
                                )!.localValue,
                                style:
                                    TextTheme.of(
                                      context,
                                    ).bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              color: WidgetStatePropertyAll(
                                context.extendedColorScheme.warningContainer,
                              ),
                            ),
                            value: HighlightText(
                              // Free entries store their value in
                              // defaultValue (there's no default to
                              // contrast it with).
                              text: isCustom
                                  ? configValue.getDefaultDisplayText(context)
                                  : configValue.getLocalDisplayText(context),
                              terms: terms,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextTheme.of(
                                    context,
                                  ).bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        if (!isCustom)
                          DashedLEntry(
                            label: Text(
                              LocalConfigLocalizations.of(
                                context,
                              )!.defaultValue,
                              style: TextTheme.of(context).bodyMedium,
                            ),
                            value: HighlightText(
                              text: configValue.getDefaultDisplayText(context),
                              terms: terms,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextTheme.of(context).bodyMedium,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
