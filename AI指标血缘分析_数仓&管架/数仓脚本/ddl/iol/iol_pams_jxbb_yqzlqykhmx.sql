/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_yqzlqykhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_yqzlqykhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_yqzlqykhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_yqzlqykhmx(
    tjrq number(22) -- 统计日期
    ,khh varchar2(90) -- 客户号
    ,qyqdmc varchar2(180) -- 签约渠道名称
    ,qyzh varchar2(180) -- 签约账户
    ,qyrq number(22) -- 签约日期
    ,qyjg varchar2(180) -- 签约机构
    ,qygy varchar2(180) -- 签约柜员
    ,qyzt varchar2(6) -- 签约状态:0-无效，1-有效
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
grant select on ${iol_schema}.pams_jxbb_yqzlqykhmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_yqzlqykhmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_yqzlqykhmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_yqzlqykhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_yqzlqykhmx is '绩效报表-签约银企直联明细表';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qyqdmc is '签约渠道名称';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qyzh is '签约账户';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qyrq is '签约日期';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qyjg is '签约机构';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qygy is '签约柜员';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.qyzt is '签约状态:0-无效，1-有效';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_yqzlqykhmx.etl_timestamp is 'ETL处理时间戳';
