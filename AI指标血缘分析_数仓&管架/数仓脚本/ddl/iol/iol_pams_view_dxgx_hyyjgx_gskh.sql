/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_view_dxgx_hyyjgx_gskh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_view_dxgx_hyyjgx_gskh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_view_dxgx_hyyjgx_gskh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_view_dxgx_hyyjgx_gskh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,fpjs varchar2(2) -- 分配角色
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22) -- 结束日期
    ,gxhslx varchar2(1) -- 关系函数类型
    ,yz number(22) -- 阈值
    ,clbl number(22) -- 存量比例
    ,zlbl number(22) -- 分配比例
    ,gxly varchar2(2) -- 关系来源
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
grant select on ${iol_schema}.pams_view_dxgx_hyyjgx_gskh to ${iml_schema};
grant select on ${iol_schema}.pams_view_dxgx_hyyjgx_gskh to ${icl_schema};
grant select on ${iol_schema}.pams_view_dxgx_hyyjgx_gskh to ${idl_schema};
grant select on ${iol_schema}.pams_view_dxgx_hyyjgx_gskh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_view_dxgx_hyyjgx_gskh is '视图-行员业绩关系-公司客户';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.fpjs is '分配角色';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.qsrq is '起始日期';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.jsrq is '结束日期';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.yz is '阈值';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.clbl is '存量比例';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.zlbl is '分配比例';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.gxly is '关系来源';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_view_dxgx_hyyjgx_gskh.etl_timestamp is 'ETL处理时间戳';
