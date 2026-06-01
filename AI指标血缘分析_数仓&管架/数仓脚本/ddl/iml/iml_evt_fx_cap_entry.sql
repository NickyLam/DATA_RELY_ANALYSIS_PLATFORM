/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_fx_cap_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_fx_cap_entry
whenever sqlerror continue none;
drop table ${iml_schema}.evt_fx_cap_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fx_cap_entry(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entry_id varchar2(60) -- 分录编号
    ,bal_chg_dtl_id varchar2(60) -- 余额变动明细编号
    ,dept_id varchar2(60) -- 部门编号
    ,org_id varchar2(60) -- 机构编号
    ,rela_tran_table_name varchar2(150) -- 关联交易表名称
    ,out_acct_dt date -- 出账日期
    ,entry_def_id varchar2(60) -- 分录定义编号
    ,entry_type_cd varchar2(10) -- 分录类型代码
    ,acct_b_id varchar2(60) -- 账簿编号
    ,subj_id varchar2(1000) -- 科目编号
    ,subj_name varchar2(150) -- 科目名称
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,curr_cd varchar2(10) -- 币种代码
    ,curr_name varchar2(150) -- 币种名称
    ,in_out_tab_flg varchar2(10) -- 表内外标志
    ,offset_entry_id varchar2(60) -- 冲回分录编号
    ,amt number(30,2) -- 金额
    ,tran_id varchar2(2000) -- 交易编号
    ,strk_bal_flg varchar2(10) -- 冲账标志
    ,acctnt_evt_name varchar2(750) -- 会计事件名称
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,curr_descb varchar2(250) -- 币种描述
    ,ib_lend_type_cd varchar2(10) -- 拆借类型代码
    ,prod_type_cd varchar2(60) -- 产品类型代码
    ,bag_id varchar2(60) -- 成交编号
    ,end_day_dt date -- 日终日期
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
grant select on ${iml_schema}.evt_fx_cap_entry to ${icl_schema};
grant select on ${iml_schema}.evt_fx_cap_entry to ${idl_schema};
grant select on ${iml_schema}.evt_fx_cap_entry to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_fx_cap_entry is '外汇资金分录事件';
comment on column ${iml_schema}.evt_fx_cap_entry.evt_id is '事件编号';
comment on column ${iml_schema}.evt_fx_cap_entry.lp_id is '法人编号';
comment on column ${iml_schema}.evt_fx_cap_entry.entry_id is '分录编号';
comment on column ${iml_schema}.evt_fx_cap_entry.bal_chg_dtl_id is '余额变动明细编号';
comment on column ${iml_schema}.evt_fx_cap_entry.dept_id is '部门编号';
comment on column ${iml_schema}.evt_fx_cap_entry.org_id is '机构编号';
comment on column ${iml_schema}.evt_fx_cap_entry.rela_tran_table_name is '关联交易表名称';
comment on column ${iml_schema}.evt_fx_cap_entry.out_acct_dt is '出账日期';
comment on column ${iml_schema}.evt_fx_cap_entry.entry_def_id is '分录定义编号';
comment on column ${iml_schema}.evt_fx_cap_entry.entry_type_cd is '分录类型代码';
comment on column ${iml_schema}.evt_fx_cap_entry.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_fx_cap_entry.subj_id is '科目编号';
comment on column ${iml_schema}.evt_fx_cap_entry.subj_name is '科目名称';
comment on column ${iml_schema}.evt_fx_cap_entry.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_fx_cap_entry.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_fx_cap_entry.curr_name is '币种名称';
comment on column ${iml_schema}.evt_fx_cap_entry.in_out_tab_flg is '表内外标志';
comment on column ${iml_schema}.evt_fx_cap_entry.offset_entry_id is '冲回分录编号';
comment on column ${iml_schema}.evt_fx_cap_entry.amt is '金额';
comment on column ${iml_schema}.evt_fx_cap_entry.tran_id is '交易编号';
comment on column ${iml_schema}.evt_fx_cap_entry.strk_bal_flg is '冲账标志';
comment on column ${iml_schema}.evt_fx_cap_entry.acctnt_evt_name is '会计事件名称';
comment on column ${iml_schema}.evt_fx_cap_entry.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_fx_cap_entry.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_fx_cap_entry.curr_descb is '币种描述';
comment on column ${iml_schema}.evt_fx_cap_entry.ib_lend_type_cd is '拆借类型代码';
comment on column ${iml_schema}.evt_fx_cap_entry.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.evt_fx_cap_entry.bag_id is '成交编号';
comment on column ${iml_schema}.evt_fx_cap_entry.end_day_dt is '日终日期';
comment on column ${iml_schema}.evt_fx_cap_entry.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_fx_cap_entry.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_fx_cap_entry.job_cd is '任务编码';
comment on column ${iml_schema}.evt_fx_cap_entry.etl_timestamp is 'ETL处理时间戳';
