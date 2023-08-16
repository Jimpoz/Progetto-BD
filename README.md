# Exam Management and Evaluation WebApp

## Introduction

Welcome to the Exam Management and Evaluation WebApp! This application has been developed to streamline and enhance the process of exam management and evaluation for teachers in a university setting. This README provides an overview of the WebApp's features, installation instructions, and basic usage guidelines.

### Features

Our Exam Management and Evaluation WebApp offers the following key features:

- **Efficient Exam Management:** The WebApp allows teachers to easily create, organize, and manage exams. This includes setting up exam details, such as exam name, date, and duration etc.

- **Seamless Evaluation:** The WebApp facilitates smooth evaluation of students' exam submissions. Teachers can efficiently review and grade the tests.

- **User-Friendly Interface:** The interface is designed with user experience in mind. It is intuitive and easy to navigate, ensuring that teachers can effectively use the application without extensive training.

### Installation

To set up the Exam Management and Evaluation WebApp locally, follow these steps:

1. Clone this repository to your local machine using the following command:

   ```
   git clone https://github.com/yourusername/exam-webapp.git
   ```

2. Install the required dependencies. Run:

   ```
   pip install
   ```

3. Configure the necessary environment variables, such as database connection details and application settings. You can find an example configuration in the `.env.example` file. Create a `.env` file and populate it with your actual configuration.

4. Start the WebApp by running:

   ```
   flask run
   ```

### Usage

Upon accessing the WebApp, teachers can perform the following actions:

- **Login:** Teachers can log in using their credentials to access the dashboard.

- **Create Exam:** Teachers can create new exams, specifying exam details such as name, date, and duration.

- **Create Test:** Teachers can create new tests under a specific exam and specifying the details. Each test has a different weight on the final grade.

- **Evaluate Submissions:** After an exam, teachers can view and evaluate student submissions by providing grades.

- **Logout:** Teachers can securely log out of the WebApp once their tasks are complete.

## License

This project is licensed under the [MIT License](LICENSE).
