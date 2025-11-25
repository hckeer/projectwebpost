# Fix Image Upload Error on Render

## Problem
"We're sorry, but something went wrong" when uploading images.

## Root Cause
Database migrations haven't been run yet. Active Storage tables are missing.

---

## Solution - Run Migrations on Render

### Step 1: Open Render Shell

1. Go to https://dashboard.render.com
2. Click your **railspower** web service
3. Click the **Shell** tab (top right)
4. Wait for shell to connect

### Step 2: Run All Migrations

In the Render shell, run these commands:

```bash
# Run primary database migrations
rails db:migrate

# Install and run Solid Cache migrations
rails solid_cache:install:migrations
rails db:migrate

# Install and run Solid Queue migrations
rails solid_queue:install:migrations
rails db:migrate

# Seed the database with sample data
rails db:seed
```

**Copy and paste all at once:**
```bash
rails db:migrate && rails solid_cache:install:migrations && rails db:migrate && rails solid_queue:install:migrations && rails db:migrate && rails db:seed
```

### Step 3: Restart the Service

After migrations complete:
1. Go back to your service dashboard
2. Click **Manual Deploy** → **Clear build cache & deploy**
   OR
3. Click **Settings** → **Restart**

---

## Verify It's Working

1. Visit your Render app URL
2. Log in (use credentials from seed data):
   - Email: `admin@contenthub.com`
   - Password: `password123`
3. Click **New Post**
4. Try uploading an image
5. Should work now! ✅

---

## Check Logs (If Still Not Working)

If image upload still fails:

1. In Render dashboard, click **Logs** tab
2. Try uploading an image again
3. Watch the logs for the actual error

Common errors and solutions:

### Error: "ActiveRecord::StatementInvalid: PG::UndefinedTable: relation 'active_storage_blobs' does not exist"

**Solution:** Migrations didn't run. Run `rails db:migrate` again.

### Error: "ActiveStorage::IntegrityError"

**Solution:** File corruption. Try uploading a different image.

### Error: "Errno::EACCES: Permission denied"

**Solution:** Render filesystem issue. You may need to switch to S3 for file storage.

---

## Important: Render Ephemeral Storage

⚠️ **Render uses ephemeral storage** - uploaded files will be deleted when you:
- Redeploy the app
- Service restarts
- Service scales

### Temporary Solution
For testing, files stay as long as the service doesn't restart.

### Permanent Solution: Use S3

1. **Create AWS S3 Bucket**
2. **Add to Render Environment variables:**
   ```
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   AWS_REGION=us-east-1
   AWS_BUCKET=your-bucket-name
   ```

3. **Update `config/storage.yml`** (already configured):
   ```yaml
   amazon:
     service: S3
     access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
     secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
     region: <%= ENV['AWS_REGION'] %>
     bucket: <%= ENV['AWS_BUCKET'] %>
   ```

4. **Update `config/environments/production.rb`:**
   ```ruby
   config.active_storage.service = :amazon
   ```

5. **Add aws-sdk-s3 gem:**
   ```bash
   bundle add aws-sdk-s3
   ```

6. **Commit and push:**
   ```bash
   git add .
   git commit -m "Add S3 for production file storage"
   git push origin main
   ```

---

## Alternative: Use Cloudinary (Easier)

Cloudinary has a free tier and is easier to set up:

1. **Sign up**: https://cloudinary.com (free tier: 25GB storage)
2. **Get your URL** from dashboard (looks like `cloudinary://key:secret@cloud`)
3. **Add to Render:**
   ```
   CLOUDINARY_URL=cloudinary://...
   ```
4. **Add gem:**
   ```bash
   bundle add cloudinary activestorage-cloudinary-service
   ```
5. **Update production.rb:**
   ```ruby
   config.active_storage.service = :cloudinary
   ```

---

## Quick Checklist

- [ ] Run `rails db:migrate` in Render Shell
- [ ] Run `rails db:seed` in Render Shell
- [ ] Restart the service
- [ ] Test image upload
- [ ] If working: Consider setting up S3/Cloudinary for persistence

---

## Still Having Issues?

Check the **Render Logs** for the exact error message and share it if you need more help!

Most common issue is just missing migrations, which should be fixed now. 🎉
