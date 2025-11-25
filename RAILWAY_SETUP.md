# Railway Deployment - Step by Step Guide

## Fixed Issues ✅

1. ✅ Added `esbuild` to package.json
2. ✅ Fixed Dockerfile to use npm instead of yarn
3. ✅ Created railway.json configuration

## Before You Start

Make sure you have:
- GitHub account with code pushed
- Railway account (free - sign up at railway.app)

---

## Step 1: Push Latest Changes to GitHub

```bash
# Add all files
git add .

# Commit with message
git commit -m "Add esbuild and fix deployment configuration"

# Push to GitHub
git push origin main
```

---

## Step 2: Create Railway Project

### Option A: Using Railway Dashboard (Easiest)

1. **Go to**: https://railway.app/new
2. **Login** with GitHub
3. Click **"Deploy from GitHub repo"**
4. **Authorize Railway** to access your GitHub repos
5. **Select**: your `railspower` repository
6. Click **"Deploy Now"**

### Option B: Using Railway Template

1. Go to: https://railway.app
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository

---

## Step 3: Add PostgreSQL Database

### In Railway Dashboard:

**Method 1 - From Project Dashboard:**
1. In your project, click **"+ New"** (top right)
2. Select **"Database"**
3. Choose **"Add PostgreSQL"**
4. Done! Railway auto-creates `DATABASE_URL`

**Method 2 - Right Panel:**
1. Look for **"Add Service"** button
2. Click it
3. Select **"Database"**
4. Choose **"PostgreSQL"**

**Can't find it?** Try this:
- Your project view should show your app service
- Click the **"+"** icon or **"New"** button
- If you see "Add a service", click that
- Then "Database" → "PostgreSQL"

---

## Step 4: Configure Environment Variables

1. Click on your **web service** (the one with your code, not database)
2. Go to **"Variables"** tab
3. Click **"+ New Variable"**
4. Add:

```
Variable Name: RAILS_MASTER_KEY
Value: <paste your master key from below>
```

**Get your master key:**
```bash
cat config/master.key
```

Copy the entire string and paste it as the value.

---

## Step 5: Wait for Deployment

Railway will automatically:
1. ✅ Build your Docker image
2. ✅ Install Ruby gems
3. ✅ Install npm packages (including esbuild now!)
4. ✅ Precompile assets
5. ✅ Start your app

**Watch the logs:**
- Click on your deployment
- View **"Build Logs"** and **"Deploy Logs"**
- Should complete in 3-5 minutes

---

## Step 6: Run Database Migrations

After first successful deployment:

1. Click your service
2. Click **"Settings"** tab
3. Scroll to **"Custom Start Command"** or **"Variables"** section
4. Look for **"..."** menu or **"Add Variable"**
5. Or use **"Run Command"** feature

**Run this command:**
```bash
rails db:migrate
```

**Then run (optional - creates sample data):**
```bash
rails db:seed
```

---

## Step 7: Generate Public URL

1. Click your web service
2. Go to **"Settings"**
3. Scroll to **"Networking"**
4. Click **"Generate Domain"**
5. Copy your URL: `https://railspower-production.up.railway.app`

---

## Step 8: Test Your App!

1. Open the generated URL
2. Sign up for an account
3. Create a post
4. Upload an image
5. Done! 🎉

---

## Troubleshooting

### "Add Database" Not Showing?

**Try this:**
1. Click **"+ New"** in top right of project
2. Or click your project name → **"+ Add Service"**
3. Should see options: Database, Empty Service, GitHub Repo

**Still can't find it?**
- Make sure you're in the PROJECT view (not service view)
- Project should show all your services
- Look for a **"+"** button or **"New"** button

### Alternative: Use Railway CLI

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to project
railway link

# Add PostgreSQL
railway add
# Select "PostgreSQL"
```

### Build Still Failing?

**Check logs for:**
- "esbuild: not found" - Fixed! Just push the new package.json
- "DATABASE_URL not set" - Add PostgreSQL database
- "RAILS_MASTER_KEY" - Add environment variable

### Database Migration Errors?

**Run manually:**
```bash
# In Railway dashboard
# Settings → ... → Run Command
rails db:create db:migrate db:seed
```

### Images Not Uploading?

Railway uses ephemeral storage. For production:

**Option 1: AWS S3 (Recommended)**
Add to Railway variables:
```
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket
```

**Option 2: Cloudinary (Easier)**
```
CLOUDINARY_URL=cloudinary://xxx:xxx@xxx
```

---

## Cost Breakdown

**Free Tier:**
- $5 credit per month
- Good for testing/small apps
- Enough for this project if low traffic

**Paid (Hobby):**
- Pay for what you use
- ~$5-10/month for small app
- Scales automatically

---

## After Deployment

### Create Admin User

If you didn't run `db:seed`:

**In Railway Dashboard:**
1. Settings → ... → Run Command
2. Enter: `rails console`
3. Run:
```ruby
User.create!(
  email: "your@email.com",
  password: "secure_password",
  username: "admin",
  role: :admin
)
exit
```

### Monitor Your App

**Railway Dashboard:**
- **Metrics**: CPU, Memory, Network usage
- **Logs**: Real-time application logs
- **Deployments**: History of all deployments

---

## Quick Reference

### Useful Railway Commands

```bash
# View logs
railway logs

# Run rails console
railway run rails console

# Run migrations
railway run rails db:migrate

# Check status
railway status
```

### Environment Variables Needed

**Required:**
```
RAILS_MASTER_KEY=<from config/master.key>
DATABASE_URL=<auto-set by Railway>
```

**Optional (S3):**
```
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_REGION=us-east-1
AWS_BUCKET=your-bucket
```

---

## Success Checklist

- [ ] Code pushed to GitHub
- [ ] Railway project created
- [ ] PostgreSQL database added
- [ ] `RAILS_MASTER_KEY` environment variable set
- [ ] Build completed successfully
- [ ] Database migrated
- [ ] Public URL generated
- [ ] Can sign up and login
- [ ] Can create posts
- [ ] Can upload images

---

## Need Help?

**Railway Discord**: https://discord.gg/railway
**Railway Docs**: https://docs.railway.app

**Common fixes:**
1. Delete and recreate project if stuck
2. Check all environment variables are set
3. Ensure PostgreSQL service is running
4. View logs for specific error messages

---

## Next Steps After Deployment

1. **Add Custom Domain** (Settings → Networking)
2. **Set up S3** for file storage
3. **Configure Email** (for password resets)
4. **Enable SSL** (automatic with Railway domains)
5. **Monitor Performance** (Railway metrics dashboard)

---

Your app should now be live! 🚀

URL format: `https://your-app-name-production.up.railway.app`
