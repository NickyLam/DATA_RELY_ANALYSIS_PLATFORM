/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_am_due_f_banks_famsf1
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
drop table ${iml_schema}.agt_am_due_f_banks_famsf1_tm purge;
drop table ${iml_schema}.agt_am_due_f_banks_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_am_due_f_banks add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_am_due_f_banks modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_am_due_f_banks_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_am_due_f_banks partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_am_due_f_banks_famsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_dealer_id -- 对方交易员编号
    ,ghb_acct_id -- 本方账户编号
    ,ghb_dealer_id -- 本方交易员编号
    ,int_accr_base_cd -- 计息基准代码
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_int_rule_cd -- 付息规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_reset_freq -- 利率重置频率
    ,int_rat_reset_rule_cd -- 利率重置规则代码
    ,holiday_rule_cd -- 节假日规则代码
    ,int_rat_effect_rule_cd -- 利率生效规则代码
    ,init_tran_flg -- 原始交易标志
    ,asset_flow_dir_cd -- 资产流向代码
    ,sys_in_flg -- 系统内标志
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,asset_dlvy_dt -- 资产交割日期
    ,rpp_dt -- 还本日期
    ,pay_flg -- 支付标志
    ,valid_flg -- 有效标志
    ,cntpty_type_cd -- 交易对手类型代码
    ,fir_stl_amt -- 首次结算金额
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_tab_flow_num -- 转仓表流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_idf -- 保本标识
    ,asset_type_cd -- 资产类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_am_due_f_banks
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_am_due_f_banks_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_am_due_f_banks partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_mnm_dpbodeal-
insert into ${iml_schema}.agt_am_due_f_banks_famsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_dealer_id -- 对方交易员编号
    ,ghb_acct_id -- 本方账户编号
    ,ghb_dealer_id -- 本方交易员编号
    ,int_accr_base_cd -- 计息基准代码
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_int_rule_cd -- 付息规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_reset_freq -- 利率重置频率
    ,int_rat_reset_rule_cd -- 利率重置规则代码
    ,holiday_rule_cd -- 节假日规则代码
    ,int_rat_effect_rule_cd -- 利率生效规则代码
    ,init_tran_flg -- 原始交易标志
    ,asset_flow_dir_cd -- 资产流向代码
    ,sys_in_flg -- 系统内标志
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,asset_dlvy_dt -- 资产交割日期
    ,rpp_dt -- 还本日期
    ,pay_flg -- 支付标志
    ,valid_flg -- 有效标志
    ,cntpty_type_cd -- 交易对手类型代码
    ,fir_stl_amt -- 首次结算金额
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_tab_flow_num -- 转仓表流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_idf -- 保本标识
    ,asset_type_cd -- 资产类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224105'||P1.SEQNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 交易流水号
    ,P1.TRADEID -- 业务编号
    ,P1.PS -- 交易方向代码
    ,P1.DEALDATE -- 交易日期
    ,P1.VDATE -- 起息日期
    ,P1.MDATE -- 到期日期
    ,P1.COUNTERID -- 交易对手编号
    ,P1.COUNTERTRADER -- 对方交易员编号
    ,P1.ACCOUNT -- 本方账户编号
    ,P1.ACCOUNTTRADER -- 本方交易员编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BASIS END -- 计息基准代码
    ,P1.DLAMT -- 本金金额
    ,P1.CCY -- 币种代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.INTERESTRATE END -- 利率调整方式代码
    ,P1.RATE -- 执行利率
    ,P1.RATECODE -- 挂钩浮动利率代码
    ,P1.SPREADRATE -- 利率浮动点数
    ,P1.INTERESTFREQUENCY -- 付息频率
    ,P1.SCHECALRULE -- 付息规则代码
    ,P1.FIRSTPAYRATEDAY -- 首次付息日期
    ,P1.RATEADJFREQUENCY -- 利率重置频率
    ,P1.RATEADJRULE -- 利率重置规则代码
    ,P1.WORKDAYRULE -- 节假日规则代码
    ,P1.RATEVALUECDTN -- 利率生效规则代码
    ,P1.ISORIGINAL -- 原始交易标志
    ,P1.ASSETPS -- 资产流向代码
    ,TO_CHAR(P1.INTERNALFLAG) -- 系统内标志
    ,P1.PRINSETTAMT -- 本金交割金额
    ,P1.INTSETTAMT -- 利息交割金额
    ,P1.SETTDATE -- 资产交割日期
    ,P1.PRINPAYDAY -- 还本日期
    ,P1.PRINPAYMARK -- 支付标志
    ,P1.EFFECTFLAG -- 有效标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COUNTERTYPE END -- 交易对手类型代码
    ,P1.VAMT -- 首次结算金额
    ,P1.FATHERSEQNO -- 父交易编号
    ,P1.ORIGINALSEQNO -- 原交易编号
    ,P1.REFSEQNO -- 转仓表流水号
    ,P1.REVSEQNO -- 反向交易流水号
    ,P1.SPLITFLAG -- 拆分交易标志
    ,P1.TRADEMODE -- 资产池标志
    ,P1.MATUREYIELD -- 到期收益率
    ,P1.TRADMARKET -- 交易市场代码
    ,P1.TRADMARKETDESC -- 交易市场描述
    ,P1.VATBREAKEVEN -- 保本标识
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ASSETTYPE END -- 资产类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_mnm_dpbodeal' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_mnm_dpbodeal p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BASIS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_MNM_DPBODEAL'
        AND R1.SRC_FIELD_EN_NAME= 'BASIS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AM_DUE_F_BANKS'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.INTERESTRATE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'FAMS'
        AND R4.SRC_TAB_EN_NAME= 'FAMS_MNM_DPBODEAL'
        AND R4.SRC_FIELD_EN_NAME= 'INTERESTRATE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AM_DUE_F_BANKS'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.COUNTERTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_MNM_DPBODEAL'
        AND R2.SRC_FIELD_EN_NAME= 'COUNTERTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AM_DUE_F_BANKS'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ASSETTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_MNM_DPBODEAL'
        AND R3.SRC_FIELD_EN_NAME= 'ASSETTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AM_DUE_F_BANKS'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ASSET_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_am_due_f_banks_famsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_am_due_f_banks_famsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_id -- 业务编号
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,cntpty_id -- 交易对手编号
    ,cntpty_dealer_id -- 对方交易员编号
    ,ghb_acct_id -- 本方账户编号
    ,ghb_dealer_id -- 本方交易员编号
    ,int_accr_base_cd -- 计息基准代码
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,exec_int_rat -- 执行利率
    ,hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,int_rat_float_point -- 利率浮动点数
    ,pay_int_freq -- 付息频率
    ,pay_int_rule_cd -- 付息规则代码
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_reset_freq -- 利率重置频率
    ,int_rat_reset_rule_cd -- 利率重置规则代码
    ,holiday_rule_cd -- 节假日规则代码
    ,int_rat_effect_rule_cd -- 利率生效规则代码
    ,init_tran_flg -- 原始交易标志
    ,asset_flow_dir_cd -- 资产流向代码
    ,sys_in_flg -- 系统内标志
    ,pric_dlvy_amt -- 本金交割金额
    ,int_dlvy_amt -- 利息交割金额
    ,asset_dlvy_dt -- 资产交割日期
    ,rpp_dt -- 还本日期
    ,pay_flg -- 支付标志
    ,valid_flg -- 有效标志
    ,cntpty_type_cd -- 交易对手类型代码
    ,fir_stl_amt -- 首次结算金额
    ,parent_tran_id -- 父交易编号
    ,init_tran_id -- 原交易编号
    ,trans_tab_flow_num -- 转仓表流水号
    ,rev_tran_flow_num -- 反向交易流水号
    ,splt_tran_flg -- 拆分交易标志
    ,asset_pool_flg -- 资产池标志
    ,exp_yld_rat -- 到期收益率
    ,tran_market_cd -- 交易市场代码
    ,tran_market_descb -- 交易市场描述
    ,brkevn_idf -- 保本标识
    ,asset_type_cd -- 资产类型代码
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_dealer_id, o.cntpty_dealer_id) as cntpty_dealer_id -- 对方交易员编号
    ,nvl(n.ghb_acct_id, o.ghb_acct_id) as ghb_acct_id -- 本方账户编号
    ,nvl(n.ghb_dealer_id, o.ghb_dealer_id) as ghb_dealer_id -- 本方交易员编号
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.hook_float_int_rat_cd, o.hook_float_int_rat_cd) as hook_float_int_rat_cd -- 挂钩浮动利率代码
    ,nvl(n.int_rat_float_point, o.int_rat_float_point) as int_rat_float_point -- 利率浮动点数
    ,nvl(n.pay_int_freq, o.pay_int_freq) as pay_int_freq -- 付息频率
    ,nvl(n.pay_int_rule_cd, o.pay_int_rule_cd) as pay_int_rule_cd -- 付息规则代码
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.int_rat_reset_freq, o.int_rat_reset_freq) as int_rat_reset_freq -- 利率重置频率
    ,nvl(n.int_rat_reset_rule_cd, o.int_rat_reset_rule_cd) as int_rat_reset_rule_cd -- 利率重置规则代码
    ,nvl(n.holiday_rule_cd, o.holiday_rule_cd) as holiday_rule_cd -- 节假日规则代码
    ,nvl(n.int_rat_effect_rule_cd, o.int_rat_effect_rule_cd) as int_rat_effect_rule_cd -- 利率生效规则代码
    ,nvl(n.init_tran_flg, o.init_tran_flg) as init_tran_flg -- 原始交易标志
    ,nvl(n.asset_flow_dir_cd, o.asset_flow_dir_cd) as asset_flow_dir_cd -- 资产流向代码
    ,nvl(n.sys_in_flg, o.sys_in_flg) as sys_in_flg -- 系统内标志
    ,nvl(n.pric_dlvy_amt, o.pric_dlvy_amt) as pric_dlvy_amt -- 本金交割金额
    ,nvl(n.int_dlvy_amt, o.int_dlvy_amt) as int_dlvy_amt -- 利息交割金额
    ,nvl(n.asset_dlvy_dt, o.asset_dlvy_dt) as asset_dlvy_dt -- 资产交割日期
    ,nvl(n.rpp_dt, o.rpp_dt) as rpp_dt -- 还本日期
    ,nvl(n.pay_flg, o.pay_flg) as pay_flg -- 支付标志
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.cntpty_type_cd, o.cntpty_type_cd) as cntpty_type_cd -- 交易对手类型代码
    ,nvl(n.fir_stl_amt, o.fir_stl_amt) as fir_stl_amt -- 首次结算金额
    ,nvl(n.parent_tran_id, o.parent_tran_id) as parent_tran_id -- 父交易编号
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.trans_tab_flow_num, o.trans_tab_flow_num) as trans_tab_flow_num -- 转仓表流水号
    ,nvl(n.rev_tran_flow_num, o.rev_tran_flow_num) as rev_tran_flow_num -- 反向交易流水号
    ,nvl(n.splt_tran_flg, o.splt_tran_flg) as splt_tran_flg -- 拆分交易标志
    ,nvl(n.asset_pool_flg, o.asset_pool_flg) as asset_pool_flg -- 资产池标志
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.tran_market_cd, o.tran_market_cd) as tran_market_cd -- 交易市场代码
    ,nvl(n.tran_market_descb, o.tran_market_descb) as tran_market_descb -- 交易市场描述
    ,nvl(n.brkevn_idf, o.brkevn_idf) as brkevn_idf -- 保本标识
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.tran_flow_num <> n.tran_flow_num
                or o.bus_id <> n.bus_id
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.tran_dt <> n.tran_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.cntpty_id <> n.cntpty_id
                or o.cntpty_dealer_id <> n.cntpty_dealer_id
                or o.ghb_acct_id <> n.ghb_acct_id
                or o.ghb_dealer_id <> n.ghb_dealer_id
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.pric_amt <> n.pric_amt
                or o.curr_cd <> n.curr_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.exec_int_rat <> n.exec_int_rat
                or o.hook_float_int_rat_cd <> n.hook_float_int_rat_cd
                or o.int_rat_float_point <> n.int_rat_float_point
                or o.pay_int_freq <> n.pay_int_freq
                or o.pay_int_rule_cd <> n.pay_int_rule_cd
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.int_rat_reset_freq <> n.int_rat_reset_freq
                or o.int_rat_reset_rule_cd <> n.int_rat_reset_rule_cd
                or o.holiday_rule_cd <> n.holiday_rule_cd
                or o.int_rat_effect_rule_cd <> n.int_rat_effect_rule_cd
                or o.init_tran_flg <> n.init_tran_flg
                or o.asset_flow_dir_cd <> n.asset_flow_dir_cd
                or o.sys_in_flg <> n.sys_in_flg
                or o.pric_dlvy_amt <> n.pric_dlvy_amt
                or o.int_dlvy_amt <> n.int_dlvy_amt
                or o.asset_dlvy_dt <> n.asset_dlvy_dt
                or o.rpp_dt <> n.rpp_dt
                or o.pay_flg <> n.pay_flg
                or o.valid_flg <> n.valid_flg
                or o.cntpty_type_cd <> n.cntpty_type_cd
                or o.fir_stl_amt <> n.fir_stl_amt
                or o.parent_tran_id <> n.parent_tran_id
                or o.init_tran_id <> n.init_tran_id
                or o.trans_tab_flow_num <> n.trans_tab_flow_num
                or o.rev_tran_flow_num <> n.rev_tran_flow_num
                or o.splt_tran_flg <> n.splt_tran_flg
                or o.asset_pool_flg <> n.asset_pool_flg
                or o.exp_yld_rat <> n.exp_yld_rat
                or o.tran_market_cd <> n.tran_market_cd
                or o.tran_market_descb <> n.tran_market_descb
                or o.brkevn_idf <> n.brkevn_idf
                or o.asset_type_cd <> n.asset_type_cd
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
from ${iml_schema}.agt_am_due_f_banks_famsf1_tm n
    full join ${iml_schema}.agt_am_due_f_banks_famsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_am_due_f_banks truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_am_due_f_banks exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.agt_am_due_f_banks_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_am_due_f_banks drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_am_due_f_banks to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_am_due_f_banks_famsf1_tm purge;
drop table ${iml_schema}.agt_am_due_f_banks_famsf1_ex purge;
drop table ${iml_schema}.agt_am_due_f_banks_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_am_due_f_banks', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);