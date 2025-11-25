# Render Free Tier Setup (No Shell Access)

Since you're on the free tier without shell access, we'll run migrations automatically during build and startup.

## ✅ I've Created Scripts For You

Two new scripts that automate everything:

1. **`bin/render-build.sh`** - Runs during build (installs dependencies, migrations)
2. **`bin/render-start.sh`** - Runs on startup (prepares DB, seeds if empty)

---

## 🚀 Update Your Render Settings

### Step 1: Push the New Scripts

First, push the scripts to GitHub:

```bash
git push origin main
```

### Step 2: Update Render Build Command

1. Go to **Render Dashboard**: https://dashboard.render.com
2. Click your **railspower** service
3. Click **Settings** (left sidebar)
4. Scroll to **Build & Deploy** section
5. Find **Build Command**

**Change it to:**
```bash
./bin/render-build.sh
```

### Step 3: Update Render Start Command

In the same Settings page, find **Start Command**

**Change it to:**
```bash
./bin/render-start.sh
```

### Step 4: Save and Deploy

1. Click **Save Changes**
2. Render will ask if you want to redeploy
3. Click **Manual Deploy** → **Deploy latest commit**

---

## 📋 What These Scripts Do

### `render-build.sh` (runs during build):
```
✅ Install Ruby gems
✅ Install npm packages
✅ Build Tailwind CSS
✅ Precompile assets
✅ Install Solid Cache migrations
✅ Install Solid Queue migrations
✅ Run all database migrations
```

### `render-start.sh` (runs on every startup):
```
✅ Prepare database (create if needed)
✅ Run any pending migrations
✅ Seed database (only if empty)
✅ Start Puma web server
```

---

## 🎯 What Happens Next

1. **Render detects new commit** → Starts build
2. **Build script runs** → Installs everything + migrations ✅
3. **Start script runs** → Prepares DB + seeds ✅
4. **App starts** → Ready to use! 🎉

---

## ⏱️ Timeline

- **First deploy**: ~5-7 minutes (full build + migrations + seed)
- **Future deploys**: ~3-5 minutes (cached dependencies)

---

## 🔍 Monitor the Deployment

Watch the **Logs** tab in Render to see:

```
==> Building...
Running ./bin/render-build.sh
Installing gems...
Installing npm packages...
Building CSS...
Precompiling assets...
Installing migrations...
Running migrations...
Build completed successfully!

==> Deploying...
Running ./bin/render-start.sh
Database is empty. Running seeds...
Seeding complete!
Created:
  - 5 users
  - 6 categories
  - 25 tags
  - 10 posts
Puma starting...
```

---

## ✅ Verify It's Working

After deployment completes:

1. **Visit your Render URL** (e.g., `https://railspower.onrender.com`)
2. **Login** with:
   - Email: `admin@contenthub.com`
   - Password: `password123`
3. **Create a new post**
4. **Upload an image** ✅ Should work!

---

## 🐛 Troubleshooting

### Build fails with "Permission denied"

**Solution:** Scripts need to be executable (already done):
```bash
chmod +x bin/render-build.sh bin/render-start.sh
git add bin/
git commit -m "Make scripts executable"
git push
```

### "No such file or directory: ./bin/render-build.sh"

**Solution:** Make sure you pushed the files:
```bash
git status
git add bin/
git push origin main
```

### Image upload still failing

**Check logs** for the actual error. If you see:
```
ActiveRecord::StatementInvalid: PG::UndefinedTable
```

This means migrations didn't run. Check build logs for errors.

---

## 📊 Database on Render Free Tier

Render free tier includes:
- ✅ PostgreSQL database (90 days free, then $7/month)
- ✅ Automatic backups
- ✅ 256MB RAM (good for small apps)

Your database will persist between deployments! ✅

---

## ⚠️ Important: File Storage

**Render free tier has ephemeral storage:**
- Uploaded images will be **deleted on restart/redeploy**
- For persistent images, you need S3 or Cloudinary

### Quick Fix: Use Cloudinary (Free Tier)

1. **Sign up**: https://cloudinary.com (25GB free)
2. **Get URL** from dashboard
3. **Add to Render Environment**:
   ```
   CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
   ```
4. **Add gems**:
   ```bash
   bundle add cloudinary activestorage-cloudinary-service
   ```
5. **Update `config/environments/production.rb`**:
   ```ruby
   config.active_storage.service = :cloudinary
   ```
6. **Commit and push**:
   ```bash
   git add .
   git commit -m "Add Cloudinary for image storage"
   git push
   ```

---

## 📝 Summary of Commands

```bash
# 1. Push scripts to GitHub
git push origin main

# 2. Update Render Settings:
#    Build Command: ./bin/render-build.sh
#    Start Command: ./bin/render-start.sh

# 3. Deploy and wait for completion

# 4. Test your app!
```

---

## 🎉 After Setup

Your app will now:
- ✅ Automatically run migrations on every deploy
- ✅ Seed database on first run
- ✅ Handle image uploads (temporarily)
- ✅ Work on Render free tier!

---

## 💰 Upgrade Options (Optional)

If you need shell access later:

**Render Starter**: $7/month
- Shell and SSH access ✅
- Zero downtime deploys ✅
- Persistent disk ✅
- Background workers ✅

But for now, **free tier works perfectly** with these scripts! 🚀
