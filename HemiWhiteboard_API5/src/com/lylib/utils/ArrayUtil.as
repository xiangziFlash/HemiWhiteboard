package com.lylib.utils
{
        public class ArrayUtil
        {
                public function ArrayUtil()
                {
                }
               
                /**
                 * 判断两个数组是否全等（Array 或 Vector 类型）。全等条件是：长度一样，并且对应索引的元素也相等。
                 * @param first 第一个数组。
                 * @param second 第二个数组。
                 * @return 如果两个数组全等则返回 true ，否则返回 false 。
                 *
                 */            
                public static function equals(first:*, second:*):Boolean
                {
                        var l:uint = first.length;
                        if (l != second.length)
                        {
                                return false;
                        }
                       
                        while (l--)
                        {
                                if (first[l] != second[l])
                                {
                                        return false;
                                }
                        }
                       
                        return true;
                }
               
        }
}

