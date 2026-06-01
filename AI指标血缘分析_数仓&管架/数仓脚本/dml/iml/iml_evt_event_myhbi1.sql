/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_event_myhbi1
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
drop table ${iml_schema}.evt_event_myhbi1_tm purge;
alter table ${iml_schema}.evt_event add partition p_myhbi1 values ('myhbi1')(
        subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_event modify partition p_myhbi1
    add subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_event_myhbi1_tm
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
-- myhb_istmnt_repay_detail-
insert into ${iml_schema}.evt_event_myhbi1_tm(
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
    '102004'||${batch_date}||P1.CONTRACT_NO||P1.SEQ_NO||lpad(P1.TERM_NO,3,'0')||P1.REPAY_TYPE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 源事件编号
    ,'102004' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MAX(SUBSTR(P1.REPAY_DATE,1,10)) -- 事件日期
    ,SUBSTR(P1.REPAY_DATE,1,10) -- 事件时间
    ,' ' -- 事件交易码
    ,' ' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myhb_istmnt_repay_detail' -- 源表名称
    ,'myhbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myhb_istmnt_repay_detail p1
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd') and replace(substr(P1.REPAY_DATE,1,10),'-','')='${batch_date}'
;
commit;

-- rcrs_myhb_repay_detail-
insert into ${iml_schema}.evt_event_myhbi1_tm(
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
    case when length（'102004'||P1.SEQ_NO||P1.CONTRACT_NO)>60 then '102004'||substr(P1.SEQ_NO||P1.CONTRACT_NO,-54) else '102004'||P1.SEQ_NO||P1.CONTRACT_NO end -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 源事件编号
    ,'102004' -- 事件类型代码
    ,${iml_schema}.DATEFORMAT_MAX(substr(P1.REPAY_DATE,1,10)) -- 事件日期
    ,' ' -- 事件时间
    ,' ' -- 事件交易码
    ,' ' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myhb_repay_detail' -- 源表名称
    ,'myhbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myhb_repay_detail p1
where  1 = 1 
    and replace(substr(P1.REPAY_DATE,1,10),'-','')='${batch_date}'
and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_event truncate subpartition p_myhbi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_event exchange subpartition p_myhbi1_${batch_date} with table ${iml_schema}.evt_event_myhbi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_event to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_event_myhbi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_event', partname => 'p_myhbi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);