/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_mbvg0021v2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_mbvg0021v2
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_mbvg0021v2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_mbvg0021v2(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,response_isidnamematch varchar2(4000) -- 手机号/证件号/姓名核验匹配情况
    ,response_operator varchar2(4000) -- 运营商标识
    ,genmonth varchar2(4000) -- 生成月份
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
grant select on ${iol_schema}.uxds_f_mbvg0021v2 to ${iml_schema};
grant select on ${iol_schema}.uxds_f_mbvg0021v2 to ${icl_schema};
grant select on ${iol_schema}.uxds_f_mbvg0021v2 to ${idl_schema};
grant select on ${iol_schema}.uxds_f_mbvg0021v2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_mbvg0021v2 is '百行征信-手机三要素-响应表';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.response_isidnamematch is '手机号/证件号/姓名核验匹配情况';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.response_operator is '运营商标识';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_mbvg0021v2.etl_timestamp is 'ETL处理时间戳';
