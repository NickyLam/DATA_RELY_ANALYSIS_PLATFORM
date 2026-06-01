/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intstl_party_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intstl_party_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intstl_party_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_party_rela_h(
    rela_id varchar2(100) -- 关系编号
    ,lp_id varchar2(60) -- 法人编号
    ,agt_id varchar2(250) -- 协议编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,agt_type_cd varchar2(30) -- 协议类型代码
    ,bus_table_name varchar2(150) -- 业务表名称
    ,role_type_cd varchar2(30) -- 角色类型代码
    ,party_addr_rela_id varchar2(60) -- 当事人地址关系编号
    ,party_id varchar2(100) -- 当事人编号
    ,addr_keyw varchar2(150) -- 地址关键字
    ,addr_desc varchar2(375) -- 地址描述
    ,addr_ref_descb varchar2(375) -- 地址参考描述
    ,party_name varchar2(150) -- 当事人名称
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
grant select on ${iml_schema}.agt_intstl_party_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_intstl_party_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_intstl_party_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intstl_party_rela_h is '国结业务当事人关系历史';
comment on column ${iml_schema}.agt_intstl_party_rela_h.rela_id is '关系编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.agt_type_cd is '协议类型代码';
comment on column ${iml_schema}.agt_intstl_party_rela_h.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_intstl_party_rela_h.role_type_cd is '角色类型代码';
comment on column ${iml_schema}.agt_intstl_party_rela_h.party_addr_rela_id is '当事人地址关系编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.party_id is '当事人编号';
comment on column ${iml_schema}.agt_intstl_party_rela_h.addr_keyw is '地址关键字';
comment on column ${iml_schema}.agt_intstl_party_rela_h.addr_desc is '地址描述';
comment on column ${iml_schema}.agt_intstl_party_rela_h.addr_ref_descb is '地址参考描述';
comment on column ${iml_schema}.agt_intstl_party_rela_h.party_name is '当事人名称';
comment on column ${iml_schema}.agt_intstl_party_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_intstl_party_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_intstl_party_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intstl_party_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intstl_party_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intstl_party_rela_h.etl_timestamp is 'ETL处理时间戳';
