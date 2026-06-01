/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_kyjgx_new_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_kyjgx_new_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_kyjgx_new_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_kyjgx_new_recal(
    tjrq number(22) -- 数据日期
    ,recal_dt number(22) -- 重算日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,gxly varchar2(6) -- 关系来源
    ,yylsh number(20) -- 预约流水号
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
grant select on ${iol_schema}.pams_dxgx_kyjgx_new_recal to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx_new_recal to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx_new_recal to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_kyjgx_new_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_kyjgx_new_recal is '存款账户业绩关系_重算';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.tjrq is '数据日期';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_dxgx_kyjgx_new_recal.etl_timestamp is 'ETL处理时间戳';
