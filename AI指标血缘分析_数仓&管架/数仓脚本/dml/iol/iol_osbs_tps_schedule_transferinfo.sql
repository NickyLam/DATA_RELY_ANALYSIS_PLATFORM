/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_tps_schedule_transferinfo
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
create table ${iol_schema}.osbs_tps_schedule_transferinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_tps_schedule_transferinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo_op purge;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_schedule_transferinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_schedule_transferinfo where 0=1;

create table ${iol_schema}.osbs_tps_schedule_transferinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_tps_schedule_transferinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_schedule_transferinfo_cl(
            tst_schedule_no -- 计划编号
            ,tst_ecifno -- 全行统一客户号
            ,tst_userno -- 用户顺序号
            ,tst_transcode -- 交易码
            ,tst_payaccno -- 付款账号
            ,tst_payaccname -- 付款账户名称
            ,tst_payerdeptid -- 付款方行号
            ,tst_payacctype -- 付款账户类型
            ,tst_paycurrency -- 转出币种
            ,tst_rcvaccno -- 收款账号
            ,tst_rcvaccname -- 收款账号名称
            ,tst_rcvacctype -- 收款账户类型
            ,tst_amount -- 转出金额
            ,tst_remark -- 附言
            ,tst_fee -- 费用
            ,tst_isnormal -- 是否加急
            ,tst_rcvcurrency -- 收款人币种
            ,tst_rcvbankid -- 收款人银行代码
            ,tst_rcvbankname -- 收款人银行名称
            ,tst_provincecode -- 收款人省份
            ,tst_provincename -- 收款人省份名称
            ,tst_citycode -- 收款人城市代码
            ,tst_cityname -- 收款人城市名称
            ,tst_rcvbankbranch -- 收款人网点
            ,tst_rcvbankbranchname -- 收款人网点名称
            ,tst_clearingnode -- 收款人清算行号
            ,tst_rcvmobile -- 收款人手机号码
            ,tst_rcvsms -- SMS
            ,tst_notemsg -- 摘要
            ,tst_finalfee -- 最终手续费
            ,tst_discount -- 折扣
            ,tst_notifyrcv -- 是否通知收款人
            ,tst_savercv -- 是否保存收款人
            ,tst_ciftype -- 账户类型
            ,tst_rcvaccnickname -- 收款人昵称
            ,tst_mobileno -- 转账手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_schedule_transferinfo_op(
            tst_schedule_no -- 计划编号
            ,tst_ecifno -- 全行统一客户号
            ,tst_userno -- 用户顺序号
            ,tst_transcode -- 交易码
            ,tst_payaccno -- 付款账号
            ,tst_payaccname -- 付款账户名称
            ,tst_payerdeptid -- 付款方行号
            ,tst_payacctype -- 付款账户类型
            ,tst_paycurrency -- 转出币种
            ,tst_rcvaccno -- 收款账号
            ,tst_rcvaccname -- 收款账号名称
            ,tst_rcvacctype -- 收款账户类型
            ,tst_amount -- 转出金额
            ,tst_remark -- 附言
            ,tst_fee -- 费用
            ,tst_isnormal -- 是否加急
            ,tst_rcvcurrency -- 收款人币种
            ,tst_rcvbankid -- 收款人银行代码
            ,tst_rcvbankname -- 收款人银行名称
            ,tst_provincecode -- 收款人省份
            ,tst_provincename -- 收款人省份名称
            ,tst_citycode -- 收款人城市代码
            ,tst_cityname -- 收款人城市名称
            ,tst_rcvbankbranch -- 收款人网点
            ,tst_rcvbankbranchname -- 收款人网点名称
            ,tst_clearingnode -- 收款人清算行号
            ,tst_rcvmobile -- 收款人手机号码
            ,tst_rcvsms -- SMS
            ,tst_notemsg -- 摘要
            ,tst_finalfee -- 最终手续费
            ,tst_discount -- 折扣
            ,tst_notifyrcv -- 是否通知收款人
            ,tst_savercv -- 是否保存收款人
            ,tst_ciftype -- 账户类型
            ,tst_rcvaccnickname -- 收款人昵称
            ,tst_mobileno -- 转账手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tst_schedule_no, o.tst_schedule_no) as tst_schedule_no -- 计划编号
    ,nvl(n.tst_ecifno, o.tst_ecifno) as tst_ecifno -- 全行统一客户号
    ,nvl(n.tst_userno, o.tst_userno) as tst_userno -- 用户顺序号
    ,nvl(n.tst_transcode, o.tst_transcode) as tst_transcode -- 交易码
    ,nvl(n.tst_payaccno, o.tst_payaccno) as tst_payaccno -- 付款账号
    ,nvl(n.tst_payaccname, o.tst_payaccname) as tst_payaccname -- 付款账户名称
    ,nvl(n.tst_payerdeptid, o.tst_payerdeptid) as tst_payerdeptid -- 付款方行号
    ,nvl(n.tst_payacctype, o.tst_payacctype) as tst_payacctype -- 付款账户类型
    ,nvl(n.tst_paycurrency, o.tst_paycurrency) as tst_paycurrency -- 转出币种
    ,nvl(n.tst_rcvaccno, o.tst_rcvaccno) as tst_rcvaccno -- 收款账号
    ,nvl(n.tst_rcvaccname, o.tst_rcvaccname) as tst_rcvaccname -- 收款账号名称
    ,nvl(n.tst_rcvacctype, o.tst_rcvacctype) as tst_rcvacctype -- 收款账户类型
    ,nvl(n.tst_amount, o.tst_amount) as tst_amount -- 转出金额
    ,nvl(n.tst_remark, o.tst_remark) as tst_remark -- 附言
    ,nvl(n.tst_fee, o.tst_fee) as tst_fee -- 费用
    ,nvl(n.tst_isnormal, o.tst_isnormal) as tst_isnormal -- 是否加急
    ,nvl(n.tst_rcvcurrency, o.tst_rcvcurrency) as tst_rcvcurrency -- 收款人币种
    ,nvl(n.tst_rcvbankid, o.tst_rcvbankid) as tst_rcvbankid -- 收款人银行代码
    ,nvl(n.tst_rcvbankname, o.tst_rcvbankname) as tst_rcvbankname -- 收款人银行名称
    ,nvl(n.tst_provincecode, o.tst_provincecode) as tst_provincecode -- 收款人省份
    ,nvl(n.tst_provincename, o.tst_provincename) as tst_provincename -- 收款人省份名称
    ,nvl(n.tst_citycode, o.tst_citycode) as tst_citycode -- 收款人城市代码
    ,nvl(n.tst_cityname, o.tst_cityname) as tst_cityname -- 收款人城市名称
    ,nvl(n.tst_rcvbankbranch, o.tst_rcvbankbranch) as tst_rcvbankbranch -- 收款人网点
    ,nvl(n.tst_rcvbankbranchname, o.tst_rcvbankbranchname) as tst_rcvbankbranchname -- 收款人网点名称
    ,nvl(n.tst_clearingnode, o.tst_clearingnode) as tst_clearingnode -- 收款人清算行号
    ,nvl(n.tst_rcvmobile, o.tst_rcvmobile) as tst_rcvmobile -- 收款人手机号码
    ,nvl(n.tst_rcvsms, o.tst_rcvsms) as tst_rcvsms -- SMS
    ,nvl(n.tst_notemsg, o.tst_notemsg) as tst_notemsg -- 摘要
    ,nvl(n.tst_finalfee, o.tst_finalfee) as tst_finalfee -- 最终手续费
    ,nvl(n.tst_discount, o.tst_discount) as tst_discount -- 折扣
    ,nvl(n.tst_notifyrcv, o.tst_notifyrcv) as tst_notifyrcv -- 是否通知收款人
    ,nvl(n.tst_savercv, o.tst_savercv) as tst_savercv -- 是否保存收款人
    ,nvl(n.tst_ciftype, o.tst_ciftype) as tst_ciftype -- 账户类型
    ,nvl(n.tst_rcvaccnickname, o.tst_rcvaccnickname) as tst_rcvaccnickname -- 收款人昵称
    ,nvl(n.tst_mobileno, o.tst_mobileno) as tst_mobileno -- 转账手机号码
    ,case when
            n.tst_schedule_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tst_schedule_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tst_schedule_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_tps_schedule_transferinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_tps_schedule_transferinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tst_schedule_no = n.tst_schedule_no
where (
        o.tst_schedule_no is null
    )
    or (
        n.tst_schedule_no is null
    )
    or (
        o.tst_ecifno <> n.tst_ecifno
        or o.tst_userno <> n.tst_userno
        or o.tst_transcode <> n.tst_transcode
        or o.tst_payaccno <> n.tst_payaccno
        or o.tst_payaccname <> n.tst_payaccname
        or o.tst_payerdeptid <> n.tst_payerdeptid
        or o.tst_payacctype <> n.tst_payacctype
        or o.tst_paycurrency <> n.tst_paycurrency
        or o.tst_rcvaccno <> n.tst_rcvaccno
        or o.tst_rcvaccname <> n.tst_rcvaccname
        or o.tst_rcvacctype <> n.tst_rcvacctype
        or o.tst_amount <> n.tst_amount
        or o.tst_remark <> n.tst_remark
        or o.tst_fee <> n.tst_fee
        or o.tst_isnormal <> n.tst_isnormal
        or o.tst_rcvcurrency <> n.tst_rcvcurrency
        or o.tst_rcvbankid <> n.tst_rcvbankid
        or o.tst_rcvbankname <> n.tst_rcvbankname
        or o.tst_provincecode <> n.tst_provincecode
        or o.tst_provincename <> n.tst_provincename
        or o.tst_citycode <> n.tst_citycode
        or o.tst_cityname <> n.tst_cityname
        or o.tst_rcvbankbranch <> n.tst_rcvbankbranch
        or o.tst_rcvbankbranchname <> n.tst_rcvbankbranchname
        or o.tst_clearingnode <> n.tst_clearingnode
        or o.tst_rcvmobile <> n.tst_rcvmobile
        or o.tst_rcvsms <> n.tst_rcvsms
        or o.tst_notemsg <> n.tst_notemsg
        or o.tst_finalfee <> n.tst_finalfee
        or o.tst_discount <> n.tst_discount
        or o.tst_notifyrcv <> n.tst_notifyrcv
        or o.tst_savercv <> n.tst_savercv
        or o.tst_ciftype <> n.tst_ciftype
        or o.tst_rcvaccnickname <> n.tst_rcvaccnickname
        or o.tst_mobileno <> n.tst_mobileno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_tps_schedule_transferinfo_cl(
            tst_schedule_no -- 计划编号
            ,tst_ecifno -- 全行统一客户号
            ,tst_userno -- 用户顺序号
            ,tst_transcode -- 交易码
            ,tst_payaccno -- 付款账号
            ,tst_payaccname -- 付款账户名称
            ,tst_payerdeptid -- 付款方行号
            ,tst_payacctype -- 付款账户类型
            ,tst_paycurrency -- 转出币种
            ,tst_rcvaccno -- 收款账号
            ,tst_rcvaccname -- 收款账号名称
            ,tst_rcvacctype -- 收款账户类型
            ,tst_amount -- 转出金额
            ,tst_remark -- 附言
            ,tst_fee -- 费用
            ,tst_isnormal -- 是否加急
            ,tst_rcvcurrency -- 收款人币种
            ,tst_rcvbankid -- 收款人银行代码
            ,tst_rcvbankname -- 收款人银行名称
            ,tst_provincecode -- 收款人省份
            ,tst_provincename -- 收款人省份名称
            ,tst_citycode -- 收款人城市代码
            ,tst_cityname -- 收款人城市名称
            ,tst_rcvbankbranch -- 收款人网点
            ,tst_rcvbankbranchname -- 收款人网点名称
            ,tst_clearingnode -- 收款人清算行号
            ,tst_rcvmobile -- 收款人手机号码
            ,tst_rcvsms -- SMS
            ,tst_notemsg -- 摘要
            ,tst_finalfee -- 最终手续费
            ,tst_discount -- 折扣
            ,tst_notifyrcv -- 是否通知收款人
            ,tst_savercv -- 是否保存收款人
            ,tst_ciftype -- 账户类型
            ,tst_rcvaccnickname -- 收款人昵称
            ,tst_mobileno -- 转账手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_tps_schedule_transferinfo_op(
            tst_schedule_no -- 计划编号
            ,tst_ecifno -- 全行统一客户号
            ,tst_userno -- 用户顺序号
            ,tst_transcode -- 交易码
            ,tst_payaccno -- 付款账号
            ,tst_payaccname -- 付款账户名称
            ,tst_payerdeptid -- 付款方行号
            ,tst_payacctype -- 付款账户类型
            ,tst_paycurrency -- 转出币种
            ,tst_rcvaccno -- 收款账号
            ,tst_rcvaccname -- 收款账号名称
            ,tst_rcvacctype -- 收款账户类型
            ,tst_amount -- 转出金额
            ,tst_remark -- 附言
            ,tst_fee -- 费用
            ,tst_isnormal -- 是否加急
            ,tst_rcvcurrency -- 收款人币种
            ,tst_rcvbankid -- 收款人银行代码
            ,tst_rcvbankname -- 收款人银行名称
            ,tst_provincecode -- 收款人省份
            ,tst_provincename -- 收款人省份名称
            ,tst_citycode -- 收款人城市代码
            ,tst_cityname -- 收款人城市名称
            ,tst_rcvbankbranch -- 收款人网点
            ,tst_rcvbankbranchname -- 收款人网点名称
            ,tst_clearingnode -- 收款人清算行号
            ,tst_rcvmobile -- 收款人手机号码
            ,tst_rcvsms -- SMS
            ,tst_notemsg -- 摘要
            ,tst_finalfee -- 最终手续费
            ,tst_discount -- 折扣
            ,tst_notifyrcv -- 是否通知收款人
            ,tst_savercv -- 是否保存收款人
            ,tst_ciftype -- 账户类型
            ,tst_rcvaccnickname -- 收款人昵称
            ,tst_mobileno -- 转账手机号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tst_schedule_no -- 计划编号
    ,o.tst_ecifno -- 全行统一客户号
    ,o.tst_userno -- 用户顺序号
    ,o.tst_transcode -- 交易码
    ,o.tst_payaccno -- 付款账号
    ,o.tst_payaccname -- 付款账户名称
    ,o.tst_payerdeptid -- 付款方行号
    ,o.tst_payacctype -- 付款账户类型
    ,o.tst_paycurrency -- 转出币种
    ,o.tst_rcvaccno -- 收款账号
    ,o.tst_rcvaccname -- 收款账号名称
    ,o.tst_rcvacctype -- 收款账户类型
    ,o.tst_amount -- 转出金额
    ,o.tst_remark -- 附言
    ,o.tst_fee -- 费用
    ,o.tst_isnormal -- 是否加急
    ,o.tst_rcvcurrency -- 收款人币种
    ,o.tst_rcvbankid -- 收款人银行代码
    ,o.tst_rcvbankname -- 收款人银行名称
    ,o.tst_provincecode -- 收款人省份
    ,o.tst_provincename -- 收款人省份名称
    ,o.tst_citycode -- 收款人城市代码
    ,o.tst_cityname -- 收款人城市名称
    ,o.tst_rcvbankbranch -- 收款人网点
    ,o.tst_rcvbankbranchname -- 收款人网点名称
    ,o.tst_clearingnode -- 收款人清算行号
    ,o.tst_rcvmobile -- 收款人手机号码
    ,o.tst_rcvsms -- SMS
    ,o.tst_notemsg -- 摘要
    ,o.tst_finalfee -- 最终手续费
    ,o.tst_discount -- 折扣
    ,o.tst_notifyrcv -- 是否通知收款人
    ,o.tst_savercv -- 是否保存收款人
    ,o.tst_ciftype -- 账户类型
    ,o.tst_rcvaccnickname -- 收款人昵称
    ,o.tst_mobileno -- 转账手机号码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.osbs_tps_schedule_transferinfo_bk o
    left join ${iol_schema}.osbs_tps_schedule_transferinfo_op n
        on
            o.tst_schedule_no = n.tst_schedule_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_tps_schedule_transferinfo_cl d
        on
            o.tst_schedule_no = d.tst_schedule_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.osbs_tps_schedule_transferinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.osbs_tps_schedule_transferinfo exchange partition p_19000101 with table ${iol_schema}.osbs_tps_schedule_transferinfo_cl;
alter table ${iol_schema}.osbs_tps_schedule_transferinfo exchange partition p_20991231 with table ${iol_schema}.osbs_tps_schedule_transferinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_tps_schedule_transferinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo_op purge;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_tps_schedule_transferinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
