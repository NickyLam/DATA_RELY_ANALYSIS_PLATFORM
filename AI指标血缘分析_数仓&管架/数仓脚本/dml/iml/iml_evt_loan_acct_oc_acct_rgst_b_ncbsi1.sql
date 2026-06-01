/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_acct_oc_acct_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,acct_id -- 账户编号
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_attr_val -- 账户属性值
    ,oc_acct_rgst_type_cd -- 开销户登记类型代码
    ,oc_acct_oper_way_cd -- 开销户操作方式代码
    ,bank_org_id -- 银行机构编号
    ,tran_dt -- 交易日期
    ,tran_ref_no -- 交易参考号
    ,cust_id -- 客户编号
    ,descb -- 描述
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_acct_oc_acct_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_open_close_reg-1
insert into ${iml_schema}.evt_loan_acct_oc_acct_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,acct_id -- 账户编号
    ,core_acct_type_cd -- 核心账户类型代码
    ,acct_attr_val -- 账户属性值
    ,oc_acct_rgst_type_cd -- 开销户登记类型代码
    ,oc_acct_oper_way_cd -- 开销户操作方式代码
    ,bank_org_id -- 银行机构编号
    ,tran_dt -- 交易日期
    ,tran_ref_no -- 交易参考号
    ,cust_id -- 客户编号
    ,descb -- 描述
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101030'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,P1.DD_NO -- 放款流水号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.ACCT_TYPE -- 核心账户类型代码
    ,P1.ACCT_NATURE -- 账户属性值
    ,P1.REG_TYPE -- 开销户登记类型代码
    ,P1.OP_METHOD -- 开销户操作方式代码
    ,P1.BRANCH -- 银行机构编号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE) -- 交易日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.NARRATIVE -- 描述
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_open_close_reg' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_open_close_reg p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_acct_oc_acct_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_acct_oc_acct_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_acct_oc_acct_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);