// Deploy: supabase functions deploy notify-alumni
// Secrets: VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY, RESEND_API_KEY (optional), RESEND_FROM (optional)

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import webpush from "npm:web-push@3.6.7";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

type NotifyBody = {
  action?: string;
  recipient_email?: string;
  batch_name?: string;
  exclude_email?: string;
  event_id?: number | string;
  title?: string;
  body?: string;
  url?: string;
  subject?: string;
  html?: string;
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ error: "Unauthorized" }, 401);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { persistSession: false } }
    );

    const token = authHeader.replace("Bearer ", "");
    const { data: userData, error: userErr } = await supabase.auth.getUser(token);
    if (userErr || !userData?.user?.email) {
      return json({ error: "Invalid session" }, 401);
    }

    const payload: NotifyBody = await req.json();
    const action = payload.action || "push";

    const vapidPublic = Deno.env.get("VAPID_PUBLIC_KEY") ?? "";
    const vapidPrivate = Deno.env.get("VAPID_PRIVATE_KEY") ?? "";
    const resendKey = Deno.env.get("RESEND_API_KEY") ?? "";
    const resendFrom = Deno.env.get("RESEND_FROM") ?? "MSU-UTC Connect <onboarding@resend.dev>";

    let pushSent = 0;
    let emailSent = 0;

    if ((action === "push" || action === "dm" || action === "batch_chat") && vapidPublic && vapidPrivate) {
      webpush.setVapidDetails("mailto:msuutc.alumni@gmail.com", vapidPublic, vapidPrivate);

      let emails: string[] = [];
      if (action === "dm" && payload.recipient_email) {
        emails = [payload.recipient_email.toLowerCase()];
      } else if (action === "batch_chat" && payload.batch_name) {
        const { data: profiles } = await supabase
          .from("alumni_profiles")
          .select("email, batch_name")
          .not("email", "is", null);
        const batch = payload.batch_name.trim().toLowerCase();
        const exclude = (payload.exclude_email || "").toLowerCase();
        emails = (profiles || [])
          .filter((p) => {
            const b = (p.batch_name || "").trim().toLowerCase();
            const match =
              b === batch ||
              (batch === "2013 eminent" && b === "2013 emminent") ||
              (batch === "2013 emminent" && b === "2013 eminent");
            return match && (p.email || "").toLowerCase() !== exclude;
          })
          .map((p) => (p.email as string).toLowerCase());
      } else if (payload.recipient_email) {
        emails = [payload.recipient_email.toLowerCase()];
      }

      emails = [...new Set(emails)];
      if (emails.length) {
        const { data: subs } = await supabase
          .from("push_subscriptions")
          .select("endpoint, p256dh, auth_key, user_email")
          .in("user_email", emails);

        const title = payload.title || "MSU-UTC Connect";
        const body = payload.body || "You have a new notification";
        const url = payload.url || "https://utc.marawionline.com";

        for (const sub of subs || []) {
          try {
            await webpush.sendNotification(
              {
                endpoint: sub.endpoint,
                keys: { p256dh: sub.p256dh, auth: sub.auth_key },
              },
              JSON.stringify({ title, body, url })
            );
            pushSent += 1;
          } catch {
            /* expired subscription — ignore */
          }
        }
      }
    }

    if ((action === "email" || action === "dm" || action === "event_reminder") && resendKey) {
      let targets: { email: string; name?: string }[] = [];

      if (action === "dm" && payload.recipient_email) {
        const { data: prof } = await supabase
          .from("alumni_profiles")
          .select("email, name, email_notify")
          .eq("email", payload.recipient_email)
          .maybeSingle();
        if (prof?.email && prof.email_notify !== false) {
          targets = [{ email: prof.email, name: prof.name }];
        }
      } else if (action === "event_reminder" && payload.event_id) {
        const eventId = Number(payload.event_id);
        const { data: rsvps } = await supabase
          .from("event_rsvps")
          .select("user_email")
          .eq("event_id", eventId)
          .eq("response", "yes");
        const rsvpEmails = [...new Set((rsvps || []).map((r) => (r.user_email as string).toLowerCase()))];
        if (rsvpEmails.length) {
          const { data: profiles } = await supabase
            .from("alumni_profiles")
            .select("email, name, email_notify")
            .in("email", rsvpEmails);
          targets = (profiles || [])
            .filter((p) => p.email && p.email_notify !== false)
            .map((p) => ({ email: p.email as string, name: p.name as string }));
        }
      } else if (payload.recipient_email) {
        targets = [{ email: payload.recipient_email }];
      }

      const subject = payload.subject || payload.title || "MSU-UTC Connect";
      const html =
        payload.html ||
        `<p>${payload.body || "Hello from MSU-UTC Connect."}</p><p><a href="https://utc.marawionline.com">Open the app</a></p>`;

      for (const t of targets) {
        const res = await fetch("https://api.resend.com/emails", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${resendKey}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            from: resendFrom,
            to: [t.email],
            subject,
            html,
          }),
        });
        if (res.ok) emailSent += 1;
      }
    }

    return json({ ok: true, pushSent, emailSent });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
