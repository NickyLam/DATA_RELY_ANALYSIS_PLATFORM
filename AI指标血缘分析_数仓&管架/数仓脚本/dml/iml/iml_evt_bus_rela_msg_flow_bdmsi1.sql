/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bus_rela_msg_flow_bdmsi1
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
drop table ${iml_schema}.evt_bus_rela_msg_flow_bdmsi1_tm purge;
alter table ${iml_schema}.evt_bus_rela_msg_flow add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bus_rela_msg_flow modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bus_rela_msg_flow_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_msg_flow_num -- 业务报文流水号
    ,msg_analy_id -- 报文解析编号
    ,tran_sender -- 交易发送方
    ,tran_recver -- 交易接收方
    ,msg_ind_no -- 报文标识号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,msg_id -- 报文编号
    ,tran_status_cd -- 交易状态代码
    ,msg_dir_cd -- 报文方向代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bus_rela_msg_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_htes_buss_msg_log-
insert into ${iml_schema}.evt_bus_rela_msg_flow_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_msg_flow_num -- 业务报文流水号
    ,msg_analy_id -- 报文解析编号
    ,tran_sender -- 交易发送方
    ,tran_recver -- 交易接收方
    ,msg_ind_no -- 报文标识号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,msg_id -- 报文编号
    ,tran_status_cd -- 交易状态代码
    ,msg_dir_cd -- 报文方向代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201001'||P1.MSG_DT||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 业务报文流水号
    ,P1.BUSS_ID -- 报文解析编号
    ,P1.TXN_SENDER -- 交易发送方
    ,P1.TXN_RCEIVER -- 交易接收方
    ,P1.MSG_ID -- 报文标识号
    ,${iml_schema}.DATEFORMAT_MIN(P1.MSG_DT) -- 交易日期
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.MSG_TM),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 交易时间
    ,P1.MSG_NO -- 报文编号
    ,NVL(TRIM(P1.TXN_STATUS),'-') -- 交易状态代码
    ,NVL(TRIM(P1.BUSS_FLAG),'00') -- 报文方向代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_htes_buss_msg_log' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_htes_buss_msg_log p1
where  1 = 1 
    AND to_char(p1.msg_dt)= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bus_rela_msg_flow truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bus_rela_msg_flow exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bus_rela_msg_flow_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bus_rela_msg_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bus_rela_msg_flow_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bus_rela_msg_flow', partname => 'p_bdmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);