/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_event_ifmsi1
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
drop table ${iml_schema}.evt_event_ifmsi1_tm purge;
alter table ${iml_schema}.evt_event add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_event modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_event_ifmsi1_tm
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
-- ifms_tbhissquare-1
insert into ${iml_schema}.evt_event_ifmsi1_tm(
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
    '104019'||nvl(to_char(p1.CLEAR_DATE),'00010101')||p1.SQUARE_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SQUARE_NO -- 源事件编号
    ,'104019' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CLEAR_DATE) -- 事件日期
    ,' ' -- 事件时间
    ,' ' -- 事件交易码
    ,'-' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbhissquare' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbhissquare p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and p1.start_dt=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;

-- ifms_tbtranscfm-
insert into ${iml_schema}.evt_event_ifmsi1_tm(
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
    '104004'||P1.TRANS_DATE||P1.CFM_NO||P1.TA_CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- 源事件编号
    ,'104004' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.TRANS_DATE)) -- 事件日期
    ,TO_CHAR(P1.TRANS_TIME) -- 事件时间
    ,' ' -- 事件交易码
    ,'-' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtranscfm' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbtranscfm p1
where  1 = 1 
    AND TO_CHAR(P1.TRANS_DATE)=${batch_date}
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;

-- ifms_tbtransreq-
insert into ${iml_schema}.evt_event_ifmsi1_tm(
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
    '104014'||to_char(P1.TRANS_DATE)||P1.SERIAL_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 源事件编号
    ,'104014' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANS_DATE) -- 事件日期
    ,TO_CHAR(P1.TRANS_TIME) -- 事件时间
    ,' ' -- 事件交易码
    ,'-' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtransreq' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbtransreq p1
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_event truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_event exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_event_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_event to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_event_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_event', partname => 'p_ifmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);