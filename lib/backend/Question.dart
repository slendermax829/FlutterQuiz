extension QuestionIdentification on Enum{

  String kind(){
    return name.toLowerCase().replaceAll('_', ' ');
  }
}

enum QuestionType{
  MULTIPLE_CHOICE,
  FILL_IN_THE_BLANK;

}

abstract class Question{
  final String _stem;
  final QuestionType _type;

  String get stem => _stem;
  String get type => _type.kind();

  const Question(this._stem, this._type);

  /// [answer] is an option index for multiple choice, or text for fill in the blank.
  bool isCorrect(Object? answer);

  factory Question.fromData(Map<String,dynamic> quizData){
    String stem = quizData['stem'];
    
    switch(quizData['type']){
      case 1:
        List<String> options = List<String>.from(
          quizData['options']
        );

        int answer = (quizData['answer'] as int)-1;

        return MultipleChoice(stem, options, answer);

      case 2:
        List<String> answer = List<String>.from(
          quizData['answer']
        );

        return FillInBlank(stem, answer);

      default:
        throw "Invalid Question";
    }

  }
  
  @override
  String toString() => '$_stem, ${_type.name}';

}

class MultipleChoice extends Question{
  final List<String> _options;
  final int _answerIndex;

  List<String> get choices => List.unmodifiable(_options);

  String get answer => _options.asMap().entries.firstWhere((e) => e.key == _answerIndex).value.toString();
  String get options => _options.asMap().entries.map((e)=>'${e.key+1} ${e.value}').toString();

  const MultipleChoice(String stem, this._options, this._answerIndex):super(stem,QuestionType.MULTIPLE_CHOICE);

  @override
  bool isCorrect(Object? answer) => answer is int && answer == _answerIndex;

  String getOption(int index) => _options[index];
}

class FillInBlank extends Question{
  final List<String> _answers;

  String get answers => _answers.map((e)=>'${e.toLowerCase().trim()}',).toString();

  const FillInBlank(String stem, this._answers):super(stem,QuestionType.FILL_IN_THE_BLANK);

  @override
  bool isCorrect(Object? answer) =>
      answer is String &&
      _answers.any((a) => a.toLowerCase().trim() == answer.toLowerCase().trim());
}