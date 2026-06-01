/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_fix_schd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_fix_schd
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_fix_schd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_fix_schd(
    security_code varchar2(24) -- 债券代码
    ,seq number(5,0) -- 序号
    ,start_date varchar2(12) -- 起始日期
    ,end_date varchar2(12) -- 到期日期
    ,fixing_date varchar2(12) -- 重定价日期
    ,fixing_rate number(24,12) -- 重定价利率
    ,modify_date date -- 修改日期
    ,modify_user number(5,0) -- 修改人ID
    ,spread number(13,10) -- 点差
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
grant select on ${iol_schema}.ctms_tbs_v_security_fix_schd to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_fix_schd to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_fix_schd to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_fix_schd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_fix_schd is '利率重定价';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.seq is '序号';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.start_date is '起始日期';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.end_date is '到期日期';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.fixing_date is '重定价日期';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.fixing_rate is '重定价利率';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.modify_date is '修改日期';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.modify_user is '修改人ID';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.spread is '点差';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_v_security_fix_schd.etl_timestamp is 'ETL处理时间戳';
