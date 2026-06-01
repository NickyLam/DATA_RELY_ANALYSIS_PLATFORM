/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_enquiryrecordinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_enquiryrecordinfo
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_enquiryrecordinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_enquiryrecordinfo(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,cr_enqr_dt date -- 征信查询日期:ph010r01
    ,inst_tp varchar2(45) -- 机构类型:ph010d01
    ,cr_enqd_insid varchar2(90) -- 征信被查询机构编号:ph010q02
    ,pbc_enqr_rscd varchar2(9) -- 人行查询原因代码:ph010q03
    ,multi_tenancy_id varchar2(30) -- 多实体标识
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
grant select on ${iol_schema}.cqss_i_r_enquiryrecordinfo to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_enquiryrecordinfo to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_enquiryrecordinfo to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_enquiryrecordinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_enquiryrecordinfo is '查询记录信息';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.cr_enqr_dt is '征信查询日期:ph010r01';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.inst_tp is '机构类型:ph010d01';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.cr_enqd_insid is '征信被查询机构编号:ph010q02';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.pbc_enqr_rscd is '人行查询原因代码:ph010q03';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_enquiryrecordinfo.etl_timestamp is 'ETL处理时间戳';
