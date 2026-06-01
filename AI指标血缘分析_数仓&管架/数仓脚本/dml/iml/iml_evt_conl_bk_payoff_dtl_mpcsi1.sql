/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_conl_bk_payoff_dtl_mpcsi1
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
drop table ${iml_schema}.evt_conl_bk_payoff_dtl_mpcsi1_tm purge;
alter table ${iml_schema}.evt_conl_bk_payoff_dtl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_conl_bk_payoff_dtl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_dtl_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_dt -- 批次日期
    ,rec_id -- 记录编号
    ,chn_dt -- 渠道日期
    ,chn_seq_num -- 渠道序号
    ,conl_bk_tran_type_cd -- 企业网银交易类型代码
    ,dtl_acct_id -- 明细账户编号
    ,dtl_acct_name -- 明细账户名称
    ,tran_amt -- 交易金额
    ,tran_sucs_amt -- 交易成功金额
    ,deduct_mode_cd -- 扣款模式代码
    ,core_memo_cd -- 核心摘要代码
    ,corp_agent_acct -- 对公代理账户
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,cntpty_acct_bank_num -- 对手账户行号
    ,postsc -- 附言
    ,unify_pay_order_no -- 统一支付订单号
    ,unify_pay_flow_num -- 统一支付流水号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_payoff_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a01tbatdetail-
insert into ${iml_schema}.evt_conl_bk_payoff_dtl_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,batch_dt -- 批次日期
    ,rec_id -- 记录编号
    ,chn_dt -- 渠道日期
    ,chn_seq_num -- 渠道序号
    ,conl_bk_tran_type_cd -- 企业网银交易类型代码
    ,dtl_acct_id -- 明细账户编号
    ,dtl_acct_name -- 明细账户名称
    ,tran_amt -- 交易金额
    ,tran_sucs_amt -- 交易成功金额
    ,deduct_mode_cd -- 扣款模式代码
    ,core_memo_cd -- 核心摘要代码
    ,corp_agent_acct -- 对公代理账户
    ,core_tran_flow_num -- 核心交易流水号
    ,core_tran_dt -- 核心交易日期
    ,resp_code -- 响应码
    ,resp_code_descb -- 响应码描述
    ,cntpty_acct_bank_num -- 对手账户行号
    ,postsc -- 附言
    ,unify_pay_order_no -- 统一支付订单号
    ,unify_pay_flow_num -- 统一支付流水号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201020'||P1.BATCHNO||P1.BATCHDT||P1.RECORDNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCHNO -- 批次编号
    ,${iml_schema}.dateformat_min(P1.BATCHDT) -- 批次日期
    ,P1.RECORDNO -- 记录编号
    ,${iml_schema}.dateformat_min(P1.FNTDT) -- 渠道日期
    ,P1.FNTSEQNO -- 渠道序号
    ,NVL(TRIM(P1.TRNTYPE),'-') -- 企业网银交易类型代码
    ,P1.PAYACCTNO -- 明细账户编号
    ,P1.PAYACCTNAME -- 明细账户名称
    ,to_number(nvl(trim(P1.TRNAMT),0)) -- 交易金额
    ,to_number(nvl(trim(P1.SUCCAMT),0)) -- 交易成功金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAYTYPE END -- 扣款模式代码
    ,P1.MEMOCD -- 核心摘要代码
    ,P1.OPPOACCTNO -- 对公代理账户
    ,P1.HOSTSEQNO -- 核心交易流水号
    ,${iml_schema}.dateformat_min(P1.HOSTSEQDT) -- 核心交易日期
    ,P1.RSPCD -- 响应码
    ,P1.RSPMSG -- 响应码描述
    ,P1.OTHERBANKNO -- 对手账户行号
    ,P1.ADDWORD -- 附言
    ,P1.ORDERID -- 统一支付订单号
    ,P1.UPPTRANSEQNO -- 统一支付流水号
    ,P1.SRV_CLLPTY_TRX_SEQ -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRNDATE) -- 交易日期
    ,P1.GLOB_SEQ_NUM -- 全局流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a01tbatdetail' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a01tbatdetail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAYTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A01TBATDETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'PAYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CONL_BK_PAYOFF_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DEDUCT_MODE_CD'
where  1 = 1 
    and p1.etl_dt = to_Date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_conl_bk_payoff_dtl truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_conl_bk_payoff_dtl exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_conl_bk_payoff_dtl_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_conl_bk_payoff_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_conl_bk_payoff_dtl_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_conl_bk_payoff_dtl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);