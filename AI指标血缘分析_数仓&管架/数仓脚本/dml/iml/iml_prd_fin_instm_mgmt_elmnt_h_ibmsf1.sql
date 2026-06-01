/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fin_instm_mgmt_elmnt_h_ibmsf1
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
alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h partition for ('ibmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_cashlb_manage_ele-1
insert into ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
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
    ,P1.COUPON*100 -- 合同利率
    ,P1.FINAL_USE_COMP -- 用款企业名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSINESS_CATEGORY END -- 行业门类代码
    ,NVL(TRIM(P1.IS_TWO_HIGH_ONE_LEFT),'-') -- 两高一剩标志
    ,NVL(TRIM(P1.IS_GOVERNMENT_PLATFORM),'-') -- 政府融资平台标志
    ,NVL(TRIM(P1.IS_REMOTE_BUSINESS),'-') -- 异地业务标志
    ,NVL(TRIM(P1.IS_INDUSTRY_FUND),'-') -- 产业基金标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.OUT_GRADE END -- 外部评级代码
    ,NVL(TRIM(P1.IN_GRADE),'-') -- 内部评级代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.IN_GRADE_MTR_DATE) -- 内部评级到期日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.COMP_AREA_PROVINCE END -- 用款企业省代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.COMP_AREA_CITY END -- 用款企业市代码
    ,NVL(TRIM(P1.IS_CONVERT_DEBT_PRO),'-') -- 投向市场化债转股标志
    ,P1.UND_ASSET_TYPE_OPT -- 底层资产类型代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.MANAGEMENT_MODE END -- 管理模式代码
    ,NVL(TRIM(P1.IS_ENTRUSTED_LOAN),'-') -- 委托贷款标志
    ,NVL(TO_NUMBER(TRIM(P1.NUM_OF_CARRIES)),0) -- SPV载体个数
    ,NVL(TRIM(P1.SPECIAL_PURPOSE_VEHICLE_TYPE),'-') -- SPV载体类型代码
    ,P1.SPECIAL_PURPOSE_VEHICLE_CODE -- SPV载体别名
    ,P1.APPROVAL_ID -- 批复号
    ,P1.TOTAL_GOODS_AMOUNT -- 产品总金额
    ,P1.APPROVAL_AMOUNT -- 批复金额
    ,NVL(TO_NUMBER(TRIM(P1.RISK_WEIGHT)),0) -- 风险权重
    ,NVL(TRIM(P1.IS_MULTI_FINANCIER),'-') -- 多融资人标志
    ,P1.ACTUAL_FINANCIER_ID -- 实际融资人客户编号
    ,P1.FINANCIER_NATURE -- 实际融资人客户性质名称
    ,P1.PARENT_GROUP -- 实际融资人所属集团名称
    ,NVL(TRIM(P1.IS_ASSET_BASE_SECURITIES),'-') -- 资产证券化产品标志
    ,NVL(TRIM(P1.IS_CREDIT_ITEM),'-') -- 信贷类项目标志
    ,nvl(trim(P1.INVESTMENT_TYPE),'-') -- 投资产品类型代码
    ,nvl(trim(P1.BUSINESS_CATEGORY_SMALL),'-') -- 投向行业细类代码
    ,P1.IS_ASSET_SECU -- 资产支持证券标志
    ,P1.IS_NO_GRADE_SECU -- 无评级资产证券化标志
    ,P1.IS_ASSET_BASE_SECURITIES -- 资产证券化产品标志
    ,P1.INVEST_FUND_PART -- 投向产业基金金额
    ,P1.INVEST_MARKET_PART -- 投向市场化债转股金额
    ,P1.INVEST_FINANCE_FORMANAGEPART -- 投向同行私募资产管理金额
    ,P1.INVEST_FINANCE_FORCAPITALPART -- 投向附属机构私募资产管理金额
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.RAISE_WAY END -- 募集方式代码
    ,nvl(trim(P1.BUSINESS_CATEGORY_MIN),'-') -- 行业类型代码
    ,nvl(trim(P1.INFORMATION_SOURCE),'-') -- 信息来源代码
    ,P1.REPORT_PERIOD -- 报告期
    ,${iml_schema}.dateformat_max2(P1.REPORT_DATE) -- 报告日期
    ,P1.FUND_SUM_SHARE -- 基金总份额
    ,P1.FUND_CURRENT_ASSET -- 基金当期总资产
    ,P1.CURRENT_PERIOD_NET -- 基金当前报告期净值
    ,P1.LEVER_RATIO -- 杠杆率
    ,nvl(trim(P1.IS_REALTY_LOAN),'-') -- 房地产开发贷款标志
    ,P1.PROJECT_SUM_INVEST -- 项目总投资
    ,P1.CAPITAL_FUND -- 资本金
    ,nvl(trim(P1.IS_COMMER_HOUSING),'-') -- 居住用房标志
    ,nvl(trim(P1.NOT_UNDASSET_TYPE),'-') -- 非底层资产大类代码
    ,nvl(trim(P1.NOT_UNDASSET_TYPE_TWO),'-') -- 非底层资产细类代码
    ,nvl(trim(P1.G31_CLASSIFY),'-') -- G31产品分类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_cashlb_manage_ele' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_cashlb_manage_ele p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESS_CATEGORY= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESS_CATEGORY'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INDUS_CATEGY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OUT_GRADE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R2.SRC_FIELD_EN_NAME= 'OUT_GRADE'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'EXT_RATING_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.COMP_AREA_PROVINCE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R3.SRC_FIELD_EN_NAME= 'COMP_AREA_PROVINCE'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'SPENT_CORP_PROV_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.COMP_AREA_CITY= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IBMS'
        AND R4.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R4.SRC_FIELD_EN_NAME= 'COMP_AREA_CITY'
        AND R4.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SPENT_CORP_CITY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.MANAGEMENT_MODE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IBMS'
        AND R5.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R5.SRC_FIELD_EN_NAME= 'MANAGEMENT_MODE'
        AND R5.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'MGMT_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.RAISE_WAY= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'IBMS'
        AND R6.SRC_TAB_EN_NAME= 'IBMS_TTRD_CASHLB_MANAGE_ELE'
        AND R6.SRC_FIELD_EN_NAME= 'RAISE_WAY'
        AND R6.TARGET_TAB_EN_NAME= 'PRD_FIN_INSTM_MGMT_ELMNT_H'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'COLL_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
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
    ,nvl(n.cont_int_rat, o.cont_int_rat) as cont_int_rat -- 合同利率
    ,nvl(n.spent_corp_name, o.spent_corp_name) as spent_corp_name -- 用款企业名称
    ,nvl(n.indus_categy_cd, o.indus_categy_cd) as indus_categy_cd -- 行业门类代码
    ,nvl(n.thol_flg, o.thol_flg) as thol_flg -- 两高一剩标志
    ,nvl(n.gover_fin_plat_flg, o.gover_fin_plat_flg) as gover_fin_plat_flg -- 政府融资平台标志
    ,nvl(n.remote_bus_flg, o.remote_bus_flg) as remote_bus_flg -- 异地业务标志
    ,nvl(n.ind_fund_flg, o.ind_fund_flg) as ind_fund_flg -- 产业基金标志
    ,nvl(n.ext_rating_cd, o.ext_rating_cd) as ext_rating_cd -- 外部评级代码
    ,nvl(n.intnal_rating_cd, o.intnal_rating_cd) as intnal_rating_cd -- 内部评级代码
    ,nvl(n.intnal_rating_exp_dt, o.intnal_rating_exp_dt) as intnal_rating_exp_dt -- 内部评级到期日期
    ,nvl(n.spent_corp_prov_cd, o.spent_corp_prov_cd) as spent_corp_prov_cd -- 用款企业省代码
    ,nvl(n.spent_corp_city_cd, o.spent_corp_city_cd) as spent_corp_city_cd -- 用款企业市代码
    ,nvl(n.dir_makti_debt_eqty_flg, o.dir_makti_debt_eqty_flg) as dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,nvl(n.uder_asset_type_cd, o.uder_asset_type_cd) as uder_asset_type_cd -- 底层资产类型代码
    ,nvl(n.mgmt_mode_cd, o.mgmt_mode_cd) as mgmt_mode_cd -- 管理模式代码
    ,nvl(n.entr_loan_flg, o.entr_loan_flg) as entr_loan_flg -- 委托贷款标志
    ,nvl(n.spv_vector_cnt, o.spv_vector_cnt) as spv_vector_cnt -- SPV载体个数
    ,nvl(n.spv_vector_type_code, o.spv_vector_type_code) as spv_vector_type_code -- SPV载体类型代码
    ,nvl(n.spv_vector_name, o.spv_vector_name) as spv_vector_name -- SPV载体别名
    ,nvl(n.reply_num, o.reply_num) as reply_num -- 批复号
    ,nvl(n.prod_tot_amt, o.prod_tot_amt) as prod_tot_amt -- 产品总金额
    ,nvl(n.reply_amt, o.reply_amt) as reply_amt -- 批复金额
    ,nvl(n.risk_wt, o.risk_wt) as risk_wt -- 风险权重
    ,nvl(n.multi_finer_flg, o.multi_finer_flg) as multi_finer_flg -- 多融资人标志
    ,nvl(n.actl_finer_cust_id, o.actl_finer_cust_id) as actl_finer_cust_id -- 实际融资人客户编号
    ,nvl(n.actl_finer_cust_char_name, o.actl_finer_cust_char_name) as actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,nvl(n.actl_finer_belong_group_name, o.actl_finer_belong_group_name) as actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,nvl(n.asset_secution_prod_flg, o.asset_secution_prod_flg) as asset_secution_prod_flg -- 资产证券化产品标志
    ,nvl(n.crdt_proj_flg, o.crdt_proj_flg) as crdt_proj_flg -- 信贷类项目标志
    ,nvl(n.invest_prod_type_cd, o.invest_prod_type_cd) as invest_prod_type_cd -- 投资产品类型代码
    ,nvl(n.dir_indus_subclass_cd, o.dir_indus_subclass_cd) as dir_indus_subclass_cd -- 投向行业细类代码
    ,nvl(n.asset_supt_secu_flg, o.asset_supt_secu_flg) as asset_supt_secu_flg -- 资产支持证券标志
    ,nvl(n.noth_rating_abs_flg, o.noth_rating_abs_flg) as noth_rating_abs_flg -- 无评级资产证券化标志
    ,nvl(n.abs_prod_flg, o.abs_prod_flg) as abs_prod_flg -- 资产证券化产品标志
    ,nvl(n.dir_ind_fund_amt, o.dir_ind_fund_amt) as dir_ind_fund_amt -- 投向产业基金金额
    ,nvl(n.dir_makti_debt_eqty_amt, o.dir_makti_debt_eqty_amt) as dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,nvl(n.dir_indus_pam_amt, o.dir_indus_pam_amt) as dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,nvl(n.dir_attach_org_pam_amt, o.dir_attach_org_pam_amt) as dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,nvl(n.coll_way_cd, o.coll_way_cd) as coll_way_cd -- 募集方式代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.info_src_cd, o.info_src_cd) as info_src_cd -- 信息来源代码
    ,nvl(n.report_prd, o.report_prd) as report_prd -- 报告期
    ,nvl(n.rept_dt, o.rept_dt) as rept_dt -- 报告日期
    ,nvl(n.fund_tot_lot, o.fund_tot_lot) as fund_tot_lot -- 基金总份额
    ,nvl(n.fund_currt_tot_asset, o.fund_currt_tot_asset) as fund_currt_tot_asset -- 基金当期总资产
    ,nvl(n.fund_curr_report_prd_nv, o.fund_curr_report_prd_nv) as fund_curr_report_prd_nv -- 基金当前报告期净值
    ,nvl(n.lever_rat, o.lever_rat) as lever_rat -- 杠杆率
    ,nvl(n.rei_loan_flg, o.rei_loan_flg) as rei_loan_flg -- 房地产开发贷款标志
    ,nvl(n.proj_tot_invest, o.proj_tot_invest) as proj_tot_invest -- 项目总投资
    ,nvl(n.capital, o.capital) as capital -- 资本金
    ,nvl(n.resd_build_flg, o.resd_build_flg) as resd_build_flg -- 居住用房标志
    ,nvl(n.non_uder_asset_cls_cd, o.non_uder_asset_cls_cd) as non_uder_asset_cls_cd -- 非底层资产大类代码
    ,nvl(n.non_uder_asset_sub_cls_cd, o.non_uder_asset_sub_cls_cd) as non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,nvl(n.g31_prod_cls_cd, o.g31_prod_cls_cd) as g31_prod_cls_cd -- G31产品分类代码
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
where (
        o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.lp_id is null
    )
    or (
        n.fin_instm_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.lp_id is null
    )
    or (
        o.cont_int_rat <> n.cont_int_rat
        or o.spent_corp_name <> n.spent_corp_name
        or o.indus_categy_cd <> n.indus_categy_cd
        or o.thol_flg <> n.thol_flg
        or o.gover_fin_plat_flg <> n.gover_fin_plat_flg
        or o.remote_bus_flg <> n.remote_bus_flg
        or o.ind_fund_flg <> n.ind_fund_flg
        or o.ext_rating_cd <> n.ext_rating_cd
        or o.intnal_rating_cd <> n.intnal_rating_cd
        or o.intnal_rating_exp_dt <> n.intnal_rating_exp_dt
        or o.spent_corp_prov_cd <> n.spent_corp_prov_cd
        or o.spent_corp_city_cd <> n.spent_corp_city_cd
        or o.dir_makti_debt_eqty_flg <> n.dir_makti_debt_eqty_flg
        or o.uder_asset_type_cd <> n.uder_asset_type_cd
        or o.mgmt_mode_cd <> n.mgmt_mode_cd
        or o.entr_loan_flg <> n.entr_loan_flg
        or o.spv_vector_cnt <> n.spv_vector_cnt
        or o.spv_vector_type_code <> n.spv_vector_type_code
        or o.spv_vector_name <> n.spv_vector_name
        or o.reply_num <> n.reply_num
        or o.prod_tot_amt <> n.prod_tot_amt
        or o.reply_amt <> n.reply_amt
        or o.risk_wt <> n.risk_wt
        or o.multi_finer_flg <> n.multi_finer_flg
        or o.actl_finer_cust_id <> n.actl_finer_cust_id
        or o.actl_finer_cust_char_name <> n.actl_finer_cust_char_name
        or o.actl_finer_belong_group_name <> n.actl_finer_belong_group_name
        or o.asset_secution_prod_flg <> n.asset_secution_prod_flg
        or o.crdt_proj_flg <> n.crdt_proj_flg
        or o.invest_prod_type_cd <> n.invest_prod_type_cd
        or o.dir_indus_subclass_cd <> n.dir_indus_subclass_cd
        or o.asset_supt_secu_flg <> n.asset_supt_secu_flg
        or o.noth_rating_abs_flg <> n.noth_rating_abs_flg
        or o.abs_prod_flg <> n.abs_prod_flg
        or o.dir_ind_fund_amt <> n.dir_ind_fund_amt
        or o.dir_makti_debt_eqty_amt <> n.dir_makti_debt_eqty_amt
        or o.dir_indus_pam_amt <> n.dir_indus_pam_amt
        or o.dir_attach_org_pam_amt <> n.dir_attach_org_pam_amt
        or o.coll_way_cd <> n.coll_way_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.info_src_cd <> n.info_src_cd
        or o.report_prd <> n.report_prd
        or o.rept_dt <> n.rept_dt
        or o.fund_tot_lot <> n.fund_tot_lot
        or o.fund_currt_tot_asset <> n.fund_currt_tot_asset
        or o.fund_curr_report_prd_nv <> n.fund_curr_report_prd_nv
        or o.lever_rat <> n.lever_rat
        or o.rei_loan_flg <> n.rei_loan_flg
        or o.proj_tot_invest <> n.proj_tot_invest
        or o.capital <> n.capital
        or o.resd_build_flg <> n.resd_build_flg
        or o.non_uder_asset_cls_cd <> n.non_uder_asset_cls_cd
        or o.non_uder_asset_sub_cls_cd <> n.non_uder_asset_sub_cls_cd
        or o.g31_prod_cls_cd <> n.g31_prod_cls_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,cont_int_rat -- 合同利率
    ,spent_corp_name -- 用款企业名称
    ,indus_categy_cd -- 行业门类代码
    ,thol_flg -- 两高一剩标志
    ,gover_fin_plat_flg -- 政府融资平台标志
    ,remote_bus_flg -- 异地业务标志
    ,ind_fund_flg -- 产业基金标志
    ,ext_rating_cd -- 外部评级代码
    ,intnal_rating_cd -- 内部评级代码
    ,intnal_rating_exp_dt -- 内部评级到期日期
    ,spent_corp_prov_cd -- 用款企业省代码
    ,spent_corp_city_cd -- 用款企业市代码
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,uder_asset_type_cd -- 底层资产类型代码
    ,mgmt_mode_cd -- 管理模式代码
    ,entr_loan_flg -- 委托贷款标志
    ,spv_vector_cnt -- SPV载体个数
    ,spv_vector_type_code -- SPV载体类型代码
    ,spv_vector_name -- SPV载体别名
    ,reply_num -- 批复号
    ,prod_tot_amt -- 产品总金额
    ,reply_amt -- 批复金额
    ,risk_wt -- 风险权重
    ,multi_finer_flg -- 多融资人标志
    ,actl_finer_cust_id -- 实际融资人客户编号
    ,actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,asset_secution_prod_flg -- 资产证券化产品标志
    ,crdt_proj_flg -- 信贷类项目标志
    ,invest_prod_type_cd -- 投资产品类型代码
    ,dir_indus_subclass_cd -- 投向行业细类代码
    ,asset_supt_secu_flg -- 资产支持证券标志
    ,noth_rating_abs_flg -- 无评级资产证券化标志
    ,abs_prod_flg -- 资产证券化产品标志
    ,dir_ind_fund_amt -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,coll_way_cd -- 募集方式代码
    ,indus_type_cd -- 行业类型代码
    ,info_src_cd -- 信息来源代码
    ,report_prd -- 报告期
    ,rept_dt -- 报告日期
    ,fund_tot_lot -- 基金总份额
    ,fund_currt_tot_asset -- 基金当期总资产
    ,fund_curr_report_prd_nv -- 基金当前报告期净值
    ,lever_rat -- 杠杆率
    ,rei_loan_flg -- 房地产开发贷款标志
    ,proj_tot_invest -- 项目总投资
    ,capital -- 资本金
    ,resd_build_flg -- 居住用房标志
    ,non_uder_asset_cls_cd -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,g31_prod_cls_cd -- G31产品分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.lp_id -- 法人编号
    ,o.cont_int_rat -- 合同利率
    ,o.spent_corp_name -- 用款企业名称
    ,o.indus_categy_cd -- 行业门类代码
    ,o.thol_flg -- 两高一剩标志
    ,o.gover_fin_plat_flg -- 政府融资平台标志
    ,o.remote_bus_flg -- 异地业务标志
    ,o.ind_fund_flg -- 产业基金标志
    ,o.ext_rating_cd -- 外部评级代码
    ,o.intnal_rating_cd -- 内部评级代码
    ,o.intnal_rating_exp_dt -- 内部评级到期日期
    ,o.spent_corp_prov_cd -- 用款企业省代码
    ,o.spent_corp_city_cd -- 用款企业市代码
    ,o.dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,o.uder_asset_type_cd -- 底层资产类型代码
    ,o.mgmt_mode_cd -- 管理模式代码
    ,o.entr_loan_flg -- 委托贷款标志
    ,o.spv_vector_cnt -- SPV载体个数
    ,o.spv_vector_type_code -- SPV载体类型代码
    ,o.spv_vector_name -- SPV载体别名
    ,o.reply_num -- 批复号
    ,o.prod_tot_amt -- 产品总金额
    ,o.reply_amt -- 批复金额
    ,o.risk_wt -- 风险权重
    ,o.multi_finer_flg -- 多融资人标志
    ,o.actl_finer_cust_id -- 实际融资人客户编号
    ,o.actl_finer_cust_char_name -- 实际融资人客户性质名称
    ,o.actl_finer_belong_group_name -- 实际融资人所属集团名称
    ,o.asset_secution_prod_flg -- 资产证券化产品标志
    ,o.crdt_proj_flg -- 信贷类项目标志
    ,o.invest_prod_type_cd -- 投资产品类型代码
    ,o.dir_indus_subclass_cd -- 投向行业细类代码
    ,o.asset_supt_secu_flg -- 资产支持证券标志
    ,o.noth_rating_abs_flg -- 无评级资产证券化标志
    ,o.abs_prod_flg -- 资产证券化产品标志
    ,o.dir_ind_fund_amt -- 投向产业基金金额
    ,o.dir_makti_debt_eqty_amt -- 投向市场化债转股金额
    ,o.dir_indus_pam_amt -- 投向同行私募资产管理金额
    ,o.dir_attach_org_pam_amt -- 投向附属机构私募资产管理金额
    ,o.coll_way_cd -- 募集方式代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.info_src_cd -- 信息来源代码
    ,o.report_prd -- 报告期
    ,o.rept_dt -- 报告日期
    ,o.fund_tot_lot -- 基金总份额
    ,o.fund_currt_tot_asset -- 基金当期总资产
    ,o.fund_curr_report_prd_nv -- 基金当前报告期净值
    ,o.lever_rat -- 杠杆率
    ,o.rei_loan_flg -- 房地产开发贷款标志
    ,o.proj_tot_invest -- 项目总投资
    ,o.capital -- 资本金
    ,o.resd_build_flg -- 居住用房标志
    ,o.non_uder_asset_cls_cd -- 非底层资产大类代码
    ,o.non_uder_asset_sub_cls_cd -- 非底层资产细类代码
    ,o.g31_prod_cls_cd -- G31产品分类代码
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
from ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_bk o
    left join ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl d
        on
            o.fin_instm_id = d.fin_instm_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h;
--alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_fin_instm_mgmt_elmnt_h') 
               and substr(subpartition_name,1,8)=upper('p_ibmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h modify partition p_ibmsf1 
add subpartition p_ibmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl;
alter table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fin_instm_mgmt_elmnt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fin_instm_mgmt_elmnt_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
