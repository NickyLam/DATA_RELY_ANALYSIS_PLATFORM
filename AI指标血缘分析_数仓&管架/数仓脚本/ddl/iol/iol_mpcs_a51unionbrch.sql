/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51unionbrch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51unionbrch
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51unionbrch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51unionbrch(
    brchbrno varchar2(21) -- 银联机构号
    ,brchbrna varchar2(150) -- 机构名称
    ,status varchar2(2) -- 标志：0-总行；1-分行；
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
grant select on ${iol_schema}.mpcs_a51unionbrch to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51unionbrch to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51unionbrch to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51unionbrch to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51unionbrch is '银联机构表';
comment on column ${iol_schema}.mpcs_a51unionbrch.brchbrno is '银联机构号';
comment on column ${iol_schema}.mpcs_a51unionbrch.brchbrna is '机构名称';
comment on column ${iol_schema}.mpcs_a51unionbrch.status is '标志：0-总行；1-分行；';
comment on column ${iol_schema}.mpcs_a51unionbrch.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a51unionbrch.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a51unionbrch.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a51unionbrch.etl_timestamp is 'ETL处理时间戳';
