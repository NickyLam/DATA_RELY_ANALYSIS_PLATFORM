/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_zcfzb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_zcfzb
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_zcfzb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_zcfzb(
    id varchar2(32) -- 主键
    ,sssqq date -- 所属时间起
    ,qms_qy number(12,2) -- 期末数资产（权益）
    ,zcxmmc varchar2(100) -- 资产项目名称
    ,mc varchar2(5) -- 序号
    ,ncs_qy number(12,2) -- 年初数资产（权益）
    ,serno varchar2(32) -- 业务流水号
    ,qyxmmc varchar2(100) -- 负债和所有者权益项目名称
    ,sssqz date -- 所属时间止
    ,bblx varchar2(3) -- 版本类型
    ,sbrq date -- 申报日期
    ,qms_zc number(12,2) -- 期末数资产（资产）
    ,ncs_zc number(12,2) -- 年初数资产（资产）
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
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
grant select on ${iol_schema}.icms_sxd_company_zcfzb to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_zcfzb to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_zcfzb to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_zcfzb to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_zcfzb is '税兴贷企业资产负债表';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.sssqq is '所属时间起';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.qms_qy is '期末数资产（权益）';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.zcxmmc is '资产项目名称';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.mc is '序号';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.ncs_qy is '年初数资产（权益）';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.qyxmmc is '负债和所有者权益项目名称';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.sssqz is '所属时间止';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.bblx is '版本类型';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.sbrq is '申报日期';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.qms_zc is '期末数资产（资产）';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.ncs_zc is '年初数资产（资产）';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_zcfzb.etl_timestamp is 'ETL处理时间戳';
