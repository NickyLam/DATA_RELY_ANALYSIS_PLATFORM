/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_gl_bal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_gl_bal
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_gl_bal purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_gl_bal(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_set_id varchar2(60) -- 账套编号
    ,acct_duran varchar2(10) -- 账务期间
    ,acct_comb_id varchar2(60) -- 账户组合编号
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,curr_cd varchar2(10) -- 币种代码
    ,org_id varchar2(60) -- 机构编号
    ,subj_id varchar2(60) -- 科目编号
    ,subj_name varchar2(100) -- 科目名称
    ,budget_subj_id varchar2(60) -- 预算科目编号
    ,subj_lev_cd varchar2(10) -- 科目级别代码
    ,subj_dir_cd varchar2(10) -- 科目方向代码
    ,subj_char_cd varchar2(10) -- 科目性质代码
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,td_bal_dir_cd varchar2(30) -- 本日余额方向代码
    ,in_out_tab_flg varchar2(10) -- 表内外标志
    ,dtl_subj_flg varchar2(10) -- 明细科目标志
    ,yd_oc_dr_bal number(30,2) -- 昨日原币借方余额
    ,yd_oc_cr_bal number(30,2) -- 昨日原币贷方余额
    ,yd_dc_dr_bal number(32,2) -- 昨日本币借方余额
    ,yd_dc_cr_bal number(32,2) -- 昨日本币贷方余额
    ,td_oc_bal number(30,2) -- 本日原币余额
    ,td_oc_dr_bal number(30,2) -- 本日原币借方余额
    ,td_oc_cr_bal number(30,2) -- 本日原币贷方余额
    ,td_dc_dr_bal number(32,2) -- 本日本币借方余额
    ,td_dc_cr_bal number(32,2) -- 本日本币贷方余额
    ,td_oc_dr_amt number(30,2) -- 本日原币借方发生额
    ,td_oc_cr_amt number(30,2) -- 本日原币贷方发生额
    ,td_dc_dr_amt number(30,2) -- 本日本币借方发生额
    ,td_dc_cr_amt number(30,2) -- 本日本币贷方发生额
    ,ten_dys_bg_dr_oc_bal number(30,2) -- 旬初借方原币余额
    ,ten_dys_bg_cr_oc_bal number(30,2) -- 旬初贷方原币余额
    ,ten_dys_bg_dr_dc_bal number(32,2) -- 旬初借方本币余额
    ,ten_dys_bg_cr_dc_bal number(32,2) -- 旬初贷方本币余额
    ,ten_dys_bg_oc_dr_amt number(30,2) -- 旬原币借方发生额
    ,ten_dys_bg_oc_cr_amt number(30,2) -- 旬原币贷方发生额
    ,ten_dys_bg_dc_dr_amt number(30,2) -- 旬本币借方发生额
    ,ten_dys_bg_dc_cr_amt number(30,2) -- 旬本币贷方发生额
    ,ear_m_dr_oc_bal number(30,2) -- 月初借方原币余额
    ,ear_m_cr_oc_bal number(30,2) -- 月初贷方原币余额
    ,ear_m_dr_dc_bal number(32,2) -- 月初借方本币余额
    ,ear_m_cr_dc_bal number(32,2) -- 月初贷方本币余额
    ,mon_oc_dr_amt number(30,2) -- 月原币借方发生额
    ,mon_oc_cr_amt number(30,2) -- 月原币贷方发生额
    ,mon_dc_dr_amt number(30,2) -- 月本币借方发生额
    ,mon_dc_cr_amt number(30,2) -- 月本币贷方发生额
    ,ear_s_dr_oc_bal number(30,2) -- 季初借方原币余额
    ,ear_s_cr_oc_bal number(30,2) -- 季初贷方原币余额
    ,ear_s_dr_dc_bal number(32,2) -- 季初借方本币余额
    ,ear_s_cr_dc_bal number(32,2) -- 季初贷方本币余额
    ,ssn_oc_dr_amt number(30,2) -- 季原币借方发生额
    ,ssn_oc_cr_amt number(30,2) -- 季原币贷方发生额
    ,ssn_dc_dr_amt number(30,2) -- 季本币借方发生额
    ,ssn_dc_cr_amt number(30,2) -- 季本币贷方发生额
    ,half_y_tm_bg_dr_oc_bal number(30,2) -- 半年期初借方原币余额
    ,half_y_tm_bg_cr_oc_bal number(30,2) -- 半年期初贷方原币余额
    ,half_y_tm_bg_dr_dc_bal number(32,2) -- 半年期初借方本币余额
    ,half_y_tm_bg_cr_dc_bal number(32,2) -- 半年期初贷方本币余额
    ,half_y_oc_dr_amt number(30,2) -- 半年原币借方发生额
    ,half_y_oc_cr_amt number(30,2) -- 半年原币贷方发生额
    ,half_y_dc_dr_amt number(30,2) -- 半年本币借方发生额
    ,half_y_dc_cr_amt number(30,2) -- 半年本币贷方发生额
    ,ear_y_dr_oc_bal number(30,2) -- 年初借方原币余额
    ,ear_y_cr_oc_bal number(30,2) -- 年初贷方原币余额
    ,ear_y_dr_dc_bal number(32,2) -- 年初借方本币余额
    ,ear_y_cr_dc_bal number(32,2) -- 年初贷方本币余额
    ,year_oc_dr_amt number(30,2) -- 年原币借方发生额
    ,year_oc_cr_amt number(30,2) -- 年原币贷方发生额
    ,year_dc_dr_amt number(30,2) -- 年本币借方发生额
    ,year_dc_cr_amt number(30,2) -- 年本币贷方发生额
    ,new_move_subj_id varchar2(60) -- 新一代迁移科目编号
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
grant select on ${icl_schema}.cmm_gl_bal to ${idl_schema};
grant select on ${icl_schema}.cmm_gl_bal to ${iel_schema};
grant select on ${icl_schema}.cmm_gl_bal to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_gl_bal is '总账余额';
comment on column ${icl_schema}.cmm_gl_bal.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_gl_bal.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_gl_bal.acct_set_id is '账套编号';
comment on column ${icl_schema}.cmm_gl_bal.acct_duran is '账务期间';
comment on column ${icl_schema}.cmm_gl_bal.acct_comb_id is '账户组合编号';
comment on column ${icl_schema}.cmm_gl_bal.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_gl_bal.tran_chn_cd is '交易渠道代码';
comment on column ${icl_schema}.cmm_gl_bal.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_gl_bal.org_id is '机构编号';
comment on column ${icl_schema}.cmm_gl_bal.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_gl_bal.subj_name is '科目名称';
comment on column ${icl_schema}.cmm_gl_bal.budget_subj_id is '预算科目编号';
comment on column ${icl_schema}.cmm_gl_bal.subj_lev_cd is '科目级别代码';
comment on column ${icl_schema}.cmm_gl_bal.subj_dir_cd is '科目方向代码';
comment on column ${icl_schema}.cmm_gl_bal.subj_char_cd is '科目性质代码';
comment on column ${icl_schema}.cmm_gl_bal.data_src_cd is '数据来源代码';
comment on column ${icl_schema}.cmm_gl_bal.td_bal_dir_cd is '本日余额方向代码';
comment on column ${icl_schema}.cmm_gl_bal.in_out_tab_flg is '表内外标志';
comment on column ${icl_schema}.cmm_gl_bal.dtl_subj_flg is '明细科目标志';
comment on column ${icl_schema}.cmm_gl_bal.yd_oc_dr_bal is '昨日原币借方余额';
comment on column ${icl_schema}.cmm_gl_bal.yd_oc_cr_bal is '昨日原币贷方余额';
comment on column ${icl_schema}.cmm_gl_bal.yd_dc_dr_bal is '昨日本币借方余额';
comment on column ${icl_schema}.cmm_gl_bal.yd_dc_cr_bal is '昨日本币贷方余额';
comment on column ${icl_schema}.cmm_gl_bal.td_oc_bal is '本日原币余额';
comment on column ${icl_schema}.cmm_gl_bal.td_oc_dr_bal is '本日原币借方余额';
comment on column ${icl_schema}.cmm_gl_bal.td_oc_cr_bal is '本日原币贷方余额';
comment on column ${icl_schema}.cmm_gl_bal.td_dc_dr_bal is '本日本币借方余额';
comment on column ${icl_schema}.cmm_gl_bal.td_dc_cr_bal is '本日本币贷方余额';
comment on column ${icl_schema}.cmm_gl_bal.td_oc_dr_amt is '本日原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.td_oc_cr_amt is '本日原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.td_dc_dr_amt is '本日本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.td_dc_cr_amt is '本日本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_dr_oc_bal is '旬初借方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_cr_oc_bal is '旬初贷方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_dr_dc_bal is '旬初借方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_cr_dc_bal is '旬初贷方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_oc_dr_amt is '旬原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_oc_cr_amt is '旬原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_dc_dr_amt is '旬本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ten_dys_bg_dc_cr_amt is '旬本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ear_m_dr_oc_bal is '月初借方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_m_cr_oc_bal is '月初贷方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_m_dr_dc_bal is '月初借方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_m_cr_dc_bal is '月初贷方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.mon_oc_dr_amt is '月原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.mon_oc_cr_amt is '月原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.mon_dc_dr_amt is '月本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.mon_dc_cr_amt is '月本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ear_s_dr_oc_bal is '季初借方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_s_cr_oc_bal is '季初贷方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_s_dr_dc_bal is '季初借方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_s_cr_dc_bal is '季初贷方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ssn_oc_dr_amt is '季原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ssn_oc_cr_amt is '季原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ssn_dc_dr_amt is '季本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ssn_dc_cr_amt is '季本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_tm_bg_dr_oc_bal is '半年期初借方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_tm_bg_cr_oc_bal is '半年期初贷方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_tm_bg_dr_dc_bal is '半年期初借方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_tm_bg_cr_dc_bal is '半年期初贷方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_oc_dr_amt is '半年原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_oc_cr_amt is '半年原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_dc_dr_amt is '半年本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.half_y_dc_cr_amt is '半年本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.ear_y_dr_oc_bal is '年初借方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_y_cr_oc_bal is '年初贷方原币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_y_dr_dc_bal is '年初借方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.ear_y_cr_dc_bal is '年初贷方本币余额';
comment on column ${icl_schema}.cmm_gl_bal.year_oc_dr_amt is '年原币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.year_oc_cr_amt is '年原币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.year_dc_dr_amt is '年本币借方发生额';
comment on column ${icl_schema}.cmm_gl_bal.year_dc_cr_amt is '年本币贷方发生额';
comment on column ${icl_schema}.cmm_gl_bal.new_move_subj_id is '新一代迁移科目编号';
comment on column ${icl_schema}.cmm_gl_bal.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_gl_bal.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_gl_bal.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_gl_bal.etl_timestamp is 'ETL处理时间戳';
