/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_acct_precon_dtl_ncbsi1
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
drop table ${iml_schema}.evt_dep_acct_precon_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_acct_precon_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_acct_precon_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_precon_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_precon_id -- 申请预约编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,precon_exp_dt -- 预约到期日期
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,cust_type_subdv_cd -- 客户类型细分代码
    ,cust_name -- 客户名称
    ,precon_status_cd -- 预约状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_acct_precon_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_acct_appointment-1
insert into ${iml_schema}.evt_dep_acct_precon_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_precon_id -- 申请预约编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,precon_exp_dt -- 预约到期日期
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,core_acct_type_cd -- 核心账户类型代码
    ,cust_type_subdv_cd -- 客户类型细分代码
    ,cust_name -- 客户名称
    ,precon_status_cd -- 预约状态代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101035'||P1.APPLY_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.APPLY_ID -- 申请预约编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.APPLY_DUE_DATE -- 预约到期日期
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.ACCT_TYPE -- 核心账户类型代码
    ,P1.CATEGORY_TYPE -- 客户类型细分代码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.APPOINTMENT_STATUS -- 预约状态代码
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_appointment' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_appointment p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_acct_precon_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_acct_precon_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_acct_precon_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_acct_precon_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_acct_precon_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_acct_precon_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);