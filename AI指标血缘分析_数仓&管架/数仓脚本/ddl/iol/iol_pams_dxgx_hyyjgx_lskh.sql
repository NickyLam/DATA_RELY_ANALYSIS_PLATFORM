/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_hyyjgx_lskh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_hyyjgx_lskh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_hyyjgx_lskh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_lskh(
    tjrq number(22) -- 数据日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 行员考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,gxhslx varchar2(3) -- 关系函数类型
    ,yz number(25,4) -- 阈值
    ,clbl number(19,5) -- 存量比例
    ,zlbl number(19,5) -- 认领比例
    ,gxly varchar2(6) -- 关系来源
    ,yylsh number(22) -- 预约流水号
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
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lskh to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lskh to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lskh to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_lskh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_hyyjgx_lskh is '视图-行员业绩关系-零售客户';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.tjrq is '数据日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.khdxdh is '行员考核对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.yz is '阈值';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.clbl is '存量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.zlbl is '认领比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.gxzt is '关系状态';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_lskh.etl_timestamp is 'ETL处理时间戳';
