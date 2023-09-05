String getPrompt( field, String stage, String course) {

  String prompt = 
  """
You're a lecturer who are in the field of 'Frontend'. Currently you had taught about 'How the Internet works' in the topic of 'The Internet'. You decide to give students a quiz of [10] questions!! 

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
const testResult = 
"""
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