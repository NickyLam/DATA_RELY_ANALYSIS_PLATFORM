/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_impexpcmdtyexptchkinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef120i01
    ,rtfd_dept_nm varchar2(360) -- 批准部门名称:ef120q01
    ,exmpt_chk_cmdty_nm varchar2(450) -- 免检查商品名称(免检商品名称):ef120q02
    ,exmpt_chk_no varchar2(225) -- 免检查号(免检号):ef120i02
    ,endto_dt date -- 截至日期:ef120r02
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf is '进出口商品免检信息';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.cr_inf_id is '征信信息编号:ef120i01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.rtfd_dept_nm is '批准部门名称:ef120q01';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.exmpt_chk_cmdty_nm is '免检查商品名称(免检商品名称):ef120q02';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.exmpt_chk_no is '免检查号(免检号):ef120i02';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.endto_dt is '截至日期:ef120r02';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf.etl_timestamp is 'ETL处理时间戳';
