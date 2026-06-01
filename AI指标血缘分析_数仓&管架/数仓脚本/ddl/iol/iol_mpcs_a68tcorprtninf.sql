/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tcorprtninf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tcorprtninf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tcorprtninf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tcorprtninf(
    corprtnid varchar2(21) -- 企业编号
    ,corprtnnm varchar2(180) -- 企业名称
    ,corprtnadr varchar2(180) -- 企业地址
    ,lvl varchar2(2) -- 企业信用等级
    ,ctctnm varchar2(180) -- 企业联系人姓名
    ,ctcttel varchar2(45) -- 企业联系电话
    ,pstcd varchar2(9) -- 邮编
    ,email varchar2(90) -- 电子邮件地址
    ,drctandindrctflg varchar2(2) -- 直接/间接商户标志
    ,sts varchar2(3) -- 企业状态
    ,rmk varchar2(381) -- 备注/附言
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
grant select on ${iol_schema}.mpcs_a68tcorprtninf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tcorprtninf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tcorprtninf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tcorprtninf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tcorprtninf is '企业信息表';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.corprtnid is '企业编号';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.corprtnnm is '企业名称';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.corprtnadr is '企业地址';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.lvl is '企业信用等级';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.ctctnm is '企业联系人姓名';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.ctcttel is '企业联系电话';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.pstcd is '邮编';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.email is '电子邮件地址';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.drctandindrctflg is '直接/间接商户标志';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.sts is '企业状态';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.rmk is '备注/附言';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a68tcorprtninf.etl_timestamp is 'ETL处理时间戳';
