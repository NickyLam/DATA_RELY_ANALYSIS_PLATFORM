/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_distr_flow_ncbsi1
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
drop table ${iml_schema}.evt_loan_distr_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_distr_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_distr_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_distr_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,cust_id -- 客户编号
    ,contrior_id -- 出资人编号
    ,once_open_distr_flg -- 一次性开立发放标志
    ,distr_way_cd -- 发放方式代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,discnt_int -- 贴现利息
    ,exp_dt -- 到期日期
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,dubil_id -- 借据编号
    ,tran_ref_no -- 交易参考号
    ,evt_cate_id -- 事件类别编号
    ,bus_tran_cate_cd -- 业务交易码
    ,revs_flg -- 冲正标志
    ,tran_revs_rs -- 交易冲正原因
    ,revs_teller_id -- 冲正柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_distr_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_cl_drawdown-1
insert into ${iml_schema}.evt_loan_distr_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,cust_id -- 客户编号
    ,contrior_id -- 出资人编号
    ,once_open_distr_flg -- 一次性开立发放标志
    ,distr_way_cd -- 发放方式代码
    ,distr_dt -- 放款日期
    ,distr_amt -- 放款金额
    ,discnt_int -- 贴现利息
    ,exp_dt -- 到期日期
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,dubil_id -- 借据编号
    ,tran_ref_no -- 交易参考号
    ,evt_cate_id -- 事件类别编号
    ,bus_tran_cate_cd -- 业务交易码
    ,revs_flg -- 冲正标志
    ,tran_revs_rs -- 交易冲正原因
    ,revs_teller_id -- 冲正柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101022'||P1.DD_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.COUNTER -- 序号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,P1.DD_NO -- 放款流水号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.LENDER -- 出资人编号
    ,'-' -- 一次性开立发放标志
    ,P1.DD_METHOD -- 发放方式代码
    ,P1.DD_DATE -- 放款日期
    ,P1.DD_AMT -- 放款金额
    ,P1.DISTINCT_INT -- 贴现利息
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.TRAN_TYPE -- 业务交易码
    ,DECODE(P1.REVERSAL,'Y','1','N','0') -- 冲正标志
    ,P1.REVERSAL_REASON -- 交易冲正原因
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_drawdown' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_drawdown p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_loan_distr_flow truncate partition p_ncbsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_distr_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_distr_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_distr_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_distr_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_distr_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);