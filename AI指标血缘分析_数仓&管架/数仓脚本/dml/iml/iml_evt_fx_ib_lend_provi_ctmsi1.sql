/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_fx_ib_lend_provi_ctmsi1
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
drop table ${iml_schema}.evt_fx_ib_lend_provi_ctmsi1_tm purge;
alter table ${iml_schema}.evt_fx_ib_lend_provi add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_fx_ib_lend_provi modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fx_ib_lend_provi_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,term_end_stl_amt -- 期末结算金额
    ,ib_lend_int_rat -- 拆借利率
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,int_accr_base_cd -- 计息基准代码
    ,portf_id -- 投组编号
    ,provi_dt -- 计提日期
    ,provi_amt -- 计提金额
    ,tran_dir_cd -- 交易方向代码
    ,ib_lend_type_cd -- 拆借类型代码
    ,bag_id -- 成交编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_fx_ib_lend_provi
where 0=1;

-- 3.1 truncate target table batch_date partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_fx_ib_lend_provi truncate subpartition p_ctmsi1_${batch_date} reuse storage;

-- 3.2 insert data to tm table
-- ctms_fbs_v_ibo_accrual-
insert into ${iml_schema}.evt_fx_ib_lend_provi_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,term_end_stl_amt -- 期末结算金额
    ,ib_lend_int_rat -- 拆借利率
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,int_accr_base_cd -- 计息基准代码
    ,portf_id -- 投组编号
    ,provi_dt -- 计提日期
    ,provi_amt -- 计提金额
    ,tran_dir_cd -- 交易方向代码
    ,ib_lend_type_cd -- 拆借类型代码
    ,bag_id -- 成交编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104015'||to_char(P1.LOAD_DATE)||to_char(P1.DEAL_SQNO) -- 事件编号
    ,'9999' -- 法人编号
    ,P1.DEAL_SQNO -- 交易流水号
    ,P1.CUS_NUMBER -- 部门编号
    ,P1.BRANCH_ID -- 机构编号
    ,P1.CRNCY_CODE -- 币种代码
    ,P1.FIRST_AMNT -- 交易金额
    ,P1.MATURITY_AMNT -- 期末结算金额
    ,P1.DEAL_RATE -- 拆借利率
    ,P1.DEAL_DATE -- 交易日期
    ,P1.VALUE_DATE -- 起息日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.RATE_TYPE -- 利率调整方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||to_char(P1.TRADE_PURPOSE) END -- 交易目的代码
    ,P1.COUNTER_PARTY_ID -- 交易对手编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||to_char(P1.INTRST_BASIS) END -- 计息基准代码
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.LOAD_DATE -- 计提日期
    ,P1.TOTAL_ACCRUAL_AMOUNT -- 计提金额
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||to_char(P1.DEAL_DIR) END -- 交易方向代码
    ,P1.IBO_TYPE -- 拆借类型代码
    ,P1.CLIENT_DEAL_SQNO -- 成交编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_ibo_accrual' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_ibo_accrual p1
    left join ${iml_schema}.ref_pub_cd_map r1 on to_char(P1.TRADE_PURPOSE) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_ACCRUAL'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_PURPOSE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_FX_IB_LEND_PROVI'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_AIM_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on to_char(P1.INTRST_BASIS) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_ACCRUAL'
        AND R2.SRC_FIELD_EN_NAME= 'INTRST_BASIS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FX_IB_LEND_PROVI'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on to_char(P1.DEAL_DIR) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_ACCRUAL'
        AND R3.SRC_FIELD_EN_NAME= 'DEAL_DIR'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_FX_IB_LEND_PROVI'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.LOAD_DATE=to_date('${batch_date}' ,'yyyy/mm/dd')
;
commit;



-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_fx_ib_lend_provi exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_fx_ib_lend_provi_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_fx_ib_lend_provi to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_fx_ib_lend_provi_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_fx_ib_lend_provi', partname => 'p_ctmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);