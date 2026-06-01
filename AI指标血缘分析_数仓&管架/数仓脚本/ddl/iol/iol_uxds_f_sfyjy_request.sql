/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_sfyjy_request
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_sfyjy_request
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_sfyjy_request purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_sfyjy_request(
    gendate date -- 生成时间
    ,sequenceid varchar2(4000) -- 系统流水号
    ,name varchar2(4000) -- 姓名
    ,cert_num varchar2(4000) -- 证件号
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
grant select on ${iol_schema}.uxds_f_sfyjy_request to ${iml_schema};
grant select on ${iol_schema}.uxds_f_sfyjy_request to ${icl_schema};
grant select on ${iol_schema}.uxds_f_sfyjy_request to ${idl_schema};
grant select on ${iol_schema}.uxds_f_sfyjy_request to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_sfyjy_request is '司法研究院请求信息';
comment on column ${iol_schema}.uxds_f_sfyjy_request.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_sfyjy_request.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_sfyjy_request.name is '姓名';
comment on column ${iol_schema}.uxds_f_sfyjy_request.cert_num is '证件号';
comment on column ${iol_schema}.uxds_f_sfyjy_request.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_sfyjy_request.etl_timestamp is 'ETL处理时间戳';
