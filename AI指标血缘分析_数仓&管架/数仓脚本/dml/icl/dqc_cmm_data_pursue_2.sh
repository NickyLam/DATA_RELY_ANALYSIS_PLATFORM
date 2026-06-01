#!/bin/sh
##############################################################################
# 版本  修改人  修改日期  修改内容
# 执行方法 sh dqc_cmm_data_pursue.sh 1 start_dt end_dt table_name 
# V1.1  修改休眠间隔时间为10小时
# V1.2  开始日期，结束日期，作业名调整为参数传入
# cbss_crcs_dpss_eass
##############################################################################
#  以下绿色部分代码为模板代码，不要修改
. ~/.bash_profile
startnum=$1     # 起跑作业序号
currentnum=0    # 当前作业
runBeginDate=`date "+%Y%m%d"`  #脚本开始运行日期

# 写日志的shell函数
logfile=./`basename $0`.log
writelog()
{
  echo `date "+%Y-%m-%d %H:%M:%S"`" $1" | tee -a $logfile
}

# 执行SHELL命令的函数
EXESH_CMD()
{
    # 检查作业可否跳过
    currentnum=`expr $currentnum + 1`
    echo "Running job #$currentnum ..."
    writelog "Running job #$currentnum ..."
    if [ "$currentnum" -lt "$startnum" ];then
        writelog "job ($currentnum < $startnum) skipped .."
        return 0  # 跳过
    fi

    # 执行之
    writelog "$CMD"
    eval "$CMD" >> $logfile
    if [ $? -ne 0 ]
    then
        writelog "SH Command failed! exit..."
        exit 1
    fi
}

#判断输入日期YYYYMMDD是否为月末的函数(1：是 0:否)
IS_MON_END()
{
    #输入函数参数为YYYYMMDD
    YYYYMMDD=$1
    year=`echo $YYYYMMDD|cut -c 1-4`
    mon=`echo $YYYYMMDD|cut -c 5-6`
    day=`echo $YYYYMMDD|cut -c 7-8`
    monend=`cal $mon $year|xargs|awk '{print $NF}'`

    if [ "$day" = "$monend" ];then
      #返回1
    	echo "1"
    else
      #返回0
      echo "0"
    fi
}

#输入日期(YYYYMMDD)返回下一天的函数
GET_NEXT_DAY()
{
    YYYYMMDD=$1
    year=`echo $YYYYMMDD|cut -c 1-4`
    mon=`echo $YYYYMMDD|cut -c 5-6`
    day=`echo $YYYYMMDD|cut -c 7-8`
    monend=`cal $mon $year|xargs|awk '{print $NF}'`

    #当为月末时
    if [ "$day" = "$monend" ];then

    		#当为月末但不是12月时，返回下月1号
    		if [ "$mon" != "12" ];then
    			nextMon=`expr $year$mon + 1`
    			nextDay=${nextMon}01
    			echo $nextDay

    		#当为月末且为12月时，返回下年1月1号
    		else
    			nextYear=`expr $year + 1`
    			nextMon=`echo ${nextYear}01`
    			nextDay=${nextMon}01
    			echo $nextDay
    		fi

    #当不为月末时
    else
    		nextDay=`expr $YYYYMMDD + 1`
    		echo $nextDay
    fi
}

#时间控制函数,如果脚本跑数时间过长需要跨天的,则需要凌晨过后暂停一段时间再跑,从而不影响跑批
BREAK_CONTR()
{
    #获取当前日期,如果当前日期与shell开始运行日期不同(或为0点时),则为隔天
    runCurrDate=`date "+%Y%m%d"`
    if [ "$runCurrDate" != "$runBeginDate" -o `date "+%H"` = "00" ];then

        #休眠64000秒,约18小时,即明天下午六点左右再调起
        writelog "shell sleeping..."
        sleep 36000

        #由于是隔天,修数的结束时间需要重新初始化
        endDate2=$(perl -e "use POSIX qw(strftime);print strftime '%Y%m%d',localtime(time() - 3600*24*2 )")
        if [ "$endDate2" = "$endDate" ];then
             endDate=$(perl -e "use POSIX qw(strftime);print strftime '%Y%m%d',localtime(time() - 3600*24 )")
        fi
        #重新初始化脚本开始运行日期
        runBeginDate=`date "+%Y%m%d"`
    fi
}

# 以上为模板代码，不要修改
##############################################################################
# 用户代码从这里开始
##############################################################################
writelog "Program start..."

# 检查命令行参数个数，需根据实际情况修改
if [ $# -ne 4 ];then
    writelog "$0: wrong number of arguments"
    writelog "Usage: `basename $0` <jobseq>"
    exit 1
fi

#  1.数据修复原因：
#    AUM

BREAK_CONTR

#跑数开始时间
#startDate=20190701
startDate=$2
#结束时间取跑数时间的前一天,输出格式YYYYMMDD
#endDate=$(perl -e "use POSIX qw(strftime);print strftime '%Y%m%d',localtime(time() - 3600*24 )")
endDate=$3
table_name=$4
vDate=$startDate
while [ $vDate -le $endDate ]
do
    #进行时间控制
    BREAK_CONTR
    CMD="python ${ETL_HOME}/script/main.py ${vDate} iel_icl_cmm_finc_acct_bal_info_f && python $ETL_HOME/script/main.py ${vDate} dis_brts_icl_cmm_finc_acct_bal_info_f";EXESH_CMD;BREAK_CONTR;
       
    #取下一天
    vDate=`GET_NEXT_DAY $vDate`
done

writelog "Program finish successfully."

exit 0
