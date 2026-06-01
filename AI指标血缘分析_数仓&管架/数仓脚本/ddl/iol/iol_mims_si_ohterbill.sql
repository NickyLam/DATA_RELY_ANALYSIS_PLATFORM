/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_ohterbill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_ohterbill
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_ohterbill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ohterbill(
    sccode varchar2(48) -- 
    ,notecode varchar2(45) -- 
    ,notetype varchar2(3) -- 
    ,remitter varchar2(45) -- 
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
grant select on ${iol_schema}.mims_si_ohterbill to ${iml_schema};
grant select on ${iol_schema}.mims_si_ohterbill to ${icl_schema};
grant select on ${iol_schema}.mims_si_ohterbill to ${idl_schema};
grant select on ${iol_schema}.mims_si_ohterbill to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_ohterbill is '其他票据';
comment on column ${iol_schema}.mims_si_ohterbill.sccode is '';
comment on column ${iol_schema}.mims_si_ohterbill.notecode is '';
comment on column ${iol_schema}.mims_si_ohterbill.notetype is '';
comment on column ${iol_schema}.mims_si_ohterbill.remitter is '';
comment on column ${iol_schema}.mims_si_ohterbill.remittercode is '';
comment on column ${iol_schema}.mims_si_ohterbill.remittertype is '';
comment on column ${iol_schema}.mims_si_ohterbill.remitteropenacount is '';
comment on column ${iol_schema}.mims_si_ohterbill.remitteraccount is '';
comment on column ${iol_schema}.mims_si_ohterbill.acceptor is '';
comment on column ${iol_schema}.mims_si_ohterbill.acceptortype is '';
comment on column ${iol_schema}.mims_si_ohterbill.payee is '';
comment on column ${iol_schema}.mims_si_ohterbill.payeetype is '';
comment on column ${iol_schema}.mims_si_ohterbill.isbillbhand is '';
comment on column ${iol_schema}.mims_si_ohterbill.billbhandname is '';
comment on column ${iol_schema}.mims_si_ohterbill.billbhandtype is '';
comment on column ${iol_schema}.mims_si_ohterbill.faceamount is '';
comment on column ${iol_schema}.mims_si_ohterbill.startdate is '';
comment on column ${iol_schema}.mims_si_ohterbill.enddate is '';
comment on column ${iol_schema}.mims_si_ohterbill.remittercountry is '';
comment on column ${iol_schema}.mims_si_ohterbill.remitterrating is '';
comment on column ${iol_schema}.mims_si_ohterbill.acceptorcountry is '';
comment on column ${iol_schema}.mims_si_ohterbill.acceptorrating is '';
comment on column ${iol_schema}.mims_si_ohterbill.remark is '';
comment on column ${iol_schema}.mims_si_ohterbill.ischecks is '';
comment on column ${iol_schema}.mims_si_ohterbill.ishavecheck is '';
comment on column ${iol_schema}.mims_si_ohterbill.isbankpaste is '';
comment on column ${iol_schema}.mims_si_ohterbill.bankpastename is '';
comment on column ${iol_schema}.mims_si_ohterbill.tdcurrency is '';
comment on column ${iol_schema}.mims_si_ohterbill.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_ohterbill.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_ohterbill.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_ohterbill.etl_timestamp is 'ETL处理时间戳';
