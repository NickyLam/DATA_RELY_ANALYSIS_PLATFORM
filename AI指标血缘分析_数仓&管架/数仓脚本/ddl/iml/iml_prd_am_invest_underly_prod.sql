/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_am_invest_underly_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_am_invest_underly_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_am_invest_underly_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_invest_underly_prod(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,prod_cate_cd varchar2(60) -- 产品类别代码
    ,prod_abbr varchar2(250) -- 产品简称
    ,prod_fname varchar2(250) -- 产品全称
    ,prft_mode_cd varchar2(60) -- 收益模式代码
    ,coupon_breed_cd varchar2(60) -- 息票品种代码
    ,fin_prod_id varchar2(60) -- 金融产品编号
    ,issue_price number(30,14) -- 发行价格
    ,issue_size number(30,2) -- 发行规模
    ,issue_curr_cd varchar2(60) -- 发行币种代码
    ,overs_flg varchar2(60) -- 境外标志
    ,tran_site_cd varchar2(60) -- 交易场所代码
    ,tran_caln_cd varchar2(60) -- 交易日历代码
    ,issue_way_cd varchar2(60) -- 发行方式代码
    ,csner_id varchar2(60) -- 委托人编号
    ,trustee_id varchar2(60) -- 托管人编号
    ,issuer_id varchar2(60) -- 发行人编号
    ,mger_id varchar2(60) -- 管理人编号
    ,finer_id varchar2(60) -- 融资人编号
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,prod_tenor number(10) -- 产品期限
    ,actl_exp_dt date -- 实际到期日期
    ,subtn_flg varchar2(60) -- 永续标志
    ,subtn_claus varchar2(1000) -- 永续条款
    ,contn_weight_flg varchar2(60) -- 含权标志
    ,brkevn_flg varchar2(60) -- 保本标志
    ,rgst_trust_org_cd varchar2(60) -- 登记托管机构代码
    ,fin_inst_issue_flg varchar2(60) -- 金融机构发行标志
    ,guartor_id varchar2(60) -- 担保人编号
    ,purch_cfm_tenor number(10) -- 申购确认期限
    ,redem_cfm_tenor number(10) -- 赎回确认期限
    ,sub_debt_flg varchar2(60) -- 次级债标志
    ,invest_char_type_cd varchar2(60) -- 投资性质类型代码
    ,fac_val number(30,14) -- 面值
    ,city_bond_flg varchar2(60) -- 城投债标志
    ,city_bond_lev_cd varchar2(60) -- 城投债级别代码
    ,init_create_tm timestamp -- 原创建时间
    ,init_update_tm timestamp -- 原更新时间
    ,asset_src_cd varchar2(60) -- 资产来源代码
    ,distr_brch_id varchar2(100) -- 放款分行编号
    ,clear_ped_cd varchar2(30) -- 清算时效
    ,proj_dir_indus_categy_cd varchar2(60) -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd varchar2(60) -- 项目投向行业大类代码
    ,actl_crdt_main_id varchar2(500) -- 实际授信主体编号
    ,ped_days varchar2(60) -- 周期天数
    ,am_plan_type_cd varchar2(60) -- 资管计划类型代码
    ,int_rat_adj_way_cd varchar2(60) -- 利率调整方式代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_am_invest_underly_prod to ${icl_schema};
grant select on ${iml_schema}.prd_am_invest_underly_prod to ${idl_schema};
grant select on ${iml_schema}.prd_am_invest_underly_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_am_invest_underly_prod is '资管投资标的产品';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.src_prod_id is '源产品编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prod_abbr is '产品简称';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prod_fname is '产品全称';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prft_mode_cd is '收益模式代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.coupon_breed_cd is '息票品种代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issue_price is '发行价格';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issue_size is '发行规模';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issue_curr_cd is '发行币种代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.overs_flg is '境外标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.tran_caln_cd is '交易日历代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issue_way_cd is '发行方式代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.csner_id is '委托人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.trustee_id is '托管人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issuer_id is '发行人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.mger_id is '管理人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.finer_id is '融资人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.issue_dt is '发行日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.value_dt is '起息日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.prod_tenor is '产品期限';
comment on column ${iml_schema}.prd_am_invest_underly_prod.actl_exp_dt is '实际到期日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.subtn_flg is '永续标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.subtn_claus is '永续条款';
comment on column ${iml_schema}.prd_am_invest_underly_prod.contn_weight_flg is '含权标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.brkevn_flg is '保本标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.rgst_trust_org_cd is '登记托管机构代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.fin_inst_issue_flg is '金融机构发行标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.guartor_id is '担保人编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.purch_cfm_tenor is '申购确认期限';
comment on column ${iml_schema}.prd_am_invest_underly_prod.redem_cfm_tenor is '赎回确认期限';
comment on column ${iml_schema}.prd_am_invest_underly_prod.sub_debt_flg is '次级债标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.invest_char_type_cd is '投资性质类型代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.fac_val is '面值';
comment on column ${iml_schema}.prd_am_invest_underly_prod.city_bond_flg is '城投债标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.city_bond_lev_cd is '城投债级别代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.init_create_tm is '原创建时间';
comment on column ${iml_schema}.prd_am_invest_underly_prod.init_update_tm is '原更新时间';
comment on column ${iml_schema}.prd_am_invest_underly_prod.asset_src_cd is '资产来源代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.distr_brch_id is '放款分行编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.clear_ped_cd is '清算时效';
comment on column ${iml_schema}.prd_am_invest_underly_prod.proj_dir_indus_categy_cd is '项目投向行业门类代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.proj_dir_indus_gen_cd is '项目投向行业大类代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.actl_crdt_main_id is '实际授信主体编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.ped_days is '周期天数';
comment on column ${iml_schema}.prd_am_invest_underly_prod.am_plan_type_cd is '资管计划类型代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_am_invest_underly_prod.create_dt is '创建日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.update_dt is '更新日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_am_invest_underly_prod.id_mark is '增删标志';
comment on column ${iml_schema}.prd_am_invest_underly_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_am_invest_underly_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_am_invest_underly_prod.etl_timestamp is 'ETL处理时间戳';
