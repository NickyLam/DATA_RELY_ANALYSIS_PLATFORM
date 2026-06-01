/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bill
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bill(
    sccode varchar2(48) -- 
    ,notecode varchar2(48) -- 
    ,notetype varchar2(3) -- 
    ,remitter varchar2(150) -- 
    ,remittercode varchar2(45) -- 
    ,remittertype varchar2(3) -- 
    ,remitteropenacount varchar2(45) -- 
    ,remitteraccount varchar2(90) -- 
    ,payee varchar2(150) -- 
    ,payeetype varchar2(3) -- 
    ,isbillbhand varchar2(3) -- 
    ,billbhandname varchar2(150) -- 
    ,billbhandtype varchar2(3) -- 
    ,faceamount number(20,2) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,remittercountry varchar2(45) -- 
    ,remitterrating varchar2(6) -- 
    ,remark varchar2(4000) -- 
    ,ischecks varchar2(3) -- 
    ,ishavecheck varchar2(3) -- 
    ,isbankpaste varchar2(3) -- 
    ,bankpastename varchar2(150) -- 
    ,tdcurrency varchar2(5) -- 
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
grant select on ${iol_schema}.mims_si_bill to ${iml_schema};
grant select on ${iol_schema}.mims_si_bill to ${icl_schema};
grant select on ${iol_schema}.mims_si_bill to ${idl_schema};
grant select on ${iol_schema}.mims_si_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bill is '央行票据/银行本票/银行支票/银行汇票';
comment on column ${iol_schema}.mims_si_bill.sccode is '';
comment on column ${iol_schema}.mims_si_bill.notecode is '';
comment on column ${iol_schema}.mims_si_bill.notetype is '';
comment on column ${iol_schema}.mims_si_bill.remitter is '';
comment on column ${iol_schema}.mims_si_bill.remittercode is '';
comment on column ${iol_schema}.mims_si_bill.remittertype is '';
comment on column ${iol_schema}.mims_si_bill.remitteropenacount is '';
comment on column ${iol_schema}.mims_si_bill.remitteraccount is '';
comment on column ${iol_schema}.mims_si_bill.payee is '';
comment on column ${iol_schema}.mims_si_bill.payeetype is '';
comment on column ${iol_schema}.mims_si_bill.isbillbhand is '';
comment on column ${iol_schema}.mims_si_bill.billbhandname is '';
comment on column ${iol_schema}.mims_si_bill.billbhandtype is '';
comment on column ${iol_schema}.mims_si_bill.faceamount is '';
comment on column ${iol_schema}.mims_si_bill.startdate is '';
comment on column ${iol_schema}.mims_si_bill.enddate is '';
comment on column ${iol_schema}.mims_si_bill.remittercountry is '';
comment on column ${iol_schema}.mims_si_bill.remitterrating is '';
comment on column ${iol_schema}.mims_si_bill.remark is '';
comment on column ${iol_schema}.mims_si_bill.ischecks is '';
comment on column ${iol_schema}.mims_si_bill.ishavecheck is '';
comment on column ${iol_schema}.mims_si_bill.isbankpaste is '';
comment on column ${iol_schema}.mims_si_bill.bankpastename is '';
comment on column ${iol_schema}.mims_si_bill.tdcurrency is '';
comment on column ${iol_schema}.mims_si_bill.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bill.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bill.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bill.etl_timestamp is 'ETL处理时间戳';
