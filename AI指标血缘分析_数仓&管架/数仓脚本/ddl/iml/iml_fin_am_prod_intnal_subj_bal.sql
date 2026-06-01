/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_prod_intnal_subj_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_prod_intnal_subj_bal
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_prod_intnal_subj_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_intnal_subj_bal(
    acct_pkg_id varchar2(100) -- 套账编号
    ,lp_id varchar2(60) -- 法人编号
    ,bal_dt date -- 余额日期
    ,subj_id varchar2(500) -- 科目编号
    ,super_subj_id varchar2(60) -- 上级科目编号
    ,subj_level_cd varchar2(30) -- 科目等级代码
    ,bal_dir_cd varchar2(60) -- 科目余额方向
    ,carr_bal_dir_cd varchar2(60) -- 结转余额方向代码
    ,oc_curr_cd varchar2(60) -- 原币币种代码
    ,oc_bal number(30,2) -- 原币余额
    ,oc_cr_bal number(30,2) -- 原币贷方余额
    ,oc_dr_bal number(30,2) -- 原币借方余额
    ,oc_carr_bal number(30,2) -- 原币结转余额
    ,oc_cr_carr_bal number(30,2) -- 原币贷方结转余额
    ,oc_dr_carr_bal number(30,2) -- 原币借方结转余额
    ,dc_curr_cd varchar2(60) -- 本币币种代码
    ,dc_bal number(30,2) -- 本币余额
    ,dc_cr_bal number(30,2) -- 本币贷方余额
    ,dc_dr_bal number(30,2) -- 本币借方余额
    ,dc_carr_bal number(30,2) -- 本币结转余额
    ,dc_cr_carr_bal number(30,2) -- 本币贷方结转余额
    ,dc_dr_carr_bal number(30,2) -- 本币借方结转余额
    ,td_oc_amt number(30,2) -- 当日原币发生额
    ,td_oc_cr_amt number(30,2) -- 当日原币贷方发生额
    ,td_oc_dr_amt number(30,2) -- 当日原币借方发生额
    ,td_oc_carr_amt number(30,2) -- 当日原币结转发生额
    ,td_oc_cr_carr_amt number(30,2) -- 当日原币贷方结转发生额
    ,td_oc_dr_carr_amt number(30,2) -- 当日原币借方结转发生额
    ,td_dc_amt number(30,2) -- 当日本币发生额
    ,td_dc_cr_amt number(30,2) -- 当日本币贷方发生额
    ,td_dc_dr_amt number(30,2) -- 当日本币借方发生额
    ,td_dc_carr_amt number(30,2) -- 当日本币结转发生额
    ,td_dc_cr_carr_amt number(30,2) -- 当日本币贷方结转发生额
    ,td_dc_dr_carr_amt number(30,2) -- 当日本币借方结转发生额
    ,noth_subor_subj_flg varchar2(10) -- 无下级科目标志
    ,lot number(30,2) -- 份额
    ,td_amt_dir_cd varchar2(60) -- 当日发生额方向代码
    ,td_carr_amt_dir_cd varchar2(60) -- 当日结转发生额方向代码
    ,oc_dr_purch_unrliz_gain number(30,2) -- 原币借方申购未实现平准金
    ,oc_dr_redem_unrliz_gain number(30,2) -- 原币借方赎回未实现平准金
    ,oc_cr_purch_unrliz_gain number(30,2) -- 原币贷方申购未实现平准金
    ,oc_cr_redem_unrliz_gain number(30,2) -- 原币贷方赎回未实现平准金
    ,dc_dr_purch_unrliz_gain number(30,2) -- 本币借方申购未实现平准金
    ,dc_dr_redem_unrliz_gain number(30,2) -- 本币借方赎回未实现平准金
    ,dc_cr_purch_unrliz_gain number(30,2) -- 本币贷方申购未实现平准金
    ,dc_cr_redem_unrliz_gain number(30,2) -- 本币贷方赎回未实现平准金
    ,ear_d_oc_bal_dir_cd varchar2(60) -- 日初原币余额方向代码
    ,ear_d_oc_bal number(30,2) -- 日初原币余额
    ,end_d_oc_bal_dir_cd varchar2(60) -- 日末原币余额方向代码
    ,end_d_oc_bal number(30,2) -- 日末原币余额
    ,ear_d_dc_bal_dir_cd varchar2(60) -- 日初本币余额方向代码
    ,ear_d_dc_bal number(30,2) -- 日初本币余额
    ,end_d_dc_bal_dir_cd varchar2(60) -- 日末本币余额方向代码
    ,end_d_dc_bal number(30,2) -- 日末本币余额
    ,sob_name varchar2(500) -- 账套名称
    ,subj_name varchar2(500) -- 科目名称
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
grant select on ${iml_schema}.fin_am_prod_intnal_subj_bal to ${icl_schema};
grant select on ${iml_schema}.fin_am_prod_intnal_subj_bal to ${idl_schema};
grant select on ${iml_schema}.fin_am_prod_intnal_subj_bal to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_prod_intnal_subj_bal is '资管产品内部科目余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.acct_pkg_id is '套账编号';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.bal_dt is '余额日期';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.subj_id is '科目编号';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.super_subj_id is '上级科目编号';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.subj_level_cd is '科目等级代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.carr_bal_dir_cd is '结转余额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_curr_cd is '原币币种代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_bal is '原币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_cr_bal is '原币贷方余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_dr_bal is '原币借方余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_carr_bal is '原币结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_cr_carr_bal is '原币贷方结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_dr_carr_bal is '原币借方结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_curr_cd is '本币币种代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_bal is '本币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_cr_bal is '本币贷方余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_dr_bal is '本币借方余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_carr_bal is '本币结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_cr_carr_bal is '本币贷方结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_dr_carr_bal is '本币借方结转余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_amt is '当日原币发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_cr_amt is '当日原币贷方发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_dr_amt is '当日原币借方发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_carr_amt is '当日原币结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_cr_carr_amt is '当日原币贷方结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_oc_dr_carr_amt is '当日原币借方结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_amt is '当日本币发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_cr_amt is '当日本币贷方发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_dr_amt is '当日本币借方发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_carr_amt is '当日本币结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_cr_carr_amt is '当日本币贷方结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_dc_dr_carr_amt is '当日本币借方结转发生额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.noth_subor_subj_flg is '无下级科目标志';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.lot is '份额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_amt_dir_cd is '当日发生额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.td_carr_amt_dir_cd is '当日结转发生额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_dr_purch_unrliz_gain is '原币借方申购未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_dr_redem_unrliz_gain is '原币借方赎回未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_cr_purch_unrliz_gain is '原币贷方申购未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.oc_cr_redem_unrliz_gain is '原币贷方赎回未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_dr_purch_unrliz_gain is '本币借方申购未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_dr_redem_unrliz_gain is '本币借方赎回未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_cr_purch_unrliz_gain is '本币贷方申购未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.dc_cr_redem_unrliz_gain is '本币贷方赎回未实现平准金';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.ear_d_oc_bal_dir_cd is '日初原币余额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.ear_d_oc_bal is '日初原币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.end_d_oc_bal_dir_cd is '日末原币余额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.end_d_oc_bal is '日末原币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.ear_d_dc_bal_dir_cd is '日初本币余额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.ear_d_dc_bal is '日初本币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.end_d_dc_bal_dir_cd is '日末本币余额方向代码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.end_d_dc_bal is '日末本币余额';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.sob_name is '账套名称';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.subj_name is '科目名称';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_prod_intnal_subj_bal.etl_timestamp is 'ETL处理时间戳';
