# Clear existing data
puts "Clearing existing data..."
PostTag.destroy_all
Post.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

# Create Admin User
puts "Creating admin user..."
admin = User.create!(
  email: "admin@contenthub.com",
  password: "password123",
  username: "admin",
  role: :admin,
  bio: "Platform administrator and content curator. Passionate about building great user experiences."
)

# Create Member Users
puts "Creating member users..."
members = []

members << User.create!(
  email: "sarah@example.com",
  password: "password123",
  username: "sarah_writes",
  role: :member,
  bio: "Tech writer and developer advocate. I love explaining complex concepts in simple terms."
)

members << User.create!(
  email: "james@example.com",
  password: "password123",
  username: "james_dev",
  role: :member,
  bio: "Full-stack developer with 10 years of experience. Ruby and JavaScript enthusiast."
)

members << User.create!(
  email: "emma@example.com",
  password: "password123",
  username: "emma_designs",
  role: :member,
  bio: "UI/UX designer turned developer. I believe in the power of beautiful, functional design."
)

members << User.create!(
  email: "mike@example.com",
  password: "password123",
  username: "mike_codes",
  role: :member,
  bio: "Backend specialist and database wizard. Always optimizing for performance."
)

# Create Categories
puts "Creating categories..."
categories = {
  "Technology" => { description: "Latest tech trends and innovations", color: "#8B5CF6", icon: "💻" },
  "Design" => { description: "UI/UX, visual design, and creativity", color: "#EC4899", icon: "🎨" },
  "Development" => { description: "Coding tutorials and best practices", color: "#10B981", icon: "⚡" },
  "Business" => { description: "Startups, entrepreneurship, and growth", color: "#F59E0B", icon: "📈" },
  "Lifestyle" => { description: "Work-life balance and personal growth", color: "#6366F1", icon: "🌟" },
  "Tutorials" => { description: "Step-by-step guides and how-tos", color: "#EF4444", icon: "📚" }
}

category_objects = {}
categories.each do |name, attrs|
  category_objects[name] = Category.create!(
    name: name,
    description: attrs[:description],
    color: attrs[:color],
    icon: attrs[:icon]
  )
end

# Create Tags
puts "Creating tags..."
tag_names = [
  "ruby", "rails", "javascript", "react", "vue", "css", "html",
  "api", "database", "devops", "git", "testing", "security",
  "performance", "ux", "ui", "mobile", "cloud", "ai", "ml",
  "startup", "productivity", "remote-work", "career", "learning"
]

tags = tag_names.map do |name|
  Tag.create!(name: name, color: "##{SecureRandom.hex(3)}")
end

# Sample post content
sample_posts = [
  {
    title: "Getting Started with Ruby on Rails 7",
    excerpt: "Learn how to build modern web applications with Rails 7 and Hotwire",
    content: "<h2>Introduction to Rails 7</h2><p>Ruby on Rails 7 brings exciting new features that make building web applications faster and more enjoyable than ever. In this comprehensive guide, we'll explore the key features and best practices.</p><h3>What's New in Rails 7</h3><p>Rails 7 introduces Hotwire as the default front-end framework, replacing the need for heavy JavaScript frameworks in many cases. This approach, called HTML-over-the-wire, sends HTML instead of JSON to the browser.</p><h3>Setting Up Your Environment</h3><p>Before we begin, make sure you have Ruby 3.0+ installed on your system. You can check your Ruby version by running <code>ruby -v</code> in your terminal.</p><p>To create a new Rails 7 application, run:</p><pre>rails new myapp --css=tailwind</pre><p>This creates a new application with Tailwind CSS pre-configured for styling.</p><h3>Understanding Hotwire</h3><p>Hotwire consists of two main components:</p><ul><li><strong>Turbo</strong> - Speeds up page changes and form submissions</li><li><strong>Stimulus</strong> - A modest JavaScript framework for adding interactivity</li></ul><p>Together, these tools allow you to build highly interactive applications while writing minimal JavaScript.</p>",
    category: "Development",
    tags: [ "ruby", "rails", "javascript" ],
    featured: true,
    views: 1250
  },
  {
    title: "Modern CSS Techniques Every Developer Should Know",
    excerpt: "Explore CSS Grid, Flexbox, and custom properties for better layouts",
    content: "<h2>CSS Has Come a Long Way</h2><p>Modern CSS provides powerful tools for creating responsive, maintainable layouts without relying on frameworks. Let's explore some essential techniques.</p><h3>CSS Grid Layout</h3><p>CSS Grid is a two-dimensional layout system that makes it easy to create complex layouts. Here's a simple example:</p><pre>.container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; }</pre><h3>Flexbox for Component Layout</h3><p>While Grid is great for page layouts, Flexbox excels at component-level layouts and alignment.</p><h3>Custom Properties (CSS Variables)</h3><p>CSS custom properties allow you to define reusable values throughout your stylesheet:</p><pre>:root { --primary-color: #8b5cf6; --spacing: 1rem; }</pre><p>Use them anywhere in your CSS with <code>var(--primary-color)</code>.</p>",
    category: "Design",
    tags: [ "css", "html", "ui" ],
    featured: true,
    views: 890
  },
  {
    title: "Building RESTful APIs with Rails",
    excerpt: "Best practices for designing and implementing APIs in Ruby on Rails",
    content: "<h2>API Design Principles</h2><p>Building a well-designed API is crucial for modern web applications. Rails makes this process straightforward with its conventions.</p><h3>RESTful Resource Design</h3><p>Follow REST conventions for predictable, maintainable APIs. Use proper HTTP methods and status codes.</p><h3>Serialization with Active Model Serializers</h3><p>Control your JSON output precisely using serializers. This separates concerns and keeps your controllers clean.</p><h3>Authentication with JWT</h3><p>Implement token-based authentication for secure API access. JWT tokens are stateless and scalable.</p><h3>Versioning Your API</h3><p>Plan for the future by versioning your API from the start. Use URL prefixes like <code>/api/v1/</code> for clarity.</p>",
    category: "Development",
    tags: [ "api", "rails", "ruby" ],
    featured: false,
    views: 567
  },
  {
    title: "The Art of Writing Clean Code",
    excerpt: "Principles and practices for maintainable, readable code",
    content: "<h2>Why Clean Code Matters</h2><p>Clean code is not just about aesthetics—it's about maintainability, readability, and reducing bugs. Let's explore key principles.</p><h3>Meaningful Names</h3><p>Use intention-revealing names for variables, methods, and classes. A good name tells you what something does without needing comments.</p><h3>Small Functions</h3><p>Functions should do one thing and do it well. If a function is doing multiple things, split it up.</p><h3>DRY Principle</h3><p>Don't Repeat Yourself. Extract common functionality into reusable methods or modules.</p><h3>Testing</h3><p>Write tests to ensure your code works as expected and to catch regressions early.</p>",
    category: "Development",
    tags: [ "testing", "learning", "career" ],
    featured: false,
    views: 423
  },
  {
    title: "UI Design Trends for 2024",
    excerpt: "Exploring the latest design trends shaping user interfaces",
    content: "<h2>Design Evolution</h2><p>Design trends continue to evolve, balancing aesthetics with usability. Here are the key trends to watch.</p><h3>Glassmorphism</h3><p>Frosted glass effects with blur and transparency create depth and hierarchy while maintaining readability.</p><h3>Micro-interactions</h3><p>Subtle animations provide feedback and delight users. They make interfaces feel alive and responsive.</p><h3>Dark Mode</h3><p>Dark mode isn't just trendy—it reduces eye strain and saves battery on OLED screens.</p><h3>Inclusive Design</h3><p>Accessibility is becoming a priority, not an afterthought. Design for all users from the start.</p>",
    category: "Design",
    tags: [ "ui", "ux", "css" ],
    featured: true,
    views: 1102
  },
  {
    title: "Database Performance Optimization",
    excerpt: "Techniques for speeding up your database queries",
    content: "<h2>Why Performance Matters</h2><p>Slow database queries are often the biggest bottleneck in web applications. Learn how to identify and fix them.</p><h3>Indexing Strategy</h3><p>Proper indexing can make queries orders of magnitude faster. Index columns used in WHERE, ORDER BY, and JOIN clauses.</p><h3>Query Optimization</h3><p>Use EXPLAIN to understand query plans. Avoid N+1 queries by eager loading associations.</p><h3>Caching</h3><p>Cache expensive queries and computed values. Rails provides several caching strategies out of the box.</p><h3>Database Design</h3><p>Good schema design prevents performance problems before they start.</p>",
    category: "Development",
    tags: [ "database", "performance", "rails" ],
    featured: false,
    views: 678
  },
  {
    title: "Remote Work Best Practices",
    excerpt: "Tips for staying productive and healthy while working from home",
    content: "<h2>The Remote Work Revolution</h2><p>Remote work is here to stay. Here's how to make the most of it while maintaining work-life balance.</p><h3>Create a Dedicated Workspace</h3><p>A separate workspace helps you focus and creates boundaries between work and personal life.</p><h3>Establish Routines</h3><p>Start and end your day at consistent times. Take regular breaks to avoid burnout.</p><h3>Communication</h3><p>Over-communicate in remote settings. Use video calls for important discussions.</p><h3>Self-Care</h3><p>Don't forget to exercise, eat well, and maintain social connections outside of work.</p>",
    category: "Lifestyle",
    tags: [ "remote-work", "productivity", "career" ],
    featured: false,
    views: 892
  },
  {
    title: "Introduction to Test-Driven Development",
    excerpt: "Learn the fundamentals of TDD and why it matters",
    content: "<h2>What is TDD?</h2><p>Test-Driven Development is a software development approach where tests are written before the actual code.</p><h3>The TDD Cycle</h3><p>Red → Green → Refactor. Write a failing test, make it pass, then improve the code.</p><h3>Benefits of TDD</h3><p>Better design, fewer bugs, documentation through tests, and confidence when refactoring.</p><h3>Testing in Rails</h3><p>Rails provides excellent testing tools out of the box. Use Minitest or RSpec to write your tests.</p><h3>Getting Started</h3><p>Start small. Write one test for a simple method and build from there.</p>",
    category: "Tutorials",
    tags: [ "testing", "ruby", "learning" ],
    featured: false,
    views: 445
  },
  {
    title: "Building a Startup: Lessons Learned",
    excerpt: "Real-world advice from founding and growing a tech startup",
    content: "<h2>The Startup Journey</h2><p>Starting a company is one of the most challenging and rewarding experiences. Here's what I've learned.</p><h3>Validate Before You Build</h3><p>Talk to potential customers before writing code. Make sure you're solving a real problem.</p><h3>Focus on Distribution</h3><p>A great product means nothing if no one knows about it. Think about acquisition from day one.</p><h3>Hire Slowly, Fire Fast</h3><p>Cultural fit matters as much as skills. One bad hire can derail a small team.</p><h3>Take Care of Yourself</h3><p>Burnout is real. Build sustainable habits from the start.</p>",
    category: "Business",
    tags: [ "startup", "career", "learning" ],
    featured: false,
    views: 756
  },
  {
    title: "Mastering Git Workflows",
    excerpt: "Essential Git strategies for effective team collaboration",
    content: "<h2>Git for Teams</h2><p>Git is essential for modern development. Master these workflows to collaborate effectively.</p><h3>Feature Branch Workflow</h3><p>Create branches for features and merge them via pull requests. This keeps main stable.</p><h3>Commit Messages</h3><p>Write clear, descriptive commit messages. Future you will thank present you.</p><h3>Rebasing vs Merging</h3><p>Understand when to use each. Rebasing creates cleaner history but requires caution.</p><h3>Resolving Conflicts</h3><p>Don't fear conflicts. Understanding how to resolve them is essential.</p>",
    category: "Tutorials",
    tags: [ "git", "devops", "learning" ],
    featured: false,
    views: 534
  }
]

# Create Posts
puts "Creating posts..."
all_users = [ admin ] + members

sample_posts.each do |post_data|
  user = all_users.sample
  post = Post.new(
    title: post_data[:title],
    excerpt: post_data[:excerpt],
    status: :published,
    featured: post_data[:featured],
    views_count: post_data[:views],
    user: user,
    category: category_objects[post_data[:category]],
    created_at: rand(30).days.ago
  )

  post.content = post_data[:content]
  post.save!

  # Add tags
  post_data[:tags].each do |tag_name|
    tag = tags.find { |t| t.name == tag_name }
    PostTag.create!(post: post, tag: tag) if tag
  end
end

# Create some draft posts
puts "Creating draft posts..."
3.times do |i|
  user = members.sample
  post = Post.new(
    title: "Draft Post #{i + 1}: Work in Progress",
    excerpt: "This is a draft post that hasn't been published yet.",
    status: :draft,
    user: user,
    category: category_objects.values.sample
  )
  post.content = "<p>This content is still being written...</p>"
  post.save!
end

puts "Seeding complete!"
puts ""
puts "Created:"
puts "  - #{User.count} users"
puts "  - #{Category.count} categories"
puts "  - #{Tag.count} tags"
puts "  - #{Post.count} posts (#{Post.published.count} published, #{Post.drafts.count} drafts)"
puts ""
puts "Login credentials:"
puts "  Admin: admin@contenthub.com / password123"
puts "  Member: sarah@example.com / password123"
