/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_fx_cap_cntpty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_fx_cap_cntpty
whenever sqlerror continue none;
drop table ${iml_schema}.pty_fx_cap_cntpty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fx_cap_cntpty(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,dept_id varchar2(60) -- 部门编号
    ,cn_name varchar2(750) -- 中文名称
    ,en_name varchar2(750) -- 英文名称
    ,cn_abbr varchar2(750) -- 中文简称
    ,en_abbr varchar2(750) -- 英文简称
    ,fx_id varchar2(60) -- 外汇编号
    ,cust_id varchar2(100) -- 客户编号
    ,cntpty_ibank_type varchar2(150) -- 交易对手同业类型
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.pty_fx_cap_cntpty to ${icl_schema};
grant select on ${iml_schema}.pty_fx_cap_cntpty to ${idl_schema};
grant select on ${iml_schema}.pty_fx_cap_cntpty to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_fx_cap_cntpty is '外汇资金交易对手';
comment on column ${iml_schema}.pty_fx_cap_cntpty.party_id is '当事人编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.lp_id is '法人编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.dept_id is '部门编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.cn_name is '中文名称';
comment on column ${iml_schema}.pty_fx_cap_cntpty.en_name is '英文名称';
comment on column ${iml_schema}.pty_fx_cap_cntpty.cn_abbr is '中文简称';
comment on column ${iml_schema}.pty_fx_cap_cntpty.en_abbr is '英文简称';
comment on column ${iml_schema}.pty_fx_cap_cntpty.fx_id is '外汇编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.cust_id is '客户编号';
comment on column ${iml_schema}.pty_fx_cap_cntpty.cntpty_ibank_type is '交易对手同业类型';
comment on column ${iml_schema}.pty_fx_cap_cntpty.create_dt is '创建日期';
comment on column ${iml_schema}.pty_fx_cap_cntpty.update_dt is '更新日期';
comment on column ${iml_schema}.pty_fx_cap_cntpty.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_fx_cap_cntpty.id_mark is '增删标志';
comment on column ${iml_schema}.pty_fx_cap_cntpty.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_fx_cap_cntpty.job_cd is '任务编码';
comment on column ${iml_schema}.pty_fx_cap_cntpty.etl_timestamp is 'ETL处理时间戳';
