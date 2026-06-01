/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_khzshz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_khzshz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_khzshz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_khzshz(
    tjrq number(22) -- 统计日期
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,khh varchar2(45) -- 客户号
    ,kmh varchar2(30) -- 科目号
    ,cph varchar2(90) -- 标准产品号
    ,bz varchar2(15) -- 币种
    ,shje number(25,4) -- 税后金额
    ,yshje number(25,4) -- 月税后金额
    ,jshje number(25,4) -- 季税后金额
    ,nshje number(25,4) -- 年税后金额
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
grant select on ${iol_schema}.pams_nbzz_khzshz to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_khzshz is '客户中收明细账汇总';
comment on column ${iol_schema}.pams_nbzz_khzshz.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_khzshz.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_khzshz.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_khzshz.cph is '标准产品号';
comment on column ${iol_schema}.pams_nbzz_khzshz.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_khzshz.shje is '税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz.yshje is '月税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz.jshje is '季税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz.nshje is '年税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_khzshz.etl_timestamp is 'ETL处理时间戳';
