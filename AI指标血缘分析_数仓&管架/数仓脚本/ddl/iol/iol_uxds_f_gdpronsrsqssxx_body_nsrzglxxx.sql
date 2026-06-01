/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_nsrzglxxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,nsrzglx_dm varchar2(4000) -- 纳税人资格类型代码
    ,rdpzuuid varchar2(4000) -- 唯一主键
    ,yxqz varchar2(4000) -- 有效期止
    ,nsrzglxmc varchar2(4000) -- 纳税人资格类型名称
    ,yxqq varchar2(4000) -- 有效期起
    ,djxh varchar2(4000) -- 登记序号
    ,sjzzrq varchar2(4000) -- 数据中止日期
    ,nsrzglxxx varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx is '广东税局纳税人涉税信息纳税人资格类型登记信息';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.nsrzglx_dm is '纳税人资格类型代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.rdpzuuid is '唯一主键';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.yxqz is '有效期止';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.nsrzglxmc is '纳税人资格类型名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.yxqq is '有效期起';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.sjzzrq is '数据中止日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.nsrzglxxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_nsrzglxxx.etl_timestamp is 'ETL处理时间戳';
