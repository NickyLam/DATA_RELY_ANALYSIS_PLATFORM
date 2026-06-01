/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_crs0039t
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_crs0039t
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_crs0039t purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_crs0039t(
    sccode varchar2(32) -- 押品编号
    ,flag varchar2(2) -- 冻结标识
    ,confmamt number(20,2) -- 记账金额
    ,curreny varchar2(3) -- 币种
    ,inputorg varchar2(20) -- 记账机构
    ,datasourceflag varchar2(1) -- 系统标识
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
grant select on ${iol_schema}.mims_yp_crs0039t to ${iml_schema};
grant select on ${iol_schema}.mims_yp_crs0039t to ${icl_schema};
grant select on ${iol_schema}.mims_yp_crs0039t to ${idl_schema};
grant select on ${iol_schema}.mims_yp_crs0039t to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_crs0039t is '';
comment on column ${iol_schema}.mims_yp_crs0039t.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_crs0039t.flag is '冻结标识';
comment on column ${iol_schema}.mims_yp_crs0039t.confmamt is '记账金额';
comment on column ${iol_schema}.mims_yp_crs0039t.curreny is '币种';
comment on column ${iol_schema}.mims_yp_crs0039t.inputorg is '记账机构';
comment on column ${iol_schema}.mims_yp_crs0039t.datasourceflag is '系统标识';
comment on column ${iol_schema}.mims_yp_crs0039t.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_crs0039t.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_crs0039t.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_crs0039t.etl_timestamp is 'ETL处理时间戳';
