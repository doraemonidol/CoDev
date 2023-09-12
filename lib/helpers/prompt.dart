import '../providers/field.dart';

String getPrompt(field, String stage, String course) {
  String prompt = """
You're a lecturer who are in the field of '$field'. Currently you had taught about '$course' in the topic of '$stage'. You decide to give students a quiz of [10] questions!! 

Please write out these questions so that they strictly follow the following convention of JSON.
{
"quiz": 
  [
    {
      "question": [question],
      "options": ["option", "option", "option", "option"],
      "answer": [answer]
    }
  ]
}

The options should not have the prefix.
The answer should be in form of (0, 1, 2, 3).
 There should be 10 questions in total.

Your result should contain the JSON only. No other words.
  """;
  return prompt;
}

const apiKey = "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";
const apiURL = "https://api.openai.com/v1/completions";
const testResult = """
{
  "quiz": [
    {
      "question": "What does HTTP stand for?",
      "options": ["Hypertext Transfer Protocol", "Hypertext Text Transfer Protocol", "Hyperlink Transmission Text Protocol", "Hypertext Transfer Text Protocol"],
      "answer": 0
    },
    {
      "question": "Which protocol is used for sending emails?",
      "options": ["SMTP", "FTP", "HTTP", "TCP"],
      "answer": 0
    },
    {
      "question": "What is the main purpose of DNS?",
      "options": ["Determining the protocol for a website", "Transmitting data over the internet", "Resolving domain names to IP addresses", "Securing web connections"],
      "answer": 2
    },
    {
      "question": "Which of the following is not a top-level domain (TLD)?",
      "options": [".com", ".net", ".web", ".org"],
      "answer": 2
    },
    {
      "question": "What does IP stand for in the context of the internet?",
      "options": ["Internet Provider", "Internet Protocol", "Internal Protocol", "Interconnected Protocol"],
      "answer": 1
    },
    {
      "question": "Which organization is responsible for managing IP address allocation globally?",
      "options": ["ICANN", "IETF", "W3C", "IEEE"],
      "answer": 0
    },
    {
      "question": "What is the purpose of a web browser's 'cache'?",
      "options": ["Storing sensitive user data", "Speeding up page loading by storing local copies of web resources", "Blocking malicious websites", "Managing user bookmarks"],
      "answer": 1
    },
    {
      "question": "Which HTTP status code represents a successful response?",
      "options": ["200 OK", "404 Not Found", "500 Internal Server Error", "302 Found"],
      "answer": 0
    },
    {
      "question": "What is the primary function of a router in a computer network?",
      "options": ["Transmitting email messages", "Determining the fastest route for data packets", "Storing website data", "Providing physical access to the internet"],
      "answer": 1
    },
    {
      "question": "Which of the following is not a valid IP address format?",
      "options": ["192.168.0.1", "256.0.0.1", "10.0.0.1", "172.16.0.1"],
      "answer": 1
    }
  ]
}

""";

String schedulePrompt(String fields_json, int num_tasks) {
  String prompt = """
    You are a consultant for a college student. The student give you a list of fields that he want to learn, each field has several courses. Your task is to schedule the courses for the student. The student want to learn about 5-6 courses per day.
    Given the list of fields, each has a list of courses as json, as following:\n
  """ +
      fields_json +
      """
\nPlease schedule the courses for the student. It must be about 5-6 tasks each day, each represent a course.
Each course must exist in the plan exactly once and their order in each field must be kept.
The fields must be scheduled parallelly, that means the student must learn about 5-6 courses from DIFFERENT fields each day.
The result must STRICTLY be in the form that, each line contains the index of the course, counting from 0, in order of the input data, and the start time of the task (hour), and the end time of the task (hour), separated by a space. There is a line containing a dot "." at the end of each day. Example result:
0 10:00 12:00
1 12:00 14:00
3 14:00 16:00
5 16:00 18:00
7 18:00 20:00
10 22:00 23:00
.
2 10:00 12:00
4 12:00 14:00
6 14:00 16:00
8 16:00 18:00
9 18:00 20:00
.
Please note that the indexes must be fully from 0 to $num_tasks - 1, and there must be exactly $num_tasks lines of indexes in total.
Your result must contain the result formatted earlier. NO OTHER WORD. PLEASE. NO OTHER WORD.
""";
  return prompt;
}
