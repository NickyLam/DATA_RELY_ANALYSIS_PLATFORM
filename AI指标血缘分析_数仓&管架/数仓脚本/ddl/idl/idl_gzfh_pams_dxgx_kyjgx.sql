/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl gzfh_pams_dxgx_kyjgx
CreateDate: 20260202
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.gzfh_pams_dxgx_kyjgx purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.gzfh_pams_dxgx_kyjgx(
tjrq number(22) --数据日期
,jxdxdh number(22) --绩效对象代号
,khdxdh number(22) --考核对象代号
,fpjs varchar2(6) --分配角色
,gxly varchar2(6) --关系来源
,yylsh number(22) --预约流水号
,zlbl number(19,5) --认领比例
,jgmc varchar2(150) --机构名称
,jgdh varchar2(15) --机构代号
,kh varchar2(30) --卡号
,khh varchar2(45) --客户号
,khmc varchar2(750) --客户名称
,hymc varchar2(150) --行员名称
,hydh varchar2(18) --行员代号
,etl_dt date --ETL处理日期
,etl_timestamp timestamp(6) --ETL处理时间戳

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.gzfh_pams_dxgx_kyjgx to ${iel_schema};

-- comment
comment on table ${idl_schema}.gzfh_pams_dxgx_kyjgx is '对象关系-存款账户关系';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.tjrq is '数据日期';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.jxdxdh is '绩效对象代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.khdxdh is '考核对象代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.fpjs is '分配角色';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.gxly is '关系来源';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.yylsh is '预约流水号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.zlbl is '认领比例';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.jgmc is '机构名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.jgdh is '机构代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.kh is '卡号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.khh is '客户号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.khmc is '客户名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.hymc is '行员名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.hydh is '行员代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.gzfh_pams_dxgx_kyjgx.etl_timestamp is 'ETL处理时间戳';

