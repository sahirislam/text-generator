import re
import random
from string import ascii_uppercase
from collections import defaultdict

PUNCTUATION = '.,!?'
SENTENCE_ENDING_PUNCTUATION = '.!?'

corpus = []
with open(input(), 'r', encoding='utf-8') as file:
    for line in file:
        # split by whitespace, remove all empty strings
        tokens = [token for token in re.split(r'\s', line) if token != '']
        corpus.extend(tokens)

trigrams = defaultdict(dict)
for head1, head2, tail in zip(corpus, corpus[1:], corpus[2:]):
    trigrams[head1 + ' ' + head2].setdefault(tail, 0)
    trigrams[head1 + ' ' + head2][tail] += 1


def generate_sentence():
    def generate_next_word(bigram):
        population = [word for word in trigrams[bigram].keys()]
        weights = [weight for weight in trigrams[bigram].values()]
        # random.choices returns a list, so subscript [0]
        return random.choices(population, weights)[0]

    def generate_first_word():
        first_word = random.choice(list(trigrams.keys()))
        while first_word[-1] in PUNCTUATION \
                or first_word[0] not in ascii_uppercase:
            first_word = random.choice(list(trigrams.keys()))
        return first_word

    while True:
        first_word = generate_first_word()
        sentence = [first_word.split()[0], first_word.split()[1]]
        if sentence[0][-1] in SENTENCE_ENDING_PUNCTUATION:
            continue
        next_word = []

        while True:
            current_bigram = sentence[-2] + ' ' + sentence[-1]
            next_word.append(generate_next_word(current_bigram))
            # break infinite loop if failing to find a compliant next word
            if len(next_word) > 10:
                next_word = []
                break
            #print(sentence, ',', next_word)
            if next_word[-1][-1] in SENTENCE_ENDING_PUNCTUATION:
                if len(sentence) >= 5:
                    sentence.append(next_word[-1])
                    return ' '.join(sentence)
                else:
                    continue
            else:
                sentence.append(next_word[-1])


for _ in range(10):
    sentence = generate_sentence()
    print(sentence)



exit()
