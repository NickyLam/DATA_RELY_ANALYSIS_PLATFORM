/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cap_acct_ety
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cap_acct_ety
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cap_acct_ety purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_acct_ety(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entry_id varchar2(60) -- 分录编号
    ,dc_flg varchar2(10) -- 本币标志
    ,dept_id varchar2(60) -- 部门编号
    ,acct_b_id varchar2(60) -- 账簿编号
    ,stl_dt date -- 结算日期
    ,in_bs_off_bs_cd varchar2(10) -- 表内表外代码
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,subj_id varchar2(100) -- 科目编号
    ,entry_amt number(30,2) -- 分录金额
    ,batch_id varchar2(60) -- 批处理编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,subj_descb varchar2(375) -- 科目描述
    ,entry_grouping_id varchar2(60) -- 分录分组编号
    ,revs_entry_id varchar2(60) -- 冲正分录编号
    ,entry_def_id varchar2(60) -- 分录定义编号
    ,strk_bal_entry_flg varchar2(10) -- 冲账分录标志
    ,bal_dtl_id varchar2(100) -- 余额明细编号
    ,curr_cd varchar2(30) -- 币种代码
    ,map_subj_id varchar2(1000) -- 映射科目编号
    ,map_subj_name varchar2(500) -- 映射科目名称
    ,subj_map_flg varchar2(10) -- 科目映射标志
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
grant select on ${iml_schema}.evt_cap_acct_ety to ${icl_schema};
grant select on ${iml_schema}.evt_cap_acct_ety to ${idl_schema};
grant select on ${iml_schema}.evt_cap_acct_ety to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cap_acct_ety is '资金会计分录事件';
comment on column ${iml_schema}.evt_cap_acct_ety.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cap_acct_ety.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cap_acct_ety.entry_id is '分录编号';
comment on column ${iml_schema}.evt_cap_acct_ety.dc_flg is '本币标志';
comment on column ${iml_schema}.evt_cap_acct_ety.dept_id is '部门编号';
comment on column ${iml_schema}.evt_cap_acct_ety.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_cap_acct_ety.stl_dt is '结算日期';
comment on column ${iml_schema}.evt_cap_acct_ety.in_bs_off_bs_cd is '表内表外代码';
comment on column ${iml_schema}.evt_cap_acct_ety.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_cap_acct_ety.subj_id is '科目编号';
comment on column ${iml_schema}.evt_cap_acct_ety.entry_amt is '分录金额';
comment on column ${iml_schema}.evt_cap_acct_ety.batch_id is '批处理编号';
comment on column ${iml_schema}.evt_cap_acct_ety.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_cap_acct_ety.subj_descb is '科目描述';
comment on column ${iml_schema}.evt_cap_acct_ety.entry_grouping_id is '分录分组编号';
comment on column ${iml_schema}.evt_cap_acct_ety.revs_entry_id is '冲正分录编号';
comment on column ${iml_schema}.evt_cap_acct_ety.entry_def_id is '分录定义编号';
comment on column ${iml_schema}.evt_cap_acct_ety.strk_bal_entry_flg is '冲账分录标志';
comment on column ${iml_schema}.evt_cap_acct_ety.bal_dtl_id is '余额明细编号';
comment on column ${iml_schema}.evt_cap_acct_ety.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_cap_acct_ety.map_subj_id is '映射科目编号';
comment on column ${iml_schema}.evt_cap_acct_ety.map_subj_name is '映射科目名称';
comment on column ${iml_schema}.evt_cap_acct_ety.subj_map_flg is '科目映射标志';
comment on column ${iml_schema}.evt_cap_acct_ety.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cap_acct_ety.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cap_acct_ety.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cap_acct_ety.etl_timestamp is 'ETL处理时间戳';
