/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ftp_ratecurve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ftp_ratecurve
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ftp_ratecurve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_ratecurve(
    status varchar2(2) -- 状态0-未生效1-已生效
    ,value_date varchar2(15) -- 数据日期
    ,curve_no varchar2(96) -- 曲线编号
    ,curve_name varchar2(192) -- 曲线名称
    ,rate_1d number(12,6) -- 1日(%)
    ,rate_7d number(12,6) -- 7日(%)
    ,rate_14d number(12,6) -- 14日(%)
    ,rate_21d number(12,6) -- 21日(%)
    ,rate_1m number(12,6) -- 1月(%)
    ,rate_3m number(12,6) -- 3月(%)
    ,rate_6m number(12,6) -- 6月(%)
    ,rate_9m number(12,6) -- 9月(%)
    ,rate_1y number(12,6) -- 1年(%)
    ,update_user varchar2(96) -- 更新人
    ,effect_time varchar2(29) -- 生效时间
    ,update_user_id number(22,0) -- 更新人id
    ,current_rate number(12,6) -- 跨月活期利率
    ,notrans_current_rate number(12,6) -- 不跨月活期利率
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
grant select on ${iol_schema}.ibms_ttrd_ftp_ratecurve to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_ratecurve to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_ratecurve to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_ratecurve to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ftp_ratecurve is 'FTP率利模型';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.status is '状态0-未生效1-已生效';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.value_date is '数据日期';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.curve_no is '曲线编号';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.curve_name is '曲线名称';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_1d is '1日(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_7d is '7日(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_14d is '14日(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_21d is '21日(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_1m is '1月(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_3m is '3月(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_6m is '6月(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_9m is '9月(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.rate_1y is '1年(%)';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.update_user is '更新人';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.effect_time is '生效时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.update_user_id is '更新人id';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.current_rate is '跨月活期利率';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.notrans_current_rate is '不跨月活期利率';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_ftp_ratecurve.etl_timestamp is 'ETL处理时间戳';
