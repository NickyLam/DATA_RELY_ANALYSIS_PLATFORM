/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_seal_acct_mgmt_jnl_flow_svssf1
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
drop table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow_svssf1_tm purge;
alter table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow add partition p_svssf1 values ('svssf1')(
        subpartition p_svssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow modify partition p_svssf1
    add subpartition p_svssf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow_svssf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,oper_type_cd -- 操作类型代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,oper_tm -- 操作时间
    ,brac_id -- 网点编号
    ,remark -- 备注
    ,opered_acct_id -- 被操作账户编号
    ,opered_acct_name -- 被操作账户名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_seal_acct_mgmt_jnl_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- svss_svs_log_accadmlog-
insert into ${iml_schema}.evt_seal_acct_mgmt_jnl_flow_svssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,oper_type_cd -- 操作类型代码
    ,oper_teller_id -- 操作柜员编号
    ,oper_dt -- 操作日期
    ,oper_tm -- 操作时间
    ,brac_id -- 网点编号
    ,remark -- 备注
    ,opered_acct_id -- 被操作账户编号
    ,opered_acct_name -- 被操作账户名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201002'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 流水号
    ,NVL(TRIM(TO_CHAR(P1.OPERATE_TYPE)),'99') -- 操作类型代码
    ,P1.OPERATE_CODE -- 操作柜员编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPERATE_DATE) -- 操作日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPERATE_DATE||P1.OPERATE_TIME) -- 操作时间
    ,P1.OPERATE_ORG_NO -- 网点编号
    ,P1.MEMO -- 备注
    ,P1.ACC_NO -- 被操作账户编号
    ,P1.ACC_NAME -- 被操作账户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'svss_svs_log_accadmlog' -- 源表名称
    ,'svssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.svss_svs_log_accadmlog p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow truncate partition p_svssf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow exchange subpartition p_svssf1_${batch_date} with table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow_svssf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_seal_acct_mgmt_jnl_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow_svssf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_seal_acct_mgmt_jnl_flow', partname => 'p_svssf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);