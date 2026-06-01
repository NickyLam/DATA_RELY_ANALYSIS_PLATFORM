/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fin_instm_ibmsf1
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
drop table ${iml_schema}.prd_fin_instm_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_fin_instm add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_fin_instm modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fin_instm_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fin_instm partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,fin_instm_name -- 金融工具名称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls -- 产品分类
    ,prod_tenor_cls_cd -- 产品期限分类代码
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,underly_fin_instm_id -- 标的金融工具编号
    ,un_asset_type_id -- 标的资产类型编号
    ,underly_market_type_id -- 标的市场类型编号
    ,coupon_type_cd -- 息票类型代码
    ,issue_mode_cd -- 发行模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_cnt -- 付息次数
    ,payoff_level_cd -- 清偿等级代码
    ,issue_org_id -- 发行机构编号
    ,cn_abbr -- 中文简写
    ,agent_name -- 经办人名称
    ,oper_dt -- 经办日期
    ,checker_name -- 复核人名称
    ,check_dt -- 复核日期
    ,issue_denom -- 发行面额
    ,fwd_int_rat_curve -- 远期利率曲线
    ,disct_int_rat_curve -- 折现利率曲线
    ,fac_val_int_rat -- 票面利率
    ,last_exp_dt -- 上次到期日期
    ,tenor_days -- 期限天数
    ,value_dt -- 起息日期
    ,risk_wt -- 风险权重
    ,cust_cls_name -- 客户分类名称
    ,acctnt_prod_name -- 会计产品名称
    ,issuer_id -- 发行人编号
    ,guartor_id -- 担保人编号
    ,issuer_cust_cls_name -- 发行人客户分类名称
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,reg_core_acct_id -- 定期核心账户编号
    ,valuation_curr_cd -- 计价币种代码
    ,spv_asset_flg -- SPV资产标志
    ,pric_amt -- 本金金额
    ,fir_pay_int_dt -- 首次付息日期
    ,int_accr_base_cd -- 计息基准代码
    ,crdt_cls_cd -- 授信分类代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_wt -- 授信权重
    ,belong_org_id -- 所属机构编号
    ,std_prod_id -- 标准产品编号
    ,renew_flg -- 续期标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_fin_instm_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_fin_instm partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_instrument-
insert into ${iml_schema}.prd_fin_instm_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,fin_instm_name -- 金融工具名称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls -- 产品分类
    ,prod_tenor_cls_cd -- 产品期限分类代码
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,underly_fin_instm_id -- 标的金融工具编号
    ,un_asset_type_id -- 标的资产类型编号
    ,underly_market_type_id -- 标的市场类型编号
    ,coupon_type_cd -- 息票类型代码
    ,issue_mode_cd -- 发行模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_cnt -- 付息次数
    ,payoff_level_cd -- 清偿等级代码
    ,issue_org_id -- 发行机构编号
    ,cn_abbr -- 中文简写
    ,agent_name -- 经办人名称
    ,oper_dt -- 经办日期
    ,checker_name -- 复核人名称
    ,check_dt -- 复核日期
    ,issue_denom -- 发行面额
    ,fwd_int_rat_curve -- 远期利率曲线
    ,disct_int_rat_curve -- 折现利率曲线
    ,fac_val_int_rat -- 票面利率
    ,last_exp_dt -- 上次到期日期
    ,tenor_days -- 期限天数
    ,value_dt -- 起息日期
    ,risk_wt -- 风险权重
    ,cust_cls_name -- 客户分类名称
    ,acctnt_prod_name -- 会计产品名称
    ,issuer_id -- 发行人编号
    ,guartor_id -- 担保人编号
    ,issuer_cust_cls_name -- 发行人客户分类名称
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,reg_core_acct_id -- 定期核心账户编号
    ,valuation_curr_cd -- 计价币种代码
    ,spv_asset_flg -- SPV资产标志
    ,pric_amt -- 本金金额
    ,fir_pay_int_dt -- 首次付息日期
    ,int_accr_base_cd -- 计息基准代码
    ,crdt_cls_cd -- 授信分类代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_wt -- 授信权重
    ,belong_org_id -- 所属机构编号
    ,std_prod_id -- 标准产品编号
    ,renew_flg -- 续期标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,P1.CURRENCY -- 币种代码
    ,P1.I_NAME -- 金融工具名称
    ,P1.P_TYPE -- 产品类型代码
    ,P1.P_CLASS -- 产品分类
    ,nvl(trim(P1.P_LS),'-') -- 产品期限分类代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.MTR_DATE) -- 到期日期
    ,P1.TERM -- 源期限代码
    ,nvl(regexp_substr(P1.TERM, '[0-9]+'),'0') -- 期限
    ,nvl(regexp_substr(P1.TERM, '[A-Z]+'),'D') -- 期限类型代码
    ,P1.U_I_CODE -- 标的金融工具编号
    ,P1.U_A_TYPE -- 标的资产类型编号
    ,P1.U_M_TYPE -- 标的市场类型编号
    ,TO_CHAR(P1.COUPON_TYPE) -- 息票类型代码
    ,P1.ISSUE_MODE -- 发行模式代码
    ,P1.PAYMENT_FREQ -- 源付息周期代码
    ,case when trim(P1.PAYMENT_FREQ) is null then '0' else
  ( case when P1.PAYMENT_FREQ='irreg' then '0' else SUBSTR(decode(P1.PAYMENT_FREQ,'-1','0D',P1.PAYMENT_FREQ),1,length(P1.PAYMENT_FREQ)-1) end
  ) end -- 付息周期频率
    ,case when trim(P1.PAYMENT_FREQ) is null then 'D' else
  ( case when P1.PAYMENT_FREQ='irreg' then 'D' else SUBSTR(decode(P1.PAYMENT_FREQ,'-1','0D',P1.PAYMENT_FREQ),-1,1) end
  ) end -- 期限单位
    ,P1.CASH_TIMES -- 付息次数
    ,UPPER(SUBSTR(P1.SENIORITY,1,3)) -- 清偿等级代码
    ,P1.PARTY_ID -- 发行机构编号
    ,P1.CHINESESPELL -- 中文简写
    ,P1.UPDATE_USER -- 经办人名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.UPDATE_TIME) -- 经办日期
    ,P1.ACCOUNT_USER -- 复核人名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.ACCOUNT_TIME) -- 复核日期
    ,P1.PAR_VALUE -- 发行面额
    ,P1.FWD_IRC -- 远期利率曲线
    ,P1.DIS_IRC -- 折现利率曲线
    ,P1.COUPON * 100 -- 票面利率
    ,${iml_schema}.DATEFORMAT_MIN(P1.PREVIOUS_VERSION_MTR_DATE) -- 上次到期日期
    ,P1.TERM_DAY -- 期限天数
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 起息日期
    ,P1.WEIGHT_LIMIT -- 风险权重
    ,P1.T_PATH -- 客户分类名称
    ,P1.P_CLASS_ACT -- 会计产品名称
    ,P1.ISSUER_ID -- 发行人编号
    ,P1.WARRANTOR_ID -- 担保人编号
    ,P1.ISSUER_T_PATH -- 发行人客户分类名称
    ,${iml_schema}.DATEFORMAT_MAX(P1.B_ACTUAL_MTR_DATE) -- 债券实际到期日期
    ,P1.CORE_ACCT_CODE -- 定期核心账户编号
    ,NVL(TRIM(P1.Q_CURRENCY),'CNY') -- 计价币种代码
    ,P1.IS_SPV_ASSET -- SPV资产标志
    ,P1.PRINCIPAL -- 本金金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.FIRST_PAYMENT_DATE) -- 首次付息日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||substr(P1.DAYCOUNT,1,9) END -- 计息基准代码
    ,P1.CREDIT_CLASSFY -- 授信分类代码
    ,P1.IS_USING_CREDIT -- 占用授信标志
    ,P1.CREDIT_WEIGHT -- 授信权重
    ,P2.ORG_ID -- 所属机构编号
    ,nvl(P1.PROD_CODE,' ') -- 标准产品编号
    ,nvl(trim(P1.IS_RENEWAL),'0') -- 续期标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_instrument' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_instrument p1
    left join ${iol_schema}.ibms_ttrd_institution p2 on P1.I_ID=P2.I_ID AND P2.start_dt <= to_date('${batch_date}','yyyymmdd') and P2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DAYCOUNT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_INSTRUMENT'
        AND R2.SRC_FIELD_EN_NAME= 'DAYCOUNT'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fin_instm_ibmsf1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
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
insert /*+ append */ into ${iml_schema}.prd_fin_instm_ibmsf1_ex(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,fin_instm_name -- 金融工具名称
    ,prod_type_cd -- 产品类型代码
    ,prod_cls -- 产品分类
    ,prod_tenor_cls_cd -- 产品期限分类代码
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,underly_fin_instm_id -- 标的金融工具编号
    ,un_asset_type_id -- 标的资产类型编号
    ,underly_market_type_id -- 标的市场类型编号
    ,coupon_type_cd -- 息票类型代码
    ,issue_mode_cd -- 发行模式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_cnt -- 付息次数
    ,payoff_level_cd -- 清偿等级代码
    ,issue_org_id -- 发行机构编号
    ,cn_abbr -- 中文简写
    ,agent_name -- 经办人名称
    ,oper_dt -- 经办日期
    ,checker_name -- 复核人名称
    ,check_dt -- 复核日期
    ,issue_denom -- 发行面额
    ,fwd_int_rat_curve -- 远期利率曲线
    ,disct_int_rat_curve -- 折现利率曲线
    ,fac_val_int_rat -- 票面利率
    ,last_exp_dt -- 上次到期日期
    ,tenor_days -- 期限天数
    ,value_dt -- 起息日期
    ,risk_wt -- 风险权重
    ,cust_cls_name -- 客户分类名称
    ,acctnt_prod_name -- 会计产品名称
    ,issuer_id -- 发行人编号
    ,guartor_id -- 担保人编号
    ,issuer_cust_cls_name -- 发行人客户分类名称
    ,bond_actl_exp_dt -- 债券实际到期日期
    ,reg_core_acct_id -- 定期核心账户编号
    ,valuation_curr_cd -- 计价币种代码
    ,spv_asset_flg -- SPV资产标志
    ,pric_amt -- 本金金额
    ,fir_pay_int_dt -- 首次付息日期
    ,int_accr_base_cd -- 计息基准代码
    ,crdt_cls_cd -- 授信分类代码
    ,ocup_crdt_flg -- 占用授信标志
    ,crdt_wt -- 授信权重
    ,belong_org_id -- 所属机构编号
    ,std_prod_id -- 标准产品编号
    ,renew_flg -- 续期标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.fin_instm_name, o.fin_instm_name) as fin_instm_name -- 金融工具名称
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_cls, o.prod_cls) as prod_cls -- 产品分类
    ,nvl(n.prod_tenor_cls_cd, o.prod_tenor_cls_cd) as prod_tenor_cls_cd -- 产品期限分类代码
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.src_tenor_cd, o.src_tenor_cd) as src_tenor_cd -- 源期限代码
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.underly_fin_instm_id, o.underly_fin_instm_id) as underly_fin_instm_id -- 标的金融工具编号
    ,nvl(n.un_asset_type_id, o.un_asset_type_id) as un_asset_type_id -- 标的资产类型编号
    ,nvl(n.underly_market_type_id, o.underly_market_type_id) as underly_market_type_id -- 标的市场类型编号
    ,nvl(n.coupon_type_cd, o.coupon_type_cd) as coupon_type_cd -- 息票类型代码
    ,nvl(n.issue_mode_cd, o.issue_mode_cd) as issue_mode_cd -- 发行模式代码
    ,nvl(n.src_pay_int_ped_cd, o.src_pay_int_ped_cd) as src_pay_int_ped_cd -- 源付息周期代码
    ,nvl(n.pay_int_ped_freq, o.pay_int_ped_freq) as pay_int_ped_freq -- 付息周期频率
    ,nvl(n.pay_int_ped_corp_cd, o.pay_int_ped_corp_cd) as pay_int_ped_corp_cd -- 期限单位
    ,nvl(n.pay_int_cnt, o.pay_int_cnt) as pay_int_cnt -- 付息次数
    ,nvl(n.payoff_level_cd, o.payoff_level_cd) as payoff_level_cd -- 清偿等级代码
    ,nvl(n.issue_org_id, o.issue_org_id) as issue_org_id -- 发行机构编号
    ,nvl(n.cn_abbr, o.cn_abbr) as cn_abbr -- 中文简写
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 经办人名称
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.checker_name, o.checker_name) as checker_name -- 复核人名称
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.issue_denom, o.issue_denom) as issue_denom -- 发行面额
    ,nvl(n.fwd_int_rat_curve, o.fwd_int_rat_curve) as fwd_int_rat_curve -- 远期利率曲线
    ,nvl(n.disct_int_rat_curve, o.disct_int_rat_curve) as disct_int_rat_curve -- 折现利率曲线
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.last_exp_dt, o.last_exp_dt) as last_exp_dt -- 上次到期日期
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 期限天数
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.risk_wt, o.risk_wt) as risk_wt -- 风险权重
    ,nvl(n.cust_cls_name, o.cust_cls_name) as cust_cls_name -- 客户分类名称
    ,nvl(n.acctnt_prod_name, o.acctnt_prod_name) as acctnt_prod_name -- 会计产品名称
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.issuer_cust_cls_name, o.issuer_cust_cls_name) as issuer_cust_cls_name -- 发行人客户分类名称
    ,nvl(n.bond_actl_exp_dt, o.bond_actl_exp_dt) as bond_actl_exp_dt -- 债券实际到期日期
    ,nvl(n.reg_core_acct_id, o.reg_core_acct_id) as reg_core_acct_id -- 定期核心账户编号
    ,nvl(n.valuation_curr_cd, o.valuation_curr_cd) as valuation_curr_cd -- 计价币种代码
    ,nvl(n.spv_asset_flg, o.spv_asset_flg) as spv_asset_flg -- SPV资产标志
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.crdt_cls_cd, o.crdt_cls_cd) as crdt_cls_cd -- 授信分类代码
    ,nvl(n.ocup_crdt_flg, o.ocup_crdt_flg) as ocup_crdt_flg -- 占用授信标志
    ,nvl(n.crdt_wt, o.crdt_wt) as crdt_wt -- 授信权重
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.renew_flg, o.renew_flg) as renew_flg -- 续期标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.fin_instm_id is null
                and o.asset_type_id is null
                and o.market_type_id is null
                and o.lp_id is null
            ) or (
                o.curr_cd <> n.curr_cd
                or o.fin_instm_name <> n.fin_instm_name
                or o.prod_type_cd <> n.prod_type_cd
                or o.prod_cls <> n.prod_cls
                or o.prod_tenor_cls_cd <> n.prod_tenor_cls_cd
                or o.exp_dt <> n.exp_dt
                or o.src_tenor_cd <> n.src_tenor_cd
                or o.tenor <> n.tenor
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.underly_fin_instm_id <> n.underly_fin_instm_id
                or o.un_asset_type_id <> n.un_asset_type_id
                or o.underly_market_type_id <> n.underly_market_type_id
                or o.coupon_type_cd <> n.coupon_type_cd
                or o.issue_mode_cd <> n.issue_mode_cd
                or o.src_pay_int_ped_cd <> n.src_pay_int_ped_cd
                or o.pay_int_ped_freq <> n.pay_int_ped_freq
                or o.pay_int_ped_corp_cd <> n.pay_int_ped_corp_cd
                or o.pay_int_cnt <> n.pay_int_cnt
                or o.payoff_level_cd <> n.payoff_level_cd
                or o.issue_org_id <> n.issue_org_id
                or o.cn_abbr <> n.cn_abbr
                or o.agent_name <> n.agent_name
                or o.oper_dt <> n.oper_dt
                or o.checker_name <> n.checker_name
                or o.check_dt <> n.check_dt
                or o.issue_denom <> n.issue_denom
                or o.fwd_int_rat_curve <> n.fwd_int_rat_curve
                or o.disct_int_rat_curve <> n.disct_int_rat_curve
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.last_exp_dt <> n.last_exp_dt
                or o.tenor_days <> n.tenor_days
                or o.value_dt <> n.value_dt
                or o.risk_wt <> n.risk_wt
                or o.cust_cls_name <> n.cust_cls_name
                or o.acctnt_prod_name <> n.acctnt_prod_name
                or o.issuer_id <> n.issuer_id
                or o.guartor_id <> n.guartor_id
                or o.issuer_cust_cls_name <> n.issuer_cust_cls_name
                or o.bond_actl_exp_dt <> n.bond_actl_exp_dt
                or o.reg_core_acct_id <> n.reg_core_acct_id
                or o.valuation_curr_cd <> n.valuation_curr_cd
                or o.spv_asset_flg <> n.spv_asset_flg
                or o.pric_amt <> n.pric_amt
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.crdt_cls_cd <> n.crdt_cls_cd
                or o.ocup_crdt_flg <> n.ocup_crdt_flg
                or o.crdt_wt <> n.crdt_wt
                or o.belong_org_id <> n.belong_org_id
                or o.std_prod_id <> n.std_prod_id
                or o.renew_flg <> n.renew_flg
            ) or (
                 case when (
                           n.fin_instm_id is null
                           and n.asset_type_id is null
                           and n.market_type_id is null
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
                n.fin_instm_id is null
                and n.asset_type_id is null
                and n.market_type_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm_ibmsf1_tm n
    full join ${iml_schema}.prd_fin_instm_ibmsf1_bk o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_fin_instm truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_fin_instm exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_fin_instm_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_fin_instm drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fin_instm to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_fin_instm_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_ibmsf1_ex purge;
drop table ${iml_schema}.prd_fin_instm_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fin_instm', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);