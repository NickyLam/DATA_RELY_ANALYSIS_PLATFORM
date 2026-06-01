/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_acct_ety_tran_mpcsi1
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
drop table ${iml_schema}.evt_wld_acct_ety_tran_mpcsi1_tm purge;
alter table ${iml_schema}.evt_wld_acct_ety_tran add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_acct_ety_tran modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_acct_ety_tran_mpcsi1_tm
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
-- mpcs_a0nds_accounting_flow-
insert into ${iml_schema}.evt_wld_acct_ety_tran_mpcsi1_tm(
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
    '102008'||TO_CHAR(P1.BATCHDATE,'YYYY/MM/DD')||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 序列号
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.BATCHDATE -- 批量日期
    ,TO_CHAR(P1.QUEUE) -- 分组序号
    ,P1.TXN_CODE -- 事件交易码
    ,P1.CPS_TXN_SEQ -- 核心交易流水
    ,P1.TXN_DESC -- 交易描述
    ,P1.TERM -- 期数
    ,P1.CARD_NO -- 卡号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURR_CD  END -- 币种代码
    ,P1.POST_AMT -- 入账金额
    ,P1.DB_CR_IND -- 借贷标志
    ,NVL(TRIM(P1.POST_GL_IND),'-') -- 入账方式代码
    ,P1.OWNING_BRANCH -- 支行编号
    ,P1.SUBJECT -- 科目编号
    ,P1.PRODUCT_CD -- 贷款产品编号
    ,P1.PLAN_NBR -- 信用计划编号
    ,P1.BANK_GROUP_ID -- 银团编号
    ,P1.BANK_NO -- 银行编号
    ,decode(trim(P1.RED_FLAG),'B','N','R','R','-') -- 红蓝字标志
    ,P1.REF_NBR -- 交易参考号
    ,NVL(TRIM(P1.AGE_GROUP),'-') -- 账龄组代码
    ,NVL(TRIM(P1.BNP_GROUP),'-') -- 余额成分组代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0nds_accounting_flow' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0nds_accounting_flow p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURR_CD  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A0NDS_ACCOUNTING_FLOW'
        AND R1.SRC_FIELD_EN_NAME= 'CURR_CD'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_WLD_ACCT_ETY_TRAN'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_acct_ety_tran truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_acct_ety_tran exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_wld_acct_ety_tran_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_acct_ety_tran to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_acct_ety_tran_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_acct_ety_tran', partname => 'p_mpcsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);