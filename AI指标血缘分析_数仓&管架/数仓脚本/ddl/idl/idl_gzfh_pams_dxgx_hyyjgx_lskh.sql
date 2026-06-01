/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl gzfh_pams_dxgx_hyyjgx_lskh
CreateDate: 20260202
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh(
tjrq number(22) --数据日期
,jxdxdh number(22) --绩效对象代号
,khdxdh number(22) --行员考核对象代号
,fpjs varchar2(6) --分配角色
,gxhslx varchar2(3) --关系函数类型
,yz number(25,4) --阈值
,clbl number(19,5) --存量比例
,zlbl number(19,5) --认领比例
,gxly varchar2(6) --关系来源
,yylsh number(22) --预约流水号
,gxzt varchar2(3) --关系状态
,jgmc varchar2(150) --机构名称
,jgdh varchar2(15) --机构代号
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
grant select on ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh to ${iel_schema};

-- comment
comment on table ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh is '对象关系-行员业绩关系-零售客户';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.tjrq is '数据日期';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.jxdxdh is '绩效对象代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.khdxdh is '行员考核对象代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.fpjs is '分配角色';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.gxhslx is '关系函数类型';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.yz is '阈值';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.clbl is '存量比例';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.zlbl is '认领比例';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.gxly is '关系来源';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.yylsh is '预约流水号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.gxzt is '关系状态';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.jgmc is '机构名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.jgdh is '机构代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.khh is '客户号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.khmc is '客户名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.hymc is '行员名称';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.hydh is '行员代号';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.gzfh_pams_dxgx_hyyjgx_lskh.etl_timestamp is 'ETL处理时间戳';

