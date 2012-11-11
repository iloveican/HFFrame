//
//  NSString+Additions.m
//  Pluto
//
//  Created by Zheng Yue on 12-10-21.
//
//

#import "NSString+Additions.h"

@implementation NSString (HF)

/*---------------------------------------------------------------------------
 * 根据format来格式化形式为"20121010"的字符串
 * 格式化的3个参数顺序是年、月、日
*--------------------------------------------------------------------------*/

- (NSString*)dateStringWithFormat:(NSString*)format
{
    int n = self.length;
    if(n < 6) return self;
    
    NSString *year = [self substringToIndex:4];
    NSRange range;
    range.location = 4;
    range.length = 2;
    NSString *month = [self substringWithRange:range];
    NSString *day = @"";
    if(n > 6) {
        day = [self substringFromIndex:6];
    }
    return [NSString stringWithFormat:format, year, month, day];
}

/*---------------------------------------------------------------------------
 * 把形式为"20121010"的字符串转成"2012年10月10日"
 *--------------------------------------------------------------------------*/

- (NSString*)ymdString
{
    return [self dateStringWithFormat:@"%@年%@月%@日"];
}

- (NSString*)ymdStringWithSeperator:(NSString*)seperator
{
    return [self dateStringWithFormat:[NSString stringWithFormat:@"%%@%@%%@%@%%@", seperator, seperator]];
}

/*---------------------------------------------------------------------------
 * 把形式为"20121010"的字符串转成"2012年10月"
 *--------------------------------------------------------------------------*/

- (NSString*)ymString
{
    return [self dateStringWithFormat:@"%@年%@月"];
}

/*---------------------------------------------------------------------------
 * 把形式为"20121010"的字符串转成"10-10"
 *--------------------------------------------------------------------------*/
- (NSString*)mdString
{
    return [self mdStringWithSeperator:@"-"];
}

- (NSString*)mdStringWithSeperator:(NSString*)seperator
{
    if(self.length < 8) return self;
    
    NSRange range;
    range.location = 4;
    range.length = 2;
    NSString *month = [self substringWithRange:range];
    range.location = 6;
    NSString *day = [self substringWithRange:range];
    return [NSString stringWithFormat:@"%@%@%@", month, seperator, day];
}

/*---------------------------------------------------------------------------
 * 把形式为"123456"的字符串，格式化成"12:34"的形式
*--------------------------------------------------------------------------*/
- (NSString*)hmString
{
    if(self.length < 6) return self;
    
    NSRange range;
    range.location = 2;
    range.length = 2;
    NSString *hour = [self substringToIndex:2];
    NSString *minute = [self substringWithRange:range];
    return [NSString stringWithFormat:@"%@:%@", hour, minute];
}

/*---------------------------------------------------------------------------
 * 返回"201212"形式或"2012年12月"的日期字符串的下一个月
 * 例如，"201210" 返回 "201211"
 *      "2012年12月" 返回 "2013月01月"
 *--------------------------------------------------------------------------*/
- (NSString*)nextMonth
{
    if(self.length != 6 && self.length != 8) return self;
    NSInteger month;
    NSInteger year = [[self substringToIndex:4] integerValue];;
    if(self.length == 6) {
        month = [[self substringFromIndex:4] integerValue];
    } else {
        NSRange range;
        range.location = 5;
        range.length = 2;
        month = [[self substringWithRange:range] integerValue];
    }
    month++;
    if(month > 12) {
        year++;
        month = 1;
    }
    return [NSString stringWithFormat:@"%d%02d", year, month];
}

/*---------------------------------------------------------------------------
 * 格式化输出带货币前缀的金额字符串
 * 例如如果输入为空，symbol="$" 则输出"$0.00"
 * 如果输入为"1.22", symbol="￥"，则输出"￥1.22"
 *--------------------------------------------------------------------------*/
- (NSString*)amountStringWithSymbol:(NSString*)symbol
{
    NSString *result;
    if(self == nil || [self isEqualToString:@""]) {
        result = [NSString stringWithFormat:@"%@0.00", symbol];
    } else {
        result = [NSString stringWithFormat:@"%@%@", symbol, self];
    }
    return result;
}

/*---------------------------------------------------------------------------
 * 输出以元为单位的金额数字
 * 返回以分为单位的字符串
 *--------------------------------------------------------------------------*/
+ (NSString*)fenStringWithDecimalNumber:(NSDecimalNumber*)number
{
    NSDecimalNumber *fen = [number decimalNumberByMultiplyingByPowerOf10:2];
    return [fen stringValue];
}

-(BOOL)isContainsString:(NSString *)findStr
{
    NSRange textRange;
    textRange =[self rangeOfString:findStr];
    return (textRange.location != NSNotFound);
}

- (BOOL)isContainsString:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}


-(int)lengthToInt
{
    //去掉空格
    NSString *st = [self  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int strlength = 0;
    char* p = (char*)[st cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[st lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
//验证是否是数字
-(BOOL)isNumberStr
{
    NSString *number =@"0123456789";
    NSCharacterSet * cs =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
    NSString * comparStr = [[self componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [self isEqualToString:comparStr];
}

-(BOOL)isLetterStr
{
    return [self isMatchedByRegex:@"^([A-Za-z]+$"];
}


//验证身份证
-(BOOL)isPersonCard
{
//    NSLog(@"%d",[self length]);
    /*招行那帮东西之前让做简单验证
      验证15位纯数字 18位纯数字 或者17位纯数字+X
      后来又要做严格验证因此现在改用正则
     */
    /*
    if ([self length]!= 15 && [self length] != 18)
    {
        return NO;
    }
    else if ( ([self length] == 18 ||[self length] ==15) && [self isNumberStr])
    {
        return YES;
    }
    else if ([self length] == 18  && ([[self substringToIndex:17] isNumberStr] && [self hasSuffix:@"X"]))
    {
        return YES;
    }
    else
    {
        return NO;
    }*/
    return [self isMatchedByRegex:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}((19\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|(19\\d{2}(0[13578]|1[02])31)|(19\\d{2}02(0[1-9]|1\\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\\d{3}(\\d|X|x)?$"];
}

-(BOOL)isNameStr
{
	return [self isMatchedByRegex:@"^([A-Za-z]|[\u4E00-\u9FA5])+$"];
};

@end
