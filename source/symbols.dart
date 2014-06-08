const int spaceCode = 0x20;
const int tabCode = 0x09;
const int nCode = 0x0A;
const int rCode = 0x0D;

const int zeroCode = 0x30; // 0
const int nineCode = 0x39; // 9
const int uACode = 0x41; // A
const int uZCode = 0x5A; // Z
const int lACode = 0x61; // a
const int lZCode = 0x7A; // z
const int underscopeCode = 0x5F; // _

const int dotCode = 0x2E; // .
const int commaCode = 0x2C; // ,
const int colonCode = 0x3A; // :
const int semicolonCode = 0x3B; // ;
const int quotesCode = 0x22; // "
const int sharpCode = 0x23; // #
const int percentCode = 0x25; // %

const int leftRoundBracketCode = 0x28; // (
const int rightRoundBracketCode = 0x29; // )
const int leftSquareBracketCode = 0x5B; // [
const int rightSquareBracketCode = 0x5D; // ]
const int leftCurlyBracketCode = 0x7B; // {
const int rightCurlyBracketCode = 0x7D; // }

bool isDigit(int symbol) => symbol >= zeroCode && symbol <= nineCode;
bool isLowercaseLetter(int symbol) => symbol >= lACode && symbol <= lZCode;
bool isUppercaseLetter(int symbol) => symbol >= uACode && symbol <= uZCode;
bool isLetter(int symbol) => isUppercaseLetter(symbol)
    || isLowercaseLetter(symbol);
bool isID(int symbol) => isDigit(symbol) || isLetter(symbol)
    || symbol == underscopeCode;