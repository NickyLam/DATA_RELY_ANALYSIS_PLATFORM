/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_hykh_cklr_gjyw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_hykh_cklr_gjyw
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_hykh_cklr_gjyw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_hykh_cklr_gjyw(
    tjrq number(22) -- 统计日期
    ,khdxdh number(22) -- 考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,khh varchar2(90) -- 客户号
    ,ypbzjblqj varchar2(9) -- 押品保证金比例区间
    ,bz varchar2(30) -- 币种
    ,sy number(25,4) -- 当日净收益
    ,dysy number(25,4) -- 当月收益
    ,djsy number(25,4) -- 当季收益
    ,dnsy number(25,4) -- 当年收益
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
grant select on ${iol_schema}.pams_nbzz_hykh_cklr_gjyw to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_cklr_gjyw to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_cklr_gjyw to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_hykh_cklr_gjyw to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_hykh_cklr_gjyw is '内部总账-行员考核-敞口类国际业务存款净收益';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.ypbzjblqj is '押品保证金比例区间';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.sy is '当日净收益';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.dysy is '当月收益';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.djsy is '当季收益';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.dnsy is '当年收益';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_hykh_cklr_gjyw.etl_timestamp is 'ETL处理时间戳';
