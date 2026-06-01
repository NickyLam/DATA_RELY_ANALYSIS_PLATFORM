/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_khdx_zblb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_khdx_zblb
whenever sqlerror continue none;
drop table ${iol_schema}.pams_khdx_zblb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_zblb(
    zbdh number(22,0) -- 指标代号
    ,ywlb varchar2(3) -- 业务类别
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,sfxs varchar2(2) -- 是否显示
    ,zbzt varchar2(2) -- 指标状态
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
grant select on ${iol_schema}.pams_khdx_zblb to ${iml_schema};
grant select on ${iol_schema}.pams_khdx_zblb to ${icl_schema};
grant select on ${iol_schema}.pams_khdx_zblb to ${idl_schema};
grant select on ${iol_schema}.pams_khdx_zblb to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_khdx_zblb is '考核对象-指标类别';
comment on column ${iol_schema}.pams_khdx_zblb.zbdh is '指标代号';
comment on column ${iol_schema}.pams_khdx_zblb.ywlb is '业务类别';
comment on column ${iol_schema}.pams_khdx_zblb.qsrq is '起始日期';
comment on column ${iol_schema}.pams_khdx_zblb.jsrq is '结束日期';
comment on column ${iol_schema}.pams_khdx_zblb.sfxs is '是否显示';
comment on column ${iol_schema}.pams_khdx_zblb.zbzt is '指标状态';
comment on column ${iol_schema}.pams_khdx_zblb.start_dt is '开始时间';
comment on column ${iol_schema}.pams_khdx_zblb.end_dt is '结束时间';
comment on column ${iol_schema}.pams_khdx_zblb.id_mark is '增删标志';
comment on column ${iol_schema}.pams_khdx_zblb.etl_timestamp is 'ETL处理时间戳';
