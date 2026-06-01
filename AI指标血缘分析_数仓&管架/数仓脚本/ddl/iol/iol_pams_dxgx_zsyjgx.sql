/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_zsyjgx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_zsyjgx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_zsyjgx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_zsyjgx(
    jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,zlbl number(19,5) -- 增量比例
    ,gxly varchar2(3) -- 关系来源
    ,gxhslx varchar2(3) -- 关系函数类型
    ,fpjs varchar2(3) -- 分配角色
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_dxgx_zsyjgx to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_zsyjgx to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_zsyjgx to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_zsyjgx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_zsyjgx is '对象关系_中间业务收入';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.qsrq is '起始日期';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.jsrq is '结束日期';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_dxgx_zsyjgx.etl_timestamp is 'ETL处理时间戳';
