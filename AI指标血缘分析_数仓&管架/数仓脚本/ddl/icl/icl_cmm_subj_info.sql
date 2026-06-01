/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_subj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_subj_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_subj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_subj_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,subj_id varchar2(60) -- 科目编号
    ,subj_name varchar2(250) -- 科目名称
    ,super_subj_id varchar2(60) -- 上级科目编号
    ,super_subj_name varchar2(250) -- 上级科目名称
    ,subj_lev_cd varchar2(30) -- 科目级别代码
    ,subj_char_cd varchar2(10) -- 科目性质代码
    ,subj_bal_dir_cd varchar2(10) -- 科目余额方向代码
    ,subj_src_cls_cd varchar2(10) -- 科目来源分类代码
    ,trdpty_ctrl_acct_type_cd varchar2(10) -- 第三方控制账户类型代码
    ,dtl_subj_flg varchar2(10) -- 明细科目标志
    ,in_out_tab_flg varchar2(10) -- 表内外标志
    ,allow_od_flg varchar2(10) -- 允许透支标志
    ,allow_budget_flg varchar2(10) -- 允许预算标志
    ,allow_post_flg varchar2(10) -- 允许过账标志
    ,adj_flg varchar2(10) -- 调节标志
    ,subj_status_cd varchar2(10) -- 科目状态代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
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
grant select on ${icl_schema}.cmm_subj_info to ${idl_schema};
grant select on ${icl_schema}.cmm_subj_info to ${iel_schema};
grant select on ${icl_schema}.cmm_subj_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_subj_info is '科目信息';
comment on column ${icl_schema}.cmm_subj_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_subj_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_subj_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_subj_info.subj_name is '科目名称';
comment on column ${icl_schema}.cmm_subj_info.super_subj_id is '上级科目编号';
comment on column ${icl_schema}.cmm_subj_info.super_subj_name is '上级科目名称';
comment on column ${icl_schema}.cmm_subj_info.subj_lev_cd is '科目级别代码';
comment on column ${icl_schema}.cmm_subj_info.subj_char_cd is '科目性质代码';
comment on column ${icl_schema}.cmm_subj_info.subj_bal_dir_cd is '科目余额方向代码';
comment on column ${icl_schema}.cmm_subj_info.subj_src_cls_cd is '科目来源分类代码';
comment on column ${icl_schema}.cmm_subj_info.trdpty_ctrl_acct_type_cd is '第三方控制账户类型代码';
comment on column ${icl_schema}.cmm_subj_info.dtl_subj_flg is '明细科目标志';
comment on column ${icl_schema}.cmm_subj_info.in_out_tab_flg is '表内外标志';
comment on column ${icl_schema}.cmm_subj_info.allow_od_flg is '允许透支标志';
comment on column ${icl_schema}.cmm_subj_info.allow_budget_flg is '允许预算标志';
comment on column ${icl_schema}.cmm_subj_info.allow_post_flg is '允许过账标志';
comment on column ${icl_schema}.cmm_subj_info.adj_flg is '调节标志';
comment on column ${icl_schema}.cmm_subj_info.subj_status_cd is '科目状态代码';
comment on column ${icl_schema}.cmm_subj_info.effect_dt is '生效日期';
comment on column ${icl_schema}.cmm_subj_info.invalid_dt is '失效日期';
comment on column ${icl_schema}.cmm_subj_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_subj_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_subj_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_subj_info.etl_timestamp is 'ETL处理时间戳';
