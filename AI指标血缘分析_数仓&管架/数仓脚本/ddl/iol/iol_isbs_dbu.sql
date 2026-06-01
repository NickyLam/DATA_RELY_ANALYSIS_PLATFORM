/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbu
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbu(
    inr varchar2(12) -- 
    ,dbusta varchar2(2) -- 
    ,extkey varchar2(36) -- 
    ,ver varchar2(6) -- 
    ,custcode varchar2(27) -- 
    ,custname varchar2(192) -- 
    ,areacode varchar2(9) -- 
    ,custaddr varchar2(390) -- 
    ,postcode varchar2(9) -- 
    ,industrycode varchar2(6) -- 
    ,attrcode varchar2(5) -- 
    ,countrycode varchar2(5) -- 
    ,istaxfree varchar2(2) -- 
    ,taxfreecode varchar2(3) -- 
    ,invcountry varchar2(600) -- 
    ,email varchar2(192) -- 
    ,rptmethod varchar2(2) -- 
    ,ecexaddr varchar2(192) -- 
    ,remarks varchar2(192) -- 
    ,moddat date -- 
    ,snddat date -- 
    ,bankinfos varchar2(1515) -- 
    ,shortname varchar2(195) -- 
    ,customerengname varchar2(390) -- 
    ,regdate date -- 
    ,corlmt varchar2(195) -- 
    ,corscope varchar2(195) -- 
    ,incorporator varchar2(45) -- 
    ,incorporatoridcode varchar2(27) -- 
    ,custcontact varchar2(195) -- 
    ,custtel varchar2(195) -- 
    ,custfax varchar2(195) -- 
    ,orgtype varchar2(2) -- 
    ,customno varchar2(30) -- 
    ,creditcode varchar2(27) -- 
    ,leicode varchar2(48) -- 
    ,swiftcode varchar2(30) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_dbu to ${iml_schema};
grant select on ${iol_schema}.isbs_dbu to ${icl_schema};
grant select on ${iol_schema}.isbs_dbu to ${idl_schema};
grant select on ${iol_schema}.isbs_dbu to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbu is '单位基本情况表';
comment on column ${iol_schema}.isbs_dbu.inr is '';
comment on column ${iol_schema}.isbs_dbu.dbusta is '';
comment on column ${iol_schema}.isbs_dbu.extkey is '';
comment on column ${iol_schema}.isbs_dbu.ver is '';
comment on column ${iol_schema}.isbs_dbu.custcode is '';
comment on column ${iol_schema}.isbs_dbu.custname is '';
comment on column ${iol_schema}.isbs_dbu.areacode is '';
comment on column ${iol_schema}.isbs_dbu.custaddr is '';
comment on column ${iol_schema}.isbs_dbu.postcode is '';
comment on column ${iol_schema}.isbs_dbu.industrycode is '';
comment on column ${iol_schema}.isbs_dbu.attrcode is '';
comment on column ${iol_schema}.isbs_dbu.countrycode is '';
comment on column ${iol_schema}.isbs_dbu.istaxfree is '';
comment on column ${iol_schema}.isbs_dbu.taxfreecode is '';
comment on column ${iol_schema}.isbs_dbu.invcountry is '';
comment on column ${iol_schema}.isbs_dbu.email is '';
comment on column ${iol_schema}.isbs_dbu.rptmethod is '';
comment on column ${iol_schema}.isbs_dbu.ecexaddr is '';
comment on column ${iol_schema}.isbs_dbu.remarks is '';
comment on column ${iol_schema}.isbs_dbu.moddat is '';
comment on column ${iol_schema}.isbs_dbu.snddat is '';
comment on column ${iol_schema}.isbs_dbu.bankinfos is '';
comment on column ${iol_schema}.isbs_dbu.shortname is '';
comment on column ${iol_schema}.isbs_dbu.customerengname is '';
comment on column ${iol_schema}.isbs_dbu.regdate is '';
comment on column ${iol_schema}.isbs_dbu.corlmt is '';
comment on column ${iol_schema}.isbs_dbu.corscope is '';
comment on column ${iol_schema}.isbs_dbu.incorporator is '';
comment on column ${iol_schema}.isbs_dbu.incorporatoridcode is '';
comment on column ${iol_schema}.isbs_dbu.custcontact is '';
comment on column ${iol_schema}.isbs_dbu.custtel is '';
comment on column ${iol_schema}.isbs_dbu.custfax is '';
comment on column ${iol_schema}.isbs_dbu.orgtype is '';
comment on column ${iol_schema}.isbs_dbu.customno is '';
comment on column ${iol_schema}.isbs_dbu.creditcode is '';
comment on column ${iol_schema}.isbs_dbu.leicode is '';
comment on column ${iol_schema}.isbs_dbu.swiftcode is '';
comment on column ${iol_schema}.isbs_dbu.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_dbu.etl_timestamp is 'ETL处理时间戳';
