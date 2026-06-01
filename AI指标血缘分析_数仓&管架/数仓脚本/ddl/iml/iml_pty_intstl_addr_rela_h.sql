/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_intstl_addr_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_intstl_addr_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_intstl_addr_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_intstl_addr_rela_h(
    rela_id varchar2(100) -- 关联编号
    ,lp_id varchar2(100) -- 法人编号
    ,party_id varchar2(100) -- 当事人编号
    ,addr_desc varchar2(150) -- 地址描述
    ,main_addr_flg varchar2(30) -- 主地址标志
    ,addr_id varchar2(100) -- 地址编号
    ,bic_code varchar2(150) -- BIC码
    ,addr_status_cd varchar2(30) -- 地址状态代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_intstl_addr_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_intstl_addr_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_intstl_addr_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_intstl_addr_rela_h is '国结当事人与地址关系历史';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.rela_id is '关联编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.addr_desc is '地址描述';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.main_addr_flg is '主地址标志';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.addr_id is '地址编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.bic_code is 'BIC码';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.addr_status_cd is '地址状态代码';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_intstl_addr_rela_h.etl_timestamp is 'ETL处理时间戳';
