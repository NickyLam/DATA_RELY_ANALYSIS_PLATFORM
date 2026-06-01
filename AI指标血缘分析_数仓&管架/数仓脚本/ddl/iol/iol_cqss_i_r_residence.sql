/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_residence
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_residence
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_residence purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_residence(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,cr_rsdnc_sttn_cd varchar2(30) -- 征信居住状况代码:pb030d01
    ,cr_rsdnc_adr varchar2(450) -- 征信居住地址:pb030q01
    ,move_telno varchar2(113) -- 移动电话号码:pb030q02
    ,cr_inf_udt_dt date -- 征信信息更新日期:pb030r01
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
grant select on ${iol_schema}.cqss_i_r_residence to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_residence to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_residence to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_residence to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_residence is '二代居住信息';
comment on column ${iol_schema}.cqss_i_r_residence.id is '代码主键';
comment on column ${iol_schema}.cqss_i_r_residence.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_i_r_residence.cr_rsdnc_sttn_cd is '征信居住状况代码:pb030d01';
comment on column ${iol_schema}.cqss_i_r_residence.cr_rsdnc_adr is '征信居住地址:pb030q01';
comment on column ${iol_schema}.cqss_i_r_residence.move_telno is '移动电话号码:pb030q02';
comment on column ${iol_schema}.cqss_i_r_residence.cr_inf_udt_dt is '征信信息更新日期:pb030r01';
comment on column ${iol_schema}.cqss_i_r_residence.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_i_r_residence.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_residence.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_residence.etl_timestamp is 'ETL处理时间戳';
