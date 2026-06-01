/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a44signcif
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a44signcif
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a44signcif purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a44signcif(
    signseqno varchar2(48) -- 
    ,trndt varchar2(12) -- 
    ,trntm varchar2(9) -- 
    ,srcsysid varchar2(30) -- 
    ,srcseqno varchar2(48) -- 
    ,idtype varchar2(3) -- 
    ,idno varchar2(48) -- 
    ,idduedt varchar2(12) -- 
    ,custname varchar2(192) -- 
    ,legalname varchar2(90) -- 
    ,legalidtype varchar2(3) -- 
    ,legalidno varchar2(48) -- 
    ,legalidduedt varchar2(12) -- 
    ,legaltel varchar2(48) -- 
    ,corpid varchar2(6) -- 
    ,regicd varchar2(48) -- 
    ,dealsp varchar2(384) -- 
    ,corppr varchar2(5) -- 
    ,corptp varchar2(9) -- 
    ,regiam varchar2(30) -- 
    ,insttype varchar2(3) -- 
    ,zipcd varchar2(9) -- 
    ,fax varchar2(48) -- 
    ,addr varchar2(384) -- 
    ,actorname varchar2(90) -- 
    ,actoridtype varchar2(3) -- 
    ,actoridno varchar2(48) -- 
    ,actoridduedt varchar2(12) -- 
    ,actortel varchar2(48) -- 
    ,actoraddr varchar2(384) -- 
    ,contactname varchar2(90) -- 
    ,contactidtype varchar2(3) -- 
    ,contactidno varchar2(48) -- 
    ,contactidduedt varchar2(12) -- 
    ,contactaddr varchar2(384) -- 
    ,mobile varchar2(48) -- 
    ,custmanagerid varchar2(45) -- 
    ,state varchar2(3) -- 
    ,custno varchar2(48) -- 
    ,acctno varchar2(90) -- 
    ,openbrcno varchar2(48) -- 
    ,openbrcname varchar2(384) -- 
    ,bstyle varchar2(2) -- 
    ,bacctno varchar2(90) -- 
    ,bacctname varchar2(192) -- 
    ,bacctbankid varchar2(48) -- 
    ,bacctbankname varchar2(384) -- 
    ,updt varchar2(12) -- 
    ,uptm varchar2(9) -- 
    ,contactzipcd varchar2(9) -- 
    ,contactfax varchar2(48) -- 
    ,cifopendt varchar2(12) -- 
    ,acopendt varchar2(12) -- 
    ,custmanagername varchar2(96) -- 
    ,tellerid varchar2(96) -- 
    ,ntusflag varchar2(2) -- 
    ,expireflag varchar2(2) -- 
    ,taxresident varchar2(2) -- 
    ,brntype varchar2(2) -- 
    ,addresstype varchar2(3) -- 
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
grant select on ${iol_schema}.mpcs_a44signcif to ${iml_schema};
grant select on ${iol_schema}.mpcs_a44signcif to ${icl_schema};
grant select on ${iol_schema}.mpcs_a44signcif to ${idl_schema};
grant select on ${iol_schema}.mpcs_a44signcif to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a44signcif is '客户签约登记表';
comment on column ${iol_schema}.mpcs_a44signcif.signseqno is '';
comment on column ${iol_schema}.mpcs_a44signcif.trndt is '';
comment on column ${iol_schema}.mpcs_a44signcif.trntm is '';
comment on column ${iol_schema}.mpcs_a44signcif.srcsysid is '';
comment on column ${iol_schema}.mpcs_a44signcif.srcseqno is '';
comment on column ${iol_schema}.mpcs_a44signcif.idtype is '';
comment on column ${iol_schema}.mpcs_a44signcif.idno is '';
comment on column ${iol_schema}.mpcs_a44signcif.idduedt is '';
comment on column ${iol_schema}.mpcs_a44signcif.custname is '';
comment on column ${iol_schema}.mpcs_a44signcif.legalname is '';
comment on column ${iol_schema}.mpcs_a44signcif.legalidtype is '';
comment on column ${iol_schema}.mpcs_a44signcif.legalidno is '';
comment on column ${iol_schema}.mpcs_a44signcif.legalidduedt is '';
comment on column ${iol_schema}.mpcs_a44signcif.legaltel is '';
comment on column ${iol_schema}.mpcs_a44signcif.corpid is '';
comment on column ${iol_schema}.mpcs_a44signcif.regicd is '';
comment on column ${iol_schema}.mpcs_a44signcif.dealsp is '';
comment on column ${iol_schema}.mpcs_a44signcif.corppr is '';
comment on column ${iol_schema}.mpcs_a44signcif.corptp is '';
comment on column ${iol_schema}.mpcs_a44signcif.regiam is '';
comment on column ${iol_schema}.mpcs_a44signcif.insttype is '';
comment on column ${iol_schema}.mpcs_a44signcif.zipcd is '';
comment on column ${iol_schema}.mpcs_a44signcif.fax is '';
comment on column ${iol_schema}.mpcs_a44signcif.addr is '';
comment on column ${iol_schema}.mpcs_a44signcif.actorname is '';
comment on column ${iol_schema}.mpcs_a44signcif.actoridtype is '';
comment on column ${iol_schema}.mpcs_a44signcif.actoridno is '';
comment on column ${iol_schema}.mpcs_a44signcif.actoridduedt is '';
comment on column ${iol_schema}.mpcs_a44signcif.actortel is '';
comment on column ${iol_schema}.mpcs_a44signcif.actoraddr is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactname is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactidtype is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactidno is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactidduedt is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactaddr is '';
comment on column ${iol_schema}.mpcs_a44signcif.mobile is '';
comment on column ${iol_schema}.mpcs_a44signcif.custmanagerid is '';
comment on column ${iol_schema}.mpcs_a44signcif.state is '';
comment on column ${iol_schema}.mpcs_a44signcif.custno is '';
comment on column ${iol_schema}.mpcs_a44signcif.acctno is '';
comment on column ${iol_schema}.mpcs_a44signcif.openbrcno is '';
comment on column ${iol_schema}.mpcs_a44signcif.openbrcname is '';
comment on column ${iol_schema}.mpcs_a44signcif.bstyle is '';
comment on column ${iol_schema}.mpcs_a44signcif.bacctno is '';
comment on column ${iol_schema}.mpcs_a44signcif.bacctname is '';
comment on column ${iol_schema}.mpcs_a44signcif.bacctbankid is '';
comment on column ${iol_schema}.mpcs_a44signcif.bacctbankname is '';
comment on column ${iol_schema}.mpcs_a44signcif.updt is '';
comment on column ${iol_schema}.mpcs_a44signcif.uptm is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactzipcd is '';
comment on column ${iol_schema}.mpcs_a44signcif.contactfax is '';
comment on column ${iol_schema}.mpcs_a44signcif.cifopendt is '';
comment on column ${iol_schema}.mpcs_a44signcif.acopendt is '';
comment on column ${iol_schema}.mpcs_a44signcif.custmanagername is '';
comment on column ${iol_schema}.mpcs_a44signcif.tellerid is '';
comment on column ${iol_schema}.mpcs_a44signcif.ntusflag is '';
comment on column ${iol_schema}.mpcs_a44signcif.expireflag is '';
comment on column ${iol_schema}.mpcs_a44signcif.taxresident is '';
comment on column ${iol_schema}.mpcs_a44signcif.brntype is '';
comment on column ${iol_schema}.mpcs_a44signcif.addresstype is '';
comment on column ${iol_schema}.mpcs_a44signcif.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a44signcif.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a44signcif.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a44signcif.etl_timestamp is 'ETL处理时间戳';
