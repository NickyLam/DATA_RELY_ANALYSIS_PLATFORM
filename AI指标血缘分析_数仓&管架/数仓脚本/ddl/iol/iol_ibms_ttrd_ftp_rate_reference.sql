/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ftp_rate_reference
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ftp_rate_reference
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ftp_rate_reference purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_rate_reference(
    value_date varchar2(15) -- 数据日期
    ,rate_1d number(12,6) -- SHIBOR-1D
    ,rate_7d number(12,6) -- SHIBOR-1W
    ,rate_14d number(12,6) -- SHIBOR-2W
    ,rate_1m number(12,6) -- SHIBOR-1M
    ,rate_3m number(12,6) -- 存单发行收益率-3M
    ,rate_6m number(12,6) -- 存单发行收益率-6M
    ,rate_9m number(12,6) -- 存单发行收益率-9M
    ,rate_1y number(12,6) -- 存单发行收益率-1Y
    ,rate_avg number(12,6) -- 活期利率加权平均价格上月平均价格
    ,rate_avg_d number(12,6) -- 活期利率加权平均价格每日计算结果
    ,update_time varchar2(29) -- 更新时间
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
grant select on ${iol_schema}.ibms_ttrd_ftp_rate_reference to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_rate_reference to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_rate_reference to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_rate_reference to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ftp_rate_reference is 'FTP参考利率表';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.value_date is '数据日期';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_1d is 'SHIBOR-1D';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_7d is 'SHIBOR-1W';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_14d is 'SHIBOR-2W';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_1m is 'SHIBOR-1M';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_3m is '存单发行收益率-3M';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_6m is '存单发行收益率-6M';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_9m is '存单发行收益率-9M';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_1y is '存单发行收益率-1Y';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_avg is '活期利率加权平均价格上月平均价格';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.rate_avg_d is '活期利率加权平均价格每日计算结果';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_ftp_rate_reference.etl_timestamp is 'ETL处理时间戳';
