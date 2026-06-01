/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_hl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_hl
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_hl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_hl(
    bz varchar2(5) -- 币种
    ,qsrq number(38,0) -- 起始日期
    ,jsrq number(38,0) -- 结束日期
    ,zrmbhl number(15,7) -- 折人民币汇率
    ,zmyhl number(15,7) -- 折美元汇率
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
grant select on ${iol_schema}.pams_csb_hl to ${iml_schema};
grant select on ${iol_schema}.pams_csb_hl to ${icl_schema};
grant select on ${iol_schema}.pams_csb_hl to ${idl_schema};
grant select on ${iol_schema}.pams_csb_hl to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_hl is '参数表-汇率';
comment on column ${iol_schema}.pams_csb_hl.bz is '币种';
comment on column ${iol_schema}.pams_csb_hl.qsrq is '起始日期';
comment on column ${iol_schema}.pams_csb_hl.jsrq is '结束日期';
comment on column ${iol_schema}.pams_csb_hl.zrmbhl is '折人民币汇率';
comment on column ${iol_schema}.pams_csb_hl.zmyhl is '折美元汇率';
comment on column ${iol_schema}.pams_csb_hl.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_hl.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_hl.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_hl.etl_timestamp is 'ETL处理时间戳';
