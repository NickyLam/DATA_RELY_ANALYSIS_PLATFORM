/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_qybgdjxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_qybgdjxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_qybgdjxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_qybgdjxx(
    id varchar2(32) -- 主键
    ,serno varchar2(32) -- 业务流水号
    ,migtflag varchar2(80) -- 
    ,bgrq varchar2(10) -- 变更日期
    ,bghnr varchar2(4000) -- 变更后内容
    ,bgxm varchar2(200) -- 变更项目
    ,bgqnr varchar2(4000) -- 变更前内容
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_sxd_company_qybgdjxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_qybgdjxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_qybgdjxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_qybgdjxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_qybgdjxx is '税兴贷企业变更表';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.migtflag is '';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.bgrq is '变更日期';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.bghnr is '变更后内容';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.bgxm is '变更项目';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.bgqnr is '变更前内容';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_qybgdjxx.etl_timestamp is 'ETL处理时间戳';
