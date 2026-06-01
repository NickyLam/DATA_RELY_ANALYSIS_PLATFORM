/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_guarantee_putout_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_guarantee_putout_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_guarantee_putout_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guarantee_putout_relative(
    serialno varchar2(64) -- 流水编号
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
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
grant select on ${iol_schema}.icms_guarantee_putout_relative to ${iml_schema};
grant select on ${iol_schema}.icms_guarantee_putout_relative to ${icl_schema};
grant select on ${iol_schema}.icms_guarantee_putout_relative to ${idl_schema};
grant select on ${iol_schema}.icms_guarantee_putout_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_guarantee_putout_relative is '出账关联表';
comment on column ${iol_schema}.icms_guarantee_putout_relative.serialno is '流水编号';
comment on column ${iol_schema}.icms_guarantee_putout_relative.objecttype is '对象类型';
comment on column ${iol_schema}.icms_guarantee_putout_relative.objectno is '对象编号';
comment on column ${iol_schema}.icms_guarantee_putout_relative.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_guarantee_putout_relative.etl_timestamp is 'ETL处理时间戳';
