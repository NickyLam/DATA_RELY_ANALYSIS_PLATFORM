/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fx_ib_lend_ctmsf1
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
drop table ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_ib_lend_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_fx_ib_lend add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_fx_ib_lend modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fx_ib_lend_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fx_ib_lend partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,ib_lend_int_rat -- 拆借利率
    ,ib_lend_amt -- 拆借金额
    ,convt_usd_curr_amt -- 折美元货币金额
    ,term_end_stl_amt -- 期末结算金额
    ,ib_lend_days -- 拆借天数
    ,daily_int_amt -- 每日利息金额
    ,acru_int_tot -- 应计利息总额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dir_cd -- 交易方向代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,ib_lend_type_cd -- 拆借类型代码
    ,clear_org_cd -- 清算机构代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_stub_proc_way_cd -- 付息残段处理方式代码
    ,curr_bal -- 当前余额
    ,inpwn_way_descb -- 质押方式描述
    ,bond_curr_cd -- 债券币种代码
    ,convt_ratio -- 折算比例
    ,bond_id -- 债券编号
    ,fac_val -- 面值
    ,cert_face_tot -- 券面总额
    ,convt_amt -- 折算金额1
    ,dealer_id -- 交易员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fx_ib_lend
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_fx_ib_lend_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_fx_ib_lend partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_fbs_v_ibo_deal-
insert into ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,ib_lend_int_rat -- 拆借利率
    ,ib_lend_amt -- 拆借金额
    ,convt_usd_curr_amt -- 折美元货币金额
    ,term_end_stl_amt -- 期末结算金额
    ,ib_lend_days -- 拆借天数
    ,daily_int_amt -- 每日利息金额
    ,acru_int_tot -- 应计利息总额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dir_cd -- 交易方向代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,ib_lend_type_cd -- 拆借类型代码
    ,clear_org_cd -- 清算机构代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_stub_proc_way_cd -- 付息残段处理方式代码
    ,curr_bal -- 当前余额
    ,inpwn_way_descb -- 质押方式描述
    ,bond_curr_cd -- 债券币种代码
    ,convt_ratio -- 折算比例
    ,bond_id -- 债券编号
    ,fac_val -- 面值
    ,cert_face_tot -- 券面总额
    ,convt_amt -- 折算金额1
    ,dealer_id -- 交易员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224103'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.DEAL_SQNO -- 业务编号
    ,P1.CUS_NUMBER -- 机构编号
    ,P1.BUSINESS_DATE -- 录入日期
    ,P1.DEAL_DATE -- 交易日期
    ,P1.VALUE_DATE -- 起息日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.FRST_PMNT_DATE -- 首次付息日期
    ,P1.CRNCY_CODE -- 币种代码
    ,P1.RATE -- 拆借利率
    ,P1.FIRST_AMNT -- 拆借金额
    ,P1.USD_CRNCY_AMNT -- 折美元货币金额
    ,P1.MATURITY_AMNT -- 期末结算金额
    ,P1.DAY_COUNT -- 拆借天数
    ,P1.DAY_ACCRD_INTRST_AMNT -- 每日利息金额
    ,P1.ACCRUED_AMNT -- 应计利息总额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRADE_PURPOSE END -- 交易目的代码
    ,P1.COUNTER_PARTY_ID -- 交易对手编号
    ,P1.COUNTER_PARTY_SCNAME -- 交易对手名称
    ,P1.PDD_DEAL_SQNO -- 交易流水号
    ,P1.DEAL_STATUS -- 交易状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DEAL_DIR END -- 交易方向代码
    ,P1.CLIENT_DEAL_SQNO -- 成交编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_TYPE END -- 交易模式代码
    ,P1.DEAL_SOURCE -- 交易来源代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DEAL_MARKET END -- 交易场所代码
    ,P1.SETTLE_TYPE -- 清算方式代码
    ,TO_CHAR(P1.DEAL_LINK_SQNO) -- 关联交易编号
    ,P1.PORTFOLIO_SQNO -- 投组交易编号
    ,P1.PORTFOLIO_ID -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,P1.PORTFOLIO_TYPE -- 投组类型名称
    ,P1.PORTFOLIO_STATUS -- 投组状态代码
    ,P1.PORTFOLIO_LINK_SQNO -- 投组关联交易编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.IBO_TYPE END -- 拆借类型代码
    ,P1.CLEAR_DEP -- 清算机构代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.INTEREST_BASE END -- 计息基准代码
    ,nvl(trim(P1.INTRST_TERM),'-') END -- 利率期限代码
    ,P1.RATE_TYPE -- 利率调整方式代码
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.FLOAT_DIRECTION END -- 利率浮动方向代码
    ,P1.SPREAD_RATE -- 利率浮动点数
    ,P1.PMNT_FREQ -- 付息频率
    ,P1.PMNT_STUB_RULE -- 付息残段处理方式代码
    ,P1.RSDL_AMNT -- 当前余额
    ,P1.COLLATERAL_METHOD -- 质押方式描述
    ,NVL(TRIM(P1.UNDERLYING_CURRENCY),'CNY') -- 债券币种代码
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.UNDERLYING_STIP_VALUE, '[0-9.]+')),0)) -- 折算比例
    ,P1.UNDERLYING_SECURITYID -- 债券编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.FACE_VALUE, '[0-9.]+')),0)) -- 面值
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.UNDERLYING_QTY, '[0-9.]+')),0)) -- 券面总额
    ,P1.underlying_discountamt -- 折算金额1
    ,P1.DEALER -- 交易员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_ibo_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_ibo_deal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on TO_CHAR(P1.TRADE_PURPOSE) = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_PURPOSE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_AIM_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on TO_CHAR(P1.DEAL_DIR) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R2.SRC_FIELD_EN_NAME= 'DEAL_DIR'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_TYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DEAL_MARKET = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'CTMS'
        AND R4.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R4.SRC_FIELD_EN_NAME= 'DEAL_MARKET'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SITE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on TO_CHAR(P1.IBO_TYPE) = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'CTMS'
        AND R5.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R5.SRC_FIELD_EN_NAME= 'IBO_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'IB_LEND_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on TO_CHAR(P1.INTEREST_BASE) = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'CTMS'
        AND R7.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R7.SRC_FIELD_EN_NAME= 'INTEREST_BASE'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on TO_CHAR(P1.FLOAT_DIRECTION) = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'CTMS'
        AND R9.SRC_TAB_EN_NAME= 'CTMS_FBS_V_IBO_DEAL'
        AND R9.SRC_FIELD_EN_NAME= 'FLOAT_DIRECTION'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_FX_IB_LEND'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_DIR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_fx_ib_lend_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,org_id -- 机构编号
    ,input_dt -- 录入日期
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,fir_pay_int_dt -- 首次付息日期
    ,curr_cd -- 币种代码
    ,ib_lend_int_rat -- 拆借利率
    ,ib_lend_amt -- 拆借金额
    ,convt_usd_curr_amt -- 折美元货币金额
    ,term_end_stl_amt -- 期末结算金额
    ,ib_lend_days -- 拆借天数
    ,daily_int_amt -- 每日利息金额
    ,acru_int_tot -- 应计利息总额
    ,tran_aim_cd -- 交易目的代码
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,tran_flow_num -- 交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dir_cd -- 交易方向代码
    ,bag_id -- 成交编号
    ,tran_mode_cd -- 交易模式代码
    ,tran_src_cd -- 交易来源代码
    ,tran_site_cd -- 交易场所代码
    ,clear_way_cd -- 清算方式代码
    ,rela_tran_id -- 关联交易编号
    ,portf_tran_id -- 投组交易编号
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,portf_type_name -- 投组类型名称
    ,portf_status_cd -- 投组状态代码
    ,portf_rela_tran_id -- 投组关联交易编号
    ,ib_lend_type_cd -- 拆借类型代码
    ,clear_org_cd -- 清算机构代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_rat_tenor_cd -- 利率期限代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_stub_proc_way_cd -- 付息残段处理方式代码
    ,curr_bal -- 当前余额
    ,inpwn_way_descb -- 质押方式描述
    ,bond_curr_cd -- 债券币种代码
    ,convt_ratio -- 折算比例
    ,bond_id -- 债券编号
    ,fac_val -- 面值
    ,cert_face_tot -- 券面总额
    ,convt_amt -- 折算金额1
    ,dealer_id -- 交易员编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ib_lend_int_rat, o.ib_lend_int_rat) as ib_lend_int_rat -- 拆借利率
    ,nvl(n.ib_lend_amt, o.ib_lend_amt) as ib_lend_amt -- 拆借金额
    ,nvl(n.convt_usd_curr_amt, o.convt_usd_curr_amt) as convt_usd_curr_amt -- 折美元货币金额
    ,nvl(n.term_end_stl_amt, o.term_end_stl_amt) as term_end_stl_amt -- 期末结算金额
    ,nvl(n.ib_lend_days, o.ib_lend_days) as ib_lend_days -- 拆借天数
    ,nvl(n.daily_int_amt, o.daily_int_amt) as daily_int_amt -- 每日利息金额
    ,nvl(n.acru_int_tot, o.acru_int_tot) as acru_int_tot -- 应计利息总额
    ,nvl(n.tran_aim_cd, o.tran_aim_cd) as tran_aim_cd -- 交易目的代码
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.bag_id, o.bag_id) as bag_id -- 成交编号
    ,nvl(n.tran_mode_cd, o.tran_mode_cd) as tran_mode_cd -- 交易模式代码
    ,nvl(n.tran_src_cd, o.tran_src_cd) as tran_src_cd -- 交易来源代码
    ,nvl(n.tran_site_cd, o.tran_site_cd) as tran_site_cd -- 交易场所代码
    ,nvl(n.clear_way_cd, o.clear_way_cd) as clear_way_cd -- 清算方式代码
    ,nvl(n.rela_tran_id, o.rela_tran_id) as rela_tran_id -- 关联交易编号
    ,nvl(n.portf_tran_id, o.portf_tran_id) as portf_tran_id -- 投组交易编号
    ,nvl(n.portf_id, o.portf_id) as portf_id -- 投组编号
    ,nvl(n.portf_name, o.portf_name) as portf_name -- 投组名称
    ,nvl(n.portf_type_name, o.portf_type_name) as portf_type_name -- 投组类型名称
    ,nvl(n.portf_status_cd, o.portf_status_cd) as portf_status_cd -- 投组状态代码
    ,nvl(n.portf_rela_tran_id, o.portf_rela_tran_id) as portf_rela_tran_id -- 投组关联交易编号
    ,nvl(n.ib_lend_type_cd, o.ib_lend_type_cd) as ib_lend_type_cd -- 拆借类型代码
    ,nvl(n.clear_org_cd, o.clear_org_cd) as clear_org_cd -- 清算机构代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_rat_tenor_cd, o.int_rat_tenor_cd) as int_rat_tenor_cd -- 利率期限代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_float_dir_cd, o.int_rat_float_dir_cd) as int_rat_float_dir_cd -- 利率浮动方向代码
    ,nvl(n.int_rat_float_point, o.int_rat_float_point) as int_rat_float_point -- 利率浮动点数
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.pay_stub_proc_way_cd, o.pay_stub_proc_way_cd) as pay_stub_proc_way_cd -- 付息残段处理方式代码
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.inpwn_way_descb, o.inpwn_way_descb) as inpwn_way_descb -- 质押方式描述
    ,nvl(n.bond_curr_cd, o.bond_curr_cd) as bond_curr_cd -- 债券币种代码
    ,nvl(n.convt_ratio, o.convt_ratio) as convt_ratio -- 折算比例
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.fac_val, o.fac_val) as fac_val -- 面值
    ,nvl(n.cert_face_tot, o.cert_face_tot) as cert_face_tot -- 券面总额
    ,nvl(n.convt_amt, o.convt_amt) as convt_amt -- 折算金额1
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bus_id <> n.bus_id
                or o.org_id <> n.org_id
                or o.input_dt <> n.input_dt
                or o.tran_dt <> n.tran_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.curr_cd <> n.curr_cd
                or o.ib_lend_int_rat <> n.ib_lend_int_rat
                or o.ib_lend_amt <> n.ib_lend_amt
                or o.convt_usd_curr_amt <> n.convt_usd_curr_amt
                or o.term_end_stl_amt <> n.term_end_stl_amt
                or o.ib_lend_days <> n.ib_lend_days
                or o.daily_int_amt <> n.daily_int_amt
                or o.acru_int_tot <> n.acru_int_tot
                or o.tran_aim_cd <> n.tran_aim_cd
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_name <> n.cntpty_name
                or o.tran_flow_num <> n.tran_flow_num
                or o.tran_status_cd <> n.tran_status_cd
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.bag_id <> n.bag_id
                or o.tran_mode_cd <> n.tran_mode_cd
                or o.tran_src_cd <> n.tran_src_cd
                or o.tran_site_cd <> n.tran_site_cd
                or o.clear_way_cd <> n.clear_way_cd
                or o.rela_tran_id <> n.rela_tran_id
                or o.portf_tran_id <> n.portf_tran_id
                or o.portf_id <> n.portf_id
                or o.portf_name <> n.portf_name
                or o.portf_type_name <> n.portf_type_name
                or o.portf_status_cd <> n.portf_status_cd
                or o.portf_rela_tran_id <> n.portf_rela_tran_id
                or o.ib_lend_type_cd <> n.ib_lend_type_cd
                or o.clear_org_cd <> n.clear_org_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.int_rat_tenor_cd <> n.int_rat_tenor_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.int_rat_float_dir_cd <> n.int_rat_float_dir_cd
                or o.int_rat_float_point <> n.int_rat_float_point
                or o.pay_int_freq <> n.pay_int_freq
                or o.pay_stub_proc_way_cd <> n.pay_stub_proc_way_cd
                or o.curr_bal <> n.curr_bal
                or o.inpwn_way_descb <> n.inpwn_way_descb
                or o.bond_curr_cd <> n.bond_curr_cd
                or o.convt_ratio <> n.convt_ratio
                or o.bond_id <> n.bond_id
                or o.fac_val <> n.fac_val
                or o.cert_face_tot <> n.cert_face_tot
                or o.convt_amt <> n.convt_amt
                or o.dealer_id <> n.dealer_id
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm n
    full join ${iml_schema}.agt_fx_ib_lend_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_fx_ib_lend truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_fx_ib_lend exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_fx_ib_lend_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_fx_ib_lend drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fx_ib_lend to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_fx_ib_lend_ctmsf1_tm purge;
drop table ${iml_schema}.agt_fx_ib_lend_ctmsf1_ex purge;
drop table ${iml_schema}.agt_fx_ib_lend_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fx_ib_lend', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);