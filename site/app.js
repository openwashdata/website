/* openwashdata static site. No libraries. Everything below degrades: without
   JavaScript the page still shows the first tab, the baked numbers and the
   catalogue header. */
(function () {
  'use strict';
  var reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };

  /* Theme ------------------------------------------------------------ */
  var toggle = $('#theme-toggle');
  function currentTheme() {
    var t = document.documentElement.getAttribute('data-theme');
    if (t) return t;
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }
  function setTheme(t) {
    document.documentElement.setAttribute('data-theme', t);
    try { localStorage.setItem('owd-theme', t); } catch (e) { /* ignore */ }
    toggle.setAttribute('aria-label', 'Switch to ' + (t === 'dark' ? 'light' : 'dark') + ' theme');
  }
  if (toggle) {
    toggle.setAttribute('aria-label', 'Switch to ' + (currentTheme() === 'dark' ? 'light' : 'dark') + ' theme');
    toggle.addEventListener('click', function () { setTheme(currentTheme() === 'dark' ? 'light' : 'dark'); });
  }

  /* Mobile nav -------------------------------------------------------- */
  var nav = $('#nav'), burger = $('#hamburger');
  function closeNav() { nav.classList.remove('open'); burger.setAttribute('aria-expanded', 'false'); burger.setAttribute('aria-label', 'Open menu'); }
  if (burger) {
    burger.addEventListener('click', function () {
      var open = nav.classList.toggle('open');
      burger.setAttribute('aria-expanded', String(open));
      burger.setAttribute('aria-label', open ? 'Close menu' : 'Open menu');
    });
    $$('#nav-links a').forEach(function (a) { a.addEventListener('click', closeNav); });
    document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeNav(); });
  }

  /* Catalogue --------------------------------------------------------- */
  var pkgs = (window.OWD && window.OWD.packages) || [];
  var tbody = $('#catalogue tbody'), search = $('#catalogue-search'), count = $('#catalogue-count');
  function esc(s) { return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  function renderCatalogue(q) {
    if (!tbody) return;
    q = (q || '').trim().toLowerCase();
    var rows = pkgs.filter(function (p) {
      return !q || (p.name + ' ' + p.title + ' ' + p.description + ' ' + p.maintainer).toLowerCase().indexOf(q) !== -1;
    });
    tbody.innerHTML = rows.map(function (p) {
      var doi = p.doi ? '<a href="https://doi.org/' + esc(p.doi) + '">DOI</a>' : '<span class="pill">in progress</span>';
      return '<tr><td><a href="' + esc(p.docs) + '">' + esc(p.name) + '</a></td><td>' + esc(p.description.length > 110 ? p.description.slice(0, 107) + '…' : p.description) + '</td><td class="num">' + p.datasets + '</td><td>' + doi + '</td></tr>';
    }).join('');
    if (count) count.textContent = rows.length + ' of ' + pkgs.length + ' packages' + (q ? ' match "' + q + '"' : '') + ' · snapshot ' + (window.OWD ? window.OWD.snapshot : '');
  }
  renderCatalogue('');
  if (search) {
    search.placeholder = 'Search ' + pkgs.length + ' packages, e.g. Malawi, sanitation, groundwater';
    search.addEventListener('input', function () { renderCatalogue(search.value); });
  }

  /* Numbers: tick up, then try to refresh from the live harvest --------- */
  function tick(el, to) {
    var from = 0, start = null, dur = 900;
    if (reduced) { el.textContent = to; return; }
    function step(ts) {
      if (!start) start = ts;
      var k = Math.min(1, (ts - start) / dur); k = 1 - Math.pow(1 - k, 3);
      el.textContent = Math.round(from + (to - from) * k);
      if (k < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }
  function setNumbers(nPkg, nDs, firstYear) {
    var years = new Date().getFullYear() - firstYear + 1;
    tick($('#n-packages'), nPkg); tick($('#n-datasets'), nDs); tick($('#n-years'), years);
    $('#first-year').textContent = firstYear;
  }
  (function () {
    var nPkg = pkgs.length, nDs = pkgs.reduce(function (a, p) { return a + p.datasets; }, 0);
    setNumbers(nPkg, nDs, (window.OWD && window.OWD.firstYear) || 2023);
    // Live refresh. Fails quietly (offline, CORS, sandbox) and keeps the snapshot.
    var url = 'https://raw.githubusercontent.com/openwashdata/owdata/main/inst/extdata/owd_packages.csv';
    if (!window.fetch) return;
    fetch(url, { mode: 'cors' }).then(function (r) { return r.ok ? r.text() : Promise.reject(); }).then(function (csv) {
      var lines = csv.split(/\r?\n/).filter(Boolean);
      var head = parseCsvLine(lines[0]);
      var iN = head.indexOf('n_datasets'), iD = head.indexOf('date');
      var n = 0, ds = 0, first = 9999;
      for (var i = 1; i < lines.length; i++) {
        var c = parseCsvLine(lines[i]); if (c.length < head.length) continue;
        n++; ds += parseInt(c[iN], 10) || 0;
        var y = parseInt((c[iD] || '').slice(0, 4), 10); if (y && y < first) first = y;
      }
      if (n) { setNumbers(n, ds, first === 9999 ? 2023 : first); $('#numbers-note').textContent = 'Counted live from the weekly harvest of the openwashdata GitHub organisation.'; }
    }).catch(function () { /* keep snapshot */ });
  })();
  function parseCsvLine(line) {
    var out = [], cur = '', q = false;
    for (var i = 0; i < line.length; i++) {
      var ch = line[i];
      if (q) { if (ch === '"' && line[i + 1] === '"') { cur += '"'; i++; } else if (ch === '"') { q = false; } else { cur += ch; } }
      else if (ch === '"') { q = true; } else if (ch === ',') { out.push(cur); cur = ''; } else { cur += ch; }
    }
    out.push(cur); return out;
  }

  /* Terminal scripts --------------------------------------------------- */
  var scripts = {
    data: [
      ['prompt', '> '], ['cmd', 'pak::pak("openwashdata/gwinfraassess")'], ['nl'],
      ['dim', '✔ Installed gwinfraassess 0.1.0 (github::openwashdata/gwinfraassess)'], ['nl'],
      ['prompt', '> '], ['cmd', 'library(gwinfraassess)'], ['nl'],
      ['prompt', '> '], ['cmd', 'dplyr::count(gwinfraassess, district, sort = TRUE)'], ['nl'],
      ['dim', '# A tibble: 9 × 2'], ['nl'],
      ['out', '  district        n'], ['nl'],
      ['out', '1 Lilongwe       28'], ['nl'],
      ['out', '2 Blantyre       21'], ['nl'],
      ['out', '3 Mzimba         17'], ['nl'],
      ['dim', '# … with 6 more rows'], ['nl'],
      ['prompt', '> '], ['cmd', 'citation("gwinfraassess")'], ['nl'],
      ['out', 'Mhango E, Chaweza T (2026). gwinfraassess: Groundwater monitoring'], ['nl'],
      ['out', 'infrastructure assessment, Malawi 2022. doi:10.5281/zenodo.…'], ['nl']
    ],
    publish: [
      ['prompt', '> '], ['cmd', 'washr::setup_rawdata()'], ['nl'],
      ['tick', '✔ Writing data-raw/data_processing.R'], ['nl'],
      ['dim', '→ Put the raw files in data-raw/ and edit the script.'], ['nl'],
      ['prompt', '> '], ['cmd', 'washr::setup_dictionary()'], ['nl'],
      ['tick', '✔ Writing data-raw/dictionary.csv (14 variables)'], ['nl'],
      ['dim', '→ Fill the description column. Nothing is published without it.'], ['nl'],
      ['prompt', '> '], ['cmd', 'washr::setup_roxygen()'], ['nl'],
      ['tick', '✔ Writing R/gwinfraassess.R from the dictionary'], ['nl'],
      ['prompt', '> '], ['cmd', 'washr::setup_website()'], ['nl'],
      ['tick', '✔ Writing _pkgdown.yml in the openwashdata brand'], ['nl'],
      ['prompt', '> '], ['cmd', 'washr::update_citation()'], ['nl'],
      ['tick', '✔ Writing CITATION.cff and inst/CITATION'], ['nl'],
      ['prompt', '> '], ['cmd', 'washr::check_publication_readiness()'], ['nl'],
      ['tick', '✔ 11 of 11 items pass. Ready for review.'], ['nl']
    ],
    review: [
      ['prompt', '❯ '], ['cmd', '/review-package gwinfraassess'], ['nl'],
      ['dim', 'Organisation profile: openwashdata · standard 1.7.0'], ['nl'],
      ['out', 'Intake screen'], ['nl'],
      ['tick', '  ✔ data-raw/ present with processing script'], ['nl'],
      ['tick', '  ✔ no direct identifiers in 14 columns, 123 rows'], ['nl'],
      ['tick', '  ✔ git history: 31 commits scanned, no removed identifier columns'], ['nl'],
      ['warn', '  ! household-level rows: no. Well-level. Continue.'], ['nl'],
      ['out', 'Writing CLAUDE.md (pkgreview standards 1.7.0) into the package'], ['nl'],
      ['out', 'Running pkgreview-check.R … 38 PASS · 3 FAIL · 1 FLAG'], ['nl'],
      ['out', 'Creating issue #1: Data Package Review: General Information & Metadata'], ['nl'],
      ['warn', 'Stopping for your approval before the first pull request.'], ['nl']
    ]
  };
  var files = {
    learn: [
      'graduates-2026/', '├── <span class="key">wasteflowkampala</span>      Solid waste flows, Kampala', '├── <span class="key">boreholesnorth</span>       Borehole functionality, Northern Ghana',
      '├── <span class="key">schoolwashkenya</span>      WASH in schools census, Kenya', '├── <span class="key">handpumprepairs</span>      Repair logs, 2019 to 2025',
      '├── <span class="key">fsmtariffs</span>           Emptying tariffs, 12 cities', '└── <span class="key">…</span> 40 more packages, one per graduate',
      '', '<span class="dim">Each folder is a repository under github.com/openwashdata</span>', '<span class="dim">with a README, a dictionary, a website and a licence.</span>'
    ],
    read: [
      '---', '<span class="key">title</span>: <span class="str">"From a raw spreadsheet to a published data package in a day"</span>',
      '<span class="key">description</span>: <span class="str">"How a field workbook from a household waste study in</span>', '<span class="str">  Kampala became a documented, reviewed and citable R data package."</span>',
      '<span class="key">categories</span>:', '  - <span class="str">open data</span>', '  - <span class="str">data packages</span>', '  - <span class="str">AI-assisted publishing</span>',
      '<span class="key">author</span>:', '  - <span class="key">name</span>: <span class="str">"Lars Schöbitz"</span>', '    <span class="key">orcid</span>: <span class="str">0000-0003-2196-5015</span>',
      '<span class="key">date</span>: <span class="str">"2026-10-20"</span>', '---', '',
      'On 22 July 2026 at 15:05, I made the first commit to a new', 'repository. It held an empty R package and one Excel workbook', 'with field data from a household waste study in Kampala.'
    ]
  };
  $$('.file').forEach(function (pre) {
    var lines = files[pre.getAttribute('data-file')] || [];
    pre.innerHTML = lines.map(function (l, i) { return '<span class="ln">' + (i + 1) + '</span>' + l; }).join('\n');
  });

  var typers = {};
  function typeInto(pre, name) {
    if (typers[name]) typers[name].cancel();
    var seq = scripts[name] || [], out = '', idx = 0, pos = 0, cancelled = false, timer = null;
    pre.innerHTML = '';
    function render(cursor) { pre.innerHTML = out + (cursor ? '<span class="cursor"></span>' : ''); }
    function wrap(kind, text) {
      var cls = { prompt: 'prompt', dim: 'dim', tick: 'tick', warn: 'warn', cmd: '', out: '' }[kind];
      return cls ? '<span class="' + cls + '">' + esc(text) + '</span>' : esc(text);
    }
    if (reduced) {
      seq.forEach(function (s) { out += s[0] === 'nl' ? '\n' : wrap(s[0], s[1]); });
      render(false); return;
    }
    function step() {
      if (cancelled) return;
      if (idx >= seq.length) { render(false); return; }
      var s = seq[idx];
      if (s[0] === 'nl') { out += '\n'; idx++; pos = 0; timer = setTimeout(step, 60); return; }
      if (s[0] === 'cmd') {
        pos++; var partial = s[1].slice(0, pos);
        pre.innerHTML = out + esc(partial) + '<span class="cursor"></span>';
        if (pos >= s[1].length) { out += esc(s[1]); idx++; pos = 0; timer = setTimeout(step, 350); }
        else timer = setTimeout(step, 28);
        return;
      }
      out += wrap(s[0], s[1]); idx++; render(true);
      timer = setTimeout(step, s[0] === 'prompt' ? 150 : 120);
    }
    typers[name] = { cancel: function () { cancelled = true; clearTimeout(timer); } };
    step();
  }

  /* Chart: dataset of the month, drawn once ----------------------------- */
  function drawChart() {
    var svg = $('#dotm-chart'); if (!svg || svg.getAttribute('data-drawn')) return;
    svg.setAttribute('data-drawn', '1');
    var data = [
      ['Find and train a gauge reader', 62, 'var(--chart-1)'], ['Provide a manual dipper', 61, 'var(--chart-3)'],
      ['Replace the level logger', 46, 'var(--chart-3)'], ['Repair the civil works', 42, 'var(--chart-2)'],
      ['Install a new logger', 24, 'var(--chart-3)'], ['Replace cover and hinges', 19, 'var(--chart-2)'],
      ['Replace the barologger', 11, 'var(--chart-3)'], ['Redevelop the well', 9, 'var(--chart-2)'],
      ['Replace the well', 5, 'var(--owd-grey-light)'], ['Discard the well', 3, 'var(--owd-grey-light)']
    ];
    var W = 520, left = 200, right = 40, top = 10, rowH = 28, barH = 18, max = 70, plotW = W - left - right;
    var H = top + data.length * rowH + 30; svg.setAttribute('viewBox', '0 0 ' + W + ' ' + H);
    var ns = 'http://www.w3.org/2000/svg';
    function el(n, a, txt) { var e = document.createElementNS(ns, n); for (var k in a) e.setAttribute(k, a[k]); if (txt != null) e.textContent = txt; return e; }
    var grid = el('g', { 'class': 'grid axis' });
    [0, 20, 40, 60].forEach(function (v) {
      var x = left + plotW * v / max;
      grid.appendChild(el('line', { x1: x, x2: x, y1: top, y2: top + data.length * rowH }));
      grid.appendChild(el('text', { x: x, y: H - 10, 'text-anchor': 'middle' }, v + '%'));
    });
    svg.appendChild(grid);
    data.forEach(function (d, i) {
      var y = top + i * rowH;
      svg.appendChild(el('text', { x: left - 8, y: y + barH / 2 + 4, 'text-anchor': 'end' }, d[0]));
      var bar = el('rect', { 'class': 'bar', x: left, y: y, height: barH, width: plotW * d[1] / max, fill: d[2], rx: 2 });
      bar.appendChild(el('title', {}, d[0] + ': ' + d[1] + '% of 122 wells'));
      if (!reduced) { bar.style.transform = 'scaleX(0)'; bar.style.transition = 'transform 0.6s ease ' + (i * 0.05) + 's'; requestAnimationFrame(function () { requestAnimationFrame(function () { bar.style.transform = 'scaleX(1)'; }); }); }
      svg.appendChild(bar);
      svg.appendChild(el('text', { x: left + plotW * d[1] / max + 5, y: y + barH / 2 + 4 }, d[1] + '%'));
    });
  }

  /* Tabs with autoplay ------------------------------------------------- */
  var tabs = $$('.tab'), panels = $$('.panel'), showcase = $('#showcase');
  var current = 0, autoplay = !reduced, paused = false, hovering = false, visible = true, inView = true, raf = null, startTs = null;
  var PERIOD = 7000, progress = null;
  tabs.forEach(function (t) { var p = document.createElement('span'); p.className = 'progress'; t.appendChild(p); });
  function select(i, focus) {
    current = (i + tabs.length) % tabs.length;
    tabs.forEach(function (t, j) {
      var on = j === current;
      t.setAttribute('aria-selected', String(on)); t.tabIndex = on ? 0 : -1;
      panels[j].hidden = !on;
    });
    // Scroll the tab bar horizontally only; scrollIntoView would move the page on load.
    var bar = tabs[current].parentNode, t = tabs[current];
    if (t.offsetLeft < bar.scrollLeft || t.offsetLeft + t.offsetWidth > bar.scrollLeft + bar.clientWidth) bar.scrollLeft = t.offsetLeft - 8;
    if (focus) tabs[current].focus();
    var panel = panels[current];
    panel.classList.remove('animate'); void panel.offsetWidth; panel.classList.add('animate');
    var term = $('.term', panel); if (term) typeInto(term, term.getAttribute('data-script'));
    if (panel.id === 'panel-dotm') drawChart();
    progress = $('.progress', tabs[current]); startTs = null;
  }
  tabs.forEach(function (t, i) {
    t.addEventListener('click', function () { select(i, false); });
    t.addEventListener('keydown', function (e) {
      var k = e.key, n = null;
      if (k === 'ArrowRight') n = current + 1; else if (k === 'ArrowLeft') n = current - 1; else if (k === 'Home') n = 0; else if (k === 'End') n = tabs.length - 1;
      if (n !== null) { e.preventDefault(); select(n, true); }
    });
  });
  function running() { return autoplay && !paused && !hovering && visible && inView; }
  function loop(ts) {
    if (running()) {
      if (!startTs) startTs = ts;
      var k = (ts - startTs) / PERIOD;
      if (progress) progress.style.transform = 'scaleX(' + Math.min(1, k) + ')';
      if (k >= 1) select(current + 1, false);
    } else { startTs = null; }
    raf = requestAnimationFrame(loop);
  }
  var state = $('#autoplay-state'), pauseBtn = $('#pause'), replayBtn = $('#replay');
  function updateState() {
    if (!autoplay) { state.textContent = 'Auto-play is off (reduced motion)'; pauseBtn.hidden = true; return; }
    state.textContent = paused ? 'Paused' : 'Auto-advancing every 7 seconds';
    pauseBtn.textContent = paused ? 'Auto-play' : 'Pause'; pauseBtn.setAttribute('aria-pressed', String(paused));
  }
  pauseBtn.addEventListener('click', function () { paused = !paused; updateState(); });
  replayBtn.addEventListener('click', function () { paused = false; select(0, false); updateState(); });
  showcase.addEventListener('mouseenter', function () { hovering = true; });
  showcase.addEventListener('mouseleave', function () { hovering = false; });
  showcase.addEventListener('focusin', function () { hovering = true; });
  showcase.addEventListener('focusout', function () { if (!showcase.contains(document.activeElement)) hovering = false; });
  document.addEventListener('visibilitychange', function () { visible = !document.hidden; });
  if ('IntersectionObserver' in window) {
    new IntersectionObserver(function (es) { inView = es[0].isIntersecting; }, { threshold: 0.2 }).observe(showcase);
  }
  select(0, false); updateState();
  if (autoplay) raf = requestAnimationFrame(loop);

  /* Readiness check ---------------------------------------------------- */
  var boxes = $$('#checks input'), ringFill = $('#ring-fill'), ringLabel = $('#ring-label'), verdict = $('#verdict'), next = $('#next-steps');
  var C = 2 * Math.PI * 62;
  var steps = {
    'c-raw': 'Put the raw files in data-raw/ and run washr::setup_rawdata() for the processing script.',
    'c-dict': 'Run washr::setup_dictionary() and write one description per variable.',
    'c-pii': 'Check every dataset for identifiers and sensitive rows before the first commit with data.',
    'c-desc': 'Fill DESCRIPTION with washr::update_description(); the licence is CC BY 4.0.',
    'c-readme': 'Run washr::setup_readme() and write what the data is and how it was collected.',
    'c-site': 'Run washr::setup_website() and turn on GitHub Pages.',
    'c-doi': 'Run washr::update_citation(), then make a GitHub release; Zenodo mints the DOI.'
  };
  function updateReadiness() {
    var done = boxes.filter(function (b) { return b.checked; }).length;
    var floorDone = boxes.filter(function (b) { return b.hasAttribute('data-floor') && b.checked; }).length;
    ringFill.setAttribute('stroke-dashoffset', String(C - C * done / boxes.length));
    ringLabel.textContent = done + '/' + boxes.length;
    if (done === boxes.length) verdict.textContent = 'Ready to publish. Tell us, and we add it to the catalogue.';
    else if (floorDone === 5) verdict.textContent = 'At the publication floor. Ready for review.';
    else if (done === 0) verdict.textContent = 'Start with the raw data.';
    else verdict.textContent = (5 - floorDone) + ' floor item' + (5 - floorDone === 1 ? '' : 's') + ' left before a review can start.';
    next.innerHTML = boxes.filter(function (b) { return !b.checked; }).slice(0, 3).map(function (b) { return '<li>' + esc(steps[b.id]) + '</li>'; }).join('');
  }
  boxes.forEach(function (b) { b.addEventListener('change', updateReadiness); });
  updateReadiness();

  /* FAQ deep links ----------------------------------------------------- */
  function openFaq() {
    var id = location.hash.slice(1);
    if (id && id.indexOf('faq-') === 0) { var d = document.getElementById(id); if (d && d.tagName === 'DETAILS') d.open = true; }
  }
  window.addEventListener('hashchange', openFaq); openFaq();
})();
