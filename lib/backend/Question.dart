/// Provides a readable, lowercase label for enum values.
extension QuestionIdentification on Enum{

  /// Returns this enum value's name in lowercase, with underscores replaced by spaces.
  String kind(){
    return name.toLowerCase().replaceAll('_', ' ');
  }
}

/// Enum that helps identify the type of question
enum QuestionType{
  MULTIPLE_CHOICE,
  FILL_IN_THE_BLANK;

}

/// Base class for quiz questions.
/// 
/// The class is abstract, cannot be instantiated
abstract class Question{
  final String _stem;
  final QuestionType _type;
  final String? _figure;

  /// The text displayed for this question.
  String get stem => _stem;

  /// The easy readable question type.
  String get type => _type.kind();

  /// If the question has an association with a image the path is stored here, otherwise `''`
  String get figure => _figure ?? '';

  /// Creates a question with its [stem] and [type].
  const Question(this._stem, this._type, this._figure);

  /// Whether [answer] is correct for this question.
  ///
  /// For multiple-choice questions, [answer] must be the selected option's
  /// zero-based index. For fill-in-the-blank questions, it must be answer text.
  bool isCorrect(Object? answer);

  /// Creates a question from its serialized [quizData].
  ///
  /// The map must include a `stem`, a numeric `type` (1 for multiple choice or
  /// 2 for fill-in-the-blank), and the corresponding `options` and `answer`
  /// data. Throws when the type is unsupported.
  factory Question.fromData(Map<String,dynamic> quizData){
    String stem = quizData['stem'];
    String? figure = quizData['figure'];
    
    switch(quizData['type']){
      case 1:
        List<String> options = List<String>.from(
          quizData['options']
        );

        int answer = (quizData['answer'] as int)-1;

        return MultipleChoice(stem, options, answer, figure);

      case 2:
        List<String> answer = List<String>.from(
          quizData['answer']
        );

        return FillInBlank(stem, answer, figure);

      default:
        throw "Invalid Question";
    }

  }
  
  /// Returns the question stem and type name.
  @override
  String toString() => '$_stem, ${_type.name}';

}

/// A question answered by selecting one of several choices.
class MultipleChoice extends Question{
  final List<String> _options;
  final int _answerIndex;

  /// The available answer choices.
  List<String> get choices => List.unmodifiable(_options);

  /// The text of the correct choice.
  String get answer => _options.asMap().entries.firstWhere((e) => e.key == _answerIndex).value.toString();

  /// The choices formatted with one-based display numbers.
  String get options => _options.asMap().entries.map((e)=>'${e.key+1} ${e.value}').toString();

  /// Creates a multiple-choice question.
  ///
  /// [stem] is the question text, `options` are the choices, and the final
  /// argument is the zero-based index of the correct choice.
  const MultipleChoice(String stem, this._options, this._answerIndex, String? figure):super(stem,QuestionType.MULTIPLE_CHOICE,figure);

  @override
  bool isCorrect(Object? answer) => answer is int && answer == _answerIndex;

  /// Returns the choice at the given zero-based [index].
  String getOption(int index) => _options[index];
}

/// A question answered by entering text matching one of its accepted answers.
class FillInBlank extends Question{
  final List<String> _answers;

  /// The accepted answers, formatted as lowercase, trimmed text.
  String get answers => _answers.map((e)=>'${e.toLowerCase().trim()}',).toString();

  /// Creates a fill-in-the-blank question with its [stem] and accepted answers.
  const FillInBlank(String stem, this._answers, String? figure):super(stem,QuestionType.FILL_IN_THE_BLANK,figure);

  @override
  bool isCorrect(Object? answer) =>
      answer is String &&
      _answers.any((a) => a.toLowerCase().trim() == answer.toLowerCase().trim());
}