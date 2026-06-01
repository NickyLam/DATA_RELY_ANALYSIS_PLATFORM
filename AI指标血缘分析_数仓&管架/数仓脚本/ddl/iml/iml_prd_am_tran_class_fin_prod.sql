/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_am_tran_class_fin_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_am_tran_class_fin_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_am_tran_class_fin_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_tran_class_fin_prod(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,brch_seq_num varchar2(100) -- 分支序号
    ,prod_cate_cd varchar2(60) -- 产品类别代码
    ,prft_mode_cd varchar2(60) -- 收益模式代码
    ,brch_type_cd varchar2(60) -- 分支类型代码
    ,pass_id varchar2(100) -- 通道编号
    ,nati_pric number(30,2) -- 名义本金
    ,pric_curr_cd varchar2(60) -- 本金币种代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor_days number(30) -- 期限天数
    ,int_rat_type_cd varchar2(60) -- 利率类型代码
    ,fix_int_rat number(30,2) -- 固定利率
    ,float_int_rat_base_id varchar2(60) -- 浮动利率基准编号
    ,int_accr_base_cd varchar2(60) -- 计息基础代码
    ,exp_pric number(30,2) -- 到期本金
    ,exp_int number(30,2) -- 到期利息
    ,exp_amt number(30,2) -- 到期金额
    ,brkevn_flg varchar2(10) -- 保本标志
    ,init_prod_id varchar2(100) -- 原产品编号
    ,tran_site_cd varchar2(60) -- 交易场所代码
    ,tran_caln_cd varchar2(60) -- 交易日历代码
    ,tenor_breed_cd varchar2(60) -- 期限品种代码
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,create_tm timestamp -- 创建时间
    ,update_tm timestamp -- 更新时间
    ,exp_corp_net_price number(30,2) -- 到期单位净价
    ,exp_corp_int number(30,2) -- 到期单位利息
    ,exp_corp_full_price number(30,2) -- 到期单位全价
    ,exp_prft number(30,2) -- 到期收益
    ,exp_stl_way_cd varchar2(60) -- 到期结算方式代码
    ,fst_dlvy_dt date -- 首期交付日期
    ,exp_dlvy_dt date -- 到期交付日期
    ,cont_id varchar2(250) -- 合同编号
    ,actl_poses_acct_days number(30) -- 实际占款天数
    ,pd_id varchar2(100) -- 期次编号
    ,cont_name varchar2(250) -- 合同名称
    ,rgst_trust_org_cd varchar2(60) -- 登记托管机构代码
    ,col_cnt number(30) -- 押品数
    ,attach_claus varchar2(2000) -- 补充条款
    ,provi_pnlt_flg varchar2(10) -- 计提罚息标志
    ,pnlt_provi_base varchar2(100) -- 罚息计提基数
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.prd_am_tran_class_fin_prod to ${icl_schema};
grant select on ${iml_schema}.prd_am_tran_class_fin_prod to ${idl_schema};
grant select on ${iml_schema}.prd_am_tran_class_fin_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_am_tran_class_fin_prod is '资管交易类金融产品';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.brch_seq_num is '分支序号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.prft_mode_cd is '收益模式代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.brch_type_cd is '分支类型代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.pass_id is '通道编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.nati_pric is '名义本金';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.pric_curr_cd is '本金币种代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.value_dt is '起息日期';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.tenor_days is '期限天数';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.fix_int_rat is '固定利率';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.float_int_rat_base_id is '浮动利率基准编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.int_accr_base_cd is '计息基础代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_pric is '到期本金';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_int is '到期利息';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_amt is '到期金额';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.brkevn_flg is '保本标志';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.init_prod_id is '原产品编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.tran_caln_cd is '交易日历代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.tenor_breed_cd is '期限品种代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.create_tm is '创建时间';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.update_tm is '更新时间';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_corp_net_price is '到期单位净价';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_corp_int is '到期单位利息';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_corp_full_price is '到期单位全价';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_prft is '到期收益';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_stl_way_cd is '到期结算方式代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.fst_dlvy_dt is '首期交付日期';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.exp_dlvy_dt is '到期交付日期';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.cont_id is '合同编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.actl_poses_acct_days is '实际占款天数';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.pd_id is '期次编号';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.cont_name is '合同名称';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.rgst_trust_org_cd is '登记托管机构代码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.col_cnt is '押品数';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.attach_claus is '补充条款';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.provi_pnlt_flg is '计提罚息标志';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.pnlt_provi_base is '罚息计提基数';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_am_tran_class_fin_prod.etl_timestamp is 'ETL处理时间戳';
