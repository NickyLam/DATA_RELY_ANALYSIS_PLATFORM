/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_ownptntsttninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_ownptntsttninf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_ownptntsttninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_ownptntsttninf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_inf_id varchar2(9) -- 征信信息编号:ef100i01
    ,ptnt_nm varchar2(450) -- 专利名称:ef100q01
    ,ptnt_no varchar2(450) -- 专利号:ef100i02
    ,aply_dt date -- 申请日期:ef100r01
    ,awrd_dt date -- 授予日期:ef100r02
    ,ptnt_avldt number(22) -- 专利有效期:ef100s01
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
grant select on ${iol_schema}.cqss_e_r_ownptntsttninf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_ownptntsttninf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_ownptntsttninf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_ownptntsttninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_ownptntsttninf is '拥有专利情况信息';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.cr_inf_id is '征信信息编号:ef100i01';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.ptnt_nm is '专利名称:ef100q01';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.ptnt_no is '专利号:ef100i02';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.aply_dt is '申请日期:ef100r01';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.awrd_dt is '授予日期:ef100r02';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.ptnt_avldt is '专利有效期:ef100s01';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_ownptntsttninf.etl_timestamp is 'ETL处理时间戳';
