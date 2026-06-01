/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_event_fsmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_event_fsmsi1_tm purge;
alter table ${iml_schema}.evt_event add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_event modify partition p_fsmsi1
    add subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_event_fsmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_event_id -- 源事件编号
    ,event_type_cd -- 事件类型代码
    ,event_dt -- 事件日期
    ,event_tm -- 事件时间
    ,event_tx_code -- 事件交易码
    ,event_chn_id -- 事件渠道编号
    ,event_teller_id -- 事件柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_event
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fsms_yeb_ack_trans_his-
insert into ${iml_schema}.evt_event_fsmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_event_id -- 源事件编号
    ,event_type_cd -- 事件类型代码
    ,event_dt -- 事件日期
    ,event_tm -- 事件时间
    ,event_tx_code -- 事件交易码
    ,event_chn_id -- 事件渠道编号
    ,event_teller_id -- 事件柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102058'||TRANSACTIONCFMDATE||TASERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TASERIALNO -- 源事件编号
    ,'102058' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSACTIONCFMDATE) -- 事件日期
    ,' ' -- 事件时间
    ,' ' -- 事件交易码
    ,' ' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_ack_trans_his' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_ack_trans_his p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.TRANSACTIONCFMDATE='${batch_date}'
;
commit;

-- fsms_yeb_app_moneyall-
insert into ${iml_schema}.evt_event_fsmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_event_id -- 源事件编号
    ,event_type_cd -- 事件类型代码
    ,event_dt -- 事件日期
    ,event_tm -- 事件时间
    ,event_tx_code -- 事件交易码
    ,event_chn_id -- 事件渠道编号
    ,event_teller_id -- 事件柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102054'||P1.MONEYSERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MONEYSERIALNO -- 源事件编号
    ,'102054' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANSACTIONDATE) -- 事件日期
    ,P1.TRANSACTIONTIME -- 事件时间
    ,'' -- 事件交易码
    ,'' -- 事件渠道编号
    ,'' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_app_moneyall' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_app_moneyall p1
where  1 = 1 
    and P1.NEWDATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_event truncate subpartition p_fsmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_event exchange subpartition p_fsmsi1_${batch_date} with table ${iml_schema}.evt_event_fsmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_event to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_event_fsmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_event', partname => 'p_fsmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);