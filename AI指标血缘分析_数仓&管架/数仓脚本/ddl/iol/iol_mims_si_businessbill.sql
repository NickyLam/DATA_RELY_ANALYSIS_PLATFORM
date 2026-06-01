/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_businessbill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_businessbill
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_businessbill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_businessbill(
    sccode varchar2(48) -- 
    ,notecode varchar2(48) -- 
    ,notetype varchar2(3) -- 
    ,remitter varchar2(150) -- 
    ,remittercode varchar2(45) -- 
    ,remittertype varchar2(3) -- 
    ,remitteropenacount varchar2(45) -- 
    ,remitteraccount varchar2(90) -- 
    ,acceptor varchar2(150) -- 
    ,acceptortype varchar2(3) -- 
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
    ,acceptorcountry varchar2(45) -- 
    ,acceptorrating varchar2(3) -- 
    ,remark varchar2(4000) -- 
    ,ischecks varchar2(3) -- 
    ,ishavecheck varchar2(3) -- 
    ,isbankpaste varchar2(3) -- 
    ,bankpastename varchar2(150) -- 
    ,tdcurrency varchar2(5) -- 
    ,acceptordepositno varchar2(30) -- 承兑人开户行行号
    ,acceptordepositname varchar2(150) -- 承兑人开户行行名
    ,sponsoraccount varchar2(60) -- 出质人账号
    ,sponsordepositno varchar2(30) -- 出质人开户行行号
    ,sponsordepositname varchar2(300) -- 出质人开户行行名
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
grant select on ${iol_schema}.mims_si_businessbill to ${iml_schema};
grant select on ${iol_schema}.mims_si_businessbill to ${icl_schema};
grant select on ${iol_schema}.mims_si_businessbill to ${idl_schema};
grant select on ${iol_schema}.mims_si_businessbill to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_businessbill is '商业承兑汇票';
comment on column ${iol_schema}.mims_si_businessbill.sccode is '';
comment on column ${iol_schema}.mims_si_businessbill.notecode is '';
comment on column ${iol_schema}.mims_si_businessbill.notetype is '';
comment on column ${iol_schema}.mims_si_businessbill.remitter is '';
comment on column ${iol_schema}.mims_si_businessbill.remittercode is '';
comment on column ${iol_schema}.mims_si_businessbill.remittertype is '';
comment on column ${iol_schema}.mims_si_businessbill.remitteropenacount is '';
comment on column ${iol_schema}.mims_si_businessbill.remitteraccount is '';
comment on column ${iol_schema}.mims_si_businessbill.acceptor is '';
comment on column ${iol_schema}.mims_si_businessbill.acceptortype is '';
comment on column ${iol_schema}.mims_si_businessbill.payee is '';
comment on column ${iol_schema}.mims_si_businessbill.payeetype is '';
comment on column ${iol_schema}.mims_si_businessbill.isbillbhand is '';
comment on column ${iol_schema}.mims_si_businessbill.billbhandname is '';
comment on column ${iol_schema}.mims_si_businessbill.billbhandtype is '';
comment on column ${iol_schema}.mims_si_businessbill.faceamount is '';
comment on column ${iol_schema}.mims_si_businessbill.startdate is '';
comment on column ${iol_schema}.mims_si_businessbill.enddate is '';
comment on column ${iol_schema}.mims_si_businessbill.remittercountry is '';
comment on column ${iol_schema}.mims_si_businessbill.remitterrating is '';
comment on column ${iol_schema}.mims_si_businessbill.acceptorcountry is '';
comment on column ${iol_schema}.mims_si_businessbill.acceptorrating is '';
comment on column ${iol_schema}.mims_si_businessbill.remark is '';
comment on column ${iol_schema}.mims_si_businessbill.ischecks is '';
comment on column ${iol_schema}.mims_si_businessbill.ishavecheck is '';
comment on column ${iol_schema}.mims_si_businessbill.isbankpaste is '';
comment on column ${iol_schema}.mims_si_businessbill.bankpastename is '';
comment on column ${iol_schema}.mims_si_businessbill.tdcurrency is '';
comment on column ${iol_schema}.mims_si_businessbill.acceptordepositno is '承兑人开户行行号';
comment on column ${iol_schema}.mims_si_businessbill.acceptordepositname is '承兑人开户行行名';
comment on column ${iol_schema}.mims_si_businessbill.sponsoraccount is '出质人账号';
comment on column ${iol_schema}.mims_si_businessbill.sponsordepositno is '出质人开户行行号';
comment on column ${iol_schema}.mims_si_businessbill.sponsordepositname is '出质人开户行行名';
comment on column ${iol_schema}.mims_si_businessbill.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_businessbill.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_businessbill.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_businessbill.etl_timestamp is 'ETL处理时间戳';
