/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_hyyjgx_dk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_hyyjgx_dk
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_hyyjgx_dk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_dk(
    tjrq number(22) -- 数据日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,gxhslx varchar2(3) -- 关系函数类型
    ,yz number(25,4) -- 阈值
    ,clbl number(19,5) -- 存量比例
    ,gxly varchar2(6) -- 关系来源
    ,yylsh number(22) -- 预约流水号
    ,zlbl number(19,5) -- 认领比例
    ,gxzt varchar2(3) -- 关系状态
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
grant select on ${iol_schema}.pams_dxgx_hyyjgx_dk to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_dk to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_dk to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_dk to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_hyyjgx_dk is '对象关系-行员业绩关系-贷款';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.tjrq is '数据日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.yz is '阈值';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.clbl is '存量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.zlbl is '认领比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.gxzt is '关系状态';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_dk.etl_timestamp is 'ETL处理时间戳';
