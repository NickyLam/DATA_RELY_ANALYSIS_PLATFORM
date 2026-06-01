/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_ownerinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_ownerinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_ownerinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ownerinfo(
    sccode varchar2(48) -- 
    ,seqno varchar2(150) -- 
    ,owner varchar2(150) -- 
    ,ownertype varchar2(15) -- 
    ,cardtype varchar2(15) -- 
    ,cardid varchar2(60) -- 
    ,relatn varchar2(3) -- 
    ,contactnumber varchar2(30) -- 抵押人联系电话
    ,contactaddress varchar2(383) -- 抵押人联系地址
    ,protion number(5,2) -- 共有份额
    ,ownertrdptyind varchar2(2) -- 押品权属人是否第三方标志
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
grant select on ${iol_schema}.mims_si_ownerinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_ownerinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_ownerinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_ownerinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_ownerinfo is '押品所有人信息';
comment on column ${iol_schema}.mims_si_ownerinfo.sccode is '';
comment on column ${iol_schema}.mims_si_ownerinfo.seqno is '';
comment on column ${iol_schema}.mims_si_ownerinfo.owner is '';
comment on column ${iol_schema}.mims_si_ownerinfo.ownertype is '';
comment on column ${iol_schema}.mims_si_ownerinfo.cardtype is '';
comment on column ${iol_schema}.mims_si_ownerinfo.cardid is '';
comment on column ${iol_schema}.mims_si_ownerinfo.relatn is '';
comment on column ${iol_schema}.mims_si_ownerinfo.contactnumber is '抵押人联系电话';
comment on column ${iol_schema}.mims_si_ownerinfo.contactaddress is '抵押人联系地址';
comment on column ${iol_schema}.mims_si_ownerinfo.protion is '共有份额';
comment on column ${iol_schema}.mims_si_ownerinfo.ownertrdptyind is '押品权属人是否第三方标志';
comment on column ${iol_schema}.mims_si_ownerinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_ownerinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_ownerinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_ownerinfo.etl_timestamp is 'ETL处理时间戳';
