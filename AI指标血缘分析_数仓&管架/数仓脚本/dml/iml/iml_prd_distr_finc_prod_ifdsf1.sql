/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_distr_finc_prod_ifdsf1
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
drop table ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm purge;
drop table ${iml_schema}.prd_distr_finc_prod_ifdsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_distr_finc_prod add partition p_ifdsf1 values ('ifdsf1')(
        subpartition p_ifdsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_distr_finc_prod modify partition p_ifdsf1
    add subpartition p_ifdsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_distr_finc_prod_ifdsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_distr_finc_prod partition for ('ifdsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,src_prod_id -- 源产品编号
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,bus_cate_cd -- 业务类别代码
    ,ta_cd -- TA代码
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_cd -- 产品托管人代码
    ,mger_cd -- 管理人代码
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,charge_way_cd -- 收费方式代码
    ,subscr_export_way_cd -- 认购导出方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,risk_level_cd -- 风险等级代码
    ,tran_status_cd -- 交易状态代码
    ,tran_cd -- 转换代码
    ,tard_way_cd -- 交易方式代码
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,tran_org_id -- 交易机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_exp_dt -- 利息到期日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_lot -- 当前份额
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,tepla_flg -- 模板标志
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,cfm_ratio -- 确认比例
    ,out_charge_flg -- 外收费标志
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_amax_bamt -- 机构单户累计最大购买金额
    ,acm_corp_divd -- 累计单位分红
    ,clear_post_days -- 清算延后天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,prod_tepla_id -- 产品模板编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_distr_finc_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_distr_finc_prod_ifdsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_distr_finc_prod partition for ('ifdsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_fds_tbproduct-
insert into ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,src_prod_id -- 源产品编号
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,bus_cate_cd -- 业务类别代码
    ,ta_cd -- TA代码
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_cd -- 产品托管人代码
    ,mger_cd -- 管理人代码
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,charge_way_cd -- 收费方式代码
    ,subscr_export_way_cd -- 认购导出方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,risk_level_cd -- 风险等级代码
    ,tran_status_cd -- 交易状态代码
    ,tran_cd -- 转换代码
    ,tard_way_cd -- 交易方式代码
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,tran_org_id -- 交易机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_exp_dt -- 利息到期日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_lot -- 当前份额
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,tepla_flg -- 模板标志
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,cfm_ratio -- 确认比例
    ,out_charge_flg -- 外收费标志
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_amax_bamt -- 机构单户累计最大购买金额
    ,acm_corp_divd -- 累计单位分红
    ,clear_post_days -- 清算延后天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,prod_tepla_id -- 产品模板编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223004'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.REAL_PRD_CODE -- 理财产品编号
    ,P1.PRD_CODE -- 源产品编号
    ,P1.PRD_NAME -- 产品名称
    ,P1.PRD_NAME2 -- 产品别名
    ,P1.MODEL_FLAG -- 产品归属类别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PRD_TYPE END -- 业务类别代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.TA_CODE END -- TA代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURR_TYPE END -- 币种代码
    ,P1.CASH_FLAG -- 钞汇标识代码
    ,P1.PRD_SPONSOR -- 产品发起人编号
    ,P1.PRD_TRUSTEE -- 产品托管人代码
    ,P1.PRD_MANAGER -- 管理人代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DIV_MODES END -- 允许分红方式代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.DIV_MODE END -- 默认分红方式代码
    ,P1.LIQU_MODE -- 募集期账务模式代码
    ,P1.LIQU_MODE2 -- 开放期账务模式代码
    ,NVL(TRIM(P1.SHARE_CLASS),'-') -- 收费方式代码
    ,NVL(TRIM(P1.SUB_EXP),'9') -- 认购导出方式代码
    ,P1.INTEREST_WAY -- 收益体现方式代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.RISK_LEVEL) END -- 风险等级代码
    ,P1.STATUS -- 交易状态代码
    ,P1.CONV_FLAG -- 转换代码
    ,NVL(TRIM(P1.TRANS_WAY),'-') -- 交易方式代码
    ,P1.NAV -- 产品净值
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.NAV_DATE)) -- 净值日期
    ,P1.NAV_DAYS -- 净值天数
    ,P1.FACE_VALUE -- 产品面值
    ,P1.ISS_PRICE -- 发行价格
    ,P1.BRANCH_NO -- 交易机构编号
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.IPO_START_DATE)) -- 募集开始日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.IPO_END_DATE)) -- 募集结束日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.ESTAB_DATE)) -- 产品成立日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.INCOME_DATE)) -- 产品起息日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.END_DATE)) -- 产品结束日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.INTEREST_END_DATE)) -- 利息到期日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.INCOME_END_DATE)) -- 收益到期日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ISSUE_FAIL_DATE)) -- 募集失败日期
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.ALIMIT_END_DATE)) -- 募集后封闭到期日期
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.REAL_ESTAB_DATE)) -- 实际成立日期
    ,P1.PRD_MIN_BALA -- 产品最低募集金额
    ,P1.PRD_MAX_BALA -- 产品最高募集金额
    ,P1.PRD_MIN_SHARES -- 产品最低募集份额
    ,P1.PRD_MAX_SHARES -- 产品最高募集份额
    ,P1.PRD_ISSUE_REAL_BALA -- 产品实际募集金额
    ,P1.CURR_SCALE -- 当前份额
    ,P1.INST_FLAG -- 销售区域控制标志
    ,P1.LIMIT_FLAG -- 额度控制标志
    ,P1.TEMP_FLAG -- 模板标志
    ,P1.CONTROL_FLAG -- 控制标志组合
    ,P1.CONTROL_FLAG2 -- BTA控制标志组合
    ,P1.ISSUE_CFM_RATE -- 确认比例
    ,P1.SUB_MODE -- 外收费标志
    ,P1.PRD_TOTVOL -- 产品当前总份额
    ,P1.TOT_NAV -- 产品累计净值
    ,P1.PSUB_UNIT -- 个人最小购买单位
    ,P1.PFIRST_AMT -- 个人首次最低投资金额
    ,P1.PAPP_AMT -- 个人追加最低投资金额
    ,P1.PMIN_INVEST_AMT -- 个人最低定投金额
    ,P1.PMIN_HOLD -- 个人最低持有份额
    ,P1.PMAX_AMT -- 个人单笔最大购买金额
    ,P1.PMAX_ACCU_AMT -- 个人单户累计最大购买金额
    ,P1.OSUB_UNIT -- 机构最小购买单位
    ,P1.OFIRST_AMT -- 机构首次最低投资金额
    ,P1.OAPP_AMT -- 机构追加最低投资金额
    ,P1.OMIN_INVEST_AMT -- 机构最低定投金额
    ,P1.OMIN_HOLD -- 机构最低持有份额
    ,P1.OMAX_AMT -- 机构单笔最大购买金额
    ,P1.OMAX_ACCU_AMT -- 机构单户累计最大购买金额
    ,P1.TOTAL_BONUS -- 累计单位分红
    ,P1.TN_CONFIRM -- 清算延后天数
    ,P1.GUEST_RATE -- 预期收益率
    ,P1.CYCLE_DAYS -- 周期天数
    ,P1.RESERVE1 -- 产品模板编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_fds_tbproduct' -- 源表名称
    ,'ifdsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_fds_tbproduct p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PRD_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'PRD_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUS_CATE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.TA_CODE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'IFMS'
        AND R8.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R8.SRC_FIELD_EN_NAME= 'TA_CODE'
        AND R8.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'TA_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURR_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DIV_MODES = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IFMS'
        AND R4.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R4.SRC_FIELD_EN_NAME= 'DIV_MODES'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ALLOW_DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.DIV_MODE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IFMS'
        AND R5.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R5.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DEFLT_DIVD_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on TO_CHAR(P1.RISK_LEVEL) = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'IFMS'
        AND R7.SRC_TAB_EN_NAME= 'IFMS_FDS_TBPRODUCT'
        AND R7.SRC_FIELD_EN_NAME= 'RISK_LEVEL'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_DISTR_FINC_PROD'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'RISK_LEVEL_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm 
  	                                group by 
  	                                        prod_id
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
insert /*+ append */ into ${iml_schema}.prd_distr_finc_prod_ifdsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,src_prod_id -- 源产品编号
    ,prod_name -- 产品名称
    ,prod_alias -- 产品别名
    ,prod_belong_cate_cd -- 产品归属类别代码
    ,bus_cate_cd -- 业务类别代码
    ,ta_cd -- TA代码
    ,curr_cd -- 币种代码
    ,ec_idf_cd -- 钞汇标识代码
    ,prod_sponsor_id -- 产品发起人编号
    ,prod_trustee_cd -- 产品托管人代码
    ,mger_cd -- 管理人代码
    ,allow_divd_way_cd -- 允许分红方式代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,coll_term_acct_mode_cd -- 募集期账务模式代码
    ,open_term_acct_mode_cd -- 开放期账务模式代码
    ,charge_way_cd -- 收费方式代码
    ,subscr_export_way_cd -- 认购导出方式代码
    ,prft_embody_way_cd -- 收益体现方式代码
    ,risk_level_cd -- 风险等级代码
    ,tran_status_cd -- 交易状态代码
    ,tran_cd -- 转换代码
    ,tard_way_cd -- 交易方式代码
    ,prod_nv -- 产品净值
    ,nv_dt -- 净值日期
    ,nv_days -- 净值天数
    ,prod_fac_val -- 产品面值
    ,issue_price -- 发行价格
    ,tran_org_id -- 交易机构编号
    ,coll_start_dt -- 募集开始日期
    ,coll_end_dt -- 募集结束日期
    ,prod_found_dt -- 产品成立日期
    ,prod_value_dt -- 产品起息日期
    ,prod_end_dt -- 产品结束日期
    ,int_exp_dt -- 利息到期日期
    ,prft_exp_dt -- 收益到期日期
    ,coll_fail_dt -- 募集失败日期
    ,aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,actl_found_dt -- 实际成立日期
    ,prod_lowt_coll_amt -- 产品最低募集金额
    ,prod_higt_coll_amt -- 产品最高募集金额
    ,prod_lowt_coll_lot -- 产品最低募集份额
    ,prod_higt_coll_lot -- 产品最高募集份额
    ,prod_actl_coll_amt -- 产品实际募集金额
    ,curr_lot -- 当前份额
    ,sell_rg_ctrl_flg -- 销售区域控制标志
    ,lmt_ctrl_flg -- 额度控制标志
    ,tepla_flg -- 模板标志
    ,ctrl_flg_comb -- 控制标志组合
    ,bta_ctrl_flg_comb -- BTA控制标志组合
    ,cfm_ratio -- 确认比例
    ,out_charge_flg -- 外收费标志
    ,prod_curr_tot_lot -- 产品当前总份额
    ,prod_acm_nv -- 产品累计净值
    ,indv_min_buy_corp -- 个人最小购买单位
    ,indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,indv_lowt_aip_amt -- 个人最低定投金额
    ,indv_lowt_hold_lot -- 个人最低持有份额
    ,indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,indv_single_amax_bamt -- 个人单户累计最大购买金额
    ,org_min_buy_corp -- 机构最小购买单位
    ,org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,org_lowt_aip_amt -- 机构最低定投金额
    ,org_lowt_hold_lot -- 机构最低持有份额
    ,org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,org_single_amax_bamt -- 机构单户累计最大购买金额
    ,acm_corp_divd -- 累计单位分红
    ,clear_post_days -- 清算延后天数
    ,expe_yld_rat -- 预期收益率
    ,ped_days -- 周期天数
    ,prod_tepla_id -- 产品模板编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.src_prod_id, o.src_prod_id) as src_prod_id -- 源产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.prod_alias, o.prod_alias) as prod_alias -- 产品别名
    ,nvl(n.prod_belong_cate_cd, o.prod_belong_cate_cd) as prod_belong_cate_cd -- 产品归属类别代码
    ,nvl(n.bus_cate_cd, o.bus_cate_cd) as bus_cate_cd -- 业务类别代码
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.prod_sponsor_id, o.prod_sponsor_id) as prod_sponsor_id -- 产品发起人编号
    ,nvl(n.prod_trustee_cd, o.prod_trustee_cd) as prod_trustee_cd -- 产品托管人代码
    ,nvl(n.mger_cd, o.mger_cd) as mger_cd -- 管理人代码
    ,nvl(n.allow_divd_way_cd, o.allow_divd_way_cd) as allow_divd_way_cd -- 允许分红方式代码
    ,nvl(n.deflt_divd_way_cd, o.deflt_divd_way_cd) as deflt_divd_way_cd -- 默认分红方式代码
    ,nvl(n.coll_term_acct_mode_cd, o.coll_term_acct_mode_cd) as coll_term_acct_mode_cd -- 募集期账务模式代码
    ,nvl(n.open_term_acct_mode_cd, o.open_term_acct_mode_cd) as open_term_acct_mode_cd -- 开放期账务模式代码
    ,nvl(n.charge_way_cd, o.charge_way_cd) as charge_way_cd -- 收费方式代码
    ,nvl(n.subscr_export_way_cd, o.subscr_export_way_cd) as subscr_export_way_cd -- 认购导出方式代码
    ,nvl(n.prft_embody_way_cd, o.prft_embody_way_cd) as prft_embody_way_cd -- 收益体现方式代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 转换代码
    ,nvl(n.tard_way_cd, o.tard_way_cd) as tard_way_cd -- 交易方式代码
    ,nvl(n.prod_nv, o.prod_nv) as prod_nv -- 产品净值
    ,nvl(n.nv_dt, o.nv_dt) as nv_dt -- 净值日期
    ,nvl(n.nv_days, o.nv_days) as nv_days -- 净值天数
    ,nvl(n.prod_fac_val, o.prod_fac_val) as prod_fac_val -- 产品面值
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.coll_start_dt, o.coll_start_dt) as coll_start_dt -- 募集开始日期
    ,nvl(n.coll_end_dt, o.coll_end_dt) as coll_end_dt -- 募集结束日期
    ,nvl(n.prod_found_dt, o.prod_found_dt) as prod_found_dt -- 产品成立日期
    ,nvl(n.prod_value_dt, o.prod_value_dt) as prod_value_dt -- 产品起息日期
    ,nvl(n.prod_end_dt, o.prod_end_dt) as prod_end_dt -- 产品结束日期
    ,nvl(n.int_exp_dt, o.int_exp_dt) as int_exp_dt -- 利息到期日期
    ,nvl(n.prft_exp_dt, o.prft_exp_dt) as prft_exp_dt -- 收益到期日期
    ,nvl(n.coll_fail_dt, o.coll_fail_dt) as coll_fail_dt -- 募集失败日期
    ,nvl(n.aft_coll_close_exp_dt, o.aft_coll_close_exp_dt) as aft_coll_close_exp_dt -- 募集后封闭到期日期
    ,nvl(n.actl_found_dt, o.actl_found_dt) as actl_found_dt -- 实际成立日期
    ,nvl(n.prod_lowt_coll_amt, o.prod_lowt_coll_amt) as prod_lowt_coll_amt -- 产品最低募集金额
    ,nvl(n.prod_higt_coll_amt, o.prod_higt_coll_amt) as prod_higt_coll_amt -- 产品最高募集金额
    ,nvl(n.prod_lowt_coll_lot, o.prod_lowt_coll_lot) as prod_lowt_coll_lot -- 产品最低募集份额
    ,nvl(n.prod_higt_coll_lot, o.prod_higt_coll_lot) as prod_higt_coll_lot -- 产品最高募集份额
    ,nvl(n.prod_actl_coll_amt, o.prod_actl_coll_amt) as prod_actl_coll_amt -- 产品实际募集金额
    ,nvl(n.curr_lot, o.curr_lot) as curr_lot -- 当前份额
    ,nvl(n.sell_rg_ctrl_flg, o.sell_rg_ctrl_flg) as sell_rg_ctrl_flg -- 销售区域控制标志
    ,nvl(n.lmt_ctrl_flg, o.lmt_ctrl_flg) as lmt_ctrl_flg -- 额度控制标志
    ,nvl(n.tepla_flg, o.tepla_flg) as tepla_flg -- 模板标志
    ,nvl(n.ctrl_flg_comb, o.ctrl_flg_comb) as ctrl_flg_comb -- 控制标志组合
    ,nvl(n.bta_ctrl_flg_comb, o.bta_ctrl_flg_comb) as bta_ctrl_flg_comb -- BTA控制标志组合
    ,nvl(n.cfm_ratio, o.cfm_ratio) as cfm_ratio -- 确认比例
    ,nvl(n.out_charge_flg, o.out_charge_flg) as out_charge_flg -- 外收费标志
    ,nvl(n.prod_curr_tot_lot, o.prod_curr_tot_lot) as prod_curr_tot_lot -- 产品当前总份额
    ,nvl(n.prod_acm_nv, o.prod_acm_nv) as prod_acm_nv -- 产品累计净值
    ,nvl(n.indv_min_buy_corp, o.indv_min_buy_corp) as indv_min_buy_corp -- 个人最小购买单位
    ,nvl(n.indv_fir_lowt_invest_amt, o.indv_fir_lowt_invest_amt) as indv_fir_lowt_invest_amt -- 个人首次最低投资金额
    ,nvl(n.indv_supp_lowt_invest_amt, o.indv_supp_lowt_invest_amt) as indv_supp_lowt_invest_amt -- 个人追加最低投资金额
    ,nvl(n.indv_lowt_aip_amt, o.indv_lowt_aip_amt) as indv_lowt_aip_amt -- 个人最低定投金额
    ,nvl(n.indv_lowt_hold_lot, o.indv_lowt_hold_lot) as indv_lowt_hold_lot -- 个人最低持有份额
    ,nvl(n.indv_sig_max_buy_amt, o.indv_sig_max_buy_amt) as indv_sig_max_buy_amt -- 个人单笔最大购买金额
    ,nvl(n.indv_single_amax_bamt, o.indv_single_amax_bamt) as indv_single_amax_bamt -- 个人单户累计最大购买金额
    ,nvl(n.org_min_buy_corp, o.org_min_buy_corp) as org_min_buy_corp -- 机构最小购买单位
    ,nvl(n.org_fir_lowt_invest_amt, o.org_fir_lowt_invest_amt) as org_fir_lowt_invest_amt -- 机构首次最低投资金额
    ,nvl(n.org_supp_lowt_invest_amt, o.org_supp_lowt_invest_amt) as org_supp_lowt_invest_amt -- 机构追加最低投资金额
    ,nvl(n.org_lowt_aip_amt, o.org_lowt_aip_amt) as org_lowt_aip_amt -- 机构最低定投金额
    ,nvl(n.org_lowt_hold_lot, o.org_lowt_hold_lot) as org_lowt_hold_lot -- 机构最低持有份额
    ,nvl(n.org_sig_max_buy_amt, o.org_sig_max_buy_amt) as org_sig_max_buy_amt -- 机构单笔最大购买金额
    ,nvl(n.org_single_amax_bamt, o.org_single_amax_bamt) as org_single_amax_bamt -- 机构单户累计最大购买金额
    ,nvl(n.acm_corp_divd, o.acm_corp_divd) as acm_corp_divd -- 累计单位分红
    ,nvl(n.clear_post_days, o.clear_post_days) as clear_post_days -- 清算延后天数
    ,nvl(n.expe_yld_rat, o.expe_yld_rat) as expe_yld_rat -- 预期收益率
    ,nvl(n.ped_days, o.ped_days) as ped_days -- 周期天数
    ,nvl(n.prod_tepla_id, o.prod_tepla_id) as prod_tepla_id -- 产品模板编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.finc_prod_id <> n.finc_prod_id
                or o.src_prod_id <> n.src_prod_id
                or o.prod_name <> n.prod_name
                or o.prod_alias <> n.prod_alias
                or o.prod_belong_cate_cd <> n.prod_belong_cate_cd
                or o.bus_cate_cd <> n.bus_cate_cd
                or o.ta_cd <> n.ta_cd
                or o.curr_cd <> n.curr_cd
                or o.ec_idf_cd <> n.ec_idf_cd
                or o.prod_sponsor_id <> n.prod_sponsor_id
                or o.prod_trustee_cd <> n.prod_trustee_cd
                or o.mger_cd <> n.mger_cd
                or o.allow_divd_way_cd <> n.allow_divd_way_cd
                or o.deflt_divd_way_cd <> n.deflt_divd_way_cd
                or o.coll_term_acct_mode_cd <> n.coll_term_acct_mode_cd
                or o.open_term_acct_mode_cd <> n.open_term_acct_mode_cd
                or o.charge_way_cd <> n.charge_way_cd
                or o.subscr_export_way_cd <> n.subscr_export_way_cd
                or o.prft_embody_way_cd <> n.prft_embody_way_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.tran_status_cd <> n.tran_status_cd
                or o.tran_cd <> n.tran_cd
                or o.tard_way_cd <> n.tard_way_cd
                or o.prod_nv <> n.prod_nv
                or o.nv_dt <> n.nv_dt
                or o.nv_days <> n.nv_days
                or o.prod_fac_val <> n.prod_fac_val
                or o.issue_price <> n.issue_price
                or o.tran_org_id <> n.tran_org_id
                or o.coll_start_dt <> n.coll_start_dt
                or o.coll_end_dt <> n.coll_end_dt
                or o.prod_found_dt <> n.prod_found_dt
                or o.prod_value_dt <> n.prod_value_dt
                or o.prod_end_dt <> n.prod_end_dt
                or o.int_exp_dt <> n.int_exp_dt
                or o.prft_exp_dt <> n.prft_exp_dt
                or o.coll_fail_dt <> n.coll_fail_dt
                or o.aft_coll_close_exp_dt <> n.aft_coll_close_exp_dt
                or o.actl_found_dt <> n.actl_found_dt
                or o.prod_lowt_coll_amt <> n.prod_lowt_coll_amt
                or o.prod_higt_coll_amt <> n.prod_higt_coll_amt
                or o.prod_lowt_coll_lot <> n.prod_lowt_coll_lot
                or o.prod_higt_coll_lot <> n.prod_higt_coll_lot
                or o.prod_actl_coll_amt <> n.prod_actl_coll_amt
                or o.curr_lot <> n.curr_lot
                or o.sell_rg_ctrl_flg <> n.sell_rg_ctrl_flg
                or o.lmt_ctrl_flg <> n.lmt_ctrl_flg
                or o.tepla_flg <> n.tepla_flg
                or o.ctrl_flg_comb <> n.ctrl_flg_comb
                or o.bta_ctrl_flg_comb <> n.bta_ctrl_flg_comb
                or o.cfm_ratio <> n.cfm_ratio
                or o.out_charge_flg <> n.out_charge_flg
                or o.prod_curr_tot_lot <> n.prod_curr_tot_lot
                or o.prod_acm_nv <> n.prod_acm_nv
                or o.indv_min_buy_corp <> n.indv_min_buy_corp
                or o.indv_fir_lowt_invest_amt <> n.indv_fir_lowt_invest_amt
                or o.indv_supp_lowt_invest_amt <> n.indv_supp_lowt_invest_amt
                or o.indv_lowt_aip_amt <> n.indv_lowt_aip_amt
                or o.indv_lowt_hold_lot <> n.indv_lowt_hold_lot
                or o.indv_sig_max_buy_amt <> n.indv_sig_max_buy_amt
                or o.indv_single_amax_bamt <> n.indv_single_amax_bamt
                or o.org_min_buy_corp <> n.org_min_buy_corp
                or o.org_fir_lowt_invest_amt <> n.org_fir_lowt_invest_amt
                or o.org_supp_lowt_invest_amt <> n.org_supp_lowt_invest_amt
                or o.org_lowt_aip_amt <> n.org_lowt_aip_amt
                or o.org_lowt_hold_lot <> n.org_lowt_hold_lot
                or o.org_sig_max_buy_amt <> n.org_sig_max_buy_amt
                or o.org_single_amax_bamt <> n.org_single_amax_bamt
                or o.acm_corp_divd <> n.acm_corp_divd
                or o.clear_post_days <> n.clear_post_days
                or o.expe_yld_rat <> n.expe_yld_rat
                or o.ped_days <> n.ped_days
                or o.prod_tepla_id <> n.prod_tepla_id
            ) or (
                 case when (
                           n.prod_id is null
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
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm n
    full join ${iml_schema}.prd_distr_finc_prod_ifdsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_distr_finc_prod truncate partition for ('ifdsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_distr_finc_prod exchange subpartition p_ifdsf1_${batch_date} with table ${iml_schema}.prd_distr_finc_prod_ifdsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_distr_finc_prod drop subpartition p_ifdsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_distr_finc_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_distr_finc_prod_ifdsf1_tm purge;
drop table ${iml_schema}.prd_distr_finc_prod_ifdsf1_ex purge;
drop table ${iml_schema}.prd_distr_finc_prod_ifdsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_distr_finc_prod', partname => 'p_ifdsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);