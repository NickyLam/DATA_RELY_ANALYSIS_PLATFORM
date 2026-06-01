/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ubcardequip
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a50ubcardequip_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a50ubcardequip
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubcardequip_op purge;
drop table ${iol_schema}.mpcs_a50ubcardequip_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubcardequip_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubcardequip where 0=1;

create table ${iol_schema}.mpcs_a50ubcardequip_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubcardequip where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubcardequip_cl(
            termid -- 设备ID
            ,unit -- 机构编码
            ,tell -- 操作员号
            ,addr -- 设备安装地点
            ,ipaddr -- 设备IP地址
            ,type -- 设备类型
            ,lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
            ,equipstat -- 设备状态
            ,module1 -- 模块1状态(币值1状态)
            ,module2 -- 模块2状态(币值2状态)
            ,module3 -- 模块3状态(币值3状态)
            ,module4 -- 模块4状态(币值4状态)
            ,othmod -- 设备模块状态
            ,sflag -- 签到标志
            ,trskey -- 传输密钥
            ,filldate -- 上次补钞日期时间
            ,lastaddamt -- 最后一次补钞尾箱余额
            ,currvalue1 -- 币值1面值
            ,currvalue2 -- 币值2面值
            ,currvalue3 -- 币值3面值
            ,currvalue4 -- 币值4面值
            ,lastfill1 -- ATM上次币值1补钞数
            ,lastfill2 -- ATM上次币值2补钞数
            ,lastfill3 -- ATM上次币值3补钞数
            ,lastfill4 -- ATM上次币值3补钞数
            ,periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
            ,periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
            ,periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
            ,periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
            ,cutdate -- 上次日终时间
            ,cutprst1 -- 日终周期币值1出入钞数
            ,cutprst2 -- 日终周期币值2出入钞数
            ,cutprst3 -- 日终周期币值3出入钞数
            ,cutprst4 -- 日终周期币值4出入钞数
            ,cwdnum -- 日终周期取款数
            ,cwdsum -- 日终周期取款金额
            ,depnum -- 日终周期存款数
            ,depsum -- 日终周期存款金额
            ,tfrnum -- 日终周期转帐数
            ,tfrsum -- 日终周期转帐金额
            ,cardret -- 日终周期吞卡数
            ,zmkey -- 本地主密钥
            ,zakey -- MAC工作密钥
            ,machinekey -- 装机码
            ,devtype -- 设备型号
            ,begindatetime -- 验证有效期：开始时间
            ,enddatetime -- 验证有效期：结束时间
            ,remainno -- 重试次数
            ,lastopttime -- 上次操作时间
            ,awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
            ,worktype -- 经营方式 1-自营 2-联营
            ,setuptype -- 安装方式 0-穿墙 1-大堂
            ,cashboxlimit -- 钱箱报警金额
            ,devservice -- 设备维护商
            ,serial -- 设备序列号
            ,startdate -- 设备启用日期
            ,stopdate -- 设备停用日期
            ,expiredate -- 保修到期日期
            ,patrolperiod -- 巡检周期 单位/天
            ,powerontime -- 每日开机时间
            ,powerdowntime -- 每日关机时间
            ,atmcsoft -- ATMC软件
            ,packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
            ,nettype -- 联网类型 C：cable有线 W：wireless无线
            ,selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
            ,devcatalog -- 设备属性
            ,devvendor -- 设备品牌
            ,installdate -- 设备安装日期
            ,atmparea -- 银联标准地区代码
            ,brnname -- 机构名称
            ,buydate -- 购机日期
            ,enctype -- 加密方式 0-国密 1或空非国密
            ,authcode -- 申请主密钥认证码(8位装机码)
            ,status -- 
            ,apltlrname -- 申请柜员名字
            ,applydate -- 申请加钞日期
            ,applyteller -- 申请加钞柜员
            ,atmcashboxno -- ATM机尾箱号
            ,cashboxno -- 加钞尾箱号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubcardequip_op(
            termid -- 设备ID
            ,unit -- 机构编码
            ,tell -- 操作员号
            ,addr -- 设备安装地点
            ,ipaddr -- 设备IP地址
            ,type -- 设备类型
            ,lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
            ,equipstat -- 设备状态
            ,module1 -- 模块1状态(币值1状态)
            ,module2 -- 模块2状态(币值2状态)
            ,module3 -- 模块3状态(币值3状态)
            ,module4 -- 模块4状态(币值4状态)
            ,othmod -- 设备模块状态
            ,sflag -- 签到标志
            ,trskey -- 传输密钥
            ,filldate -- 上次补钞日期时间
            ,lastaddamt -- 最后一次补钞尾箱余额
            ,currvalue1 -- 币值1面值
            ,currvalue2 -- 币值2面值
            ,currvalue3 -- 币值3面值
            ,currvalue4 -- 币值4面值
            ,lastfill1 -- ATM上次币值1补钞数
            ,lastfill2 -- ATM上次币值2补钞数
            ,lastfill3 -- ATM上次币值3补钞数
            ,lastfill4 -- ATM上次币值3补钞数
            ,periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
            ,periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
            ,periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
            ,periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
            ,cutdate -- 上次日终时间
            ,cutprst1 -- 日终周期币值1出入钞数
            ,cutprst2 -- 日终周期币值2出入钞数
            ,cutprst3 -- 日终周期币值3出入钞数
            ,cutprst4 -- 日终周期币值4出入钞数
            ,cwdnum -- 日终周期取款数
            ,cwdsum -- 日终周期取款金额
            ,depnum -- 日终周期存款数
            ,depsum -- 日终周期存款金额
            ,tfrnum -- 日终周期转帐数
            ,tfrsum -- 日终周期转帐金额
            ,cardret -- 日终周期吞卡数
            ,zmkey -- 本地主密钥
            ,zakey -- MAC工作密钥
            ,machinekey -- 装机码
            ,devtype -- 设备型号
            ,begindatetime -- 验证有效期：开始时间
            ,enddatetime -- 验证有效期：结束时间
            ,remainno -- 重试次数
            ,lastopttime -- 上次操作时间
            ,awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
            ,worktype -- 经营方式 1-自营 2-联营
            ,setuptype -- 安装方式 0-穿墙 1-大堂
            ,cashboxlimit -- 钱箱报警金额
            ,devservice -- 设备维护商
            ,serial -- 设备序列号
            ,startdate -- 设备启用日期
            ,stopdate -- 设备停用日期
            ,expiredate -- 保修到期日期
            ,patrolperiod -- 巡检周期 单位/天
            ,powerontime -- 每日开机时间
            ,powerdowntime -- 每日关机时间
            ,atmcsoft -- ATMC软件
            ,packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
            ,nettype -- 联网类型 C：cable有线 W：wireless无线
            ,selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
            ,devcatalog -- 设备属性
            ,devvendor -- 设备品牌
            ,installdate -- 设备安装日期
            ,atmparea -- 银联标准地区代码
            ,brnname -- 机构名称
            ,buydate -- 购机日期
            ,enctype -- 加密方式 0-国密 1或空非国密
            ,authcode -- 申请主密钥认证码(8位装机码)
            ,status -- 
            ,apltlrname -- 申请柜员名字
            ,applydate -- 申请加钞日期
            ,applyteller -- 申请加钞柜员
            ,atmcashboxno -- ATM机尾箱号
            ,cashboxno -- 加钞尾箱号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.termid, o.termid) as termid -- 设备ID
    ,nvl(n.unit, o.unit) as unit -- 机构编码
    ,nvl(n.tell, o.tell) as tell -- 操作员号
    ,nvl(n.addr, o.addr) as addr -- 设备安装地点
    ,nvl(n.ipaddr, o.ipaddr) as ipaddr -- 设备IP地址
    ,nvl(n.type, o.type) as type -- 设备类型
    ,nvl(n.lastdate, o.lastdate) as lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
    ,nvl(n.equipstat, o.equipstat) as equipstat -- 设备状态
    ,nvl(n.module1, o.module1) as module1 -- 模块1状态(币值1状态)
    ,nvl(n.module2, o.module2) as module2 -- 模块2状态(币值2状态)
    ,nvl(n.module3, o.module3) as module3 -- 模块3状态(币值3状态)
    ,nvl(n.module4, o.module4) as module4 -- 模块4状态(币值4状态)
    ,nvl(n.othmod, o.othmod) as othmod -- 设备模块状态
    ,nvl(n.sflag, o.sflag) as sflag -- 签到标志
    ,nvl(n.trskey, o.trskey) as trskey -- 传输密钥
    ,nvl(n.filldate, o.filldate) as filldate -- 上次补钞日期时间
    ,nvl(n.lastaddamt, o.lastaddamt) as lastaddamt -- 最后一次补钞尾箱余额
    ,nvl(n.currvalue1, o.currvalue1) as currvalue1 -- 币值1面值
    ,nvl(n.currvalue2, o.currvalue2) as currvalue2 -- 币值2面值
    ,nvl(n.currvalue3, o.currvalue3) as currvalue3 -- 币值3面值
    ,nvl(n.currvalue4, o.currvalue4) as currvalue4 -- 币值4面值
    ,nvl(n.lastfill1, o.lastfill1) as lastfill1 -- ATM上次币值1补钞数
    ,nvl(n.lastfill2, o.lastfill2) as lastfill2 -- ATM上次币值2补钞数
    ,nvl(n.lastfill3, o.lastfill3) as lastfill3 -- ATM上次币值3补钞数
    ,nvl(n.lastfill4, o.lastfill4) as lastfill4 -- ATM上次币值3补钞数
    ,nvl(n.periprst1, o.periprst1) as periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
    ,nvl(n.periprst2, o.periprst2) as periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
    ,nvl(n.periprst3, o.periprst3) as periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
    ,nvl(n.periprst4, o.periprst4) as periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
    ,nvl(n.cutdate, o.cutdate) as cutdate -- 上次日终时间
    ,nvl(n.cutprst1, o.cutprst1) as cutprst1 -- 日终周期币值1出入钞数
    ,nvl(n.cutprst2, o.cutprst2) as cutprst2 -- 日终周期币值2出入钞数
    ,nvl(n.cutprst3, o.cutprst3) as cutprst3 -- 日终周期币值3出入钞数
    ,nvl(n.cutprst4, o.cutprst4) as cutprst4 -- 日终周期币值4出入钞数
    ,nvl(n.cwdnum, o.cwdnum) as cwdnum -- 日终周期取款数
    ,nvl(n.cwdsum, o.cwdsum) as cwdsum -- 日终周期取款金额
    ,nvl(n.depnum, o.depnum) as depnum -- 日终周期存款数
    ,nvl(n.depsum, o.depsum) as depsum -- 日终周期存款金额
    ,nvl(n.tfrnum, o.tfrnum) as tfrnum -- 日终周期转帐数
    ,nvl(n.tfrsum, o.tfrsum) as tfrsum -- 日终周期转帐金额
    ,nvl(n.cardret, o.cardret) as cardret -- 日终周期吞卡数
    ,nvl(n.zmkey, o.zmkey) as zmkey -- 本地主密钥
    ,nvl(n.zakey, o.zakey) as zakey -- MAC工作密钥
    ,nvl(n.machinekey, o.machinekey) as machinekey -- 装机码
    ,nvl(n.devtype, o.devtype) as devtype -- 设备型号
    ,nvl(n.begindatetime, o.begindatetime) as begindatetime -- 验证有效期：开始时间
    ,nvl(n.enddatetime, o.enddatetime) as enddatetime -- 验证有效期：结束时间
    ,nvl(n.remainno, o.remainno) as remainno -- 重试次数
    ,nvl(n.lastopttime, o.lastopttime) as lastopttime -- 上次操作时间
    ,nvl(n.awayflag, o.awayflag) as awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
    ,nvl(n.worktype, o.worktype) as worktype -- 经营方式 1-自营 2-联营
    ,nvl(n.setuptype, o.setuptype) as setuptype -- 安装方式 0-穿墙 1-大堂
    ,nvl(n.cashboxlimit, o.cashboxlimit) as cashboxlimit -- 钱箱报警金额
    ,nvl(n.devservice, o.devservice) as devservice -- 设备维护商
    ,nvl(n.serial, o.serial) as serial -- 设备序列号
    ,nvl(n.startdate, o.startdate) as startdate -- 设备启用日期
    ,nvl(n.stopdate, o.stopdate) as stopdate -- 设备停用日期
    ,nvl(n.expiredate, o.expiredate) as expiredate -- 保修到期日期
    ,nvl(n.patrolperiod, o.patrolperiod) as patrolperiod -- 巡检周期 单位/天
    ,nvl(n.powerontime, o.powerontime) as powerontime -- 每日开机时间
    ,nvl(n.powerdowntime, o.powerdowntime) as powerdowntime -- 每日关机时间
    ,nvl(n.atmcsoft, o.atmcsoft) as atmcsoft -- ATMC软件
    ,nvl(n.packetsize, o.packetsize) as packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
    ,nvl(n.nettype, o.nettype) as nettype -- 联网类型 C：cable有线 W：wireless无线
    ,nvl(n.selfbanktype, o.selfbanktype) as selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
    ,nvl(n.devcatalog, o.devcatalog) as devcatalog -- 设备属性
    ,nvl(n.devvendor, o.devvendor) as devvendor -- 设备品牌
    ,nvl(n.installdate, o.installdate) as installdate -- 设备安装日期
    ,nvl(n.atmparea, o.atmparea) as atmparea -- 银联标准地区代码
    ,nvl(n.brnname, o.brnname) as brnname -- 机构名称
    ,nvl(n.buydate, o.buydate) as buydate -- 购机日期
    ,nvl(n.enctype, o.enctype) as enctype -- 加密方式 0-国密 1或空非国密
    ,nvl(n.authcode, o.authcode) as authcode -- 申请主密钥认证码(8位装机码)
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.apltlrname, o.apltlrname) as apltlrname -- 申请柜员名字
    ,nvl(n.applydate, o.applydate) as applydate -- 申请加钞日期
    ,nvl(n.applyteller, o.applyteller) as applyteller -- 申请加钞柜员
    ,nvl(n.atmcashboxno, o.atmcashboxno) as atmcashboxno -- ATM机尾箱号
    ,nvl(n.cashboxno, o.cashboxno) as cashboxno -- 加钞尾箱号
    ,case when
            n.termid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.termid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.termid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a50ubcardequip_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a50ubcardequip where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.termid = n.termid
where (
        o.termid is null
    )
    or (
        n.termid is null
    )
    or (
        o.unit <> n.unit
        or o.tell <> n.tell
        or o.addr <> n.addr
        or o.ipaddr <> n.ipaddr
        or o.type <> n.type
        or o.lastdate <> n.lastdate
        or o.equipstat <> n.equipstat
        or o.module1 <> n.module1
        or o.module2 <> n.module2
        or o.module3 <> n.module3
        or o.module4 <> n.module4
        or o.othmod <> n.othmod
        or o.sflag <> n.sflag
        or o.trskey <> n.trskey
        or o.filldate <> n.filldate
        or o.lastaddamt <> n.lastaddamt
        or o.currvalue1 <> n.currvalue1
        or o.currvalue2 <> n.currvalue2
        or o.currvalue3 <> n.currvalue3
        or o.currvalue4 <> n.currvalue4
        or o.lastfill1 <> n.lastfill1
        or o.lastfill2 <> n.lastfill2
        or o.lastfill3 <> n.lastfill3
        or o.lastfill4 <> n.lastfill4
        or o.periprst1 <> n.periprst1
        or o.periprst2 <> n.periprst2
        or o.periprst3 <> n.periprst3
        or o.periprst4 <> n.periprst4
        or o.cutdate <> n.cutdate
        or o.cutprst1 <> n.cutprst1
        or o.cutprst2 <> n.cutprst2
        or o.cutprst3 <> n.cutprst3
        or o.cutprst4 <> n.cutprst4
        or o.cwdnum <> n.cwdnum
        or o.cwdsum <> n.cwdsum
        or o.depnum <> n.depnum
        or o.depsum <> n.depsum
        or o.tfrnum <> n.tfrnum
        or o.tfrsum <> n.tfrsum
        or o.cardret <> n.cardret
        or o.zmkey <> n.zmkey
        or o.zakey <> n.zakey
        or o.machinekey <> n.machinekey
        or o.devtype <> n.devtype
        or o.begindatetime <> n.begindatetime
        or o.enddatetime <> n.enddatetime
        or o.remainno <> n.remainno
        or o.lastopttime <> n.lastopttime
        or o.awayflag <> n.awayflag
        or o.worktype <> n.worktype
        or o.setuptype <> n.setuptype
        or o.cashboxlimit <> n.cashboxlimit
        or o.devservice <> n.devservice
        or o.serial <> n.serial
        or o.startdate <> n.startdate
        or o.stopdate <> n.stopdate
        or o.expiredate <> n.expiredate
        or o.patrolperiod <> n.patrolperiod
        or o.powerontime <> n.powerontime
        or o.powerdowntime <> n.powerdowntime
        or o.atmcsoft <> n.atmcsoft
        or o.packetsize <> n.packetsize
        or o.nettype <> n.nettype
        or o.selfbanktype <> n.selfbanktype
        or o.devcatalog <> n.devcatalog
        or o.devvendor <> n.devvendor
        or o.installdate <> n.installdate
        or o.atmparea <> n.atmparea
        or o.brnname <> n.brnname
        or o.buydate <> n.buydate
        or o.enctype <> n.enctype
        or o.authcode <> n.authcode
        or o.status <> n.status
        or o.apltlrname <> n.apltlrname
        or o.applydate <> n.applydate
        or o.applyteller <> n.applyteller
        or o.atmcashboxno <> n.atmcashboxno
        or o.cashboxno <> n.cashboxno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubcardequip_cl(
            termid -- 设备ID
            ,unit -- 机构编码
            ,tell -- 操作员号
            ,addr -- 设备安装地点
            ,ipaddr -- 设备IP地址
            ,type -- 设备类型
            ,lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
            ,equipstat -- 设备状态
            ,module1 -- 模块1状态(币值1状态)
            ,module2 -- 模块2状态(币值2状态)
            ,module3 -- 模块3状态(币值3状态)
            ,module4 -- 模块4状态(币值4状态)
            ,othmod -- 设备模块状态
            ,sflag -- 签到标志
            ,trskey -- 传输密钥
            ,filldate -- 上次补钞日期时间
            ,lastaddamt -- 最后一次补钞尾箱余额
            ,currvalue1 -- 币值1面值
            ,currvalue2 -- 币值2面值
            ,currvalue3 -- 币值3面值
            ,currvalue4 -- 币值4面值
            ,lastfill1 -- ATM上次币值1补钞数
            ,lastfill2 -- ATM上次币值2补钞数
            ,lastfill3 -- ATM上次币值3补钞数
            ,lastfill4 -- ATM上次币值3补钞数
            ,periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
            ,periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
            ,periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
            ,periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
            ,cutdate -- 上次日终时间
            ,cutprst1 -- 日终周期币值1出入钞数
            ,cutprst2 -- 日终周期币值2出入钞数
            ,cutprst3 -- 日终周期币值3出入钞数
            ,cutprst4 -- 日终周期币值4出入钞数
            ,cwdnum -- 日终周期取款数
            ,cwdsum -- 日终周期取款金额
            ,depnum -- 日终周期存款数
            ,depsum -- 日终周期存款金额
            ,tfrnum -- 日终周期转帐数
            ,tfrsum -- 日终周期转帐金额
            ,cardret -- 日终周期吞卡数
            ,zmkey -- 本地主密钥
            ,zakey -- MAC工作密钥
            ,machinekey -- 装机码
            ,devtype -- 设备型号
            ,begindatetime -- 验证有效期：开始时间
            ,enddatetime -- 验证有效期：结束时间
            ,remainno -- 重试次数
            ,lastopttime -- 上次操作时间
            ,awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
            ,worktype -- 经营方式 1-自营 2-联营
            ,setuptype -- 安装方式 0-穿墙 1-大堂
            ,cashboxlimit -- 钱箱报警金额
            ,devservice -- 设备维护商
            ,serial -- 设备序列号
            ,startdate -- 设备启用日期
            ,stopdate -- 设备停用日期
            ,expiredate -- 保修到期日期
            ,patrolperiod -- 巡检周期 单位/天
            ,powerontime -- 每日开机时间
            ,powerdowntime -- 每日关机时间
            ,atmcsoft -- ATMC软件
            ,packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
            ,nettype -- 联网类型 C：cable有线 W：wireless无线
            ,selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
            ,devcatalog -- 设备属性
            ,devvendor -- 设备品牌
            ,installdate -- 设备安装日期
            ,atmparea -- 银联标准地区代码
            ,brnname -- 机构名称
            ,buydate -- 购机日期
            ,enctype -- 加密方式 0-国密 1或空非国密
            ,authcode -- 申请主密钥认证码(8位装机码)
            ,status -- 
            ,apltlrname -- 申请柜员名字
            ,applydate -- 申请加钞日期
            ,applyteller -- 申请加钞柜员
            ,atmcashboxno -- ATM机尾箱号
            ,cashboxno -- 加钞尾箱号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubcardequip_op(
            termid -- 设备ID
            ,unit -- 机构编码
            ,tell -- 操作员号
            ,addr -- 设备安装地点
            ,ipaddr -- 设备IP地址
            ,type -- 设备类型
            ,lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
            ,equipstat -- 设备状态
            ,module1 -- 模块1状态(币值1状态)
            ,module2 -- 模块2状态(币值2状态)
            ,module3 -- 模块3状态(币值3状态)
            ,module4 -- 模块4状态(币值4状态)
            ,othmod -- 设备模块状态
            ,sflag -- 签到标志
            ,trskey -- 传输密钥
            ,filldate -- 上次补钞日期时间
            ,lastaddamt -- 最后一次补钞尾箱余额
            ,currvalue1 -- 币值1面值
            ,currvalue2 -- 币值2面值
            ,currvalue3 -- 币值3面值
            ,currvalue4 -- 币值4面值
            ,lastfill1 -- ATM上次币值1补钞数
            ,lastfill2 -- ATM上次币值2补钞数
            ,lastfill3 -- ATM上次币值3补钞数
            ,lastfill4 -- ATM上次币值3补钞数
            ,periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
            ,periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
            ,periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
            ,periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
            ,cutdate -- 上次日终时间
            ,cutprst1 -- 日终周期币值1出入钞数
            ,cutprst2 -- 日终周期币值2出入钞数
            ,cutprst3 -- 日终周期币值3出入钞数
            ,cutprst4 -- 日终周期币值4出入钞数
            ,cwdnum -- 日终周期取款数
            ,cwdsum -- 日终周期取款金额
            ,depnum -- 日终周期存款数
            ,depsum -- 日终周期存款金额
            ,tfrnum -- 日终周期转帐数
            ,tfrsum -- 日终周期转帐金额
            ,cardret -- 日终周期吞卡数
            ,zmkey -- 本地主密钥
            ,zakey -- MAC工作密钥
            ,machinekey -- 装机码
            ,devtype -- 设备型号
            ,begindatetime -- 验证有效期：开始时间
            ,enddatetime -- 验证有效期：结束时间
            ,remainno -- 重试次数
            ,lastopttime -- 上次操作时间
            ,awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
            ,worktype -- 经营方式 1-自营 2-联营
            ,setuptype -- 安装方式 0-穿墙 1-大堂
            ,cashboxlimit -- 钱箱报警金额
            ,devservice -- 设备维护商
            ,serial -- 设备序列号
            ,startdate -- 设备启用日期
            ,stopdate -- 设备停用日期
            ,expiredate -- 保修到期日期
            ,patrolperiod -- 巡检周期 单位/天
            ,powerontime -- 每日开机时间
            ,powerdowntime -- 每日关机时间
            ,atmcsoft -- ATMC软件
            ,packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
            ,nettype -- 联网类型 C：cable有线 W：wireless无线
            ,selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
            ,devcatalog -- 设备属性
            ,devvendor -- 设备品牌
            ,installdate -- 设备安装日期
            ,atmparea -- 银联标准地区代码
            ,brnname -- 机构名称
            ,buydate -- 购机日期
            ,enctype -- 加密方式 0-国密 1或空非国密
            ,authcode -- 申请主密钥认证码(8位装机码)
            ,status -- 
            ,apltlrname -- 申请柜员名字
            ,applydate -- 申请加钞日期
            ,applyteller -- 申请加钞柜员
            ,atmcashboxno -- ATM机尾箱号
            ,cashboxno -- 加钞尾箱号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.termid -- 设备ID
    ,o.unit -- 机构编码
    ,o.tell -- 操作员号
    ,o.addr -- 设备安装地点
    ,o.ipaddr -- 设备IP地址
    ,o.type -- 设备类型
    ,o.lastdate -- 最后一次开启或关闭时间（YYMMDDHHMM）
    ,o.equipstat -- 设备状态
    ,o.module1 -- 模块1状态(币值1状态)
    ,o.module2 -- 模块2状态(币值2状态)
    ,o.module3 -- 模块3状态(币值3状态)
    ,o.module4 -- 模块4状态(币值4状态)
    ,o.othmod -- 设备模块状态
    ,o.sflag -- 签到标志
    ,o.trskey -- 传输密钥
    ,o.filldate -- 上次补钞日期时间
    ,o.lastaddamt -- 最后一次补钞尾箱余额
    ,o.currvalue1 -- 币值1面值
    ,o.currvalue2 -- 币值2面值
    ,o.currvalue3 -- 币值3面值
    ,o.currvalue4 -- 币值4面值
    ,o.lastfill1 -- ATM上次币值1补钞数
    ,o.lastfill2 -- ATM上次币值2补钞数
    ,o.lastfill3 -- ATM上次币值3补钞数
    ,o.lastfill4 -- ATM上次币值3补钞数
    ,o.periprst1 -- ATM补钞周期币值1出钞数/CDM币值1存钞数
    ,o.periprst2 -- ATM补钞周期币值2出钞数/CDM币值2存钞数
    ,o.periprst3 -- ATM补钞周期币值3出钞数/CDM币值3存钞数
    ,o.periprst4 -- ATM补钞周期币值4出钞数/CDM币值4存钞数
    ,o.cutdate -- 上次日终时间
    ,o.cutprst1 -- 日终周期币值1出入钞数
    ,o.cutprst2 -- 日终周期币值2出入钞数
    ,o.cutprst3 -- 日终周期币值3出入钞数
    ,o.cutprst4 -- 日终周期币值4出入钞数
    ,o.cwdnum -- 日终周期取款数
    ,o.cwdsum -- 日终周期取款金额
    ,o.depnum -- 日终周期存款数
    ,o.depsum -- 日终周期存款金额
    ,o.tfrnum -- 日终周期转帐数
    ,o.tfrsum -- 日终周期转帐金额
    ,o.cardret -- 日终周期吞卡数
    ,o.zmkey -- 本地主密钥
    ,o.zakey -- MAC工作密钥
    ,o.machinekey -- 装机码
    ,o.devtype -- 设备型号
    ,o.begindatetime -- 验证有效期：开始时间
    ,o.enddatetime -- 验证有效期：结束时间
    ,o.remainno -- 重试次数
    ,o.lastopttime -- 上次操作时间
    ,o.awayflag -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
    ,o.worktype -- 经营方式 1-自营 2-联营
    ,o.setuptype -- 安装方式 0-穿墙 1-大堂
    ,o.cashboxlimit -- 钱箱报警金额
    ,o.devservice -- 设备维护商
    ,o.serial -- 设备序列号
    ,o.startdate -- 设备启用日期
    ,o.stopdate -- 设备停用日期
    ,o.expiredate -- 保修到期日期
    ,o.patrolperiod -- 巡检周期 单位/天
    ,o.powerontime -- 每日开机时间
    ,o.powerdowntime -- 每日关机时间
    ,o.atmcsoft -- ATMC软件
    ,o.packetsize -- 传输包大小 有线设备初始8000 无线设备初始256
    ,o.nettype -- 联网类型 C：cable有线 W：wireless无线
    ,o.selfbanktype -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
    ,o.devcatalog -- 设备属性
    ,o.devvendor -- 设备品牌
    ,o.installdate -- 设备安装日期
    ,o.atmparea -- 银联标准地区代码
    ,o.brnname -- 机构名称
    ,o.buydate -- 购机日期
    ,o.enctype -- 加密方式 0-国密 1或空非国密
    ,o.authcode -- 申请主密钥认证码(8位装机码)
    ,o.status -- 
    ,o.apltlrname -- 申请柜员名字
    ,o.applydate -- 申请加钞日期
    ,o.applyteller -- 申请加钞柜员
    ,o.atmcashboxno -- ATM机尾箱号
    ,o.cashboxno -- 加钞尾箱号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a50ubcardequip_bk o
    left join ${iol_schema}.mpcs_a50ubcardequip_op n
        on
            o.termid = n.termid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a50ubcardequip_cl d
        on
            o.termid = d.termid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a50ubcardequip;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a50ubcardequip') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a50ubcardequip drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a50ubcardequip add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a50ubcardequip exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a50ubcardequip_cl;
alter table ${iol_schema}.mpcs_a50ubcardequip exchange partition p_20991231 with table ${iol_schema}.mpcs_a50ubcardequip_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ubcardequip to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubcardequip_op purge;
drop table ${iol_schema}.mpcs_a50ubcardequip_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a50ubcardequip_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ubcardequip',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
