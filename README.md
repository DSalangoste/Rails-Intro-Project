# README
# Dog Wiki 🐕

Dog Wiki is a Ruby on Rails application that serves as a comprehensive database for dog lovers to discover and learn about different dog breeds, their characteristics, and view photos.

## Installation

1. Clone the repository
```bash
git clone <your-repository-url>
cd dog-wiki
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Set up environment variables
- Create a `.env` file in the root directory
- Add your Dog API key:
```bash
DOG_API_KEY=your_api_key_here
```

4. Set up the database
```bash
rails db:create
rails db:migrate
rails db:seed
```

## Running the Application

1. Start the Rails server
```bash
rails server
```

2. Visit `http://localhost:3000` in your browser