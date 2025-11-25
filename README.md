# ContentHub - Modern Content Management Platform

A beautiful, production-ready Ruby on Rails content management system with a modern UI, role-based access control, and rich text editing.

![Ruby](https://img.shields.io/badge/Ruby-3.0+-red)
![Rails](https://img.shields.io/badge/Rails-8.0+-red)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

ContentHub is a full-stack content management platform that allows users to create, manage, and publish content with a stunning modern interface. It features a gradient-rich design, glassmorphism effects, dark mode support, and smooth animations.

## Features

### For Visitors
- Browse published content in a magazine-style grid layout
- Search and filter posts by category and tags
- View detailed post pages with related content
- Dark/light theme toggle
- Responsive design for all devices

### For Members
- Create posts with rich text editor (Action Text)
- Upload images and media
- Personal dashboard with statistics
- Manage own content (edit, delete, publish)
- Profile management

### For Admins
- Complete admin panel with analytics
- Manage all users (view, edit, promote/demote)
- Moderate all content (edit, delete, publish/archive)
- Category and tag management
- User role management

## Technology Stack

- **Backend**: Ruby on Rails 8.0+
- **Frontend**: Hotwire (Turbo & Stimulus)
- **Styling**: Tailwind CSS 4.0
- **Authentication**: Devise
- **Authorization**: Pundit
- **Rich Text**: Action Text with Trix Editor
- **File Storage**: Active Storage
- **Pagination**: Pagy
- **Database**: SQLite (development), PostgreSQL (production)

## Prerequisites

- Ruby 3.0+
- Node.js 18+
- Yarn
- SQLite3 (or PostgreSQL for production)

## Setup Instructions

### 1. Clone the repository

```bash
git clone <repository-url>
cd railspower
```

### 2. Install dependencies

```bash
bundle install
yarn install
```

### 3. Setup database

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. Start the development server

```bash
bin/dev
```

This starts the Rails server, CSS build, and JavaScript build concurrently.

### 5. Access the application

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Default Accounts

After running seeds, you can login with:

| Role   | Email                    | Password     |
|--------|--------------------------|--------------|
| Admin  | admin@contenthub.com     | password123  |
| Member | sarah@example.com        | password123  |
| Member | james@example.com        | password123  |
| Member | emma@example.com         | password123  |
| Member | mike@example.com         | password123  |

## Database Schema

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Users     │     │    Posts    │     │  Categories │
├─────────────┤     ├─────────────┤     ├─────────────┤
│ id          │────<│ user_id     │     │ id          │
│ email       │     │ category_id │>────│ name        │
│ username    │     │ title       │     │ slug        │
│ role        │     │ slug        │     │ description │
│ bio         │     │ excerpt     │     │ color       │
│ ...         │     │ status      │     │ icon        │
└─────────────┘     │ featured    │     └─────────────┘
                    │ views_count │
                    │ ...         │     ┌─────────────┐
                    └─────────────┘     │    Tags     │
                          │             ├─────────────┤
                          │             │ id          │
                    ┌─────────────┐     │ name        │
                    │  PostTags   │     │ slug        │
                    ├─────────────┤     │ color       │
                    │ post_id     │>────└─────────────┘
                    │ tag_id      │
                    └─────────────┘
```

## Project Structure

```
app/
├── controllers/
│   ├── admin/           # Admin namespace controllers
│   ├── application_controller.rb
│   ├── dashboard_controller.rb
│   ├── home_controller.rb
│   └── posts_controller.rb
├── javascript/
│   └── controllers/     # Stimulus controllers
├── models/
│   ├── user.rb
│   ├── post.rb
│   ├── category.rb
│   └── tag.rb
├── policies/            # Pundit authorization policies
├── views/
│   ├── admin/           # Admin panel views
│   ├── dashboard/       # Member dashboard
│   ├── home/            # Public pages
│   ├── posts/           # Post CRUD views
│   ├── shared/          # Partials (navbar, footer)
│   └── layouts/
└── assets/
    └── stylesheets/     # Tailwind CSS
```

## Environment Variables

Create a `.env` file for production:

```env
DATABASE_URL=postgresql://...
RAILS_MASTER_KEY=...
SECRET_KEY_BASE=...
```

## Deployment

### Heroku

```bash
heroku create
heroku addons:create heroku-postgresql:hobby-dev
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed
```

### Docker

```bash
docker build -t contenthub .
docker run -p 3000:3000 contenthub
```

### Render/Railway

1. Connect your Git repository
2. Set Ruby version and build commands
3. Add PostgreSQL database
4. Configure environment variables

## Design Highlights

- **Gradient Color Scheme**: Violet to Indigo gradients throughout
- **Glassmorphism**: Frosted glass effects for depth
- **Dark Mode**: Complete dark theme support
- **Typography**: Inter font for UI, Playfair Display for headers
- **Micro-interactions**: Smooth hover effects and transitions
- **Responsive**: Mobile-first design approach

## Future Improvements

- [ ] Comments system for posts
- [ ] Social media sharing
- [ ] Email notifications
- [ ] Full-text search with Elasticsearch
- [ ] Image optimization with imgproxy
- [ ] Analytics dashboard with charts
- [ ] API endpoints for mobile apps
- [ ] Webhooks for integrations
- [ ] Multiple language support (i18n)
- [ ] Two-factor authentication
- [ ] OAuth login (Google, GitHub)
- [ ] Content scheduling
- [ ] SEO meta tag management
- [ ] RSS feed generation
- [ ] Export/import content

## Testing

```bash
rails test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - see LICENSE file for details.

## Acknowledgments

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Hotwire](https://hotwired.dev/)
- [Devise](https://github.com/heartcombo/devise)
- [Pundit](https://github.com/varvet/pundit)
