/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dldxzsmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dldxzsmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dldxzsmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dldxzsmx(
    tjrq number(22) -- 统计日期
    ,sjly varchar2(45) -- 数据来源
    ,cph varchar2(150) -- 产品号
    ,khh varchar2(150) -- 客户号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jgdh varchar2(150) -- 机构代号
    ,fpjs varchar2(2) -- 分配角色
    ,zhdh varchar2(150) -- 账号代号
    ,tadm varchar2(150) -- TA代码
    ,zlbl number(19,5) -- 增量比例
    ,zs number(25,4) -- 中收
    ,cpmc varchar2(150) -- 产品名称
    ,ssjgdh varchar2(300) -- 所属机构代号
    ,sshydh varchar2(60) -- 所属员工工号
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
grant select on ${iol_schema}.pams_jxbb_dldxzsmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dldxzsmx is '绩效报表-代理代销中收明细';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.zhdh is '账号代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.tadm is 'TA代码';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.zs is '中收';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.sshydh is '所属员工工号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx.etl_timestamp is 'ETL处理时间戳';
