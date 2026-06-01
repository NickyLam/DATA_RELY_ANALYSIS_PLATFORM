/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_cap_ld_fin_instm_ibmsf1
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
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ibank_cap_ld_fin_instm add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ibank_cap_ld_fin_instm modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_cap_ld_fin_instm partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm
compress ${option_switch} for query high
as
select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,cty_cd -- 国家代码
    ,asset_name -- 资产名称
    ,asset_type_name -- 资产类型名称
    ,corp_fac_val -- 单位面值
    ,fac_val_int_rat -- 票面利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,base_fin_instm_id -- 基准金融工具编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,issue_mode_cd -- 发行模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_adj_type_cd -- 付息调整类型代码
    ,src_int_rat_adj_ped_cd -- 源利率调整周期代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_type_cd -- 利率调整类型代码
    ,issue_org_name -- 发行机构名称
    ,input_dt -- 录入日期
    ,cn_abbr -- 中文简称
    ,del_flg -- 删除标志
    ,agent_name -- 经办人名称
    ,checker_name -- 复核人名称
    ,fir_ped_set_int_dt -- 首周期定息日期
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_multir -- 利率乘数
    ,ovdue_int_rat -- 逾期利率
    ,issue_amt -- 发行金额
    ,exp_mode_cd -- 到期模式代码
    ,edit_num -- 版本号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,prod_type_cd -- 产品类型代码
    ,effect_flg -- 生效标志
    ,acct_id -- 账户编号
    ,auto_redt_flg -- 自动转存标志
    ,stup_ped_type_cd -- 残期类型代码
    ,pay_flg -- 支付标志
    ,belong_org_id -- 所属机构编号
    ,cash_dt -- 兑付日期
    ,pay_int_type_cd -- 付息类型代码
    ,crdt_cust_id -- 授信客户编号
    ,guar_way_cd -- 担保方式代码
    ,guar_name -- 担保物名称
    ,unexp_draw_int_rat -- 提前支取利率
    ,draw_post_int_rat -- 支取后利率
    ,open_cert_flg -- 开立证实书标志
    ,auto_calc_int_rat_flg -- 自动计算利率标志
    ,nmal_int_rat -- 名义利率
    ,vat_rat -- 增值税率
    ,pass_addit_tax_rat -- 通道附加税率
    ,pass_fee_rat -- 通道费率
    ,pass_fee_int_accr_base_cd -- 通道费计息基准代码
    ,trust_fee_rat -- 托管费率
    ,trust_fee_int_accr_base_cd -- 托管费计息基准代码
    ,other_fee_rat -- 其他费率
    ,other_fee_int_accr_base_cd -- 其他费用计息基准代码
    ,nmal_int_rat_int_accr_base_cd -- 名义利率计息基准代码
    ,int_stl_way_cd -- 利息结算方式代码
    ,issue_org_id -- 发行机构编号
    ,std_prod_id -- 标准产品编号
    ,cashflow_get_way_cd -- 现金流获取方式代码
    ,trans_loan_flg -- 转贷款标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_cap_ld_fin_instm
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ibank_cap_ld_fin_instm partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_cashlb-
insert into ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,cty_cd -- 国家代码
    ,asset_name -- 资产名称
    ,asset_type_name -- 资产类型名称
    ,corp_fac_val -- 单位面值
    ,fac_val_int_rat -- 票面利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,base_fin_instm_id -- 基准金融工具编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,issue_mode_cd -- 发行模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_adj_type_cd -- 付息调整类型代码
    ,src_int_rat_adj_ped_cd -- 源利率调整周期代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_type_cd -- 利率调整类型代码
    ,issue_org_name -- 发行机构名称
    ,input_dt -- 录入日期
    ,cn_abbr -- 中文简称
    ,del_flg -- 删除标志
    ,agent_name -- 经办人名称
    ,checker_name -- 复核人名称
    ,fir_ped_set_int_dt -- 首周期定息日期
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_multir -- 利率乘数
    ,ovdue_int_rat -- 逾期利率
    ,issue_amt -- 发行金额
    ,exp_mode_cd -- 到期模式代码
    ,edit_num -- 版本号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,prod_type_cd -- 产品类型代码
    ,effect_flg -- 生效标志
    ,acct_id -- 账户编号
    ,auto_redt_flg -- 自动转存标志
    ,stup_ped_type_cd -- 残期类型代码
    ,pay_flg -- 支付标志
    ,belong_org_id -- 所属机构编号
    ,cash_dt -- 兑付日期
    ,pay_int_type_cd -- 付息类型代码
    ,crdt_cust_id -- 授信客户编号
    ,guar_way_cd -- 担保方式代码
    ,guar_name -- 担保物名称
    ,unexp_draw_int_rat -- 提前支取利率
    ,draw_post_int_rat -- 支取后利率
    ,open_cert_flg -- 开立证实书标志
    ,auto_calc_int_rat_flg -- 自动计算利率标志
    ,nmal_int_rat -- 名义利率
    ,vat_rat -- 增值税率
    ,pass_addit_tax_rat -- 通道附加税率
    ,pass_fee_rat -- 通道费率
    ,pass_fee_int_accr_base_cd -- 通道费计息基准代码
    ,trust_fee_rat -- 托管费率
    ,trust_fee_int_accr_base_cd -- 托管费计息基准代码
    ,other_fee_rat -- 其他费率
    ,other_fee_int_accr_base_cd -- 其他费用计息基准代码
    ,nmal_int_rat_int_accr_base_cd -- 名义利率计息基准代码
    ,int_stl_way_cd -- 利息结算方式代码
    ,issue_org_id -- 发行机构编号
    ,std_prod_id -- 标准产品编号
    ,cashflow_get_way_cd -- 现金流获取方式代码
    ,trans_loan_flg -- 转贷款标志
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
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COUNTRY END -- 国家代码
    ,P1.I_NAME -- 资产名称
    ,P1.P_CLASS -- 资产类型名称
    ,P1.PAR_VALUE -- 单位面值
    ,P1.COUPON * 100 -- 票面利率
    ,${iml_schema}.DATEFORMAT_MIN(P1.START_DATE) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MTR_DATE) -- 到期日期
    ,P1.TERM -- 源期限代码
    ,nvl(regexp_substr(P1.TERM, '[0-9]+'),'0') -- 期限
    ,nvl(regexp_substr(P1.TERM, '[A-Z]+'),'D') -- 期限类型代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.DAYCOUNT END -- 计息基准代码
    ,P1.I_CODE_BENCH -- 基准金融工具编号
    ,P1.A_TYPE_BENCH -- 基准资产类型编号
    ,P1.M_TYPE_BENCH -- 基准市场类型编号
    ,P1.ISSUE_MODE -- 发行模式代码
    ,P1.COUPON_TYPE -- 利率调整方式代码
    ,P1.PAYMENT_FREQ -- 源付息周期代码
    ,SUBSTR(decode(P1.PAYMENT_FREQ,'-1','0D',P1.PAYMENT_FREQ),1,LENGTH(P1.PAYMENT_FREQ)-1) -- 付息周期频率
    ,case when trim(P1.PAYMENT_FREQ) is null then  '0D' 
          when P1.PAYMENT_FREQ='irreg' then 'IR'
      else P1.PAYMENT_FREQ  end  -- 期限单位
    ,P1.PAYMENT_CONV -- 付息调整类型代码
    ,P1.RESET_FREQ -- 源利率调整周期代码
    ,SUBSTR(P1.RESET_FREQ,1,LENGTH(P1.RESET_FREQ)-1) -- 利率调整周期频率
    ,nvl(trim(SUBSTR(P1.RESET_FREQ,-1,1)),'-')-- 利率调整周期单位代码
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||substr(P1.RESET_CONV,1,9) END -- 利率调整类型代码
    ,P1.ISSUER -- 发行机构名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_TIME) -- 录入日期
    ,P1.CHINESESPELL -- 中文简称
    ,P1.IS_DELETE -- 删除标志
    ,P1.UPDATE_USER -- 经办人名称
    ,P1.ACCOUNT_USER -- 复核人名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.INITIAL_FIXING_DATE) -- 首周期定息日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.FIRST_PAYMENT_DATE) -- 首次付息日期
    ,P1.RATE_MULTI -- 利率乘数
    ,P1.OVERDUE_RATE -- 逾期利率
    ,P1.VOLUME -- 发行金额
    ,P1.MTR_MODE -- 到期模式代码
    ,P1.VER_ID -- 版本号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.END_DATE) -- 失效日期
    ,P1.FST_SET_AMOUNT -- 首期结算金额
    ,P1.MTR_SET_AMOUNT -- 到期结算金额
    ,P1.P_TYPE -- 产品类型代码
    ,P1.USABLE_FLAG -- 生效标志
    ,P1.ACCT_ID -- 账户编号
    ,P1.AUTO_REDEPO -- 自动转存标志
    ,P1.STUB_PERIOD_TYPE -- 残期类型代码
    ,P1.PAYMENT -- 支付标志
    ,P2.ORG_ID -- 所属机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.CASH_DATE) -- 兑付日期
    ,P1.INTEREST_TYPE -- 付息类型代码
    ,P1.CREDIT_ID -- 授信客户编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.GUARANTEE_WAY END -- 担保方式代码
    ,P1.GUARANTEE_INFOR -- 担保物名称
    ,P1.DRAW_ADVANCE_RATE -- 提前支取利率
    ,P1.POST_INTEREST_RATE -- 支取后利率
    ,P1.IS_OPEN_LETTER -- 开立证实书标志
    ,P1.IS_AUTO_CALCULATE -- 自动计算利率标志
    ,P1.NOMINAL_RATE -- 名义利率
    ,P1.ADDED_RATE -- 增值税率
    ,P1.SLOTTING_ADDRATE -- 通道附加税率
    ,P1.SLOTTING_RATE -- 通道费率
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.SLOTTING_DAYCOUNTER,1,8) END -- 通道费计息基准代码
    ,P1.TRUSTEE_RATE -- 托管费率
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.TRUSTEE_DAYCOUNTER,1,8) END -- 托管费计息基准代码
    ,P1.OTHER_RATE -- 其他费率
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.OTHER_DAYCOUNTER,1,8) END -- 其他费用计息基准代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.NOMINAL_DAYCOUNTER,1,8) END -- 名义利率计息基准代码
    ,P1.ACCOUNTING_TYPE -- 利息结算方式代码
    ,P1.ISSUER_ID -- 发行机构编号
    ,nvl(p3.prod_code,' ') -- 标准产品编号
    ,NVL(TRIM(P1.PAYMENTINFO_TYPE),'-') -- 现金流获取方式代码
    ,NVL(TRIM(P1.is_subloan),'-') -- 转贷款标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_cashlb' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_cashlb p1
    left join ${iol_schema}.ibms_ttrd_institution p2 on P1.I_ID=P2.I_ID 
    AND P2.start_dt <= to_date('${batch_date}','yyyymmdd') 
    AND P2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.COUNTRY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R2.SRC_FIELD_EN_NAME= 'COUNTRY'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CTY_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.DAYCOUNT = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'IBMS'
        AND R8.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R8.SRC_FIELD_EN_NAME= 'DAYCOUNT'
        AND R8.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.RESET_CONV = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'IBMS'
        AND R9.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R9.SRC_FIELD_EN_NAME= 'RESET_CONV'
        AND R9.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.GUARANTEE_WAY = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'IBMS'
        AND R7.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R7.SRC_FIELD_EN_NAME= 'GUARANTEE_WAY'
        AND R7.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'GUAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SLOTTING_DAYCOUNTER = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R3.SRC_FIELD_EN_NAME= 'SLOTTING_DAYCOUNTER'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PASS_FEE_INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.TRUSTEE_DAYCOUNTER = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IBMS'
        AND R4.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R4.SRC_FIELD_EN_NAME= 'TRUSTEE_DAYCOUNTER'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'TRUST_FEE_INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.OTHER_DAYCOUNTER = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IBMS'
        AND R5.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R5.SRC_FIELD_EN_NAME= 'OTHER_DAYCOUNTER'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'OTHER_FEE_INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.NOMINAL_DAYCOUNTER = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'IBMS'
        AND R6.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB'
        AND R6.SRC_FIELD_EN_NAME= 'NOMINAL_DAYCOUNTER'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_IBANK_CAP_LD_FIN_INSTM'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'NMAL_INT_RAT_INT_ACCR_BASE_CD'
    left join ${iol_schema}.ibms_ttrd_instrument p3 on P1.i_code = P3.i_code
   AND P1.a_type = P3.a_type
   AND P1.m_type = P3.m_type
   AND P3.START_DT <= to_date('${batch_date}','yyyymmdd') 
   AND P3.END_DT > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_ex(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,curr_cd -- 币种代码
    ,cty_cd -- 国家代码
    ,asset_name -- 资产名称
    ,asset_type_name -- 资产类型名称
    ,corp_fac_val -- 单位面值
    ,fac_val_int_rat -- 票面利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,src_tenor_cd -- 源期限代码
    ,tenor -- 期限
    ,tenor_type_cd -- 期限类型代码
    ,int_accr_base_cd -- 计息基准代码
    ,base_fin_instm_id -- 基准金融工具编号
    ,base_asset_type_id -- 基准资产类型编号
    ,base_market_type_id -- 基准市场类型编号
    ,issue_mode_cd -- 发行模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,src_pay_int_ped_cd -- 源付息周期代码
    ,pay_int_ped_freq -- 付息周期频率
    ,pay_int_ped_corp_cd -- 期限单位
    ,pay_int_adj_type_cd -- 付息调整类型代码
    ,src_int_rat_adj_ped_cd -- 源利率调整周期代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_type_cd -- 利率调整类型代码
    ,issue_org_name -- 发行机构名称
    ,input_dt -- 录入日期
    ,cn_abbr -- 中文简称
    ,del_flg -- 删除标志
    ,agent_name -- 经办人名称
    ,checker_name -- 复核人名称
    ,fir_ped_set_int_dt -- 首周期定息日期
    ,fir_pay_int_dt -- 首次付息日期
    ,int_rat_multir -- 利率乘数
    ,ovdue_int_rat -- 逾期利率
    ,issue_amt -- 发行金额
    ,exp_mode_cd -- 到期模式代码
    ,edit_num -- 版本号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,prod_type_cd -- 产品类型代码
    ,effect_flg -- 生效标志
    ,acct_id -- 账户编号
    ,auto_redt_flg -- 自动转存标志
    ,stup_ped_type_cd -- 残期类型代码
    ,pay_flg -- 支付标志
    ,belong_org_id -- 所属机构编号
    ,cash_dt -- 兑付日期
    ,pay_int_type_cd -- 付息类型代码
    ,crdt_cust_id -- 授信客户编号
    ,guar_way_cd -- 担保方式代码
    ,guar_name -- 担保物名称
    ,unexp_draw_int_rat -- 提前支取利率
    ,draw_post_int_rat -- 支取后利率
    ,open_cert_flg -- 开立证实书标志
    ,auto_calc_int_rat_flg -- 自动计算利率标志
    ,nmal_int_rat -- 名义利率
    ,vat_rat -- 增值税率
    ,pass_addit_tax_rat -- 通道附加税率
    ,pass_fee_rat -- 通道费率
    ,pass_fee_int_accr_base_cd -- 通道费计息基准代码
    ,trust_fee_rat -- 托管费率
    ,trust_fee_int_accr_base_cd -- 托管费计息基准代码
    ,other_fee_rat -- 其他费率
    ,other_fee_int_accr_base_cd -- 其他费用计息基准代码
    ,nmal_int_rat_int_accr_base_cd -- 名义利率计息基准代码
    ,int_stl_way_cd -- 利息结算方式代码
    ,issue_org_id -- 发行机构编号
    ,std_prod_id -- 标准产品编号
    ,cashflow_get_way_cd -- 现金流获取方式代码
    ,trans_loan_flg -- 转贷款标志
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
    ,nvl(n.cty_cd, o.cty_cd) as cty_cd -- 国家代码
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_type_name, o.asset_type_name) as asset_type_name -- 资产类型名称
    ,nvl(n.corp_fac_val, o.corp_fac_val) as corp_fac_val -- 单位面值
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.src_tenor_cd, o.src_tenor_cd) as src_tenor_cd -- 源期限代码
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.base_fin_instm_id, o.base_fin_instm_id) as base_fin_instm_id -- 基准金融工具编号
    ,nvl(n.base_asset_type_id, o.base_asset_type_id) as base_asset_type_id -- 基准资产类型编号
    ,nvl(n.base_market_type_id, o.base_market_type_id) as base_market_type_id -- 基准市场类型编号
    ,nvl(n.issue_mode_cd, o.issue_mode_cd) as issue_mode_cd -- 发行模式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.src_pay_int_ped_cd, o.src_pay_int_ped_cd) as src_pay_int_ped_cd -- 源付息周期代码
    ,nvl(n.pay_int_ped_freq, o.pay_int_ped_freq) as pay_int_ped_freq -- 付息周期频率
    ,nvl(n.pay_int_ped_corp_cd, o.pay_int_ped_corp_cd) as pay_int_ped_corp_cd -- 期限单位
    ,nvl(n.pay_int_adj_type_cd, o.pay_int_adj_type_cd) as pay_int_adj_type_cd -- 付息调整类型代码
    ,nvl(n.src_int_rat_adj_ped_cd, o.src_int_rat_adj_ped_cd) as src_int_rat_adj_ped_cd -- 源利率调整周期代码
    ,nvl(n.int_rat_adj_ped_freq, o.int_rat_adj_ped_freq) as int_rat_adj_ped_freq -- 利率调整周期频率
    ,nvl(n.int_rat_adj_ped_corp_cd, o.int_rat_adj_ped_corp_cd) as int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,nvl(n.int_rat_adj_type_cd, o.int_rat_adj_type_cd) as int_rat_adj_type_cd -- 利率调整类型代码
    ,nvl(n.issue_org_name, o.issue_org_name) as issue_org_name -- 发行机构名称
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.cn_abbr, o.cn_abbr) as cn_abbr -- 中文简称
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 删除标志
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 经办人名称
    ,nvl(n.checker_name, o.checker_name) as checker_name -- 复核人名称
    ,nvl(n.fir_ped_set_int_dt, o.fir_ped_set_int_dt) as fir_ped_set_int_dt -- 首周期定息日期
    ,nvl(n.fir_pay_int_dt, o.fir_pay_int_dt) as fir_pay_int_dt -- 首次付息日期
    ,nvl(n.int_rat_multir, o.int_rat_multir) as int_rat_multir -- 利率乘数
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 发行金额
    ,nvl(n.exp_mode_cd, o.exp_mode_cd) as exp_mode_cd -- 到期模式代码
    ,nvl(n.edit_num, o.edit_num) as edit_num -- 版本号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.fst_stl_amt, o.fst_stl_amt) as fst_stl_amt -- 首期结算金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.auto_redt_flg, o.auto_redt_flg) as auto_redt_flg -- 自动转存标志
    ,nvl(n.stup_ped_type_cd, o.stup_ped_type_cd) as stup_ped_type_cd -- 残期类型代码
    ,nvl(n.pay_flg, o.pay_flg) as pay_flg -- 支付标志
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.cash_dt, o.cash_dt) as cash_dt -- 兑付日期
    ,nvl(n.pay_int_type_cd, o.pay_int_type_cd) as pay_int_type_cd -- 付息类型代码
    ,nvl(n.crdt_cust_id, o.crdt_cust_id) as crdt_cust_id -- 授信客户编号
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.guar_name, o.guar_name) as guar_name -- 担保物名称
    ,nvl(n.unexp_draw_int_rat, o.unexp_draw_int_rat) as unexp_draw_int_rat -- 提前支取利率
    ,nvl(n.draw_post_int_rat, o.draw_post_int_rat) as draw_post_int_rat -- 支取后利率
    ,nvl(n.open_cert_flg, o.open_cert_flg) as open_cert_flg -- 开立证实书标志
    ,nvl(n.auto_calc_int_rat_flg, o.auto_calc_int_rat_flg) as auto_calc_int_rat_flg -- 自动计算利率标志
    ,nvl(n.nmal_int_rat, o.nmal_int_rat) as nmal_int_rat -- 名义利率
    ,nvl(n.vat_rat, o.vat_rat) as vat_rat -- 增值税率
    ,nvl(n.pass_addit_tax_rat, o.pass_addit_tax_rat) as pass_addit_tax_rat -- 通道附加税率
    ,nvl(n.pass_fee_rat, o.pass_fee_rat) as pass_fee_rat -- 通道费率
    ,nvl(n.pass_fee_int_accr_base_cd, o.pass_fee_int_accr_base_cd) as pass_fee_int_accr_base_cd -- 通道费计息基准代码
    ,nvl(n.trust_fee_rat, o.trust_fee_rat) as trust_fee_rat -- 托管费率
    ,nvl(n.trust_fee_int_accr_base_cd, o.trust_fee_int_accr_base_cd) as trust_fee_int_accr_base_cd -- 托管费计息基准代码
    ,nvl(n.other_fee_rat, o.other_fee_rat) as other_fee_rat -- 其他费率
    ,nvl(n.other_fee_int_accr_base_cd, o.other_fee_int_accr_base_cd) as other_fee_int_accr_base_cd -- 其他费用计息基准代码
    ,nvl(n.nmal_int_rat_int_accr_base_cd, o.nmal_int_rat_int_accr_base_cd) as nmal_int_rat_int_accr_base_cd -- 名义利率计息基准代码
    ,nvl(n.int_stl_way_cd, o.int_stl_way_cd) as int_stl_way_cd -- 利息结算方式代码
    ,nvl(n.issue_org_id, o.issue_org_id) as issue_org_id -- 发行机构编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.cashflow_get_way_cd, o.cashflow_get_way_cd) as cashflow_get_way_cd -- 现金流获取方式代码
    ,nvl(n.trans_loan_flg, o.trans_loan_flg) as trans_loan_flg -- 转贷款标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.fin_instm_id is null
                and o.asset_type_id is null
                and o.market_type_id is null
                and o.lp_id is null
            ) or (
                o.curr_cd <> n.curr_cd
                or o.cty_cd <> n.cty_cd
                or o.asset_name <> n.asset_name
                or o.asset_type_name <> n.asset_type_name
                or o.corp_fac_val <> n.corp_fac_val
                or o.fac_val_int_rat <> n.fac_val_int_rat
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.src_tenor_cd <> n.src_tenor_cd
                or o.tenor <> n.tenor
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.int_accr_base_cd <> n.int_accr_base_cd
                or o.base_fin_instm_id <> n.base_fin_instm_id
                or o.base_asset_type_id <> n.base_asset_type_id
                or o.base_market_type_id <> n.base_market_type_id
                or o.issue_mode_cd <> n.issue_mode_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.src_pay_int_ped_cd <> n.src_pay_int_ped_cd
                or o.pay_int_ped_freq <> n.pay_int_ped_freq
                or o.pay_int_ped_corp_cd <> n.pay_int_ped_corp_cd
                or o.pay_int_adj_type_cd <> n.pay_int_adj_type_cd
                or o.src_int_rat_adj_ped_cd <> n.src_int_rat_adj_ped_cd
                or o.int_rat_adj_ped_freq <> n.int_rat_adj_ped_freq
                or o.int_rat_adj_ped_corp_cd <> n.int_rat_adj_ped_corp_cd
                or o.int_rat_adj_type_cd <> n.int_rat_adj_type_cd
                or o.issue_org_name <> n.issue_org_name
                or o.input_dt <> n.input_dt
                or o.cn_abbr <> n.cn_abbr
                or o.del_flg <> n.del_flg
                or o.agent_name <> n.agent_name
                or o.checker_name <> n.checker_name
                or o.fir_ped_set_int_dt <> n.fir_ped_set_int_dt
                or o.fir_pay_int_dt <> n.fir_pay_int_dt
                or o.int_rat_multir <> n.int_rat_multir
                or o.ovdue_int_rat <> n.ovdue_int_rat
                or o.issue_amt <> n.issue_amt
                or o.exp_mode_cd <> n.exp_mode_cd
                or o.edit_num <> n.edit_num
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.fst_stl_amt <> n.fst_stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.prod_type_cd <> n.prod_type_cd
                or o.effect_flg <> n.effect_flg
                or o.acct_id <> n.acct_id
                or o.auto_redt_flg <> n.auto_redt_flg
                or o.stup_ped_type_cd <> n.stup_ped_type_cd
                or o.pay_flg <> n.pay_flg
                or o.belong_org_id <> n.belong_org_id
                or o.cash_dt <> n.cash_dt
                or o.pay_int_type_cd <> n.pay_int_type_cd
                or o.crdt_cust_id <> n.crdt_cust_id
                or o.guar_way_cd <> n.guar_way_cd
                or o.guar_name <> n.guar_name
                or o.unexp_draw_int_rat <> n.unexp_draw_int_rat
                or o.draw_post_int_rat <> n.draw_post_int_rat
                or o.open_cert_flg <> n.open_cert_flg
                or o.auto_calc_int_rat_flg <> n.auto_calc_int_rat_flg
                or o.nmal_int_rat <> n.nmal_int_rat
                or o.vat_rat <> n.vat_rat
                or o.pass_addit_tax_rat <> n.pass_addit_tax_rat
                or o.pass_fee_rat <> n.pass_fee_rat
                or o.pass_fee_int_accr_base_cd <> n.pass_fee_int_accr_base_cd
                or o.trust_fee_rat <> n.trust_fee_rat
                or o.trust_fee_int_accr_base_cd <> n.trust_fee_int_accr_base_cd
                or o.other_fee_rat <> n.other_fee_rat
                or o.other_fee_int_accr_base_cd <> n.other_fee_int_accr_base_cd
                or o.nmal_int_rat_int_accr_base_cd <> n.nmal_int_rat_int_accr_base_cd
                or o.int_stl_way_cd <> n.int_stl_way_cd
                or o.issue_org_id <> n.issue_org_id
                or o.std_prod_id <> n.std_prod_id
                or o.cashflow_get_way_cd <> n.cashflow_get_way_cd
                or o.trans_loan_flg <> n.trans_loan_flg
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
from ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm n
    full join ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_bk o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ibank_cap_ld_fin_instm truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ibank_cap_ld_fin_instm exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ibank_cap_ld_fin_instm drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_cap_ld_fin_instm to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_ex purge;
drop table ${iml_schema}.prd_ibank_cap_ld_fin_instm_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_cap_ld_fin_instm', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);