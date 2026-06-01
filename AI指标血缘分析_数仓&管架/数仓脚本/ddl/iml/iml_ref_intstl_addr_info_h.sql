/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_intstl_addr_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_intstl_addr_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_intstl_addr_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_intstl_addr_info_h(
    addr_id varchar2(100) -- 地址编号
    ,addr_idf varchar2(45) -- 地址标识
    ,addr_desc varchar2(750) -- 地址描述
    ,advise_bank_swift_id varchar2(100) -- 通知行SWIFT编号
    ,e_mail varchar2(150) -- 电子邮箱
    ,street_addr varchar2(750) -- 街道地址
    ,zip_cd varchar2(90) -- 邮政编码
    ,cty_rg_cd varchar2(30) -- 国家代码
    ,dist_cd varchar2(60) -- 行政区划代码
    ,mailbox_num varchar2(60) -- 邮箱号码
    ,tel_num varchar2(60) -- 电话号码
    ,pbc_name varchar2(750) -- 人行名称
    ,pbc_addr varchar2(750) -- 人行地址
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_intstl_addr_info_h to ${icl_schema};
grant select on ${iml_schema}.ref_intstl_addr_info_h to ${idl_schema};
grant select on ${iml_schema}.ref_intstl_addr_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_intstl_addr_info_h is '国结地址信息历史';
comment on column ${iml_schema}.ref_intstl_addr_info_h.addr_id is '地址编号';
comment on column ${iml_schema}.ref_intstl_addr_info_h.addr_idf is '地址标识';
comment on column ${iml_schema}.ref_intstl_addr_info_h.addr_desc is '地址描述';
comment on column ${iml_schema}.ref_intstl_addr_info_h.advise_bank_swift_id is '通知行SWIFT编号';
comment on column ${iml_schema}.ref_intstl_addr_info_h.e_mail is '电子邮箱';
comment on column ${iml_schema}.ref_intstl_addr_info_h.street_addr is '街道地址';
comment on column ${iml_schema}.ref_intstl_addr_info_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.cty_rg_cd is '国家代码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.dist_cd is '行政区划代码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.mailbox_num is '邮箱号码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.tel_num is '电话号码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.pbc_name is '人行名称';
comment on column ${iml_schema}.ref_intstl_addr_info_h.pbc_addr is '人行地址';
comment on column ${iml_schema}.ref_intstl_addr_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_intstl_addr_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_intstl_addr_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_intstl_addr_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_intstl_addr_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_intstl_addr_info_h.etl_timestamp is 'ETL处理时间戳';
