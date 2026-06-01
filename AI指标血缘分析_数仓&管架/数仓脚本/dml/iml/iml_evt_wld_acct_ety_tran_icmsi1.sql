/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_acct_ety_tran_icmsi1
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
drop table ${iml_schema}.evt_wld_acct_ety_tran_icmsi1_tm purge;
alter table ${iml_schema}.evt_wld_acct_ety_tran add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_acct_ety_tran modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_acct_ety_tran_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,batch_dt -- 批量日期
    ,grouping_seq_num -- 分组序号
    ,evt_tran_code -- 事件交易码
    ,core_tran_flow -- 核心交易流水
    ,tran_descb -- 交易描述
    ,perds -- 期数
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,enter_acct_amt -- 入账金额
    ,debit_crdt_flg -- 借贷标志
    ,enter_acct_way_cd -- 入账方式代码
    ,subrch_id -- 支行编号
    ,subj_id -- 科目编号
    ,loan_prod_id -- 贷款产品编号
    ,crdt_plan_id -- 信用计划编号
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,rb_w_flg -- 红蓝字标志
    ,tran_ref_no -- 交易参考号
    ,aging_group_cd -- 账龄组代码
    ,bal_compnt_group_cd -- 余额成分组代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_acct_ety_tran
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_ds_accounting_flow-1
insert into ${iml_schema}.evt_wld_acct_ety_tran_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_doc_name -- 批量文件名称
    ,batch_dt -- 批量日期
    ,grouping_seq_num -- 分组序号
    ,evt_tran_code -- 事件交易码
    ,core_tran_flow -- 核心交易流水
    ,tran_descb -- 交易描述
    ,perds -- 期数
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,enter_acct_amt -- 入账金额
    ,debit_crdt_flg -- 借贷标志
    ,enter_acct_way_cd -- 入账方式代码
    ,subrch_id -- 支行编号
    ,subj_id -- 科目编号
    ,loan_prod_id -- 贷款产品编号
    ,crdt_plan_id -- 信用计划编号
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,rb_w_flg -- 红蓝字标志
    ,tran_ref_no -- 交易参考号
    ,aging_group_cd -- 账龄组代码
    ,bal_compnt_group_cd -- 余额成分组代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102008'||TO_CHAR(P1.BATCHDATE,'YYYY/MM/DD')||P1.CPSTXNSEQ -- 事件编号
    ,'9999' -- 法人编号
    ,' ' -- 序列号
    ,' ' -- 批量文件名称
    ,P1.BATCHDATE -- 批量日期
    ,TO_CHAR(P1.QUEUE) -- 分组序号
    ,P1.TXNCODE -- 事件交易码
    ,P1.CPSTXNSEQ -- 核心交易流水
    ,P1.TXNDESC -- 交易描述
    ,P1.TERM -- 期数
    ,P1.CARDNO -- 卡号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURRCD  END -- 币种代码
    ,P1.POSTAMT -- 入账金额
    ,NVL(TRIM(P1.DBCRIND),'-') -- 借贷标志
    ,NVL(TRIM(P1.POSTGLIND),'-') -- 入账方式代码
    ,P1.OWNINGBRANCH -- 支行编号
    ,P1.SUBJECT -- 科目编号
    ,P1.PRODUCTCD -- 贷款产品编号
    ,P1.PLANNBR -- 信用计划编号
    ,P1.BANKGROUPID -- 银团编号
    ,P1.BANKNO -- 银行编号
    ,decode(trim(P1.REDFLAG),'B','N','R','R','-') -- 红蓝字标志
    ,P1.REFNBR -- 交易参考号
    ,NVL(TRIM(P1.AGEGROUP),'-') -- 账龄组代码
    ,NVL(TRIM(P1.BNPGROUP),'-') -- 余额成分组代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ds_accounting_flow' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ds_accounting_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURRCD  = R1.SRC_CODE_VAL
        and R1.SORC_SYS_CD= 'ICMS'
        and R1.SRC_TAB_EN_NAME= 'ICMS_DS_ACCOUNTING_FLOW'
        and R1.SRC_FIELD_EN_NAME= 'CURRCD'
        and R1.TARGET_TAB_EN_NAME= 'EVT_WLD_ACCT_ETY_TRAN'
        and R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'  
where  1 = 1 
     and p1.bankgroupid in ('GHB06','GHB07')
     and p1.batchdate = to_date('${batch_date}','yyyymmdd') 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_acct_ety_tran truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_acct_ety_tran exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wld_acct_ety_tran_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_acct_ety_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_acct_ety_tran_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_acct_ety_tran', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);