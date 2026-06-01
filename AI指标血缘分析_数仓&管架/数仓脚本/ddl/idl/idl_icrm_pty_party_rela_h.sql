/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_pty_party_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_pty_party_rela_h
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_pty_party_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_pty_party_rela_h(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,party_rela_type_cd varchar2(10) -- 当事人关系类型代码
    ,seq_num varchar2(60) -- 序号
    ,rela_party_id varchar2(60) -- 关联当事人编号
    ,valid_flg varchar2(10) -- 有效标志
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_pty_party_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_pty_party_rela_h is '当事人关系历史';
comment on column ${idl_schema}.icrm_pty_party_rela_h.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_pty_party_rela_h.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_pty_party_rela_h.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_pty_party_rela_h.party_rela_type_cd is '当事人关系类型代码';
comment on column ${idl_schema}.icrm_pty_party_rela_h.seq_num is '序号';
comment on column ${idl_schema}.icrm_pty_party_rela_h.rela_party_id is '关联当事人编号';
comment on column ${idl_schema}.icrm_pty_party_rela_h.valid_flg is '有效标志';
comment on column ${idl_schema}.icrm_pty_party_rela_h.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_pty_party_rela_h.etl_timestamp is '数据处理时间';
