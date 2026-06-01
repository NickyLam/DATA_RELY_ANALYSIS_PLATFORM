/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_am_invest_underly_prod
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${idl_schema}.prd_am_invest_underly_prod drop partition p_${last_date};
alter table ${idl_schema}.prd_am_invest_underly_prod drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_am_invest_underly_prod add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_am_invest_underly_prod (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,src_prod_id  -- 源产品编号
    ,prod_cate_cd  -- 产品类别代码
    ,prod_abbr  -- 产品简称
    ,prod_fname  -- 产品全称
    ,prft_mode_cd  -- 收益模式代码
    ,coupon_breed_cd  -- 息票品种代码
    ,fin_prod_id  -- 金融产品编号
    ,issue_price  -- 发行价格
    ,issue_size  -- 发行规模
    ,issue_curr_cd  -- 发行币种代码
    ,overs_flg  -- 境外标志
    ,tran_site_cd  -- 交易场所代码
    ,tran_caln_cd  -- 交易日历代码
    ,issue_way_cd  -- 发行方式代码
    ,csner_id  -- 委托人编号
    ,trustee_id  -- 托管人编号
    ,issuer_id  -- 发行人编号
    ,mger_id  -- 管理人编号
    ,finer_id  -- 融资人编号
    ,issue_dt  -- 发行日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,prod_tenor  -- 产品期限
    ,actl_exp_dt  -- 实际到期日期
    ,subtn_flg  -- 永续标志
    ,subtn_claus  -- 永续条款
    ,contn_weight_flg  -- 含权标志
    ,brkevn_flg  -- 保本标志
    ,rgst_trust_org_cd  -- 登记托管机构代码
    ,fin_inst_issue_flg  -- 金融机构发行标志
    ,guartor_id  -- 担保人编号
    ,purch_cfm_tenor  -- 申购确认期限
    ,redem_cfm_tenor  -- 赎回确认期限
    ,sub_debt_flg  -- 次级债标志
    ,invest_char_type_cd  -- 投资性质类型代码
    ,fac_val  -- 面值
    ,city_bond_flg  -- 城投债标志
    ,city_bond_lev_cd  -- 城投债级别代码
    ,init_create_tm  -- 原创建时间
    ,init_update_tm  -- 原更新时间
    ,asset_src_cd  -- 资产来源代码
    ,distr_brch_id  -- 放款分行编号
    ,clear_ped_cd  -- 清算周期代码
    ,proj_dir_indus_categy_cd  -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd  -- 项目投向行业大类代码
    ,actl_crdt_main_id  -- 实际授信主体编号
    ,ped_days  -- 周期天数
    ,am_plan_type_cd  -- 资管计划类型代码
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'')  -- 源产品编号
    ,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'')  -- 产品类别代码
    ,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'')  -- 产品简称
    ,replace(replace(t1.prod_fname,chr(13),''),chr(10),'')  -- 产品全称
    ,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'')  -- 收益模式代码
    ,replace(replace(t1.coupon_breed_cd,chr(13),''),chr(10),'')  -- 息票品种代码
    ,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'')  -- 金融产品编号
    ,t1.issue_price  -- 发行价格
    ,t1.issue_size  -- 发行规模
    ,replace(replace(t1.issue_curr_cd,chr(13),''),chr(10),'')  -- 发行币种代码
    ,replace(replace(t1.overs_flg,chr(13),''),chr(10),'')  -- 境外标志
    ,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'')  -- 交易场所代码
    ,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'')  -- 交易日历代码
    ,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'')  -- 发行方式代码
    ,replace(replace(t1.csner_id,chr(13),''),chr(10),'')  -- 委托人编号
    ,replace(replace(t1.trustee_id,chr(13),''),chr(10),'')  -- 托管人编号
    ,replace(replace(t1.issuer_id,chr(13),''),chr(10),'')  -- 发行人编号
    ,replace(replace(t1.mger_id,chr(13),''),chr(10),'')  -- 管理人编号
    ,replace(replace(t1.finer_id,chr(13),''),chr(10),'')  -- 融资人编号
    ,t1.issue_dt  -- 发行日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.prod_tenor  -- 产品期限
    ,t1.actl_exp_dt  -- 实际到期日期
    ,replace(replace(t1.subtn_flg,chr(13),''),chr(10),'')  -- 永续标志
    ,replace(replace(t1.subtn_claus,chr(13),''),chr(10),'')  -- 永续条款
    ,replace(replace(t1.contn_weight_flg,chr(13),''),chr(10),'')  -- 含权标志
    ,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'')  -- 保本标志
    ,replace(replace(t1.rgst_trust_org_cd,chr(13),''),chr(10),'')  -- 登记托管机构代码
    ,replace(replace(t1.fin_inst_issue_flg,chr(13),''),chr(10),'')  -- 金融机构发行标志
    ,replace(replace(t1.guartor_id,chr(13),''),chr(10),'')  -- 担保人编号
    ,t1.purch_cfm_tenor  -- 申购确认期限
    ,t1.redem_cfm_tenor  -- 赎回确认期限
    ,replace(replace(t1.sub_debt_flg,chr(13),''),chr(10),'')  -- 次级债标志
    ,replace(replace(t1.invest_char_type_cd,chr(13),''),chr(10),'')  -- 投资性质类型代码
    ,t1.fac_val  -- 面值
    ,replace(replace(t1.city_bond_flg,chr(13),''),chr(10),'')  -- 城投债标志
    ,replace(replace(t1.city_bond_lev_cd,chr(13),''),chr(10),'')  -- 城投债级别代码
    ,t1.init_create_tm  -- 原创建时间
    ,t1.init_update_tm  -- 原更新时间
    ,replace(replace(t1.asset_src_cd,chr(13),''),chr(10),'')  -- 资产来源代码
    ,replace(replace(t1.distr_brch_id,chr(13),''),chr(10),'')  -- 放款分行编号
    ,replace(replace(t1.clear_ped_cd,chr(13),''),chr(10),'')  -- 清算周期代码
    ,replace(replace(t1.proj_dir_indus_categy_cd,chr(13),''),chr(10),'')  -- 项目投向行业门类代码
    ,replace(replace(t1.proj_dir_indus_gen_cd,chr(13),''),chr(10),'')  -- 项目投向行业大类代码
    ,replace(replace(t1.actl_crdt_main_id,chr(13),''),chr(10),'')  -- 实际授信主体编号
    ,replace(replace(t1.ped_days,chr(13),''),chr(10),'')  -- 周期天数
    ,replace(replace(t1.am_plan_type_cd,chr(13),''),chr(10),'')  -- 资管计划类型代码
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_am_invest_underly_prod t1    --资管投资标的产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_am_invest_underly_prod',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);