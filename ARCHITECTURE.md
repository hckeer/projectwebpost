# ContentHub - Complete Architecture & Deployment Guide

## Table of Contents
1. [System Overview](#system-overview)
2. [Authentication System](#authentication-system)
3. [Data Storage](#data-storage)
4. [Media Storage](#media-storage)
5. [Application Architecture](#application-architecture)
6. [Deployment Options](#deployment-options)

---

## System Overview

ContentHub is a modern content management platform built with **Ruby on Rails 8.0.4**, using:
- **Backend Framework**: Ruby on Rails 8
- **Frontend**: Hotwire (Turbo & Stimulus), Tailwind CSS 4
- **Database**: SQLite 3 (development), can be switched to PostgreSQL for production
- **File Storage**: Active Storage (local disk, can use S3/Cloud Storage)
- **Authentication**: Devise gem
- **Authorization**: Pundit gem
- **Rich Text**: Action Text (Trix editor)
- **Pagination**: Pagy gem

---

## Authentication System

### How It Works

#### 1. **Signup Flow**
```
User fills form → Devise validates → Creates user record → Sends to homepage
Location: app/views/devise/registrations/new.html.erb
```

**Process:**
1. User visits `/users/sign_up`
2. Fills username, email, password, password_confirmation
3. Devise validates:
   - Email format and uniqueness
   - Username (3+ chars, letters/numbers/underscores only)
   - Password (6+ characters minimum)
4. Password is encrypted using `bcrypt` (stored as `encrypted_password`)
5. User record saved to `users` table in database
6. User automatically logged in
7. Redirected to homepage

**Database Table: `users`**
- `id` - Primary key
- `email` - Unique email address
- `encrypted_password` - Bcrypt hashed password
- `username` - Unique username
- `bio` - User biography
- `role` - Integer (0=member, 1=admin)
- `reset_password_token` - For password reset
- `remember_created_at` - For "remember me" feature

#### 2. **Login Flow**
```
User enters credentials → Devise authenticates → Session created → Redirected
Location: app/views/devise/sessions/new.html.erb
```

**Process:**
1. User visits `/users/sign_in`
2. Enters email and password
3. Devise compares encrypted password using bcrypt
4. If valid:
   - Creates session in `sessions` table (Rails session store)
   - Sets encrypted cookie in browser
   - User logged in
5. If invalid: Shows error message

**Session Storage:**
- Cookie-based sessions (encrypted)
- Session data stored in browser cookie
- Expires when browser closes (unless "Remember me" checked)

#### 3. **Password Reset**
```
Request reset → Email sent → Click link → Set new password
```

**Process:**
1. User clicks "Forgot password"
2. Enters email
3. Devise generates unique `reset_password_token`
4. Email sent with reset link (would need email config)
5. User clicks link, enters new password
6. Password updated in database

#### 4. **Authorization (Pundit)**
```ruby
# app/policies/post_policy.rb
class PostPolicy < ApplicationPolicy
  def update?
    user.admin? || record.user == user
  end
end
```

**Access Control:**
- Each controller checks permissions using Pundit
- Policies define who can do what
- Examples:
  - Only post owner or admin can edit/delete posts
  - Only admins can access admin dashboard
  - Public can view published posts

---

## Data Storage

### Database: SQLite 3

**Development Environment:**
- File: `storage/development.sqlite3`
- Location: Local file system
- Accessible via Rails console: `rails console`

**Production Environment:**
- Multiple databases for different purposes:
  - `storage/production.sqlite3` - Main data (users, posts, etc.)
  - `storage/production_cache.sqlite3` - Cache data
  - `storage/production_queue.sqlite3` - Background jobs
  - `storage/production_cable.sqlite3` - WebSocket connections

### Database Tables

#### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  encrypted_password VARCHAR NOT NULL,
  username VARCHAR UNIQUE,
  bio TEXT,
  role INTEGER DEFAULT 0,
  created_at DATETIME,
  updated_at DATETIME
)
```

#### Posts Table
```sql
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title VARCHAR,
  slug VARCHAR UNIQUE,
  excerpt TEXT,
  status INTEGER (0=draft, 1=published, 2=archived),
  featured BOOLEAN,
  views_count INTEGER,
  user_id INTEGER REFERENCES users(id),
  category_id INTEGER REFERENCES categories(id),
  created_at DATETIME,
  updated_at DATETIME
)
```

#### Categories Table
```sql
CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name VARCHAR,
  slug VARCHAR,
  description TEXT,
  color VARCHAR,
  icon VARCHAR
)
```

#### Tags & Post_Tags (Many-to-Many)
```sql
CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  name VARCHAR,
  slug VARCHAR,
  color VARCHAR
)

CREATE TABLE post_tags (
  post_id INTEGER REFERENCES posts(id),
  tag_id INTEGER REFERENCES tags(id)
)
```

### How Data Flows

**Creating a Post:**
```
1. User fills form → 2. Controller validates → 3. Saves to database → 4. Redirects
```

```ruby
# app/controllers/posts_controller.rb
def create
  @post = current_user.posts.build(post_params)
  if @post.save
    # Saves to posts table
    # Creates post_tags associations
    # Attaches images to Active Storage
    redirect_to @post
  end
end
```

**Data Relationships:**
- User `has_many` Posts
- Post `belongs_to` User
- Post `belongs_to` Category
- Post `has_many` Tags (through post_tags)
- Post `has_rich_text` Content (Action Text)
- Post `has_many_attached` Images (Active Storage)

---

## Media Storage

### Active Storage System

**How It Works:**

1. **Upload Flow:**
```
User selects file → JavaScript previews → Form submits → Rails processes → Saves to disk
```

2. **Storage Structure:**
```
storage/
├── development/          # Development files
│   ├── xx/              # First 2 chars of key
│   │   └── yy/          # Next 2 chars of key
│   │       └── xxyyzz... # Actual file
```

3. **Database Tables:**

**active_storage_blobs** - File metadata
```sql
CREATE TABLE active_storage_blobs (
  id INTEGER PRIMARY KEY,
  key VARCHAR UNIQUE,           -- Random key (e.g., "abc123...")
  filename VARCHAR,              -- Original filename
  content_type VARCHAR,          -- MIME type (image/png)
  byte_size INTEGER,             -- File size in bytes
  checksum VARCHAR,              -- MD5 checksum
  metadata TEXT,                 -- JSON metadata
  service_name VARCHAR,          -- 'local', 's3', etc.
  created_at DATETIME
)
```

**active_storage_attachments** - Links files to records
```sql
CREATE TABLE active_storage_attachments (
  id INTEGER PRIMARY KEY,
  name VARCHAR,                  -- 'images', 'avatar', etc.
  record_type VARCHAR,           -- 'Post', 'User', etc.
  record_id INTEGER,             -- ID of the post/user
  blob_id INTEGER REFERENCES active_storage_blobs(id)
)
```

4. **Serving Files:**
```
Browser requests → Rails controller → Redirects to signed URL → File served
URL format: /rails/active_storage/blobs/:signed_id/:filename
```

**Example:**
```ruby
# In view
<%= image_tag post.images.first %>

# Generates URL like:
/rails/active_storage/blobs/eyJfcmFpbHMi.../photo.jpg
```

5. **Image Processing:**
- Currently disabled (serving original images)
- Can enable with image_processing gem + vips/imagemagick
- Would create variants (thumbnails, resized versions)

---

## Application Architecture

### MVC Pattern

```
┌─────────────┐      ┌──────────────┐      ┌────────────┐
│   Browser   │ ───> │  Controller  │ ───> │   Model    │
│             │      │              │      │            │
│  (View)     │ <─── │  (Logic)     │ <─── │ (Database) │
└─────────────┘      └──────────────┘      └────────────┘
```

**Example: Viewing a Post**

1. **Route** (`config/routes.rb`)
```ruby
resources :posts  # Creates /posts/:id route
```

2. **Controller** (`app/controllers/posts_controller.rb`)
```ruby
def show
  @post = Post.find_by!(slug: params[:id])
  @post.increment_views!  # Updates views_count
end
```

3. **Model** (`app/models/post.rb`)
```ruby
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many_attached :images

  validates :title, presence: true

  def reading_time
    words = content.to_s.split.size
    (words / 200.0).ceil
  end
end
```

4. **View** (`app/views/posts/show.html.erb`)
```erb
<h1><%= @post.title %></h1>
<%= @post.content %>
```

### Key Components

**Controllers:**
- `PostsController` - Manage posts (CRUD)
- `DashboardController` - User dashboard
- `Admin::*Controller` - Admin panel
- `HomeController` - Homepage
- `Devise::*Controller` - Authentication

**Models:**
- `User` - User accounts
- `Post` - Blog posts
- `Category` - Post categories
- `Tag` - Post tags
- `PostTag` - Join table

**Services/Concerns:**
- `Pundit::Authorization` - Permission checks
- `Pagy::Method` - Pagination
- Action Text - Rich text editing
- Active Storage - File uploads

### Request Lifecycle

```
1. Browser sends request
   ↓
2. Rails Router matches URL to controller/action
   ↓
3. Before filters run (authentication, authorization)
   ↓
4. Controller action executes
   ↓
5. Model queries database
   ↓
6. View renders HTML
   ↓
7. Response sent to browser
```

---

## Deployment Options

### Option 1: Heroku (Easiest)

**Prerequisites:**
- Heroku account (free tier available)
- Heroku CLI installed

**Steps:**

1. **Prepare Database**
```bash
# Add PostgreSQL for production
bundle add pg
```

Update `config/database.yml`:
```yaml
production:
  adapter: postgresql
  url: <%= ENV['DATABASE_URL'] %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
```

2. **Initialize Heroku**
```bash
heroku login
heroku create your-app-name
```

3. **Configure Environment**
```bash
heroku config:set RAILS_MASTER_KEY=`cat config/master.key`
```

4. **Deploy**
```bash
git add .
git commit -m "Ready for Heroku"
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed  # If you have seed data
```

5. **Open App**
```bash
heroku open
```

**File Storage on Heroku:**
- Use Amazon S3 or Cloudinary
- Update `config/storage.yml`:
```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: us-east-1
  bucket: your-bucket-name
```

Update `config/environments/production.rb`:
```ruby
config.active_storage.service = :amazon
```

### Option 2: Railway.app (Easy)

1. **Sign up at railway.app**
2. **New Project → Deploy from GitHub**
3. **Connect repository**
4. **Add PostgreSQL database** (automatic)
5. **Set environment variables:**
   - `RAILS_MASTER_KEY`
6. **Deploy automatically on git push**

**Benefits:**
- Free tier
- Automatic deployments
- Built-in PostgreSQL
- Simple setup

### Option 3: DigitalOcean/AWS (Traditional VPS)

**Using Kamal (included in your app):**

1. **Server Setup**
```bash
# Create droplet/EC2 instance
# Install Docker on server
```

2. **Configure Kamal**
Edit `.kamal/hooks/docker-setup`:
```yaml
service: railspower
image: your-username/railspower
servers:
  - 192.168.1.1  # Your server IP
registry:
  username: your-docker-username
  password:
    - DOCKER_PASSWORD
env:
  secret:
    - RAILS_MASTER_KEY
```

3. **Deploy**
```bash
kamal setup       # First time setup
kamal deploy      # Deploy
```

### Option 4: Render.com (Easy, Free Tier)

1. **Sign up at render.com**
2. **New → Web Service**
3. **Connect GitHub repo**
4. **Settings:**
   - Build Command: `bundle install && rails db:migrate`
   - Start Command: `bundle exec rails server`
5. **Add PostgreSQL database**
6. **Environment variables:**
   - `RAILS_MASTER_KEY`
   - `DATABASE_URL` (auto-set)

### Option 5: Fly.io (Modern)

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Launch app
fly launch

# Deploy
fly deploy
```

---

## Production Checklist

### 1. Environment Variables

Create/update `config/credentials.yml.enc`:
```bash
EDITOR="nano" rails credentials:edit
```

Add:
```yaml
secret_key_base: your-secret-key
aws:
  access_key_id: xxx
  secret_access_key: xxx
smtp:
  username: your-email
  password: your-password
```

### 2. Database

**For PostgreSQL:**
```bash
# Add gem
bundle add pg

# Update database.yml
production:
  adapter: postgresql
  url: <%= ENV['DATABASE_URL'] %>
```

**Migrate:**
```bash
rails db:migrate RAILS_ENV=production
```

### 3. Assets

**Precompile:**
```bash
rails assets:precompile
```

**CSS Build:**
```bash
npm run build:css
```

### 4. Email Configuration

Update `config/environments/production.rb`:
```ruby
config.action_mailer.default_url_options = { host: 'yourdomain.com' }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

### 5. File Storage (S3)

**Add AWS gem:**
```bash
bundle add aws-sdk-s3
```

**Configure:**
```yaml
# config/storage.yml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_SECRET_ACCESS_KEY'] %>
  region: us-east-1
  bucket: your-bucket
```

```ruby
# config/environments/production.rb
config.active_storage.service = :amazon
```

### 6. Security

```ruby
# config/environments/production.rb
config.force_ssl = true  # Require HTTPS
config.assume_ssl = true
```

---

## Quick Deploy Summary

### Fastest Way (Render.com - Free):

1. Push code to GitHub
2. Sign up at render.com
3. New Web Service → Connect repo
4. Add PostgreSQL database
5. Set `RAILS_MASTER_KEY` env var
6. Deploy!

**Your app will be live at:** `https://your-app.onrender.com`

### Recommended for Production (Railway):

1. Push to GitHub
2. Sign up at railway.app
3. New Project → Deploy from GitHub
4. Add PostgreSQL
5. Add S3 for file storage
6. Set environment variables
7. Deploy

**Custom domain:** Add your domain in settings

---

## Testing Locally Before Deploy

```bash
# Build CSS
npm run build:css

# Precompile assets
rails assets:precompile

# Test production mode locally
RAILS_ENV=production rails db:create db:migrate
RAILS_ENV=production rails server

# Visit http://localhost:3000
```

---

## Monitoring & Maintenance

**Check logs:**
```bash
# Heroku
heroku logs --tail

# Railway
railway logs

# Fly.io
fly logs
```

**Database console:**
```bash
# Heroku
heroku run rails console

# Railway
railway run rails console
```

**Database backup:**
```bash
# Heroku
heroku pg:backups:capture
heroku pg:backups:download
```

---

## Summary

**Your app uses:**
- ✅ SQLite locally (switch to PostgreSQL for production)
- ✅ Local disk for files (switch to S3 for production)
- ✅ Devise for authentication (encrypted passwords)
- ✅ Active Storage for media (organized file system)
- ✅ Action Text for rich content
- ✅ Pundit for permissions

**To deploy:**
1. Choose platform (Render/Railway recommended)
2. Add PostgreSQL database
3. Set environment variables
4. Push code
5. Run migrations
6. Done!

**Cost:**
- Free tier: Render, Railway, Heroku (limited)
- Production: ~$7-15/month for small app

Need help with specific deployment? Let me know which platform you want to use!
