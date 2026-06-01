/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fin_instm_mgmt_elmnt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h(
    fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(100) -- 资产类型编号
    ,market_type_id varchar2(100) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,cont_int_rat number(18,8) -- 合同利率
    ,spent_corp_name varchar2(750) -- 用款企业名称
    ,indus_categy_cd varchar2(30) -- 行业门类代码
    ,thol_flg varchar2(10) -- 两高一剩标志
    ,gover_fin_plat_flg varchar2(10) -- 政府融资平台标志
    ,remote_bus_flg varchar2(10) -- 异地业务标志
    ,ind_fund_flg varchar2(10) -- 产业基金标志
    ,ext_rating_cd varchar2(30) -- 外部评级代码
    ,intnal_rating_cd varchar2(30) -- 内部评级代码
    ,intnal_rating_exp_dt date -- 内部评级到期日期
    ,spent_corp_prov_cd varchar2(30) -- 用款企业省代码
    ,spent_corp_city_cd varchar2(30) -- 用款企业市代码
    ,dir_makti_debt_eqty_flg varchar2(10) -- 投向市场化债转股标志
    ,uder_asset_type_cd varchar2(30) -- 底层资产类型代码
    ,mgmt_mode_cd varchar2(30) -- 管理模式代码
    ,entr_loan_flg varchar2(10) -- 委托贷款标志
    ,spv_vector_cnt number(10) -- SPV载体个数
    ,spv_vector_type_code varchar2(100) -- SPV载体类型代码
    ,spv_vector_name varchar2(250) -- SPV载体别名
    ,reply_num varchar2(100) -- 批复号
    ,prod_tot_amt number(38,4) -- 产品总金额
    ,reply_amt number(38,4) -- 批复金额
    ,risk_wt number(18,6) -- 风险权重
    ,multi_finer_flg varchar2(10) -- 多融资人标志
    ,actl_finer_cust_id varchar2(100) -- 实际融资人客户编号
    ,actl_finer_cust_char_name varchar2(750) -- 实际融资人客户性质名称
    ,actl_finer_belong_group_name varchar2(750) -- 实际融资人所属集团名称
    ,asset_secution_prod_flg varchar2(10) -- 资产证券化产品标志
    ,crdt_proj_flg varchar2(10) -- 信贷类项目标志
    ,invest_prod_type_cd varchar2(30) -- 投资产品类型代码
    ,dir_indus_subclass_cd varchar2(100) -- 投向行业细类代码
    ,asset_supt_secu_flg varchar2(10) -- 资产支持证券标志
    ,noth_rating_abs_flg varchar2(10) -- 无评级资产证券化标志
    ,abs_prod_flg varchar2(10) -- 资产证券化产品标志
    ,dir_ind_fund_amt number(36,8) -- 投向产业基金金额
    ,dir_makti_debt_eqty_amt number(36,8) -- 投向市场化债转股金额
    ,dir_indus_pam_amt number(36,8) -- 投向同行私募资产管理金额
    ,dir_attach_org_pam_amt number(36,8) -- 投向附属机构私募资产管理金额
    ,coll_way_cd varchar2(60) -- 募集方式代码
    ,indus_type_cd varchar2(60) -- 行业类型代码
    ,info_src_cd varchar2(30) -- 信息来源代码
    ,report_prd varchar2(100) -- 报告期
    ,rept_dt date -- 报告日期
    ,fund_tot_lot number(30,2) -- 基金总份额
    ,fund_currt_tot_asset number(30,2) -- 基金当期总资产
    ,fund_curr_report_prd_nv number(18,6) -- 基金当前报告期净值
    ,lever_rat number(18,6) -- 杠杆率
    ,rei_loan_flg varchar2(10) -- 房地产开发贷款标志
    ,proj_tot_invest number(38,8) -- 项目总投资
    ,capital number(38,8) -- 资本金
    ,resd_build_flg varchar2(10) -- 居住用房标志
    ,non_uder_asset_cls_cd varchar2(30) -- 非底层资产大类代码
    ,non_uder_asset_sub_cls_cd varchar2(30) -- 非底层资产细类代码
    ,g31_prod_cls_cd varchar2(100) -- G31产品分类代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_fin_instm_mgmt_elmnt_h to ${icl_schema};
grant select on ${iml_schema}.prd_fin_instm_mgmt_elmnt_h to ${idl_schema};
grant select on ${iml_schema}.prd_fin_instm_mgmt_elmnt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fin_instm_mgmt_elmnt_h is '金融工具管理要素历史';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.cont_int_rat is '合同利率';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spent_corp_name is '用款企业名称';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.indus_categy_cd is '行业门类代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.thol_flg is '两高一剩标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.gover_fin_plat_flg is '政府融资平台标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.remote_bus_flg is '异地业务标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.ind_fund_flg is '产业基金标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.ext_rating_cd is '外部评级代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.intnal_rating_cd is '内部评级代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.intnal_rating_exp_dt is '内部评级到期日期';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spent_corp_prov_cd is '用款企业省代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spent_corp_city_cd is '用款企业市代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_makti_debt_eqty_flg is '投向市场化债转股标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.uder_asset_type_cd is '底层资产类型代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.mgmt_mode_cd is '管理模式代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.entr_loan_flg is '委托贷款标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spv_vector_cnt is 'SPV载体个数';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spv_vector_type_code is 'SPV载体类型代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.spv_vector_name is 'SPV载体别名';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.reply_num is '批复号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.prod_tot_amt is '产品总金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.reply_amt is '批复金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.risk_wt is '风险权重';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.multi_finer_flg is '多融资人标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.actl_finer_cust_id is '实际融资人客户编号';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.actl_finer_cust_char_name is '实际融资人客户性质名称';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.actl_finer_belong_group_name is '实际融资人所属集团名称';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.asset_secution_prod_flg is '资产证券化产品标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.crdt_proj_flg is '信贷类项目标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.invest_prod_type_cd is '投资产品类型代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_indus_subclass_cd is '投向行业细类代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.asset_supt_secu_flg is '资产支持证券标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.noth_rating_abs_flg is '无评级资产证券化标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.abs_prod_flg is '资产证券化产品标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_ind_fund_amt is '投向产业基金金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_makti_debt_eqty_amt is '投向市场化债转股金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_indus_pam_amt is '投向同行私募资产管理金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.dir_attach_org_pam_amt is '投向附属机构私募资产管理金额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.coll_way_cd is '募集方式代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.info_src_cd is '信息来源代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.report_prd is '报告期';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.rept_dt is '报告日期';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.fund_tot_lot is '基金总份额';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.fund_currt_tot_asset is '基金当期总资产';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.fund_curr_report_prd_nv is '基金当前报告期净值';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.lever_rat is '杠杆率';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.rei_loan_flg is '房地产开发贷款标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.proj_tot_invest is '项目总投资';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.capital is '资本金';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.resd_build_flg is '居住用房标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.non_uder_asset_cls_cd is '非底层资产大类代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.non_uder_asset_sub_cls_cd is '非底层资产细类代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.g31_prod_cls_cd is 'G31产品分类代码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fin_instm_mgmt_elmnt_h.etl_timestamp is 'ETL处理时间戳';
