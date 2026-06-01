/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_ymhais02012
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_ymhais02012
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_ymhais02012 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_ymhais02012(
    gendate varchar2(4000) -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,channeltype varchar2(4000) -- 渠道类型
    ,mobileinnetperiodresult_itemdata varchar2(4000) -- 查询结果数据
    ,mobileinnetperiodresult_itemcode varchar2(4000) -- 查询结果代码
    ,mobileinnetperiodresult_iteminfo varchar2(4000) -- 查询结果描述
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
grant select on ${iol_schema}.uxds_f_ymhais02012 to ${iml_schema};
grant select on ${iol_schema}.uxds_f_ymhais02012 to ${icl_schema};
grant select on ${iol_schema}.uxds_f_ymhais02012 to ${idl_schema};
grant select on ${iol_schema}.uxds_f_ymhais02012 to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_ymhais02012 is '粤码核-全国运营商在网时长查询-响应表';
comment on column ${iol_schema}.uxds_f_ymhais02012.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_ymhais02012.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_ymhais02012.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_ymhais02012.channeltype is '渠道类型';
comment on column ${iol_schema}.uxds_f_ymhais02012.mobileinnetperiodresult_itemdata is '查询结果数据';
comment on column ${iol_schema}.uxds_f_ymhais02012.mobileinnetperiodresult_itemcode is '查询结果代码';
comment on column ${iol_schema}.uxds_f_ymhais02012.mobileinnetperiodresult_iteminfo is '查询结果描述';
comment on column ${iol_schema}.uxds_f_ymhais02012.genmonth is '生成月份';
comment on column ${iol_schema}.uxds_f_ymhais02012.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_ymhais02012.etl_timestamp is 'ETL处理时间戳';
