/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_exetrtstqutgrnchnlinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef110i01
    ,rtfd_dept_nm varchar2(360) -- 批准部门名称:ef110q01
    ,excmdt_nm varchar2(450) -- 出口商品名称:ef110q02
    ,efdt date -- 生效日期:ef110r01
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
grant select on ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf is '出入境检验检疫绿色通道信息';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.cr_inf_id is '征信信息编号:ef110i01';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.rtfd_dept_nm is '批准部门名称:ef110q01';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.excmdt_nm is '出口商品名称:ef110q02';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.efdt is '生效日期:ef110r01';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf.etl_timestamp is 'ETL处理时间戳';
