const CACHE = 'utc-connect-v4';
const PRECACHE = ['./', './index.html', './manifest.webmanifest', './assets/logo.png'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(PRECACHE)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('push', (event) => {
  let data = { title: 'MSU-UTC Connect', body: 'New activity', url: '/' };
  try {
    if (event.data) data = { ...data, ...event.data.json() };
  } catch (_) { /* ignore */ }
  const title = data.title || 'MSU-UTC Connect';
  const options = {
    body: data.body || '',
    icon: 'assets/logo.png',
    badge: 'assets/logo.png',
    data: { url: data.url || 'https://utc.marawionline.com' },
    tag: 'utc-connect-push',
    renotify: true
  };
  event.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const url = event.notification.data?.url || 'https://utc.marawionline.com';
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((list) => {
      for (const client of list) {
        if ('focus' in client) {
          client.navigate(url);
          return client.focus();
        }
      }
      if (clients.openWindow) return clients.openWindow(url);
    })
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;
  event.respondWith(
    fetch(event.request)
      .then((res) => {
        if (res.ok && (url.pathname.endsWith('.html') || url.pathname === '/' || url.pathname.endsWith('/'))) {
          const copy = res.clone();
          caches.open(CACHE).then((c) => c.put(event.request, copy));
        }
        return res;
      })
      .catch(() => caches.match(event.request).then((r) => r || caches.match('./index.html')))
  );
});
