/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_kyjgx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_kyjgx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_kyjgx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_kyjgx(
    tjrq number(22) -- 数据日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,gxly varchar2(6) -- 关系来源
    ,yylsh number(22) -- 预约流水号
    ,zlbl number(19,5) -- 认领比例
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
grant select on ${iol_schema}.pams_dxgx_kyjgx to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_kyjgx is '对象关系-存款账户关系';
comment on column ${iol_schema}.pams_dxgx_kyjgx.tjrq is '数据日期';
comment on column ${iol_schema}.pams_dxgx_kyjgx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_kyjgx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_kyjgx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_kyjgx.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_kyjgx.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_kyjgx.zlbl is '认领比例';
comment on column ${iol_schema}.pams_dxgx_kyjgx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_dxgx_kyjgx.etl_timestamp is 'ETL处理时间戳';
