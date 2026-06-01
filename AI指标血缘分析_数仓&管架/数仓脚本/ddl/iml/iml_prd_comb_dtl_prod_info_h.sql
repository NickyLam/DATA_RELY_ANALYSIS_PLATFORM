/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_comb_dtl_prod_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_comb_dtl_prod_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_comb_dtl_prod_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_comb_dtl_prod_info_h(
    dtl_prod_id varchar2(100) -- 明细产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,dtl_prod_name varchar2(750) -- 明细产品名称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_risk_level_cd varchar2(60) -- 产品风险等级代码
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,ta_cd varchar2(30) -- TA代码
    ,corp_nv number(18,8) -- 单位净值
    ,nv_dt date -- 净值日期
    ,open_tm varchar2(60) -- 开市时间
    ,close_tm varchar2(60) -- 闭市时间
    ,sevn_aual_yld number(18,8) -- 七日年化收益率
    ,ten_thous_prft number(22,12) -- 万份收益
    ,issue_dt date -- 发布日期
    ,indv_single_acct_amax_bamt number(30,2) -- 个人单户累计最大购买金额
    ,indv_single_day_single_acct_redem_lot_uplmi number(30,8) -- 个人单日单户赎回份额上限
    ,indv_single_day_single_acct_realtm_redem_amt number(30,2) -- 个人单日单户实时赎回金额
    ,indv_td_acm_max_buy number(30,2) -- 个人当日累计最大购买
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
grant select on ${iml_schema}.prd_comb_dtl_prod_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_comb_dtl_prod_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_comb_dtl_prod_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_comb_dtl_prod_info_h is '组合明细产品信息历史';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.dtl_prod_id is '明细产品编号';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.dtl_prod_name is '明细产品名称';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.prod_risk_level_cd is '产品风险等级代码';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.corp_nv is '单位净值';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.nv_dt is '净值日期';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.open_tm is '开市时间';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.close_tm is '闭市时间';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.sevn_aual_yld is '七日年化收益率';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.ten_thous_prft is '万份收益';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.issue_dt is '发布日期';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.indv_single_acct_amax_bamt is '个人单户累计最大购买金额';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.indv_single_day_single_acct_redem_lot_uplmi is '个人单日单户赎回份额上限';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.indv_single_day_single_acct_realtm_redem_amt is '个人单日单户实时赎回金额';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.indv_td_acm_max_buy is '个人当日累计最大购买';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_comb_dtl_prod_info_h.etl_timestamp is 'ETL处理时间戳';
