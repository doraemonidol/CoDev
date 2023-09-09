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

String schedulePrompt(String fields_json) {
  String prompt = """
    You are a consultant for a college student. The student give you a list of fields that he want to learn, each field has several stages and each stage has several courses. Your task is to schedule the courses for the student. The student want to learn about 3-4 courses per day.
    Given the list of fields (including stages and courses) as json, as following:
  """ +
      fields_json +
      """
Please schedule the courses for the student. It should be about 3-4 tasks each day, each represent a course. 
Each course must exist in the plan exactly once and their order in each field and stage must be kept.
The result must strictly be in form of json, as following:
"tasklists": [
  {
    "date": "date_of_tasks",
    "tasks":[
      {
        "field": "field_name",
        "stage": "stage_name",
        "course": "course_name",
        "startTime": "start_time",
        "endTime": "end_time",
        "color": "blue" (keep this constant),
        "icon": "icon" (keep this constant)),
        "state": "not done" (keep this constant)
      }
    ]
  }
]
The tasklists is the array contains each element as a tasklist for each day, "date" in "tasklists" represents the date of the tasklist, "tasks" in "tasklists" represents the array of tasks in that day. Each task has "field", "stage", "course" is a course exists in the input data, "startTime" and "endTime" is the scheduled time of the task, "color" and "icon" and "state" must be kept constant as above.
Your result must contain the JSON only. No other words.
""";
  return prompt;
}
