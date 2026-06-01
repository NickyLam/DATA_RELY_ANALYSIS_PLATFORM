/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a77subacctzf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a77subacctzf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a77subacctzf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77subacctzf(
    docno varchar2(75) -- 协作编号
    ,caseno varchar2(150) -- 案件编号
    ,uniqueid varchar2(60) -- 止付唯一标志
    ,account varchar2(75) -- 主账户
    ,subsac varchar2(45) -- 子账户序号
    ,crcycd varchar2(45) -- 币种
    ,csextg varchar2(45) -- 汇钞标志
    ,suopbr varchar2(30) -- 开子户网点
    ,dataid varchar2(45) -- 核心唯一标识
    ,hostdate varchar2(12) -- 核心日期
    ,hostnbr varchar2(45) -- 核心流水
    ,hostcode varchar2(15) -- 核心返回码
    ,erortx varchar2(300) -- 错误信息
    ,status varchar2(2) -- 0-初始登记 1-止付成功 2-止付失败
    ,stoppayment varchar2(2) -- 止付类型 0-止付 1-止付解除
    ,oldseq varchar2(60) -- 原止付流水
    ,xtbz varchar2(6) -- 
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
grant select on ${iol_schema}.mpcs_a77subacctzf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a77subacctzf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a77subacctzf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a77subacctzf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a77subacctzf is '广东公安和检察院止付流水';
comment on column ${iol_schema}.mpcs_a77subacctzf.docno is '协作编号';
comment on column ${iol_schema}.mpcs_a77subacctzf.caseno is '案件编号';
comment on column ${iol_schema}.mpcs_a77subacctzf.uniqueid is '止付唯一标志';
comment on column ${iol_schema}.mpcs_a77subacctzf.account is '主账户';
comment on column ${iol_schema}.mpcs_a77subacctzf.subsac is '子账户序号';
comment on column ${iol_schema}.mpcs_a77subacctzf.crcycd is '币种';
comment on column ${iol_schema}.mpcs_a77subacctzf.csextg is '汇钞标志';
comment on column ${iol_schema}.mpcs_a77subacctzf.suopbr is '开子户网点';
comment on column ${iol_schema}.mpcs_a77subacctzf.dataid is '核心唯一标识';
comment on column ${iol_schema}.mpcs_a77subacctzf.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a77subacctzf.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a77subacctzf.hostcode is '核心返回码';
comment on column ${iol_schema}.mpcs_a77subacctzf.erortx is '错误信息';
comment on column ${iol_schema}.mpcs_a77subacctzf.status is '0-初始登记 1-止付成功 2-止付失败';
comment on column ${iol_schema}.mpcs_a77subacctzf.stoppayment is '止付类型 0-止付 1-止付解除';
comment on column ${iol_schema}.mpcs_a77subacctzf.oldseq is '原止付流水';
comment on column ${iol_schema}.mpcs_a77subacctzf.xtbz is '';
comment on column ${iol_schema}.mpcs_a77subacctzf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a77subacctzf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a77subacctzf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a77subacctzf.etl_timestamp is 'ETL处理时间戳';
