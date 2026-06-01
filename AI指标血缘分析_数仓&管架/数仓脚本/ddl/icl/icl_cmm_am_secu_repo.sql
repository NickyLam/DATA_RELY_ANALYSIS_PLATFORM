/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_am_secu_repo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_am_secu_repo
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_am_secu_repo purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_secu_repo(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,repo_type_cd varchar2(10) -- 回购类型代码
    ,acct_set_id varchar2(60) -- 账套编号
    ,am_prod_id varchar2(60) -- 资管产品编号
    ,am_prod_name varchar2(1000) -- 资管产品名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,am_prod_prft_type_cd varchar2(60) -- 资管产品收益类型代码
    ,asset_id varchar2(60) -- 资产编号
    ,asset_name varchar2(1000) -- 资产名称
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,subj_id varchar2(60) -- 科目编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,asset_type_cd varchar2(60) -- 资产类型代码
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,cntpty_type_cd varchar2(60) -- 交易对手类型代码
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(750) -- 投组名称
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor number(18,0) -- 期限
    ,tran_amt number(30,2) -- 交易金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,acru_int number(30,2) -- 应计利息
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,curr_cd varchar2(10) -- 币种代码
    ,repo_int_rat number(18,8) -- 回购利率
    ,bond_fac_val number(30,2) -- 债券面值
    ,inpwn_ratio varchar2(2000) -- 质押比例
    ,pledge_val varchar2(2000) -- 质押物价值
    ,pledge_fac_val varchar2(2000) -- 质押物面值
    ,pledge_id_comb varchar2(2000) -- 质押物编号组合
    ,pledge_name_comb varchar2(4000) -- 质押物名称组合
    ,inpwn_bond_type_comb varchar2(2000) -- 质押债券类型组合
    ,currt_bal number(30,2) -- 当期余额
    ,td_acru_int number(30,2) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,fst_stl_way_cd varchar2(10) -- 首期结算方式代码
    ,exp_stl_way_cd varchar2(10) -- 到期结算方式代码
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(500) -- 交易员名称
    ,tran_id varchar2(60) -- 交易编号
    ,bag_id varchar2(60) -- 成交编号
    ,onl_flg varchar2(10) -- 线上标志
    ,crdt_out_acct_flow_num varchar2(60) -- 信贷出账流水号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_am_secu_repo to ${idl_schema};
grant select on ${icl_schema}.cmm_am_secu_repo to ${iel_schema};
grant select on ${icl_schema}.cmm_am_secu_repo to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_am_secu_repo is '资管证券回购';
comment on column ${icl_schema}.cmm_am_secu_repo.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_am_secu_repo.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_am_secu_repo.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_am_secu_repo.repo_type_cd is '回购类型代码';
comment on column ${icl_schema}.cmm_am_secu_repo.acct_set_id is '账套编号';
comment on column ${icl_schema}.cmm_am_secu_repo.am_prod_id is '资管产品编号';
comment on column ${icl_schema}.cmm_am_secu_repo.am_prod_name is '资管产品名称';
comment on column ${icl_schema}.cmm_am_secu_repo.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_am_secu_repo.am_prod_prft_type_cd is '资管产品收益类型代码';
comment on column ${icl_schema}.cmm_am_secu_repo.asset_id is '资产编号';
comment on column ${icl_schema}.cmm_am_secu_repo.asset_name is '资产名称';
comment on column ${icl_schema}.cmm_am_secu_repo.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_am_secu_repo.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_am_secu_repo.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_am_secu_repo.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_am_secu_repo.asset_type_cd is '资产类型代码';
comment on column ${icl_schema}.cmm_am_secu_repo.indus_type_cd is '行业类型代码';
comment on column ${icl_schema}.cmm_am_secu_repo.cntpty_type_cd is '交易对手类型代码';
comment on column ${icl_schema}.cmm_am_secu_repo.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_am_secu_repo.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_am_secu_repo.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_am_secu_repo.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_am_secu_repo.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_am_secu_repo.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_am_secu_repo.tenor is '期限';
comment on column ${icl_schema}.cmm_am_secu_repo.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_am_secu_repo.exp_stl_amt is '到期结算金额';
comment on column ${icl_schema}.cmm_am_secu_repo.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_am_secu_repo.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_am_secu_repo.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_am_secu_repo.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_am_secu_repo.repo_int_rat is '回购利率';
comment on column ${icl_schema}.cmm_am_secu_repo.bond_fac_val is '债券面值';
comment on column ${icl_schema}.cmm_am_secu_repo.inpwn_ratio is '质押比例';
comment on column ${icl_schema}.cmm_am_secu_repo.pledge_val is '质押物价值';
comment on column ${icl_schema}.cmm_am_secu_repo.pledge_fac_val is '质押物面值';
comment on column ${icl_schema}.cmm_am_secu_repo.pledge_id_comb is '质押物编号组合';
comment on column ${icl_schema}.cmm_am_secu_repo.pledge_name_comb is '质押物名称组合';
comment on column ${icl_schema}.cmm_am_secu_repo.inpwn_bond_type_comb is '质押债券类型组合';
comment on column ${icl_schema}.cmm_am_secu_repo.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_am_secu_repo.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_am_secu_repo.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_am_secu_repo.fst_stl_way_cd is '首期结算方式代码';
comment on column ${icl_schema}.cmm_am_secu_repo.exp_stl_way_cd is '到期结算方式代码';
comment on column ${icl_schema}.cmm_am_secu_repo.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_am_secu_repo.dealer_name is '交易员名称';
comment on column ${icl_schema}.cmm_am_secu_repo.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_am_secu_repo.bag_id is '成交编号';
comment on column ${icl_schema}.cmm_am_secu_repo.onl_flg is '线上标志';
comment on column ${icl_schema}.cmm_am_secu_repo.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${icl_schema}.cmm_am_secu_repo.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_am_secu_repo.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_am_secu_repo.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_am_secu_repo.etl_timestamp is 'ETL处理时间戳';
