/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_col_guar_cont_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_col_guar_cont_rela
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_col_guar_cont_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_guar_cont_rela(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(60) -- 押品编号
    ,guar_cont_id varchar2(60) -- 担保合同编号
    ,col_brwer_pc_flg varchar2(10) -- 押品与借款人正相关标志
    ,guar_impt_flg varchar2(10) -- 保证落实标志
    ,guar_rela_cd varchar2(10) -- 保证相关性代码
    ,curr_cd varchar2(10) -- 币种代码
    ,guar_amt number(30,2) -- 担保金额
    ,mtg_rat number(18,6) -- 抵押率
    ,guar_form_cd varchar2(10) -- 保证担保形式代码
    ,guar_kind_cd varchar2(10) -- 保证种类代码
    ,main_col_flg varchar2(10) -- 主押品标志
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
grant select on ${icl_schema}.cmm_col_guar_cont_rela to ${idl_schema};
grant select on ${icl_schema}.cmm_col_guar_cont_rela to ${iel_schema};
grant select on ${icl_schema}.cmm_col_guar_cont_rela to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_col_guar_cont_rela is '押品与担保合同关系';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.col_id is '押品编号';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_cont_id is '担保合同编号';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.col_brwer_pc_flg is '押品与借款人正相关标志';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_impt_flg is '保证落实标志';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_rela_cd is '保证相关性代码';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_amt is '担保金额';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.mtg_rat is '抵押率';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_form_cd is '保证担保形式代码';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.guar_kind_cd is '保证种类代码';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.main_col_flg is '主押品标志';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_col_guar_cont_rela.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_col_guar_cont_rela.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_col_guar_cont_rela.etl_timestamp is 'ETL处理时间戳';
