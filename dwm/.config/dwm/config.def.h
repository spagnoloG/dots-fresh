/* See LICENSE file for copyright and license details. */
/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "iosevka:size=11", "fontawesome:size=10" };
static const char dmenufont[]       = "iosevka:size=11";

static const char norm_fg[] = "#D5C4A1";
static const char norm_bg[] = "#1d2021";
static const char norm_border[] = "#665c54";

static const char sel_fg[] = "#FE8019";
static const char sel_bg[] = "#1d2021";
static const char sel_border[] = "#fbf1c7";

static const char urg_fg[] = "#fbf1c7";
static const char urg_bg[] = "#fb4934";
static const char urg_border[] = "#fb4934";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
};

static const char *const autostart[] = {
	"wmname", "LG3D", NULL,
	"slstatus", NULL,
	"picom", NULL,
	"hsetroot", "/home/gasper/pictures/wallpapers/RetroCar.jpg", NULL,
	"kitty", "-e", "tmux", NULL,
	NULL /* terminate */
};

/* tagging */
//static const char *tags[] = {  "", "", "", "", "", "", "", "", "" };
static const char *tags[] = {  "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[G]",	  gaplessgrid },
	{ "[D]",	  deck },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define XF86XK_AudioMute        0x1008FF12   /* Mute sound from the system */
#define XF86XK_AudioLowerVolume 0x1008FF11   /* Volume control down        */
#define XF86XK_AudioRaiseVolume 0x1008FF13   /* Volume control up          */
#define XF86XK_MonBrightnessUp   0x1008FF02  /* Monitor/panel brightness */
#define XF86XK_MonBrightnessDown 0x1008FF03  /* Monitor/panel brightness */
#define XF86XK_PrintScreeen 0x0000ff61 /* Printscreen key */
// https://cgit.freedesktop.org/xorg/proto/x11proto/tree/XF86keysym.h

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", norm_bg, "-nf", norm_fg, "-sb", norm_border, "-sf", sel_fg, NULL };
static const char *termcmd[]  = { "kitty", "-e", "tmux", NULL };
static const char *lock_cmd[] = { "i3lock", "-c", "000000", NULL };
static const char *sleep_cmd[] = {"systemctl", "suspend", "&&", "i3lock", "-c", "000000", NULL };
static const char *printscreen_cmd[] = { "flameshot", "gui", NULL };


/* Brightness and volume commands */
static const char *mutevol[] = { "pactl", "set-sink-mute", "@DEFAULT_SINK@",  "toggle", NULL };
static const char *volume_up[] =  { "amixer", "-q", "sset", "Master", "1%+", NULL }; 
static const char *volume_down[] =  { "amixer", "-q", "sset", "Master", "1%-", NULL };
static const char *backlight_up[] = { "brightnessctl", "s", "+5%", NULL };
static const char *backlight_down[] = { "brightnessctl", "s", "5%-", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_g,      setlayout,      {.v = &layouts[3] } },
	{ MODKEY,                       XK_c,      setlayout,      {.v = &layouts[4] } },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
    { 0,                            XF86XK_AudioMute, spawn, {.v = mutevol } },
    { 0,                            XF86XK_AudioLowerVolume, spawn, {.v = volume_down } },
    { 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = volume_up   } },
    { 0,                            XF86XK_MonBrightnessUp, spawn, {.v = backlight_up   } },
    { 0,                            XF86XK_MonBrightnessDown, spawn, {.v = backlight_down   } },
	{ 0,							XF86XK_PrintScreeen, spawn, {.v = printscreen_cmd} },
	{ MODKEY,						XK_x,		spawn,			{.v= lock_cmd}},
	{ MODKEY|ShiftMask,				XK_X,		spawn,			{.v= sleep_cmd}},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

