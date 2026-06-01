/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_creditstru_distribution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_creditstru_distribution
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_creditstru_distribution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_creditstru_distribution(
    inputdate timestamp -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 最后更新机构
    ,season number(38) -- 数据季度
    ,updatedate timestamp -- 最后更新日期
    ,pledgeloan number(24,6) -- 质押贷款
    ,inputuserid varchar2(64) -- 登记人
    ,year number(38) -- 数据年份
    ,guaranteedloan number(24,6) -- 担保贷款
    ,creditloan number(24,6) -- 信用贷款
    ,updateuserid varchar2(64) -- 最后更新人
    ,mortgageloan number(24,6) -- 抵押贷款
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
grant select on ${iol_schema}.icms_cl_creditstru_distribution to ${iml_schema};
grant select on ${iol_schema}.icms_cl_creditstru_distribution to ${icl_schema};
grant select on ${iol_schema}.icms_cl_creditstru_distribution to ${idl_schema};
grant select on ${iol_schema}.icms_cl_creditstru_distribution to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_creditstru_distribution is '信用结构额度分布';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.season is '数据季度';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.pledgeloan is '质押贷款';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.year is '数据年份';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.guaranteedloan is '担保贷款';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.creditloan is '信用贷款';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.mortgageloan is '抵押贷款';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_creditstru_distribution.etl_timestamp is 'ETL处理时间戳';
