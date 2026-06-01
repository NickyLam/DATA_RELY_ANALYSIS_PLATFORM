/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_bankbill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_bankbill
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_bankbill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_bankbill(
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
grant select on ${iol_schema}.mims_si_bankbill to ${iml_schema};
grant select on ${iol_schema}.mims_si_bankbill to ${icl_schema};
grant select on ${iol_schema}.mims_si_bankbill to ${idl_schema};
grant select on ${iol_schema}.mims_si_bankbill to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_bankbill is '银行承兑汇票';
comment on column ${iol_schema}.mims_si_bankbill.sccode is '';
comment on column ${iol_schema}.mims_si_bankbill.notecode is '';
comment on column ${iol_schema}.mims_si_bankbill.notetype is '';
comment on column ${iol_schema}.mims_si_bankbill.remitter is '';
comment on column ${iol_schema}.mims_si_bankbill.remittercode is '';
comment on column ${iol_schema}.mims_si_bankbill.remittertype is '';
comment on column ${iol_schema}.mims_si_bankbill.remitteropenacount is '';
comment on column ${iol_schema}.mims_si_bankbill.remitteraccount is '';
comment on column ${iol_schema}.mims_si_bankbill.acceptor is '';
comment on column ${iol_schema}.mims_si_bankbill.acceptortype is '';
comment on column ${iol_schema}.mims_si_bankbill.payee is '';
comment on column ${iol_schema}.mims_si_bankbill.payeetype is '';
comment on column ${iol_schema}.mims_si_bankbill.isbillbhand is '';
comment on column ${iol_schema}.mims_si_bankbill.billbhandname is '';
comment on column ${iol_schema}.mims_si_bankbill.billbhandtype is '';
comment on column ${iol_schema}.mims_si_bankbill.faceamount is '';
comment on column ${iol_schema}.mims_si_bankbill.startdate is '';
comment on column ${iol_schema}.mims_si_bankbill.enddate is '';
comment on column ${iol_schema}.mims_si_bankbill.remittercountry is '';
comment on column ${iol_schema}.mims_si_bankbill.remitterrating is '';
comment on column ${iol_schema}.mims_si_bankbill.acceptorcountry is '';
comment on column ${iol_schema}.mims_si_bankbill.acceptorrating is '';
comment on column ${iol_schema}.mims_si_bankbill.remark is '';
comment on column ${iol_schema}.mims_si_bankbill.ischecks is '';
comment on column ${iol_schema}.mims_si_bankbill.ishavecheck is '';
comment on column ${iol_schema}.mims_si_bankbill.isbankpaste is '';
comment on column ${iol_schema}.mims_si_bankbill.bankpastename is '';
comment on column ${iol_schema}.mims_si_bankbill.tdcurrency is '';
comment on column ${iol_schema}.mims_si_bankbill.acceptordepositno is '承兑人开户行行号';
comment on column ${iol_schema}.mims_si_bankbill.acceptordepositname is '承兑人开户行行名';
comment on column ${iol_schema}.mims_si_bankbill.sponsoraccount is '出质人账号';
comment on column ${iol_schema}.mims_si_bankbill.sponsordepositno is '出质人开户行行号';
comment on column ${iol_schema}.mims_si_bankbill.sponsordepositname is '出质人开户行行名';
comment on column ${iol_schema}.mims_si_bankbill.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_bankbill.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_bankbill.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_bankbill.etl_timestamp is 'ETL处理时间戳';
