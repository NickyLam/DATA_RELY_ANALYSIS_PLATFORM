/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_maincmpsstffinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_maincmpsstffinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_maincmpsstffinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_maincmpsstffinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,main_cmps_stff_nm varchar2(135) -- 主要组成人员姓名:ec030q01
    ,pbc_tngncr_pts_tpcd varchar2(11) -- 人行二代证件类型代码(证件类型）:ec030d01
    ,maincmps_stff_crdt_no varchar2(90) -- 主要组成人员证件号码:ec030i01
    ,main_cmps_stff_pstn varchar2(2) -- 主要组成人员职位:ec030d02
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
grant select on ${iol_schema}.cqss_e_r_maincmpsstffinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_maincmpsstffinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_maincmpsstffinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_maincmpsstffinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_maincmpsstffinf is '主要组成人员信息';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.main_cmps_stff_nm is '主要组成人员姓名:ec030q01';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.pbc_tngncr_pts_tpcd is '人行二代证件类型代码(证件类型）:ec030d01';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.maincmps_stff_crdt_no is '主要组成人员证件号码:ec030i01';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.main_cmps_stff_pstn is '主要组成人员职位:ec030d02';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_maincmpsstffinf.etl_timestamp is 'ETL处理时间戳';
