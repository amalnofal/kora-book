-- Extensions
create extension if not exists btree_gist;

-- 1) profiles (id = auth.users.id)
create table public.profiles (
  id uuid primary key references auth.users(id) on delete restrict,
  role text not null check (role in ('customer', 'venue')),
  name text,
  phone text,
  avatar_url text,
  locale text not null default 'ar' check (locale in ('ar', 'en')),
  created_at timestamptz not null default now(),
  constraint customer_name_required
    check (role <> 'customer' or (name is not null and length(trim(name)) > 0))
);

-- 2) venues (one venue per venue account)
create table public.venues (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null unique references public.profiles(id) on delete restrict,
  name text,
  phone text,
  area text,
  address text,
  description text,
  latitude double precision,
  longitude double precision,
  cover_url text,
  opening_time time,
  closing_time time,
  is_active boolean not null default false,
  setup_completed_at timestamptz,
  category text not null default 'football',
  created_at timestamptz not null default now()
);

-- 3) pitches
create table public.pitches (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues(id) on delete restrict,
  name text not null,
  size text,
  description text,
  price numeric(10,2) not null check (price >= 0),
  duration_minutes int not null check (duration_minutes in (60, 90)),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (id, venue_id)
);

-- 4) bookings
create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id) on delete restrict,
  venue_id uuid not null references public.venues(id) on delete restrict,
  pitch_id uuid not null,
  start_time timestamptz not null,
  end_time timestamptz not null,
  price numeric(10,2) not null check (price >= 0),
  status text not null default 'confirmed'
    check (status in ('confirmed', 'cancelled')),
  cancelled_by text check (cancelled_by in ('customer', 'venue')),
  cancelled_at timestamptz,
  reconfirmed_at timestamptz,
  attendance text check (attendance in ('attended', 'no_show')),
  reminder_sent_at timestamptz,
  created_at timestamptz not null default now(),
  constraint bookings_time_order check (end_time > start_time),
  constraint bookings_pitch_venue_fk
    foreign key (pitch_id, venue_id)
    references public.pitches (id, venue_id) on delete restrict,
  constraint bookings_no_overlap
    exclude using gist (
      pitch_id with =,
      tstzrange(start_time, end_time) with &&
    ) where (status = 'confirmed')
);

-- 5) venue_blocks
create table public.venue_blocks (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues(id) on delete restrict,
  customer_id uuid not null references public.profiles(id) on delete restrict,
  reason text,
  created_at timestamptz not null default now(),
  unique (venue_id, customer_id)
);

-- 6) notifications
create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete restrict,
  type text not null,
  booking_id uuid references public.bookings(id) on delete restrict,
  data jsonb not null default '{}'::jsonb,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

-- 7) device_tokens
create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete restrict,
  token text not null unique,
  platform text not null,
  updated_at timestamptz not null default now()
);

-- Indexes
create index on public.pitches (venue_id);
create index on public.bookings (venue_id, start_time);
create index on public.bookings (customer_id, start_time);
create index on public.venue_blocks (customer_id);
create index on public.notifications (user_id, created_at desc);
create index on public.device_tokens (user_id);

-- RLS enabled on every table (policies come in the next migration).
-- Until then, no client access is possible.
alter table public.profiles       enable row level security;
alter table public.venues         enable row level security;
alter table public.pitches        enable row level security;
alter table public.bookings       enable row level security;
alter table public.venue_blocks   enable row level security;
alter table public.notifications  enable row level security;
alter table public.device_tokens  enable row level security;