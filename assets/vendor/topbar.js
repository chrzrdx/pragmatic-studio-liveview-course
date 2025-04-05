/**
 * @license MIT
 * topbar 3.0.0
 * http://buunguyen.github.io/topbar
 * Copyright (c) 2024 Buu Nguyen
 */

let canvas;
let currentProgress;
let showing;
let progressTimerId = null;
let fadeTimerId = null;
let delayTimerId = null;

const addEvent = (elem, type, handler) => {
  if (elem.addEventListener) elem.addEventListener(type, handler, false);
  else if (elem.attachEvent) elem.attachEvent(`on${type}`, handler);
  else elem[`on${type}`] = handler;
};

const options = {
  autoRun: true,
  barThickness: 3,
  barColors: {
    0: "rgba(26,  188, 156, .9)",
    ".25": "rgba(52,  152, 219, .9)",
    ".50": "rgba(241, 196, 15,  .9)",
    ".75": "rgba(230, 126, 34,  .9)",
    "1.0": "rgba(211, 84,  0,   .9)",
  },
  shadowBlur: 10,
  shadowColor: "rgba(0,   0,   0,   .6)",
  className: null,
};

const repaint = () => {
  canvas.width = window.innerWidth;
  canvas.height = options.barThickness * 5; // need space for shadow

  const ctx = canvas.getContext("2d");
  ctx.shadowBlur = options.shadowBlur;
  ctx.shadowColor = options.shadowColor;

  const lineGradient = ctx.createLinearGradient(0, 0, canvas.width, 0);
  for (const stop in options.barColors)
    lineGradient.addColorStop(stop, options.barColors[stop]);
  ctx.lineWidth = options.barThickness;
  ctx.beginPath();
  ctx.moveTo(0, options.barThickness / 2);
  ctx.lineTo(
    Math.ceil(currentProgress * canvas.width),
    options.barThickness / 2
  );
  ctx.strokeStyle = lineGradient;
  ctx.stroke();
};

const createCanvas = () => {
  canvas = document.createElement("canvas");
  const style = canvas.style;
  style.position = "fixed";
  style.top = style.left = style.right = style.margin = style.padding = 0;
  style.zIndex = 100001;
  style.display = "none";
  if (options.className) canvas.classList.add(options.className);
  addEvent(window, "resize", repaint);
};

export const topbar = {
  config: (opts) => {
    for (const key in opts)
      if (Object.prototype.hasOwnProperty.call(options, key))
        options[key] = opts[key];
  },
  show: (delay) => {
    if (showing) return;
    if (delay) {
      if (delayTimerId) return;
      delayTimerId = setTimeout(() => topbar.show(), delay);
    } else {
      showing = true;
      if (fadeTimerId !== null) window.cancelAnimationFrame(fadeTimerId);
      if (!canvas) createCanvas();
      if (!canvas.parentElement) document.body.appendChild(canvas);
      canvas.style.opacity = 1;
      canvas.style.display = "block";
      topbar.progress(0);
      if (options.autoRun) {
        (function loop() {
          progressTimerId = window.requestAnimationFrame(loop);
          topbar.progress(`+${0.05 * (1 - Math.sqrt(currentProgress)) ** 2}`);
        })();
      }
    }
  },
  progress: (to) => {
    if (typeof to === "undefined") return currentProgress;
    let newProgress;
    if (typeof to === "string") {
      newProgress =
        (to.indexOf("+") >= 0 || to.indexOf("-") >= 0 ? currentProgress : 0) +
        Number.parseFloat(to);
    } else {
      newProgress = to;
    }
    currentProgress = newProgress > 1 ? 1 : newProgress;
    repaint();
    return currentProgress;
  },
  hide: () => {
    clearTimeout(delayTimerId);
    delayTimerId = null;
    if (!showing) return;
    showing = false;
    if (progressTimerId != null) {
      window.cancelAnimationFrame(progressTimerId);
      progressTimerId = null;
    }
    (function loop() {
      if (topbar.progress("+.1") >= 1) {
        canvas.style.opacity -= 0.05;
        if (canvas.style.opacity <= 0.05) {
          canvas.style.display = "none";
          fadeTimerId = null;
          return;
        }
      }
      fadeTimerId = window.requestAnimationFrame(loop);
    })();
  },
};

export default topbar;
