/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0hfamrelation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0hfamrelation
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0hfamrelation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0hfamrelation(
    familyid varchar2(12) -- 家庭号
    ,memsignid varchar2(21) -- 成员签约编号
    ,custacc varchar2(60) -- 卡号
    ,custname varchar2(60) -- 持卡人姓名
    ,phonenum varchar2(23) -- 手机号
    ,cardgrade varchar2(3) -- 等级 00-普通 01-黄金 11-白金 12-钻石
    ,custno varchar2(18) -- 客户号
    ,signstate varchar2(2) -- 签约状态
    ,cardstate varchar2(2) -- 卡状态 0-正常 1-销户 2-挂失
    ,signdate varchar2(15) -- 家庭卡签约时间
    ,unsigndate varchar2(15) -- 家庭卡解约时间
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
grant select on ${iol_schema}.mpcs_a0hfamrelation to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0hfamrelation to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0hfamrelation to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0hfamrelation to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0hfamrelation is '家庭关系表';
comment on column ${iol_schema}.mpcs_a0hfamrelation.familyid is '家庭号';
comment on column ${iol_schema}.mpcs_a0hfamrelation.memsignid is '成员签约编号';
comment on column ${iol_schema}.mpcs_a0hfamrelation.custacc is '卡号';
comment on column ${iol_schema}.mpcs_a0hfamrelation.custname is '持卡人姓名';
comment on column ${iol_schema}.mpcs_a0hfamrelation.phonenum is '手机号';
comment on column ${iol_schema}.mpcs_a0hfamrelation.cardgrade is '等级 00-普通 01-黄金 11-白金 12-钻石';
comment on column ${iol_schema}.mpcs_a0hfamrelation.custno is '客户号';
comment on column ${iol_schema}.mpcs_a0hfamrelation.signstate is '签约状态';
comment on column ${iol_schema}.mpcs_a0hfamrelation.cardstate is '卡状态 0-正常 1-销户 2-挂失';
comment on column ${iol_schema}.mpcs_a0hfamrelation.signdate is '家庭卡签约时间';
comment on column ${iol_schema}.mpcs_a0hfamrelation.unsigndate is '家庭卡解约时间';
comment on column ${iol_schema}.mpcs_a0hfamrelation.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0hfamrelation.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0hfamrelation.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0hfamrelation.etl_timestamp is 'ETL处理时间戳';
