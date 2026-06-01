/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_acct_accti_flow_ncbsi1
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
drop table ${iml_schema}.evt_loan_acct_accti_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_acct_accti_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_acct_accti_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_acct_accti_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,accti_seq_num -- 核算序号
    ,bus_flow_num -- 业务流水号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,acct_curr_cd -- 账户币种代码
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_status_cd -- 账户状态代码
    ,accti_status_cd -- 核算状态代码
    ,cust_type_cd -- 客户类型代码
    ,sob_cate_cd -- 账套类别代码
    ,src_module_type_cd -- 源模块类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,evt_cate_id -- 事件类别编号
    ,amt_type_cd -- 金额类型代码
    ,tran_amt -- 交易金额
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,tran_ref_no -- 交易参考号
    ,bank_tran_seq_num -- 银行交易序号
    ,revs_flg -- 冲正标志
    ,revs_dt -- 冲正日期
    ,tran_descb -- 交易描述
    ,post_flg -- 过账标志
    ,loan_org_id -- 贷款机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,check_entry_code -- 对账编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_acct_accti_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_ac_hist-1
insert into ${iml_schema}.evt_loan_acct_accti_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,accti_seq_num -- 核算序号
    ,bus_flow_num -- 业务流水号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,acct_curr_cd -- 账户币种代码
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_status_cd -- 账户状态代码
    ,accti_status_cd -- 核算状态代码
    ,cust_type_cd -- 客户类型代码
    ,sob_cate_cd -- 账套类别代码
    ,src_module_type_cd -- 源模块类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_code -- 交易码
    ,evt_cate_id -- 事件类别编号
    ,amt_type_cd -- 金额类型代码
    ,tran_amt -- 交易金额
    ,org_id -- 机构编号
    ,chn_id -- 渠道编号
    ,tran_ref_no -- 交易参考号
    ,bank_tran_seq_num -- 银行交易序号
    ,revs_flg -- 冲正标志
    ,revs_dt -- 冲正日期
    ,tran_descb -- 交易描述
    ,post_flg -- 过账标志
    ,loan_org_id -- 贷款机构编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,check_entry_code -- 对账编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401015'||P1.BUS_SEQ_NO||P1.SEQ_NO||P1.TRAN_TIMESTAMP -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 核算序号
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.DD_NO -- 放款流水号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,P1.PROD_TYPE -- 产品编号
    ,P1.MARKETING_PROD -- 营销产品编号
    ,P1.MARKETING_PROD_DESC -- 营销产品名称
    ,P1.ACCT_DESC -- 账户名称
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类别代码
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.TRAN_TYPE -- 交易码
    ,P1.EVENT_TYPE -- 事件类别编号
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.BRANCH -- 机构编号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,decode(trim(P1.REVERSAL),'Y','1','N','0','','-') -- 冲正标志
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.NARRATIVE -- 交易描述
    ,decode(trim(P1.GL_POSTED_FLAG),'Y','1','N','0','','-') -- 过账标志
    ,P1.LENDER -- 贷款机构编号
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.REACCOUNT_CD -- 对账编码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_ac_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_ac_hist p1
    left join ${iml_schema}.ref_pub_cd_map R1 on P1.CLIENT_TYPE=R1.SRC_CODE_VAL
           AND R1.SORC_SYS_CD= 'NCBS'
           AND R1.SRC_TAB_EN_NAME ='NCBS_CL_AC_HIST'
           AND R1.SRC_FIELD_EN_NAME ='CLIENT_TYPE'
           AND R1.TARGET_TAB_EN_NAME='EVT_LOAN_ACCT_ACCTI_FLOW'
           AND R1.TARGET_TAB_FIELD_EN_NAME='CUST_TYPE_CD'
where  1 = 1 
    and p1.tran_date = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_acct_accti_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_acct_accti_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_acct_accti_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_acct_accti_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_acct_accti_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_acct_accti_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);