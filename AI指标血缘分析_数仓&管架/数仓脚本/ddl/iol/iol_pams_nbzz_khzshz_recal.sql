/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_khzshz_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_khzshz_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_khzshz_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_khzshz_recal(
    tjrq number(22) -- 统计日期
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,khh varchar2(90) -- 客户号
    ,kmh varchar2(60) -- 科目号
    ,cph varchar2(180) -- 标准产品号
    ,bz varchar2(30) -- 币种
    ,shje number(25,4) -- 税后金额
    ,yshje number(25,4) -- 月税后金额
    ,jshje number(25,4) -- 季税后金额
    ,nshje number(25,4) -- 年税后金额
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_nbzz_khzshz_recal to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz_recal to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz_recal to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_khzshz_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_khzshz_recal is '客户中收明细账汇总_重算';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.cph is '标准产品号';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.shje is '税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.yshje is '月税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.jshje is '季税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.nshje is '年税后金额';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_khzshz_recal.etl_timestamp is 'ETL处理时间戳';
