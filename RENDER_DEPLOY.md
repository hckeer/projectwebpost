# Render Deployment Guide

## What Was Fixed ✅

The `database.yml` was missing the `queue` and `cache` database configurations needed by Solid Queue and Solid Cache. Now it's properly configured to use a single PostgreSQL database for all connections.

---

## Prerequisites

1. **Render Account**: Sign up at https://render.com
2. **GitHub**: Code pushed to GitHub
3. **PostgreSQL on Railway**: You mentioned PostgreSQL is on Railway

---

## Option 1: PostgreSQL on Railway (Current Setup)

### Step 1: Get Railway Database URL

1. Go to Railway dashboard
2. Click your PostgreSQL service
3. Go to **Variables** tab
4. Copy the `DATABASE_URL` value (starts with `postgresql://`)

### Step 2: Deploy to Render

1. Go to https://dashboard.render.com
2. Click **New +** → **Web Service**
3. Connect your GitHub repository
4. Configure:

```
Name: railspower
Environment: Ruby
Build Command: bundle install && npm ci && npm run build:css && rails assets:precompile
Start Command: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production}
```

### Step 3: Add Environment Variables

In Render dashboard → **Environment** tab, add:

```
RAILS_MASTER_KEY=<from config/master.key>
DATABASE_URL=<copied from Railway PostgreSQL>
RAILS_ENV=production
RACK_ENV=production
```

Get your master key:
```bash
cat config/master.key
```

### Step 4: Deploy

Click **Create Web Service**. Render will build and deploy.

### Step 5: Run Migrations

After first successful deploy, go to **Shell** tab and run:

```bash
rails db:migrate db:seed
```

---

## Option 2: PostgreSQL on Render (Recommended)

Keep everything in one place!

### Step 1: Create PostgreSQL Database

1. In Render dashboard, click **New +** → **PostgreSQL**
2. Name: `railspower-db`
3. Database: `railspower`
4. User: `railspower`
5. Plan: **Free** (good for testing)
6. Click **Create Database**

### Step 2: Deploy Web Service

1. Click **New +** → **Web Service**
2. Connect your GitHub repository
3. Configure:

```
Name: railspower
Environment: Ruby
Build Command: bundle install && npm ci && npm run build:css && rails assets:precompile && rails db:migrate
Start Command: bundle exec puma -C config/puma.rb
```

### Step 3: Link Database

In **Environment** tab:

1. Click **Add Environment Variable**
2. Render will suggest linking your PostgreSQL database
3. Click **Link** next to your database
4. This automatically sets `DATABASE_URL`

Also add:
```
RAILS_MASTER_KEY=<from config/master.key>
RAILS_ENV=production
RACK_ENV=production
```

### Step 4: Deploy & Seed

After deployment succeeds, run in Shell:

```bash
rails db:seed
```

---

## Current Status Check

Based on your error, you need to:

1. **Push the fixed code:**
   ```bash
   git push origin main
   ```

2. **Redeploy on Render** (triggers automatically or click **Manual Deploy**)

3. **Verify DATABASE_URL is set** in Render Environment variables

---

## Expected Results

After deploying with the fixed `database.yml`:

✅ Build will succeed
✅ Solid Queue will connect to database
✅ Solid Cache will connect to database
✅ App will start successfully
✅ Healthcheck will pass

---

## Troubleshooting

### "ActiveRecord::AdapterNotSpecified: The queue database..."

**Solution:** You're seeing this! Push the fixed code and redeploy.

### "Could not connect to database"

**Solution:** Verify `DATABASE_URL` is set in Render Environment variables.

### "PG::ConnectionBad"

**Solution:** Check that DATABASE_URL format is correct:
```
postgresql://user:password@host:port/database
```

### "Migrations pending"

**Solution:** Run in Render Shell:
```bash
rails db:migrate
```

### Images not uploading

**Note:** Render has ephemeral storage. For production, set up S3:

1. Create AWS S3 bucket
2. Add to Render Environment:
   ```
   AWS_ACCESS_KEY_ID=xxx
   AWS_SECRET_ACCESS_KEY=xxx
   AWS_REGION=us-east-1
   AWS_BUCKET=your-bucket
   ```
3. Update `config/environments/production.rb`:
   ```ruby
   config.active_storage.service = :amazon
   ```
4. Add gem: `bundle add aws-sdk-s3`

---

## After Successful Deployment

1. **Get your URL**: `https://railspower.onrender.com`
2. **Create admin user** in Render Shell:
   ```ruby
   rails console
   User.create!(
     email: "admin@example.com",
     password: "password123",
     username: "admin",
     role: :admin
   )
   ```
3. **Test the app**: Sign up and create a post!

---

## Cost

**Render Free Tier:**
- Web Service: Free (spins down after inactivity)
- PostgreSQL: Free (90 days, then $7/month)

**Paid Plans:**
- Starter: $7/month for web service (always on)
- PostgreSQL: $7/month (persistent)

---

## Next Steps

1. **Push the fix**: `git push origin main`
2. **Wait for Render to redeploy** (automatic)
3. **Check deployment logs** for success
4. **Run migrations**: `rails db:migrate db:seed`
5. **Visit your app URL**

Your deployment should work now! 🚀
