/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tquerymsg
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tquerymsg_ex purge;
alter table ${iol_schema}.mpcs_a08tquerymsg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a08tquerymsg;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a08tquerymsg_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a08tquerymsg where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a08tquerymsg_ex(
    queryseq -- 
    ,querydt -- 
    ,sndct -- 
    ,sndupbrn -- 
    ,sndbrn -- 
    ,rcvct -- 
    ,rcvupbrn -- 
    ,rcvbrn -- 
    ,transtype -- 
    ,querytype -- 
    ,status -- 
    ,processcode -- 
    ,oldmainseq -- 
    ,oldmsgtp -- 
    ,oldconsigndt -- 
    ,oldsndbrn -- 
    ,oldrcvbrn -- 
    ,oldtransseq -- 
    ,oldpksqno -- 
    ,oldcmtnum -- 
    ,oldclramt -- 
    ,ccynbr -- 
    ,info -- 
    ,repinfo -- 
    ,oprtlr -- 
    ,sndtlr -- 
    ,msgsrc -- 
    ,magebrn -- 
    ,refdid -- 
    ,msgno -- 
    ,bepsdt -- 
    ,errcode -- 
    ,errms -- 
    ,billnb -- 
    ,billpaydt -- 
    ,billdt -- 
    ,billenddt -- 
    ,billacctname -- 
    ,recvname -- 
    ,paybkname -- 
    ,ourcnapsver -- 
    ,othercnapsver -- 
    ,dealdate -- 
    ,billflag -- 
    ,chkflag -- 对账标志 0-对平 1-人行多账 2-行内状态不符
    ,snddt -- 
    ,rcvdt -- 
    ,pjcflag -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    queryseq -- 
    ,querydt -- 
    ,sndct -- 
    ,sndupbrn -- 
    ,sndbrn -- 
    ,rcvct -- 
    ,rcvupbrn -- 
    ,rcvbrn -- 
    ,transtype -- 
    ,querytype -- 
    ,status -- 
    ,processcode -- 
    ,oldmainseq -- 
    ,oldmsgtp -- 
    ,oldconsigndt -- 
    ,oldsndbrn -- 
    ,oldrcvbrn -- 
    ,oldtransseq -- 
    ,oldpksqno -- 
    ,oldcmtnum -- 
    ,oldclramt -- 
    ,ccynbr -- 
    ,info -- 
    ,repinfo -- 
    ,oprtlr -- 
    ,sndtlr -- 
    ,msgsrc -- 
    ,magebrn -- 
    ,refdid -- 
    ,msgno -- 
    ,bepsdt -- 
    ,errcode -- 
    ,errms -- 
    ,billnb -- 
    ,billpaydt -- 
    ,billdt -- 
    ,billenddt -- 
    ,billacctname -- 
    ,recvname -- 
    ,paybkname -- 
    ,ourcnapsver -- 
    ,othercnapsver -- 
    ,dealdate -- 
    ,billflag -- 
    ,chkflag -- 对账标志 0-对平 1-人行多账 2-行内状态不符
    ,snddt -- 
    ,rcvdt -- 
    ,pjcflag -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a08tquerymsg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a08tquerymsg exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a08tquerymsg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tquerymsg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a08tquerymsg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tquerymsg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);