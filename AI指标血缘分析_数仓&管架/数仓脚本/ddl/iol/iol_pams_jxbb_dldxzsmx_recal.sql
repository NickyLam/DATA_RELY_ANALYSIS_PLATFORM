/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dldxzsmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dldxzsmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dldxzsmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dldxzsmx_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算日期
    ,sjly varchar2(90) -- 数据来源
    ,cph varchar2(300) -- 产品编号
    ,khh varchar2(300) -- 客户号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jgdh varchar2(300) -- 机构代号
    ,fpjs varchar2(3) -- 分配角色：1-共管，2-管户
    ,zhdh varchar2(300) -- 账号ID
    ,tadm varchar2(300) -- TA代码
    ,zlbl number(19,5) -- 认领比例
    ,zs number(25,4) -- 中收
    ,cpmc varchar2(300) -- 产品名称
    ,ssjgdh varchar2(300) -- 所属机构代号
    ,sshydh varchar2(60) -- 所属行员代号
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
grant select on ${iol_schema}.pams_jxbb_dldxzsmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dldxzsmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dldxzsmx_recal is '绩效报表-代理代销中收明细_重算';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.cph is '产品编号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.fpjs is '分配角色：1-共管，2-管户';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.zhdh is '账号ID';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.tadm is 'TA代码';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.zs is '中收';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.sshydh is '所属行员代号';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dldxzsmx_recal.etl_timestamp is 'ETL处理时间戳';
