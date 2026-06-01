/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_gl_mult_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_gl_mult_flow
whenever sqlerror continue none;
drop table ${iml_schema}.fin_gl_mult_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_gl_mult_flow(
    sob_id varchar2(100) -- 账套编号
    ,sys_cd varchar2(30) -- 系统代码
    ,acct_dt varchar2(100) -- 账务日期
    ,gl_org_id varchar2(100) -- 总账机构编号
    ,subj_id varchar2(100) -- 科目编号
    ,curr_cd varchar2(30) -- 币种代码
    ,gl_type_cd varchar2(30) -- 总账类型代码
    ,chn_id varchar2(100) -- 渠道编号
    ,sellbl_prod_id varchar2(100) -- 可售产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,dr_ld_bal number(30,2) -- 借方上日余额
    ,cr_ld_bal number(30,2) -- 贷方上日余额
    ,dr_td_amt number(30,2) -- 借方本日发生额
    ,dr_td_happ_cnt number(38) -- 借方本日发生笔数
    ,cr_td_amt number(30,2) -- 贷方本日发生额
    ,cr_td_happ_cnt number(38) -- 贷方本日发生笔数
    ,dr_bal number(30,2) -- 借方余额
    ,cr_bal number(30,2) -- 贷方余额
    ,curr_bal_dir_cd varchar2(30) -- 当前余额方向代码
    ,curr_bal number(30,2) -- 当前余额
    ,l_ped_bal_dir_cd varchar2(30) -- 上期余额方向代码
    ,l_ped_bal number(30,2) -- 上期余额
    ,end_level_subj_flg varchar2(10) -- 末级科目标志
    ,stand_mony_tm_bg_dr_bal number(32,2) -- 本位币期初借方余额
    ,stand_mony_tm_bg_cr_bal number(32,2) -- 本位币期初贷方余额
    ,dc_dr_amt number(30,2) -- 本币借方发生额
    ,dc_cr_amt number(30,2) -- 本币贷方发生额
    ,stand_mony_term_end_dr_bal number(32,2) -- 本位币期末借方余额
    ,stand_mony_term_end_cr_bal number(32,2) -- 本位币期末贷方余额
    ,bal_accum number(32,2) -- 余额积数
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
grant select on ${iml_schema}.fin_gl_mult_flow to ${icl_schema};
grant select on ${iml_schema}.fin_gl_mult_flow to ${idl_schema};
grant select on ${iml_schema}.fin_gl_mult_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_gl_mult_flow is '多维总账汇总';
comment on column ${iml_schema}.fin_gl_mult_flow.sob_id is '账套编号';
comment on column ${iml_schema}.fin_gl_mult_flow.sys_cd is '系统代码';
comment on column ${iml_schema}.fin_gl_mult_flow.acct_dt is '账务日期';
comment on column ${iml_schema}.fin_gl_mult_flow.gl_org_id is '总账机构编号';
comment on column ${iml_schema}.fin_gl_mult_flow.subj_id is '科目编号';
comment on column ${iml_schema}.fin_gl_mult_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.fin_gl_mult_flow.gl_type_cd is '总账类型代码';
comment on column ${iml_schema}.fin_gl_mult_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.fin_gl_mult_flow.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.fin_gl_mult_flow.lp_id is '法人编号';
comment on column ${iml_schema}.fin_gl_mult_flow.dr_ld_bal is '借方上日余额';
comment on column ${iml_schema}.fin_gl_mult_flow.cr_ld_bal is '贷方上日余额';
comment on column ${iml_schema}.fin_gl_mult_flow.dr_td_amt is '借方本日发生额';
comment on column ${iml_schema}.fin_gl_mult_flow.dr_td_happ_cnt is '借方本日发生笔数';
comment on column ${iml_schema}.fin_gl_mult_flow.cr_td_amt is '贷方本日发生额';
comment on column ${iml_schema}.fin_gl_mult_flow.cr_td_happ_cnt is '贷方本日发生笔数';
comment on column ${iml_schema}.fin_gl_mult_flow.dr_bal is '借方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.cr_bal is '贷方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.curr_bal_dir_cd is '当前余额方向代码';
comment on column ${iml_schema}.fin_gl_mult_flow.curr_bal is '当前余额';
comment on column ${iml_schema}.fin_gl_mult_flow.l_ped_bal_dir_cd is '上期余额方向代码';
comment on column ${iml_schema}.fin_gl_mult_flow.l_ped_bal is '上期余额';
comment on column ${iml_schema}.fin_gl_mult_flow.end_level_subj_flg is '末级科目标志';
comment on column ${iml_schema}.fin_gl_mult_flow.stand_mony_tm_bg_dr_bal is '本位币期初借方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.stand_mony_tm_bg_cr_bal is '本位币期初贷方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.dc_dr_amt is '本币借方发生额';
comment on column ${iml_schema}.fin_gl_mult_flow.dc_cr_amt is '本币贷方发生额';
comment on column ${iml_schema}.fin_gl_mult_flow.stand_mony_term_end_dr_bal is '本位币期末借方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.stand_mony_term_end_cr_bal is '本位币期末贷方余额';
comment on column ${iml_schema}.fin_gl_mult_flow.bal_accum is '余额积数';
comment on column ${iml_schema}.fin_gl_mult_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_gl_mult_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_gl_mult_flow.job_cd is '任务编码';
comment on column ${iml_schema}.fin_gl_mult_flow.etl_timestamp is 'ETL处理时间戳';
