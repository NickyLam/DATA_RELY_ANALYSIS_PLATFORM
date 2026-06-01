/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_financedebt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_financedebt
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_financedebt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_financedebt(
    sccode varchar2(48) -- 
    ,debtcode varchar2(45) -- 
    ,certificatecode varchar2(150) -- 
    ,debtname varchar2(150) -- 
    ,amount number(22) -- 
    ,issuercode varchar2(45) -- 
    ,issuername varchar2(150) -- 
    ,issuertype varchar2(3) -- 
    ,isborrower varchar2(3) -- 
    ,ishaveoutrating varchar2(3) -- 
    ,outratingresult varchar2(15) -- 
    ,issueroutorg varchar2(3) -- 
    ,issueroutresult varchar2(15) -- 
    ,issuercountry varchar2(45) -- 
    ,issuercountryresult varchar2(15) -- 
    ,issuerresult varchar2(15) -- 
    ,faceamount number(20,2) -- 
    ,paytype varchar2(3) -- 
    ,rate number(5,2) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,isfirst varchar2(3) -- 
    ,publishreson varchar2(3) -- 
    ,deadlinetype varchar2(3) -- 
    ,paylevel varchar2(3) -- 
    ,ismarket varchar2(3) -- 
    ,remark varchar2(4000) -- 
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
grant select on ${iol_schema}.mims_si_financedebt to ${iml_schema};
grant select on ${iol_schema}.mims_si_financedebt to ${icl_schema};
grant select on ${iol_schema}.mims_si_financedebt to ${idl_schema};
grant select on ${iol_schema}.mims_si_financedebt to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_financedebt is '金融债券';
comment on column ${iol_schema}.mims_si_financedebt.sccode is '';
comment on column ${iol_schema}.mims_si_financedebt.debtcode is '';
comment on column ${iol_schema}.mims_si_financedebt.certificatecode is '';
comment on column ${iol_schema}.mims_si_financedebt.debtname is '';
comment on column ${iol_schema}.mims_si_financedebt.amount is '';
comment on column ${iol_schema}.mims_si_financedebt.issuercode is '';
comment on column ${iol_schema}.mims_si_financedebt.issuername is '';
comment on column ${iol_schema}.mims_si_financedebt.issuertype is '';
comment on column ${iol_schema}.mims_si_financedebt.isborrower is '';
comment on column ${iol_schema}.mims_si_financedebt.ishaveoutrating is '';
comment on column ${iol_schema}.mims_si_financedebt.outratingresult is '';
comment on column ${iol_schema}.mims_si_financedebt.issueroutorg is '';
comment on column ${iol_schema}.mims_si_financedebt.issueroutresult is '';
comment on column ${iol_schema}.mims_si_financedebt.issuercountry is '';
comment on column ${iol_schema}.mims_si_financedebt.issuercountryresult is '';
comment on column ${iol_schema}.mims_si_financedebt.issuerresult is '';
comment on column ${iol_schema}.mims_si_financedebt.faceamount is '';
comment on column ${iol_schema}.mims_si_financedebt.paytype is '';
comment on column ${iol_schema}.mims_si_financedebt.rate is '';
comment on column ${iol_schema}.mims_si_financedebt.startdate is '';
comment on column ${iol_schema}.mims_si_financedebt.enddate is '';
comment on column ${iol_schema}.mims_si_financedebt.isfirst is '';
comment on column ${iol_schema}.mims_si_financedebt.publishreson is '';
comment on column ${iol_schema}.mims_si_financedebt.deadlinetype is '';
comment on column ${iol_schema}.mims_si_financedebt.paylevel is '';
comment on column ${iol_schema}.mims_si_financedebt.ismarket is '';
comment on column ${iol_schema}.mims_si_financedebt.remark is '';
comment on column ${iol_schema}.mims_si_financedebt.tdcurrency is '';
comment on column ${iol_schema}.mims_si_financedebt.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_financedebt.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_financedebt.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_financedebt.etl_timestamp is 'ETL处理时间戳';
