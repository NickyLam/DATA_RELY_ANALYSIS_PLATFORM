/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ifs_sub_acct_provi_rgst_b_ifcsi1
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
drop table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b_ifcsi1_tm purge;
alter table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b add partition p_ifcsi1 values ('ifcsi1')(
        subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b modify partition p_ifcsi1
    add subpartition p_ifcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b_ifcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_dt -- 计提日期
    ,dep_acct_id -- 存款账户编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,dep_bal -- 存款余额
    ,td_int_paybl -- 当日应付利息
    ,exec_int_rat -- 执行利率
    ,tran_status_cd -- 交易状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifcs_dep_provi_rgst_b-
insert into ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b_ifcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_dt -- 计提日期
    ,dep_acct_id -- 存款账户编号
    ,dep_prod_sub_acct_id -- 存款产品分户编号
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,dep_bal -- 存款余额
    ,td_int_paybl -- 当日应付利息
    ,exec_int_rat -- 执行利率
    ,tran_status_cd -- 交易状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102029'||P1.TRAN_DT||P1.DEP_ACCT_ID||P1.DEP_PROD_SUB_ACCT_ID||P1.PROD_ID||NVL(P1.TRAN_STATUS_CD,'-') -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_min(P1.TRAN_DT) -- 计提日期
    ,P1.DEP_ACCT_ID -- 存款账户编号
    ,P1.DEP_PROD_SUB_ACCT_ID -- 存款产品分户编号
    ,P1.OPEN_ACCT_ORG_ID -- 机构编号
    ,P1.PROD_ID -- 产品编号
    ,P1.REC_BAL -- 存款余额
    ,P1.INT_PAYBL -- 当日应付利息
    ,P1.EXEC_INT_RAT -- 执行利率
    ,NVL(P1.TRAN_STATUS_CD,'-') -- 交易状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifcs_dep_provi_rgst_b' -- 源表名称
    ,'ifcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifcs_dep_provi_rgst_b p1
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b truncate subpartition p_ifcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b exchange subpartition p_ifcsi1_${batch_date} with table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b_ifcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b_ifcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ifs_sub_acct_provi_rgst_b', partname => 'p_ifcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);