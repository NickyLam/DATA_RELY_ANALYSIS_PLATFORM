/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_event_ifcsi1
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
drop table ${iml_schema}.evt_event_ifcsi1_tm purge;
alter table ${iml_schema}.evt_event add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_event modify partition p_ifcsi1
    add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_event_ifcsi1_tm
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
-- ifcs_acct_tran_dtl-
insert into ${iml_schema}.evt_event_ifcsi1_tm(
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
    '102027'||P1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_FLOW_NUM -- 源事件编号
    ,'102027' -- 事件类型代码
    ,${iml_schema}.dateformat_min(P1.TRAN_DT) -- 事件日期
    ,P1.TRAN_TM -- 事件时间
    ,P1.TRAN_TYPE_CD -- 事件交易码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRAN_CHN_CD END -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_acct_tran_dtl' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_acct_tran_dtl p1
left join ${iml_schema}.REF_PUB_CD_MAP R1 ON P1.TRAN_CHN_CD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFCS'
        AND R1.SRC_TAB_EN_NAME= 'IFCS_ACCT_TRAN_DTL'
        AND R1.SRC_FIELD_EN_NAME= 'TRAN_CHN_CD'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_EVENT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EVENT_CHN_ID'
where  1 = 1 
    and p1.etl_dt=to_date(${batch_date},'yyyymmdd')
    and p1.tran_dt= '${batch_date}'
;
commit;

-- ifcs_dep_prod_acct_tran_dtl-
insert into ${iml_schema}.evt_event_ifcsi1_tm(
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
    '102028'||P1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_FLOW_NUM -- 源事件编号
    ,'102028' -- 事件类型代码
    ,${iml_schema}.dateformat_min(P1.TRAN_DT) -- 事件日期
    ,P1.TRAN_TM -- 事件时间
    ,P1.TRAN_TYPE_CD -- 事件交易码
    ,P1.TRAN_CHN_CD -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_prod_acct_tran_dtl' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_dep_prod_acct_tran_dtl p1
where  1 = 1 
    and etl_dt=to_date(${batch_date},'yyyymmdd')
    and p1.tran_dt= '${batch_date}'
;
commit;

-- ifcs_dep_provi_rgst_b-
insert into ${iml_schema}.evt_event_ifcsi1_tm(
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
    '102029'||P1.TRAN_DT||P1.DEP_ACCT_ID||P1.DEP_PROD_SUB_ACCT_ID||P1.PROD_ID||NVL(P1.TRAN_STATUS_CD,'-') -- 事件编号
    ,'9999' -- 法人编号
    ,' ' -- 源事件编号
    ,'102029' -- 事件类型代码
    ,${iml_schema}.dateformat_min(P1.TRAN_DT) -- 事件日期
    ,' ' -- 事件时间
    ,' ' -- 事件交易码
    ,' ' -- 事件渠道编号
    ,' ' -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_provi_rgst_b' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_dep_provi_rgst_b p1
where  1 = 1 
    and p1.tran_dt= '${batch_date}'
;
commit;

-- ifcs_jud_remit_rgst_b-
insert into ${iml_schema}.evt_event_ifcsi1_tm(
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
    '102032'||p1.REMIT_DT||p1.REMIT_FLOW_NUM||p1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,REMIT_FLOW_NUM -- 源事件编号
    ,'102032' -- 事件类型代码
    ,${iml_schema}.dateformat_min(P1.REMIT_DT) -- 事件日期
    ,replace(substr(P1.REMIT_TM,10,8),':','') -- 事件时间
    ,' ' -- 事件交易码
    ,P1.REMIT_CHN -- 事件渠道编号
    ,P1.TELLER_NO -- 事件柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_jud_remit_rgst_b' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_jud_remit_rgst_b p1
where  1 = 1 
    and p1.remit_dt= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_event truncate subpartition p_ifcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_event exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.evt_event_ifcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_event to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_event_ifcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_event', partname => 'p_ifcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);