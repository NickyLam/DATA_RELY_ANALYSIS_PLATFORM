/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_dxgx_hyyjgx_kh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_dxgx_hyyjgx_kh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_dxgx_hyyjgx_kh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_dxgx_hyyjgx_kh(
    jxdxdh number(22,0) -- 绩效对象代号
    ,khdxdh number(22,0) -- 考核对象代号
    ,fpjs varchar2(3) -- 分配角色
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,yz number(25,4) -- 阈值
    ,clbl number(19,5) -- 存量比例
    ,zlbl number(19,5) -- 增量比例
    ,gxly varchar2(3) -- 关系来源
    ,yylsh number(20,0) -- 预约流水号
    ,gxzt varchar2(2) -- 关系状态
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
grant select on ${iol_schema}.pams_dxgx_hyyjgx_kh to ${iml_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_kh to ${icl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_kh to ${idl_schema};
grant select on ${iol_schema}.pams_dxgx_hyyjgx_kh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_dxgx_hyyjgx_kh is '对象关系-行员业绩关系-客户';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.fpjs is '分配角色';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.qsrq is '起始日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.jsrq is '结束日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.yz is '阈值';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.clbl is '存量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.zlbl is '增量比例';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.gxly is '关系来源';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.yylsh is '预约流水号';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.gxzt is '关系状态';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_dxgx_hyyjgx_kh.etl_timestamp is 'ETL处理时间戳';
