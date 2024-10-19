import os
from stanfordcorenlp import StanfordCoreNLP
import speech_recognition as sr
import pyttsx3
import json

# Stop words set
stop_words = set([
    "am", "are", "is", "was", "were", "be", "being", "been", "have", "has", "had",
    "does", "did", "could", "should", "would", "can", "shall", "will", "may", "might", "must", "let"
]) #this words are removed from the sentence ad it is not used in for translation

class StanfordNLP:
    def __init__(self, host='http://localhost', port=9000):
        self.nlp = StanfordCoreNLP(host, port=port, timeout=30000)
        self.props = {
            'annotators': 'tokenize,ssplit,pos,lemma,ner,parse,depparse,dcoref,relation',
            'pipelineLanguage': 'en',
            'outputFormat': 'json'
        }

    def word_tokenize(self, sentence):
        return self.nlp.word_tokenize(sentence)

# Function to check if a SiGML file exists for the given word
def check_sigml_file(word):
    # Assuming SiGML files are stored in a directory called "sigml_files"
    file_path = f"sigml_files/{word}.sigml"
    return os.path.exists(file_path)

# Function to play the SiGML file
def play_sigml(file_name):
    # Call to SiGML player to play the file
    # Replace this with the actual player command or API
    print(f"Playing SiGML file: {file_name}")

# Function to play SiGML files for words
def play_sigml_for_word(word):
    if check_sigml_file(word):
        # If a SiGML file for the word exists, play it
        play_sigml(f"sigml_files/{word}.sigml")
    else:
        # If no SiGML file exists, fallback to playing letter by letter
        for letter in word:
            if check_sigml_file(letter):
                play_sigml(f"sigml_files/{letter}.sigml")
            else:
                print(f"Error: No SiGML file found for letter: {letter}")

# Function to convert text to speech
def SpeakText(command):
    engine = pyttsx3.init()
    engine.say(command)
    engine.runAndWait()

def process_speech():
    # Initialize the recognizer
    recognizer = sr.Recognizer()

    try:
        # Use the microphone as source for input
        with sr.Microphone() as source:
            recognizer.adjust_for_ambient_noise(source, duration=0.2)
            audio = recognizer.listen(source)

            # Using Google to recognize audio
            speech_text = recognizer.recognize_google(audio)
            speech_text = speech_text.lower()

            print("You said: ", speech_text)
            SpeakText(speech_text)

            return speech_text

    except sr.RequestError as e:
        print("Could not request results; {0}".format(e))
    except sr.UnknownValueError:
        print("Unknown error occurred")

if __name__ == '__main__':
    sNLP = StanfordNLP()

    while True:
        print("Say something...")
        spoken_text = process_speech()

        if spoken_text:
            print("Processing spoken text with NLP...")

            # Tokenization and other NLP tasks
            tokens = sNLP.word_tokenize(spoken_text)
            print("Tokens:", tokens)

            # Removing stop words
            filtered_tokens = [word for word in tokens if word not in stop_words]
            print("Filtered Tokens (without stop words):", filtered_tokens)

            # For each filtered token, check and play SiGML file
            for token in filtered_tokens:
                play_sigml_for_word(token)
