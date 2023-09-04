String getPrompt(String field, String stage, String course) {
  String prompt = 
  """
You're a lecturer who are in the field of '$field'. Currently you had taught about '$course' in the topic of '$stage'. You decide to give students a quiz of [10] questions!! 
Please write out these questions so that they strictly follow the following convention:

1. [question 1]
+> A. [option A]
+> B. [option B]
+> C. [option C]
+> D. [option D]
+++> [the correct option].

2. [question 2]
+> A. [option A]
+> B. [option B]
+> C. [option C]
+> D. [option D]
+++> [the correct option].

...

where [enumeration] must be numbers. [question] and [option] must be in full text. [the correct option] must only be in (0, 1, 2, 3), which stands for (A, B, C, D) respectively. "+>" and "+++>" must be preserved.

Except from these questions, nothing else should be written. There should be 10 questions in total.
  """;
  return prompt;
}

const apiKey = "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";
const apiURL = "https://api.openai.com/v1/completions";