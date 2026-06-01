/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ifs_main_acct_tran_dtl_ifcsi1
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
drop table ${iml_schema}.evt_ifs_main_acct_tran_dtl_ifcsi1_tm purge;
alter table ${iml_schema}.evt_ifs_main_acct_tran_dtl add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ifs_main_acct_tran_dtl modify partition p_ifcsi1
    add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_main_acct_tran_dtl_ifcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_id -- 交易流水编号
    ,acct_id -- 账户编号
    ,dep_sub_acct_id -- 存款子户编号
    ,cust_id -- 客户编号
    ,ext_prod_id -- 外部产品编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_type_cd -- 交易类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,call_sys_id -- 调用系统编号
    ,ext_flow_id -- 外部流水编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ifs_main_acct_tran_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifcs_acct_tran_dtl-
insert into ${iml_schema}.evt_ifs_main_acct_tran_dtl_ifcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_id -- 交易流水编号
    ,acct_id -- 账户编号
    ,dep_sub_acct_id -- 存款子户编号
    ,cust_id -- 客户编号
    ,ext_prod_id -- 外部产品编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_type_cd -- 交易类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,tran_status_cd -- 交易状态代码
    ,tran_org_id -- 交易机构编号
    ,call_sys_id -- 调用系统编号
    ,ext_flow_id -- 外部流水编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102027'||P1.TRAN_FLOW_NUM -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_FLOW_NUM -- 交易流水编号
    ,P1.ACCT_ID -- 账户编号
    ,P1.DEP_PROD_SUB_ACCT_ID -- 存款子户编号
    ,P1.CUST_ID -- 客户编号
    ,P1.EXT_PROD_ID -- 外部产品编号
    ,${iml_schema}.dateformat_min(P1.TRAN_DT) -- 交易日期
    ,P1.TRAN_TM -- 交易时间
    ,P1.TRAN_TYPE_CD -- 交易类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRAN_CHN_CD END -- 交易渠道代码
    ,P1.TRAN_STATUS_CD -- 交易状态代码
    ,P1.TRAN_ORG_ID -- 交易机构编号
    ,P1.CALL_SYS_ID -- 调用系统编号
    ,P1.EXT_FLOW_NUM -- 外部流水编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_acct_tran_dtl' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_acct_tran_dtl p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRAN_CHN_CD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFCS'
        AND R1.SRC_TAB_EN_NAME= 'IFCS_ACCT_TRAN_DTL'
        AND R1.SRC_FIELD_EN_NAME= 'TRAN_CHN_CD'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IFS_MAIN_ACCT_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
where  1 = 1 
    and ${iml_schema}.dateformat_min(P1.TRAN_DT)=to_date(${batch_date},'yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ifs_main_acct_tran_dtl truncate subpartition p_ifcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ifs_main_acct_tran_dtl exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.evt_ifs_main_acct_tran_dtl_ifcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ifs_main_acct_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ifs_main_acct_tran_dtl_ifcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ifs_main_acct_tran_dtl', partname => 'p_ifcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);