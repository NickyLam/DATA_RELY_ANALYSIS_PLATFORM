/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_guarantee_guarantor_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three(
    datadt varchar2(10) -- 数据日期
    ,guarcontractno varchar2(64) -- 担保合同编号
    ,guarantorcustid varchar2(32) -- 保证人客户号
    ,orgid varchar2(20) -- 机构号
    ,guarantortype varchar2(10) -- 保证人客户类型
    ,guarantorname varchar2(80) -- 保证人名称
    ,guarantoridtype varchar2(32) -- 保证人证件类型
    ,guarantoridno varchar2(40) -- 保证人证件号码
    ,guarantyvalue number(22,4) -- 保证总金额
    ,merchantid varchar2(32) -- 单位ID
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
grant select on ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three is '保证人信息报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.datadt is '数据日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarcontractno is '担保合同编号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantorcustid is '保证人客户号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantortype is '保证人客户类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantorname is '保证人名称';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantoridtype is '保证人证件类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantoridno is '保证人证件号码';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.guarantyvalue is '保证总金额';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.merchantid is '单位ID';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_guarantor_rep_three.etl_timestamp is 'ETL处理时间戳';
