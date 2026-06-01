/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_wfe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_wfe
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_wfe purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_wfe(
    wfsinr varchar2(12) -- 
    ,wfssub varchar2(9) -- 
    ,srv varchar2(9) -- 
    ,sta varchar2(2) -- 
    ,rtycnt number(6,0) -- 
    ,tardattim timestamp -- 
    ,ssninr varchar2(12) -- 
    ,dattim timestamp -- 
    ,txt varchar2(275) -- 
    ,manflg varchar2(2) -- 
    ,opndur number(10,0) -- 
    ,waidur number(10,0) -- 
    ,retdur number(10,0) -- 
    ,hdldur number(10,0) -- 
    ,bchkeyinr varchar2(12) -- 
    ,txt2 varchar2(275) -- 
    ,itfinr varchar2(96) -- 
    ,coreinr varchar2(150) -- 
    ,czinr varchar2(96) -- 
    ,itfdate varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_wfe to ${iml_schema};
grant select on ${iol_schema}.isbs_wfe to ${icl_schema};
grant select on ${iol_schema}.isbs_wfe to ${idl_schema};
grant select on ${iol_schema}.isbs_wfe to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_wfe is '工作流记录';
comment on column ${iol_schema}.isbs_wfe.wfsinr is '';
comment on column ${iol_schema}.isbs_wfe.wfssub is '';
comment on column ${iol_schema}.isbs_wfe.srv is '';
comment on column ${iol_schema}.isbs_wfe.sta is '';
comment on column ${iol_schema}.isbs_wfe.rtycnt is '';
comment on column ${iol_schema}.isbs_wfe.tardattim is '';
comment on column ${iol_schema}.isbs_wfe.ssninr is '';
comment on column ${iol_schema}.isbs_wfe.dattim is '';
comment on column ${iol_schema}.isbs_wfe.txt is '';
comment on column ${iol_schema}.isbs_wfe.manflg is '';
comment on column ${iol_schema}.isbs_wfe.opndur is '';
comment on column ${iol_schema}.isbs_wfe.waidur is '';
comment on column ${iol_schema}.isbs_wfe.retdur is '';
comment on column ${iol_schema}.isbs_wfe.hdldur is '';
comment on column ${iol_schema}.isbs_wfe.bchkeyinr is '';
comment on column ${iol_schema}.isbs_wfe.txt2 is '';
comment on column ${iol_schema}.isbs_wfe.itfinr is '';
comment on column ${iol_schema}.isbs_wfe.coreinr is '';
comment on column ${iol_schema}.isbs_wfe.czinr is '';
comment on column ${iol_schema}.isbs_wfe.itfdate is '';
comment on column ${iol_schema}.isbs_wfe.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_wfe.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_wfe.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_wfe.etl_timestamp is 'ETL处理时间戳';
