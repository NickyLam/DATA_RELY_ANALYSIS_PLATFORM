/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_bond_issuer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_bond_issuer_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_bond_issuer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_bond_issuer_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,issuer_id varchar2(60) -- 发行人编号
    ,issuer_status_cd varchar2(60) -- 发行人状态代码
    ,cn_name varchar2(150) -- 中文名称
    ,en_name varchar2(150) -- 英文名称
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
grant select on ${iml_schema}.pty_bond_issuer_info to ${icl_schema};
grant select on ${iml_schema}.pty_bond_issuer_info to ${idl_schema};
grant select on ${iml_schema}.pty_bond_issuer_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_bond_issuer_info is '债券发行人信息';
comment on column ${iml_schema}.pty_bond_issuer_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_bond_issuer_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_bond_issuer_info.issuer_id is '发行人编号';
comment on column ${iml_schema}.pty_bond_issuer_info.issuer_status_cd is '发行人状态代码';
comment on column ${iml_schema}.pty_bond_issuer_info.cn_name is '中文名称';
comment on column ${iml_schema}.pty_bond_issuer_info.en_name is '英文名称';
comment on column ${iml_schema}.pty_bond_issuer_info.create_dt is '创建日期';
comment on column ${iml_schema}.pty_bond_issuer_info.update_dt is '更新日期';
comment on column ${iml_schema}.pty_bond_issuer_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_bond_issuer_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_bond_issuer_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_bond_issuer_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_bond_issuer_info.etl_timestamp is 'ETL处理时间戳';
