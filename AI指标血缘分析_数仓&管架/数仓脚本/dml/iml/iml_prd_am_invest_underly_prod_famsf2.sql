/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_invest_underly_prod_famsf2
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
drop table ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm purge;
drop table ${iml_schema}.prd_am_invest_underly_prod_famsf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_am_invest_underly_prod add partition p_famsf2 values ('famsf2')(
        subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_invest_underly_prod modify partition p_famsf2
    add subpartition p_famsf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_am_invest_underly_prod_famsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_am_invest_underly_prod partition for ('famsf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,coupon_breed_cd -- 息票品种代码
    ,fin_prod_id -- 金融产品编号
    ,issue_price -- 发行价格
    ,issue_size -- 发行规模
    ,issue_curr_cd -- 发行币种代码
    ,overs_flg -- 境外标志
    ,tran_site_cd -- 交易场所代码
    ,tran_caln_cd -- 交易日历代码
    ,issue_way_cd -- 发行方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,issuer_id -- 发行人编号
    ,mger_id -- 管理人编号
    ,finer_id -- 融资人编号
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,contn_weight_flg -- 含权标志
    ,brkevn_flg -- 保本标志
    ,rgst_trust_org_cd -- 登记托管机构代码
    ,fin_inst_issue_flg -- 金融机构发行标志
    ,guartor_id -- 担保人编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,sub_debt_flg -- 次级债标志
    ,invest_char_type_cd -- 投资性质类型代码
    ,fac_val -- 面值
    ,city_bond_flg -- 城投债标志
    ,city_bond_lev_cd -- 城投债级别代码
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,asset_src_cd -- 资产来源代码
    ,distr_brch_id -- 放款分行编号
    ,clear_ped_cd -- 清算时效
    ,proj_dir_indus_categy_cd -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd -- 项目投向行业大类代码
    ,actl_crdt_main_id -- 实际授信主体编号
    ,ped_days -- 周期天数
    ,am_plan_type_cd -- 资管计划类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_invest_underly_prod
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_am_invest_underly_prod_famsf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_am_invest_underly_prod partition for ('famsf2') where 0=1;

-- 2.1 insert data to tm table
-- fams_fin_product-1
insert into ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,coupon_breed_cd -- 息票品种代码
    ,fin_prod_id -- 金融产品编号
    ,issue_price -- 发行价格
    ,issue_size -- 发行规模
    ,issue_curr_cd -- 发行币种代码
    ,overs_flg -- 境外标志
    ,tran_site_cd -- 交易场所代码
    ,tran_caln_cd -- 交易日历代码
    ,issue_way_cd -- 发行方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,issuer_id -- 发行人编号
    ,mger_id -- 管理人编号
    ,finer_id -- 融资人编号
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,contn_weight_flg -- 含权标志
    ,brkevn_flg -- 保本标志
    ,rgst_trust_org_cd -- 登记托管机构代码
    ,fin_inst_issue_flg -- 金融机构发行标志
    ,guartor_id -- 担保人编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,sub_debt_flg -- 次级债标志
    ,invest_char_type_cd -- 投资性质类型代码
    ,fac_val -- 面值
    ,city_bond_flg -- 城投债标志
    ,city_bond_lev_cd -- 城投债级别代码
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,asset_src_cd -- 资产来源代码
    ,distr_brch_id -- 放款分行编号
    ,clear_ped_cd -- 清算时效
    ,proj_dir_indus_categy_cd -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd -- 项目投向行业大类代码
    ,actl_crdt_main_id -- 实际授信主体编号
    ,ped_days -- 周期天数
    ,am_plan_type_cd -- 资管计划类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,std_prod_id -- 标准产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223003'||P1.FINPROD_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.FINPROD_ID -- 源产品编号
    ,P1.FINPROD_TYPE2 -- 产品类别代码
    ,P1.FINPROD_ABBR -- 产品简称
    ,P1.FINPROD_NAME -- 产品全称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PROFIT_TYPE END -- 收益模式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.COUPON_SPECIES END -- 息票品种代码
    ,P1.FINPROD_MARKET_ID -- 金融产品编号
    ,P1.ISSUE_PRICE -- 发行价格
    ,P1.ISSUE_AMT -- 发行规模
    ,NVL(TRIM(P1.CCY),'-') -- 发行币种代码
    ,CASE WHEN P1.BLN_AREA='02' THEN '1'WHEN P1.BLN_AREA='01' THEN '0' ELSE '-' END  -- 境外标志
    ,NVL(TRIM(P1.TRADE_MARKET),'-') -- 交易场所代码
    ,NVL(TRIM(P1.CALENDAR_ID),'-') -- 交易日历代码
    ,NVL(TRIM(P1.ISSUE_TYPE),'00') -- 发行方式代码
    ,P1.ENTRUSTER -- 委托人编号
    ,P1.TRUSTEE_ID -- 托管人编号
    ,P1.ISSUER -- 发行人编号
    ,P1.MANAGER -- 管理人编号
    ,P1.FINANCIER -- 融资人编号
    ,p1.IDATE -- 发行日期
    ,p1.VDATE -- 起息日期
    ,p1.MDATE -- 到期日期
    ,P1.TERM_DAYS -- 产品期限
    ,P1.ACTMDATE -- 实际到期日期
    ,CASE WHEN P1.IS_SUS ='N' THEN '0' WHEN P1.IS_SUS ='Y' THEN '1' ELSE '-' END -- 永续标志
    ,P1.SUSTAINABLE_REMARK -- 永续条款
    ,CASE WHEN P1.IS_RIGHT ='N' THEN '0' WHEN P1.IS_RIGHT ='Y' THEN '1' ELSE '-' END -- 含权标志
    ,CASE WHEN P1.CAPI_INCOME_FEATURE ='02' THEN '0' WHEN P1.CAPI_INCOME_FEATURE ='01' THEN '1' ELSE '-' END -- 保本标志
    ,NVL(TRIM(P1.REGIST_ORG),'-') -- 登记托管机构代码
    ,CASE WHEN P1.IS_FIN_ORG ='N' THEN '0' WHEN P1.IS_FIN_ORG ='Y' THEN '1' ELSE '-' END -- 金融机构发行标志
    ,P1.SPONSOR -- 担保人编号
    ,P2.PUR_SPEED -- 申购确认期限
    ,P2.RED_SPEED -- 赎回确认期限
    ,CASE WHEN P2.IS_SEC_BOND ='N' THEN '0' WHEN P2.IS_SEC_BOND ='Y' THEN '1' ELSE '-' END -- 次级债标志
    ,NVL(TRIM(P2.INVEST_NATURE),'-') -- 投资性质类型代码
    ,P2.FACE_VALUE -- 面值
    ,CASE WHEN P2.IS_CITY_BOND ='N' THEN '0' WHEN P2.IS_CITY_BOND ='Y' THEN '1' ELSE '-' END -- 城投债标志
    ,NVL(TRIM(P2.CITY_BOND_LEV),'-') -- 城投债级别代码
    ,P1.CREATE_TIME -- 原创建时间
    ,P1.UPDATE_TIME -- 原更新时间
    ,NVL(TRIM(P4.ASSET_SOURCE),'-') -- 资产来源代码
    ,P4.LOAD_BANK -- 放款分行编号
    ,NVL(TRIM(P4.SETTLE_DAYS),'9') -- 清算时效
    ,CASE WHEN TRIM(P4.PROJ_INVEST_INDUSTRY) IS NULL THEN '-'
     WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P4.PROJ_INVEST_INDUSTRY END -- 项目投向行业门类代码
    ,NVL(TRIM(P4.PROJ_INVEST_INDUSTRY2),'-') -- 项目投向行业大类代码
    ,P4.ACTUAL_CREDIT_PROVID -- 实际授信主体编号
    ,P4.INVESTMENT_CYCLE -- 周期天数
    ,NVL(TRIM(P4.REP_PLAN_PROP),'-') -- 资管计划类型代码
    ,nvl(trim(P4.INT_TYPE),'-') -- 利率调整方式代码
    ,p3.STD_PROD_ID -- 标准产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_product' -- 源表名称
    ,'famsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product p1
    left join ${iol_schema}.fams_fin_product_add p2 on p1.finprod_id=p2.finprod_id
 and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_pa_fin_product p4 on p1.finprod_id=p4.finprod_id
 and p4.start_dt <= to_date('${batch_date}','yyyymmdd') and p4.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PROFIT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FAMS'
        AND R1.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT'
        AND R1.SRC_FIELD_EN_NAME= 'PROFIT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'PRD_AM_INVEST_UNDERLY_PROD'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PRFT_MODE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.COUPON_SPECIES= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_FIN_PRODUCT'
        AND R2.SRC_FIELD_EN_NAME= 'COUPON_SPECIES'
        AND R2.TARGET_TAB_EN_NAME= 'PRD_AM_INVEST_UNDERLY_PROD'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'COUPON_BREED_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P4.PROJ_INVEST_INDUSTRY = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'FAMS'
        AND R3.SRC_TAB_EN_NAME= 'FAMS_PA_FIN_PRODUCT'
        AND R3.SRC_FIELD_EN_NAME= 'PROJ_INVEST_INDUSTRY'
        AND R3.TARGET_TAB_EN_NAME= 'PRD_AM_INVEST_UNDERLY_PROD'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'PROJ_DIR_INDUS_CATEGY_CD'
    left join ${iol_schema}.fams_fin_product_type p3 on P1.FINPROD_ID=P3.FINPROD_ID
and p3.start_dt <= to_date('${batch_date}','yyyymmdd')
and p3.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.FINPROD_TYPE2 not in ('F16','F24','F26')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm 
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
insert /*+ append */ into ${iml_schema}.prd_am_invest_underly_prod_famsf2_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,src_prod_id -- 源产品编号
    ,prod_cate_cd -- 产品类别代码
    ,prod_abbr -- 产品简称
    ,prod_fname -- 产品全称
    ,prft_mode_cd -- 收益模式代码
    ,coupon_breed_cd -- 息票品种代码
    ,fin_prod_id -- 金融产品编号
    ,issue_price -- 发行价格
    ,issue_size -- 发行规模
    ,issue_curr_cd -- 发行币种代码
    ,overs_flg -- 境外标志
    ,tran_site_cd -- 交易场所代码
    ,tran_caln_cd -- 交易日历代码
    ,issue_way_cd -- 发行方式代码
    ,csner_id -- 委托人编号
    ,trustee_id -- 托管人编号
    ,issuer_id -- 发行人编号
    ,mger_id -- 管理人编号
    ,finer_id -- 融资人编号
    ,issue_dt -- 发行日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,prod_tenor -- 产品期限
    ,actl_exp_dt -- 实际到期日期
    ,subtn_flg -- 永续标志
    ,subtn_claus -- 永续条款
    ,contn_weight_flg -- 含权标志
    ,brkevn_flg -- 保本标志
    ,rgst_trust_org_cd -- 登记托管机构代码
    ,fin_inst_issue_flg -- 金融机构发行标志
    ,guartor_id -- 担保人编号
    ,purch_cfm_tenor -- 申购确认期限
    ,redem_cfm_tenor -- 赎回确认期限
    ,sub_debt_flg -- 次级债标志
    ,invest_char_type_cd -- 投资性质类型代码
    ,fac_val -- 面值
    ,city_bond_flg -- 城投债标志
    ,city_bond_lev_cd -- 城投债级别代码
    ,init_create_tm -- 原创建时间
    ,init_update_tm -- 原更新时间
    ,asset_src_cd -- 资产来源代码
    ,distr_brch_id -- 放款分行编号
    ,clear_ped_cd -- 清算时效
    ,proj_dir_indus_categy_cd -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd -- 项目投向行业大类代码
    ,actl_crdt_main_id -- 实际授信主体编号
    ,ped_days -- 周期天数
    ,am_plan_type_cd -- 资管计划类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,std_prod_id -- 标准产品编号
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
    ,nvl(n.src_prod_id, o.src_prod_id) as src_prod_id -- 源产品编号
    ,nvl(n.prod_cate_cd, o.prod_cate_cd) as prod_cate_cd -- 产品类别代码
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.prod_fname, o.prod_fname) as prod_fname -- 产品全称
    ,nvl(n.prft_mode_cd, o.prft_mode_cd) as prft_mode_cd -- 收益模式代码
    ,nvl(n.coupon_breed_cd, o.coupon_breed_cd) as coupon_breed_cd -- 息票品种代码
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.issue_size, o.issue_size) as issue_size -- 发行规模
    ,nvl(n.issue_curr_cd, o.issue_curr_cd) as issue_curr_cd -- 发行币种代码
    ,nvl(n.overs_flg, o.overs_flg) as overs_flg -- 境外标志
    ,nvl(n.tran_site_cd, o.tran_site_cd) as tran_site_cd -- 交易场所代码
    ,nvl(n.tran_caln_cd, o.tran_caln_cd) as tran_caln_cd -- 交易日历代码
    ,nvl(n.issue_way_cd, o.issue_way_cd) as issue_way_cd -- 发行方式代码
    ,nvl(n.csner_id, o.csner_id) as csner_id -- 委托人编号
    ,nvl(n.trustee_id, o.trustee_id) as trustee_id -- 托管人编号
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人编号
    ,nvl(n.mger_id, o.mger_id) as mger_id -- 管理人编号
    ,nvl(n.finer_id, o.finer_id) as finer_id -- 融资人编号
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.prod_tenor, o.prod_tenor) as prod_tenor -- 产品期限
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.subtn_flg, o.subtn_flg) as subtn_flg -- 永续标志
    ,nvl(n.subtn_claus, o.subtn_claus) as subtn_claus -- 永续条款
    ,nvl(n.contn_weight_flg, o.contn_weight_flg) as contn_weight_flg -- 含权标志
    ,nvl(n.brkevn_flg, o.brkevn_flg) as brkevn_flg -- 保本标志
    ,nvl(n.rgst_trust_org_cd, o.rgst_trust_org_cd) as rgst_trust_org_cd -- 登记托管机构代码
    ,nvl(n.fin_inst_issue_flg, o.fin_inst_issue_flg) as fin_inst_issue_flg -- 金融机构发行标志
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.purch_cfm_tenor, o.purch_cfm_tenor) as purch_cfm_tenor -- 申购确认期限
    ,nvl(n.redem_cfm_tenor, o.redem_cfm_tenor) as redem_cfm_tenor -- 赎回确认期限
    ,nvl(n.sub_debt_flg, o.sub_debt_flg) as sub_debt_flg -- 次级债标志
    ,nvl(n.invest_char_type_cd, o.invest_char_type_cd) as invest_char_type_cd -- 投资性质类型代码
    ,nvl(n.fac_val, o.fac_val) as fac_val -- 面值
    ,nvl(n.city_bond_flg, o.city_bond_flg) as city_bond_flg -- 城投债标志
    ,nvl(n.city_bond_lev_cd, o.city_bond_lev_cd) as city_bond_lev_cd -- 城投债级别代码
    ,nvl(n.init_create_tm, o.init_create_tm) as init_create_tm -- 原创建时间
    ,nvl(n.init_update_tm, o.init_update_tm) as init_update_tm -- 原更新时间
    ,nvl(n.asset_src_cd, o.asset_src_cd) as asset_src_cd -- 资产来源代码
    ,nvl(n.distr_brch_id, o.distr_brch_id) as distr_brch_id -- 放款分行编号
    ,nvl(n.clear_ped_cd, o.clear_ped_cd) as clear_ped_cd -- 清算时效
    ,nvl(n.proj_dir_indus_categy_cd, o.proj_dir_indus_categy_cd) as proj_dir_indus_categy_cd -- 项目投向行业门类代码
    ,nvl(n.proj_dir_indus_gen_cd, o.proj_dir_indus_gen_cd) as proj_dir_indus_gen_cd -- 项目投向行业大类代码
    ,nvl(n.actl_crdt_main_id, o.actl_crdt_main_id) as actl_crdt_main_id -- 实际授信主体编号
    ,nvl(n.ped_days, o.ped_days) as ped_days -- 周期天数
    ,nvl(n.am_plan_type_cd, o.am_plan_type_cd) as am_plan_type_cd -- 资管计划类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.src_prod_id <> n.src_prod_id
                or o.prod_cate_cd <> n.prod_cate_cd
                or o.prod_abbr <> n.prod_abbr
                or o.prod_fname <> n.prod_fname
                or o.prft_mode_cd <> n.prft_mode_cd
                or o.coupon_breed_cd <> n.coupon_breed_cd
                or o.fin_prod_id <> n.fin_prod_id
                or o.issue_price <> n.issue_price
                or o.issue_size <> n.issue_size
                or o.issue_curr_cd <> n.issue_curr_cd
                or o.overs_flg <> n.overs_flg
                or o.tran_site_cd <> n.tran_site_cd
                or o.tran_caln_cd <> n.tran_caln_cd
                or o.issue_way_cd <> n.issue_way_cd
                or o.csner_id <> n.csner_id
                or o.trustee_id <> n.trustee_id
                or o.issuer_id <> n.issuer_id
                or o.mger_id <> n.mger_id
                or o.finer_id <> n.finer_id
                or o.issue_dt <> n.issue_dt
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.prod_tenor <> n.prod_tenor
                or o.actl_exp_dt <> n.actl_exp_dt
                or o.subtn_flg <> n.subtn_flg
                or o.subtn_claus <> n.subtn_claus
                or o.contn_weight_flg <> n.contn_weight_flg
                or o.brkevn_flg <> n.brkevn_flg
                or o.rgst_trust_org_cd <> n.rgst_trust_org_cd
                or o.fin_inst_issue_flg <> n.fin_inst_issue_flg
                or o.guartor_id <> n.guartor_id
                or o.purch_cfm_tenor <> n.purch_cfm_tenor
                or o.redem_cfm_tenor <> n.redem_cfm_tenor
                or o.sub_debt_flg <> n.sub_debt_flg
                or o.invest_char_type_cd <> n.invest_char_type_cd
                or o.fac_val <> n.fac_val
                or o.city_bond_flg <> n.city_bond_flg
                or o.city_bond_lev_cd <> n.city_bond_lev_cd
                or o.init_create_tm <> n.init_create_tm
                or o.init_update_tm <> n.init_update_tm
                or o.asset_src_cd <> n.asset_src_cd
                or o.distr_brch_id <> n.distr_brch_id
                or o.clear_ped_cd <> n.clear_ped_cd
                or o.proj_dir_indus_categy_cd <> n.proj_dir_indus_categy_cd
                or o.proj_dir_indus_gen_cd <> n.proj_dir_indus_gen_cd
                or o.actl_crdt_main_id <> n.actl_crdt_main_id
                or o.ped_days <> n.ped_days
                or o.am_plan_type_cd <> n.am_plan_type_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.std_prod_id <> n.std_prod_id
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
from ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm n
    full join ${iml_schema}.prd_am_invest_underly_prod_famsf2_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_am_invest_underly_prod truncate partition for ('famsf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_am_invest_underly_prod exchange subpartition p_famsf2_${batch_date} with table ${iml_schema}.prd_am_invest_underly_prod_famsf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_am_invest_underly_prod drop subpartition p_famsf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_invest_underly_prod to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_invest_underly_prod_famsf2_tm purge;
drop table ${iml_schema}.prd_am_invest_underly_prod_famsf2_ex purge;
drop table ${iml_schema}.prd_am_invest_underly_prod_famsf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_invest_underly_prod', partname => 'p_famsf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);