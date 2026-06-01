/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a02acctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a02acctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a02acctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02acctinfo(
    custno varchar2(30) -- 客户号
    ,acctno varchar2(60) -- 签约账号
    ,instno varchar2(12) -- 签约机构
    ,begindate varchar2(12) -- 募集起始日期
    ,enddate varchar2(12) -- 募集结束日期
    ,signsts varchar2(3) -- 签约状态：0-签约  1-解约
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
grant select on ${iol_schema}.mpcs_a02acctinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a02acctinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a02acctinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a02acctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a02acctinfo is '私募基金签约信息表';
comment on column ${iol_schema}.mpcs_a02acctinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a02acctinfo.acctno is '签约账号';
comment on column ${iol_schema}.mpcs_a02acctinfo.instno is '签约机构';
comment on column ${iol_schema}.mpcs_a02acctinfo.begindate is '募集起始日期';
comment on column ${iol_schema}.mpcs_a02acctinfo.enddate is '募集结束日期';
comment on column ${iol_schema}.mpcs_a02acctinfo.signsts is '签约状态：0-签约  1-解约';
comment on column ${iol_schema}.mpcs_a02acctinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a02acctinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a02acctinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a02acctinfo.etl_timestamp is 'ETL处理时间戳';
