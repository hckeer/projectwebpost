# Quick Deployment Guide - Railway

## Prerequisites
- GitHub account
- Railway account (sign up at railway.app)
- Code pushed to GitHub

## Step-by-Step Deployment

### 1. Prepare Code for Deployment

All changes are ready! Just commit:

```bash
git add .
git commit -m "Prepare for production deployment"
git push origin main
```

### 2. Deploy to Railway

1. **Go to**: https://railway.app
2. **Sign up/Login** (use GitHub)
3. **New Project** → **Deploy from GitHub repo**
4. **Select repository**: `railspower`
5. **Add Database**:
   - Click "New" → "Database" → "PostgreSQL"
   - Railway automatically sets `DATABASE_URL`

### 3. Configure Environment Variables

Click on your service → **Variables** tab → Add:

```
RAILS_MASTER_KEY=<copy from config/master.key>
```

Get your master key:
```bash
cat config/master.key
```

### 4. Configure Build (if needed)

Railway auto-detects Rails, but if needed, add in **Settings**:

- **Build Command**: `bundle install && npm ci && npm run build:css && rails assets:precompile`
- **Start Command**: `rails server -b 0.0.0.0 -p $PORT`

### 5. Deploy

Railway automatically deploys! Watch the build logs.

First deployment runs:
1. Install dependencies
2. Precompile assets
3. Run database migrations (automatic)
4. Start server

### 6. Run Database Seeds (Optional)

In Railway **Settings** → Click **...** → **Run a Command**:
```bash
rails db:seed
```

This creates sample categories, tags, and admin user.

### 7. Get Your URL

Railway provides a URL like: `https://railspower-production.up.railway.app`

Click **Settings** → **Networking** → **Generate Domain**

### 8. Add Custom Domain (Optional)

**Settings** → **Networking** → **Custom Domain**

Add your domain and update DNS:
```
CNAME → yourapp.up.railway.app
```

---

## After Deployment

### Create Admin User

If you didn't run seeds, create admin manually:

```bash
# In Railway: Settings → ... → Run a Command
rails console
```

Then:
```ruby
User.create!(
  email: "admin@example.com",
  password: "password123",
  username: "admin",
  role: :admin
)
```

### Test Your App

1. Visit your Railway URL
2. Sign up for an account
3. Create a post
4. Upload images
5. Browse posts

---

## Common Issues

### Images Not Uploading

**Problem**: SQLite doesn't handle concurrent uploads well

**Solution**: Railway includes PostgreSQL (already set up!)

### Styles Not Loading

**Problem**: Assets not precompiled

**Fix**: Railway runs `rails assets:precompile` automatically

### 500 Error

**Check logs** in Railway dashboard:
- Click on deployment
- View build/runtime logs

Common fixes:
- Verify `RAILS_MASTER_KEY` is correct
- Check database migrations ran
- Ensure PostgreSQL is connected

---

## File Storage in Production

Currently using **local disk** (files stored in Railway container).

⚠️ **Warning**: Railway containers are ephemeral - uploaded files disappear on redeploy!

### Solution: Use S3 (Recommended)

1. **Create AWS S3 bucket**
2. **Add credentials to Railway**:
```
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket-name
```

3. **Update** `config/environments/production.rb`:
```ruby
config.active_storage.service = :amazon
```

4. **Add gem**:
```bash
bundle add aws-sdk-s3
git commit -am "Add S3 support"
git push
```

**Alternative**: Use Cloudinary (easier, has free tier)

---

## Cost

**Railway Free Tier:**
- $5 credit per month
- Enough for small apps

**Paid Plan:**
- ~$5-10/month for hobby projects
- Pay only for what you use

---

## Quick Deploy Command

From your local machine:

```bash
# Commit all changes
git add .
git commit -m "Ready for deployment"
git push origin main

# Then go to railway.app and deploy!
```

---

## Environment Variables Needed

```
RAILS_MASTER_KEY=<from config/master.key>
DATABASE_URL=<auto-set by Railway PostgreSQL>
```

**Optional (for S3):**
```
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket
```

**Optional (for emails):**
```
SMTP_USERNAME=your-email
SMTP_PASSWORD=your-password
```

---

## Done! 🎉

Your ContentHub app is now live and accessible worldwide!

**Next Steps:**
- Add custom domain
- Set up S3 for file storage
- Configure email delivery
- Monitor performance in Railway dashboard
