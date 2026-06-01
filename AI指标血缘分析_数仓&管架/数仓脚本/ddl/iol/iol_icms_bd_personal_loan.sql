/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bd_personal_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bd_personal_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bd_personal_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_personal_loan(
    serialno varchar2(30) -- 借据编号
    ,iswhite varchar2(10) -- 是否白户
    ,balloonamortenddate date -- 气球贷摊销到期日
    ,isfarmer varchar2(2) -- 是否农户
    ,migtflag varchar2(80) -- 迁移标志
    ,indtype varchar2(9) -- 客户性质：IndType
    ,taxflg varchar2(2) -- 是否涉税：YesNo
    ,custloantype varchar2(18) -- 
    ,isagriculture varchar2(2) -- 
    ,entclaimserialno varchar2(32) -- 
    ,retailclaimserialno varchar2(32) -- 
    ,entclaimimageinfono varchar2(64) -- 
    ,indclaimimageinfono varchar2(64) -- 
    ,isbelongterm varchar2(2) -- 
    ,productchannel varchar2(20) -- 
    ,ftpapplyno varchar2(32) -- 
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
grant select on ${iol_schema}.icms_bd_personal_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bd_personal_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bd_personal_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bd_personal_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bd_personal_loan is '借据附属信息表';
comment on column ${iol_schema}.icms_bd_personal_loan.serialno is '借据编号';
comment on column ${iol_schema}.icms_bd_personal_loan.iswhite is '是否白户';
comment on column ${iol_schema}.icms_bd_personal_loan.balloonamortenddate is '气球贷摊销到期日';
comment on column ${iol_schema}.icms_bd_personal_loan.isfarmer is '是否农户';
comment on column ${iol_schema}.icms_bd_personal_loan.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_bd_personal_loan.indtype is '客户性质：IndType';
comment on column ${iol_schema}.icms_bd_personal_loan.taxflg is '是否涉税：YesNo';
comment on column ${iol_schema}.icms_bd_personal_loan.custloantype is '';
comment on column ${iol_schema}.icms_bd_personal_loan.isagriculture is '';
comment on column ${iol_schema}.icms_bd_personal_loan.entclaimserialno is '';
comment on column ${iol_schema}.icms_bd_personal_loan.retailclaimserialno is '';
comment on column ${iol_schema}.icms_bd_personal_loan.entclaimimageinfono is '';
comment on column ${iol_schema}.icms_bd_personal_loan.indclaimimageinfono is '';
comment on column ${iol_schema}.icms_bd_personal_loan.isbelongterm is '';
comment on column ${iol_schema}.icms_bd_personal_loan.productchannel is '';
comment on column ${iol_schema}.icms_bd_personal_loan.ftpapplyno is '';
comment on column ${iol_schema}.icms_bd_personal_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bd_personal_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bd_personal_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bd_personal_loan.etl_timestamp is 'ETL处理时间戳';
