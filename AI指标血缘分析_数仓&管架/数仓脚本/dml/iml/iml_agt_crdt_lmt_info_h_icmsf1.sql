/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_lmt_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_crdt_lmt_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_lmt_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_lmt_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cl_credit_info-1
insert into ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300010'||P1.CREDITNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CREDITNO -- 额度编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.AVAILABLEBUSINESSTYPE -- 适用产品编号
    ,P1.CREDITTYPE -- 额度产品编号
    ,nvl(trim(P1.CREDITPHASE),'-') -- 当前授信阶段代码
    ,P1.SOURCESYSTEM -- 最初来源系统代码
    ,P1.SOURCECREDITNO -- 最初来源额度编号
    ,nvl(trim(P1.OCCURWAY),'-') -- 发生方式代码
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.AVAILABLENOMINALAMOUNT -- 可用名义金额
    ,P1.AVAILABLEEXPOSUREAMOUNT -- 可用敞口金额
    ,P1.EXPOSUREAMOUNT -- 敞口金额
    ,P1.NOMINALAMOUNT -- 名义金额
    ,P1.EXECNOMINALAMOUNT -- 执行名义金额
    ,P1.EXECEXPOSUREAMOUNT -- 执行敞口金额
    ,P1.EXECSLOWRELEASEEXPOSUREAMOUNT -- 执行可缓释敞口金额
    ,nvl(trim(P1.SLOWRELEASEEXPOSURECURRENCY),'-') -- 可缓释敞口币种代码
    ,P1.SLOWRELEASEEXPOSUREAMOUNT -- 可缓释敞口金额
    ,nvl(trim(P1.RECYCLABLE),'-') -- 可循环标志
    ,P1.CANBEEXTRACTEDUNDERCREDIT -- 额度项下可直接提款标志
    ,P1.EFFECTIVEDATE -- 生效日期
    ,decode(p1.EXPIREDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.EXPIREDATE) -- 到期日期
    ,nvl(trim(P1.OCCUPYFLAG),'-') -- 占用标识代码
    ,P1.LOCKFLAG -- 锁定标志
    ,P1.FREEZESTATUS -- 已冻结标志
    ,nvl(trim(P1.STATUS),'-') -- 状态代码
    ,P1.NOMINALBALANCE -- 授信名义余额
    ,P1.EXPOSUREBALANCE -- 授信敞口余额
    ,P1.LOWEROCCUPYUPPEREXPOSUREAMOUNT -- 下层占用上层授信敞口金额
    ,P1.LOWEROCCUPYUPPERNOMINALAMOUNT -- 下层占用上层授信名义金额
    ,P1.ASSIGNOCCUPYUPPEREXPOSUREAMOUN -- 指定占用上层授信敞口金额
    ,P1.ASSIGNOCCUPYUPPERNOMINALAMOUNT -- 指定占用上层授信名义金额
    ,p1.LATESTARTDATEUNDERLOWERCREDIT -- 项下下层授信最迟起始日期
    ,p1.EARLYSTARTDATEUNDERLOWERCREDIT -- 项下下层授信最早起始日期
    ,decode(p1.LATESTUSEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.LATESTUSEDATE) -- 额度最迟使用日期
    ,decode(p1.LATEEXPIREDATEUNDERLOWERCREDIT,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.LATEEXPIREDATEUNDERLOWERCREDIT) -- 项下下层授信最迟到期日期
    ,P1.MAXPERIODMONTHUNDERLOWERCREDIT -- 项下下层授信最长月期限
    ,P1.MAXPERIODDAYUNDERLOWERCREDIT -- 项下下层授信最长日期限
    ,P1.SUBOCCUPYNOMINALBALANCE -- 下层授信名义余额占用汇总
    ,P1.SUBOCCUPYEXPOSUREBALANCE -- 下层授信敞口余额占用汇总
    ,P1.SINGLEBIZMOSTAMOUNT -- 明细额度下业务单笔最大金额
    ,P1.BIZLOWESTFLOATRATE -- 额度下业务利率最低浮动值
    ,P1.BIZBAILINITIALRATE -- 额度下业务初始保证金比例
    ,P1.BIZMOSTMORTGAGERATE -- 额度下业务最高抵质押率
    ,P1.BUSINESSOCCUPYNOMINALAMOUNT -- 下层业务占用名义金额汇总
    ,P1.BUSINESSOCCUPYEXPOSUREAMOUNT -- 下层业务占用敞口金额汇总
    ,P1.ADJUSTNOMINALAMOUNT -- 串用名义金额
    ,P1.ADJUSTEXPOSUREAMOUNT -- 串用敞口金额
    ,P1.PRENOMINALAMOUNT -- 预占名义金额
    ,P1.PREEXPOSUREAMOUNT -- 预占敞口金额
    ,P1.LEFTPRENOMINALAMOUNT -- 剩余预占名义金额
    ,P1.LEFTPREEXPOSUREAMOUNT -- 剩余预占敞口金额
    ,P1.FREEZENOMINALAMOUNT -- 冻结名义金额
    ,P1.FREEZEEXPOSUREAMOUNT -- 冻结敞口金额
    ,nvl(trim(P1.CURRENCYRANGE),'-') -- 项下业务币种代码范围
    ,P1.DEDICATEDFLAG -- 授信专用标志
    ,P1.AVAILABLERESERVEDAMOUNT -- 可用预留金额
    ,P1.RESERVEDAMOUNT -- 预留金额
    ,P1.USABLEAMOUNTCALCFLAG -- 可用金额计算标志
    ,nvl(trim(P1.GUARANTYWAY),'-') -- 担保方式代码
    ,P1.TIMELIMITDAY -- 日期限
    ,P1.TIMELIMITMONTH -- 月期限
    ,P1.TOTALPAYMENT -- 累计放款金额
    ,P1.TOTALREPAYMENT -- 累计还款金额
    ,decode(p1.ACTUALEXPIREDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.ACTUALEXPIREDATE) -- 实际失效日期
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.MANAGEUSERID -- 管理柜员编号
    ,P1.MANAGEORGID -- 管理机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,p1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,nvl(trim(P1.LINECLASS),'-') -- 额度种类代码
    ,nvl(trim(P1.ISPUBLICCREDIT),'-') -- 公开授信标志
    ,P1.PURPOSE -- 用途描述
    ,P1.ADDITIONCOMMAND -- 其他条件描述
    ,P1.RESERVEDCUSTOMERID -- 集团成员客户编号
    ,P1.ONLINEAMOUNT -- 初始线上额度
    ,decode(P1.ISTRANS,' ','-','Y','1','N','0',P1.ISTRANS) -- 转授信标志
    ,P1.RISKEXPOSURESUM -- 初始一般敞口金额
    ,P1.AVAILABLERISKEXPOSURESUM -- 一般风险可用敞口金额
    ,P1.PLEDGESUM -- 抵质押物金额
    ,P1.ONLINEBUSINESSAMOUNT -- 资金系统线上业务金额汇总
    ,P1.ONLINEBUSINESSBALANCE -- 资金系统线上业务余额汇总
    ,P1.LOWOCCUPYNOMINALAMOUNTONLINE -- 下层占用线上额度金额
    ,P1.LOWOCCUPYEXPOSUREAMOUNTONLINE -- 下层占用线上敞口金额
    ,decode(P1.ISJOINLIMITS,' ','-','Y','1','N','0',P1.ISJOINLIMITS) -- 纳入单一客户或集团限额标志
    ,P1.NBGKOCCUPYAMOUNT -- 内部管控额度占用金额
    ,P1.ICMSAPPROVEAMOUT -- 风控审批可用金额
    ,P1.BAPSERIALNO -- 批复编号
    ,P1.OCCUPYCREDITNO -- 占用集团授信额度编号
    ,P1.RISKAPPROVEAMOUT -- 风控年审审批可用金额
    ,decode(P1.ISEXEMPT,' ','-','Y','1','N','0',P1.ISEXEMPT)  -- 豁免标志
    ,decode(P1.ISCOLLECTIONAGENCY,' ','-','Y','1','N','0',P1.ISCOLLECTIONAGENCY)  -- 集合类代销标志
    ,P1.EXPLAIN -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cl_credit_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cl_credit_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.fit_prod_id, o.fit_prod_id) as fit_prod_id -- 适用产品编号
    ,nvl(n.lmt_prod_id, o.lmt_prod_id) as lmt_prod_id -- 额度产品编号
    ,nvl(n.curr_crdt_stage_cd, o.curr_crdt_stage_cd) as curr_crdt_stage_cd -- 当前授信阶段代码
    ,nvl(n.init_src_sys_cd, o.init_src_sys_cd) as init_src_sys_cd -- 最初来源系统代码
    ,nvl(n.init_src_lmt_id, o.init_src_lmt_id) as init_src_lmt_id -- 最初来源额度编号
    ,nvl(n.happ_way_cd, o.happ_way_cd) as happ_way_cd -- 发生方式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 敞口金额
    ,nvl(n.nmal_amt, o.nmal_amt) as nmal_amt -- 名义金额
    ,nvl(n.exec_nmal_amt, o.exec_nmal_amt) as exec_nmal_amt -- 执行名义金额
    ,nvl(n.exec_open_amt, o.exec_open_amt) as exec_open_amt -- 执行敞口金额
    ,nvl(n.exec_dr_open_amt, o.exec_dr_open_amt) as exec_dr_open_amt -- 执行可缓释敞口金额
    ,nvl(n.dr_open_curr_cd, o.dr_open_curr_cd) as dr_open_curr_cd -- 可缓释敞口币种代码
    ,nvl(n.dr_open_amt, o.dr_open_amt) as dr_open_amt -- 可缓释敞口金额
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 可循环标志
    ,nvl(n.lmt_under_dir_draw_flg, o.lmt_under_dir_draw_flg) as lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.ocup_idf_cd, o.ocup_idf_cd) as ocup_idf_cd -- 占用标识代码
    ,nvl(n.lock_flg, o.lock_flg) as lock_flg -- 锁定标志
    ,nvl(n.aldy_froz_flg, o.aldy_froz_flg) as aldy_froz_flg -- 已冻结标志
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.crdt_nmal_bal, o.crdt_nmal_bal) as crdt_nmal_bal -- 授信名义余额
    ,nvl(n.crdt_open_bal, o.crdt_open_bal) as crdt_open_bal -- 授信敞口余额
    ,nvl(n.lower_ocup_up_level_crdt_open_amt, o.lower_ocup_up_level_crdt_open_amt) as lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,nvl(n.lower_ocup_up_level_crdt_nmal_amt, o.lower_ocup_up_level_crdt_nmal_amt) as lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,nvl(n.spec_ocup_up_level_crdt_open_amt, o.spec_ocup_up_level_crdt_open_amt) as spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,nvl(n.spec_ocup_up_level_crdt_nmal_amt, o.spec_ocup_up_level_crdt_nmal_amt) as spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,nvl(n.under_lower_crdt_latest_begin_dt, o.under_lower_crdt_latest_begin_dt) as under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,nvl(n.under_lower_crdt_earliest_begin_dt, o.under_lower_crdt_earliest_begin_dt) as under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,nvl(n.lmt_latest_use_dt, o.lmt_latest_use_dt) as lmt_latest_use_dt -- 额度最迟使用日期
    ,nvl(n.under_lower_crdt_latest_exp_dt, o.under_lower_crdt_latest_exp_dt) as under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,nvl(n.under_lower_crdt_lont_mon_tenor, o.under_lower_crdt_lont_mon_tenor) as under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,nvl(n.under_lower_crdt_lont_day_tenor, o.under_lower_crdt_lont_day_tenor) as under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,nvl(n.lower_crdt_nmal_bal_ocup_tot, o.lower_crdt_nmal_bal_ocup_tot) as lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,nvl(n.lower_crdt_open_bal_ocup_tot, o.lower_crdt_open_bal_ocup_tot) as lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,nvl(n.dtl_lmt_next_bus_sig_max_amt, o.dtl_lmt_next_bus_sig_max_amt) as dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,nvl(n.lmt_next_bus_int_rat_lowt_flo_val, o.lmt_next_bus_int_rat_lowt_flo_val) as lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,nvl(n.lmt_next_bus_init_margin_ratio, o.lmt_next_bus_init_margin_ratio) as lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,nvl(n.lmt_next_bus_higt_pm_rat, o.lmt_next_bus_higt_pm_rat) as lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,nvl(n.lower_bus_ocup_nmal_amt_tot, o.lower_bus_ocup_nmal_amt_tot) as lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,nvl(n.lower_bus_ocup_open_amt_tot, o.lower_bus_ocup_open_amt_tot) as lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,nvl(n.beads_nmal_amt, o.beads_nmal_amt) as beads_nmal_amt -- 串用名义金额
    ,nvl(n.beads_open_amt, o.beads_open_amt) as beads_open_amt -- 串用敞口金额
    ,nvl(n.pre_ocup_nmal_amt, o.pre_ocup_nmal_amt) as pre_ocup_nmal_amt -- 预占名义金额
    ,nvl(n.pre_ocup_open_amt, o.pre_ocup_open_amt) as pre_ocup_open_amt -- 预占敞口金额
    ,nvl(n.surp_pre_ocup_nmal_amt, o.surp_pre_ocup_nmal_amt) as surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,nvl(n.surp_pre_ocup_open_amt, o.surp_pre_ocup_open_amt) as surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,nvl(n.froz_nmal_amt, o.froz_nmal_amt) as froz_nmal_amt -- 冻结名义金额
    ,nvl(n.froz_open_amt, o.froz_open_amt) as froz_open_amt -- 冻结敞口金额
    ,nvl(n.under_bus_curr_cd_range, o.under_bus_curr_cd_range) as under_bus_curr_cd_range -- 项下业务币种代码范围
    ,nvl(n.crdt_spec_flg, o.crdt_spec_flg) as crdt_spec_flg -- 授信专用标志
    ,nvl(n.aval_rsrv_amt, o.aval_rsrv_amt) as aval_rsrv_amt -- 可用预留金额
    ,nvl(n.rsrv_amt, o.rsrv_amt) as rsrv_amt -- 预留金额
    ,nvl(n.aval_amt_calc_flg, o.aval_amt_calc_flg) as aval_amt_calc_flg -- 可用金额计算标志
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.acm_distr_amt, o.acm_distr_amt) as acm_distr_amt -- 累计放款金额
    ,nvl(n.acm_repay_amt, o.acm_repay_amt) as acm_repay_amt -- 累计还款金额
    ,nvl(n.actl_invalid_dt, o.actl_invalid_dt) as actl_invalid_dt -- 实际失效日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.mgmt_teller_id, o.mgmt_teller_id) as mgmt_teller_id -- 管理柜员编号
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.lmt_kind_cd, o.lmt_kind_cd) as lmt_kind_cd -- 额度种类代码
    ,nvl(n.public_crdt_flg, o.public_crdt_flg) as public_crdt_flg -- 公开授信标志
    ,nvl(n.usage_descb, o.usage_descb) as usage_descb -- 用途描述
    ,nvl(n.other_cond_descb, o.other_cond_descb) as other_cond_descb -- 其他条件描述
    ,nvl(n.gm_cust_id, o.gm_cust_id) as gm_cust_id -- 集团成员客户编号
    ,nvl(n.init_onl_lmt, o.init_onl_lmt) as init_onl_lmt -- 初始线上额度
    ,nvl(n.turn_crdt_flg, o.turn_crdt_flg) as turn_crdt_flg -- 转授信标志
    ,nvl(n.init_comn_open_amt, o.init_comn_open_amt) as init_comn_open_amt -- 初始一般敞口金额
    ,nvl(n.comn_risk_aval_open_amt, o.comn_risk_aval_open_amt) as comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,nvl(n.pmo_amt, o.pmo_amt) as pmo_amt -- 抵质押物金额
    ,nvl(n.cap_sys_onl_bus_amt_tot, o.cap_sys_onl_bus_amt_tot) as cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,nvl(n.cap_sys_onl_bus_bal_tot, o.cap_sys_onl_bus_bal_tot) as cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,nvl(n.lower_ocup_onl_lmt_amt, o.lower_ocup_onl_lmt_amt) as lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,nvl(n.lower_ocup_onl_open_amt, o.lower_ocup_onl_open_amt) as lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,nvl(n.fit_in_single_cust_or_group_lmt_flg, o.fit_in_single_cust_or_group_lmt_flg) as fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,nvl(n.intnal_contr_amt_degree_ocup_amt, o.intnal_contr_amt_degree_ocup_amt) as intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,nvl(n.risk_mgmt_apv_aval_amt, o.risk_mgmt_apv_aval_amt) as risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,nvl(n.reply_id, o.reply_id) as reply_id -- 批复编号
    ,nvl(n.ocup_group_crdt_lmt_id, o.ocup_group_crdt_lmt_id) as ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,nvl(n.risk_mgmt_annual_vrfction_apv_aval_amt, o.risk_mgmt_annual_vrfction_apv_aval_amt) as risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,nvl(n.free_flg, o.free_flg) as free_flg -- 豁免标志
    ,nvl(n.comb_class_consmt_flg, o.comb_class_consmt_flg) as comb_class_consmt_flg -- 集合类代销标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.lmt_id <> n.lmt_id
        or o.cust_id <> n.cust_id
        or o.fit_prod_id <> n.fit_prod_id
        or o.lmt_prod_id <> n.lmt_prod_id
        or o.curr_crdt_stage_cd <> n.curr_crdt_stage_cd
        or o.init_src_sys_cd <> n.init_src_sys_cd
        or o.init_src_lmt_id <> n.init_src_lmt_id
        or o.happ_way_cd <> n.happ_way_cd
        or o.curr_cd <> n.curr_cd
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.open_amt <> n.open_amt
        or o.nmal_amt <> n.nmal_amt
        or o.exec_nmal_amt <> n.exec_nmal_amt
        or o.exec_open_amt <> n.exec_open_amt
        or o.exec_dr_open_amt <> n.exec_dr_open_amt
        or o.dr_open_curr_cd <> n.dr_open_curr_cd
        or o.dr_open_amt <> n.dr_open_amt
        or o.circl_flg <> n.circl_flg
        or o.lmt_under_dir_draw_flg <> n.lmt_under_dir_draw_flg
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.ocup_idf_cd <> n.ocup_idf_cd
        or o.lock_flg <> n.lock_flg
        or o.aldy_froz_flg <> n.aldy_froz_flg
        or o.status_cd <> n.status_cd
        or o.crdt_nmal_bal <> n.crdt_nmal_bal
        or o.crdt_open_bal <> n.crdt_open_bal
        or o.lower_ocup_up_level_crdt_open_amt <> n.lower_ocup_up_level_crdt_open_amt
        or o.lower_ocup_up_level_crdt_nmal_amt <> n.lower_ocup_up_level_crdt_nmal_amt
        or o.spec_ocup_up_level_crdt_open_amt <> n.spec_ocup_up_level_crdt_open_amt
        or o.spec_ocup_up_level_crdt_nmal_amt <> n.spec_ocup_up_level_crdt_nmal_amt
        or o.under_lower_crdt_latest_begin_dt <> n.under_lower_crdt_latest_begin_dt
        or o.under_lower_crdt_earliest_begin_dt <> n.under_lower_crdt_earliest_begin_dt
        or o.lmt_latest_use_dt <> n.lmt_latest_use_dt
        or o.under_lower_crdt_latest_exp_dt <> n.under_lower_crdt_latest_exp_dt
        or o.under_lower_crdt_lont_mon_tenor <> n.under_lower_crdt_lont_mon_tenor
        or o.under_lower_crdt_lont_day_tenor <> n.under_lower_crdt_lont_day_tenor
        or o.lower_crdt_nmal_bal_ocup_tot <> n.lower_crdt_nmal_bal_ocup_tot
        or o.lower_crdt_open_bal_ocup_tot <> n.lower_crdt_open_bal_ocup_tot
        or o.dtl_lmt_next_bus_sig_max_amt <> n.dtl_lmt_next_bus_sig_max_amt
        or o.lmt_next_bus_int_rat_lowt_flo_val <> n.lmt_next_bus_int_rat_lowt_flo_val
        or o.lmt_next_bus_init_margin_ratio <> n.lmt_next_bus_init_margin_ratio
        or o.lmt_next_bus_higt_pm_rat <> n.lmt_next_bus_higt_pm_rat
        or o.lower_bus_ocup_nmal_amt_tot <> n.lower_bus_ocup_nmal_amt_tot
        or o.lower_bus_ocup_open_amt_tot <> n.lower_bus_ocup_open_amt_tot
        or o.beads_nmal_amt <> n.beads_nmal_amt
        or o.beads_open_amt <> n.beads_open_amt
        or o.pre_ocup_nmal_amt <> n.pre_ocup_nmal_amt
        or o.pre_ocup_open_amt <> n.pre_ocup_open_amt
        or o.surp_pre_ocup_nmal_amt <> n.surp_pre_ocup_nmal_amt
        or o.surp_pre_ocup_open_amt <> n.surp_pre_ocup_open_amt
        or o.froz_nmal_amt <> n.froz_nmal_amt
        or o.froz_open_amt <> n.froz_open_amt
        or o.under_bus_curr_cd_range <> n.under_bus_curr_cd_range
        or o.crdt_spec_flg <> n.crdt_spec_flg
        or o.aval_rsrv_amt <> n.aval_rsrv_amt
        or o.rsrv_amt <> n.rsrv_amt
        or o.aval_amt_calc_flg <> n.aval_amt_calc_flg
        or o.guar_way_cd <> n.guar_way_cd
        or o.day_tenor <> n.day_tenor
        or o.mon_tenor <> n.mon_tenor
        or o.acm_distr_amt <> n.acm_distr_amt
        or o.acm_repay_amt <> n.acm_repay_amt
        or o.actl_invalid_dt <> n.actl_invalid_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.mgmt_teller_id <> n.mgmt_teller_id
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
        or o.lmt_kind_cd <> n.lmt_kind_cd
        or o.public_crdt_flg <> n.public_crdt_flg
        or o.usage_descb <> n.usage_descb
        or o.other_cond_descb <> n.other_cond_descb
        or o.gm_cust_id <> n.gm_cust_id
        or o.init_onl_lmt <> n.init_onl_lmt
        or o.turn_crdt_flg <> n.turn_crdt_flg
        or o.init_comn_open_amt <> n.init_comn_open_amt
        or o.comn_risk_aval_open_amt <> n.comn_risk_aval_open_amt
        or o.pmo_amt <> n.pmo_amt
        or o.cap_sys_onl_bus_amt_tot <> n.cap_sys_onl_bus_amt_tot
        or o.cap_sys_onl_bus_bal_tot <> n.cap_sys_onl_bus_bal_tot
        or o.lower_ocup_onl_lmt_amt <> n.lower_ocup_onl_lmt_amt
        or o.lower_ocup_onl_open_amt <> n.lower_ocup_onl_open_amt
        or o.fit_in_single_cust_or_group_lmt_flg <> n.fit_in_single_cust_or_group_lmt_flg
        or o.intnal_contr_amt_degree_ocup_amt <> n.intnal_contr_amt_degree_ocup_amt
        or o.risk_mgmt_apv_aval_amt <> n.risk_mgmt_apv_aval_amt
        or o.reply_id <> n.reply_id
        or o.ocup_group_crdt_lmt_id <> n.ocup_group_crdt_lmt_id
        or o.risk_mgmt_annual_vrfction_apv_aval_amt <> n.risk_mgmt_annual_vrfction_apv_aval_amt
        or o.free_flg <> n.free_flg
        or o.comb_class_consmt_flg <> n.comb_class_consmt_flg
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,lmt_id -- 额度编号
    ,cust_id -- 客户编号
    ,fit_prod_id -- 适用产品编号
    ,lmt_prod_id -- 额度产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_lmt_id -- 最初来源额度编号
    ,happ_way_cd -- 发生方式代码
    ,curr_cd -- 币种代码
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,circl_flg -- 可循环标志
    ,lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,lock_flg -- 锁定标志
    ,aldy_froz_flg -- 已冻结标志
    ,status_cd -- 状态代码
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt -- 串用名义金额
    ,beads_open_amt -- 串用敞口金额
    ,pre_ocup_nmal_amt -- 预占名义金额
    ,pre_ocup_open_amt -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,froz_nmal_amt -- 冻结名义金额
    ,froz_open_amt -- 冻结敞口金额
    ,under_bus_curr_cd_range -- 项下业务币种代码范围
    ,crdt_spec_flg -- 授信专用标志
    ,aval_rsrv_amt -- 可用预留金额
    ,rsrv_amt -- 预留金额
    ,aval_amt_calc_flg -- 可用金额计算标志
    ,guar_way_cd -- 担保方式代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,lmt_kind_cd -- 额度种类代码
    ,public_crdt_flg -- 公开授信标志
    ,usage_descb -- 用途描述
    ,other_cond_descb -- 其他条件描述
    ,gm_cust_id -- 集团成员客户编号
    ,init_onl_lmt -- 初始线上额度
    ,turn_crdt_flg -- 转授信标志
    ,init_comn_open_amt -- 初始一般敞口金额
    ,comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,pmo_amt -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,reply_id -- 批复编号
    ,ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,free_flg -- 豁免标志
    ,comb_class_consmt_flg -- 集合类代销标志
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.lmt_id -- 额度编号
    ,o.cust_id -- 客户编号
    ,o.fit_prod_id -- 适用产品编号
    ,o.lmt_prod_id -- 额度产品编号
    ,o.curr_crdt_stage_cd -- 当前授信阶段代码
    ,o.init_src_sys_cd -- 最初来源系统代码
    ,o.init_src_lmt_id -- 最初来源额度编号
    ,o.happ_way_cd -- 发生方式代码
    ,o.curr_cd -- 币种代码
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.open_amt -- 敞口金额
    ,o.nmal_amt -- 名义金额
    ,o.exec_nmal_amt -- 执行名义金额
    ,o.exec_open_amt -- 执行敞口金额
    ,o.exec_dr_open_amt -- 执行可缓释敞口金额
    ,o.dr_open_curr_cd -- 可缓释敞口币种代码
    ,o.dr_open_amt -- 可缓释敞口金额
    ,o.circl_flg -- 可循环标志
    ,o.lmt_under_dir_draw_flg -- 额度项下可直接提款标志
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.ocup_idf_cd -- 占用标识代码
    ,o.lock_flg -- 锁定标志
    ,o.aldy_froz_flg -- 已冻结标志
    ,o.status_cd -- 状态代码
    ,o.crdt_nmal_bal -- 授信名义余额
    ,o.crdt_open_bal -- 授信敞口余额
    ,o.lower_ocup_up_level_crdt_open_amt -- 下层占用上层授信敞口金额
    ,o.lower_ocup_up_level_crdt_nmal_amt -- 下层占用上层授信名义金额
    ,o.spec_ocup_up_level_crdt_open_amt -- 指定占用上层授信敞口金额
    ,o.spec_ocup_up_level_crdt_nmal_amt -- 指定占用上层授信名义金额
    ,o.under_lower_crdt_latest_begin_dt -- 项下下层授信最迟起始日期
    ,o.under_lower_crdt_earliest_begin_dt -- 项下下层授信最早起始日期
    ,o.lmt_latest_use_dt -- 额度最迟使用日期
    ,o.under_lower_crdt_latest_exp_dt -- 项下下层授信最迟到期日期
    ,o.under_lower_crdt_lont_mon_tenor -- 项下下层授信最长月期限
    ,o.under_lower_crdt_lont_day_tenor -- 项下下层授信最长日期限
    ,o.lower_crdt_nmal_bal_ocup_tot -- 下层授信名义余额占用汇总
    ,o.lower_crdt_open_bal_ocup_tot -- 下层授信敞口余额占用汇总
    ,o.dtl_lmt_next_bus_sig_max_amt -- 明细额度下业务单笔最大金额
    ,o.lmt_next_bus_int_rat_lowt_flo_val -- 额度下业务利率最低浮动值
    ,o.lmt_next_bus_init_margin_ratio -- 额度下业务初始保证金比例
    ,o.lmt_next_bus_higt_pm_rat -- 额度下业务最高抵质押率
    ,o.lower_bus_ocup_nmal_amt_tot -- 下层业务占用名义金额汇总
    ,o.lower_bus_ocup_open_amt_tot -- 下层业务占用敞口金额汇总
    ,o.beads_nmal_amt -- 串用名义金额
    ,o.beads_open_amt -- 串用敞口金额
    ,o.pre_ocup_nmal_amt -- 预占名义金额
    ,o.pre_ocup_open_amt -- 预占敞口金额
    ,o.surp_pre_ocup_nmal_amt -- 剩余预占名义金额
    ,o.surp_pre_ocup_open_amt -- 剩余预占敞口金额
    ,o.froz_nmal_amt -- 冻结名义金额
    ,o.froz_open_amt -- 冻结敞口金额
    ,o.under_bus_curr_cd_range -- 项下业务币种代码范围
    ,o.crdt_spec_flg -- 授信专用标志
    ,o.aval_rsrv_amt -- 可用预留金额
    ,o.rsrv_amt -- 预留金额
    ,o.aval_amt_calc_flg -- 可用金额计算标志
    ,o.guar_way_cd -- 担保方式代码
    ,o.day_tenor -- 日期限
    ,o.mon_tenor -- 月期限
    ,o.acm_distr_amt -- 累计放款金额
    ,o.acm_repay_amt -- 累计还款金额
    ,o.actl_invalid_dt -- 实际失效日期
    ,o.oper_teller_id -- 业务经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.mgmt_teller_id -- 管理柜员编号
    ,o.mgmt_org_id -- 管理机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.final_update_dt -- 最后更新日期
    ,o.lmt_kind_cd -- 额度种类代码
    ,o.public_crdt_flg -- 公开授信标志
    ,o.usage_descb -- 用途描述
    ,o.other_cond_descb -- 其他条件描述
    ,o.gm_cust_id -- 集团成员客户编号
    ,o.init_onl_lmt -- 初始线上额度
    ,o.turn_crdt_flg -- 转授信标志
    ,o.init_comn_open_amt -- 初始一般敞口金额
    ,o.comn_risk_aval_open_amt -- 一般风险可用敞口金额
    ,o.pmo_amt -- 抵质押物金额
    ,o.cap_sys_onl_bus_amt_tot -- 资金系统线上业务金额汇总
    ,o.cap_sys_onl_bus_bal_tot -- 资金系统线上业务余额汇总
    ,o.lower_ocup_onl_lmt_amt -- 下层占用线上额度金额
    ,o.lower_ocup_onl_open_amt -- 下层占用线上敞口金额
    ,o.fit_in_single_cust_or_group_lmt_flg -- 纳入单一客户或集团限额标志
    ,o.intnal_contr_amt_degree_ocup_amt -- 内部管控额度占用金额
    ,o.risk_mgmt_apv_aval_amt -- 风控审批可用金额
    ,o.reply_id -- 批复编号
    ,o.ocup_group_crdt_lmt_id -- 占用集团授信额度编号
    ,o.risk_mgmt_annual_vrfction_apv_aval_amt -- 风控年审审批可用金额
    ,o.free_flg -- 豁免标志
    ,o.comb_class_consmt_flg -- 集合类代销标志
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_crdt_lmt_info_h;
--alter table ${iml_schema}.agt_crdt_lmt_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_crdt_lmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_crdt_lmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_crdt_lmt_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_crdt_lmt_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_crdt_lmt_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_lmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_crdt_lmt_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_lmt_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
