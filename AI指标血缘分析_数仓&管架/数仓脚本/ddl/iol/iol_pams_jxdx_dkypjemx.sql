/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dkypjemx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dkypjemx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dkypjemx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkypjemx(
    tjrq number(22) -- 数据日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,bzjje number(30,4) -- 保证金金额
    ,cdje number(30,4) -- 存单金额
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
grant select on ${iol_schema}.pams_jxdx_dkypjemx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dkypjemx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dkypjemx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dkypjemx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dkypjemx is '贷款借据押品金额明细';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.tjrq is '数据日期';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.bzjje is '保证金金额';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.cdje is '存单金额';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_dkypjemx.etl_timestamp is 'ETL处理时间戳';
