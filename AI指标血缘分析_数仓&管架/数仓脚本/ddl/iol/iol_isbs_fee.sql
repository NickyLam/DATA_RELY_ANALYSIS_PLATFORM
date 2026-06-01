/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fee
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fee(
    grpcod varchar2(9) -- 
    ,etgextkey varchar2(12) -- 
    ,cod varchar2(9) -- 
    ,dscmodflg varchar2(2) -- 
    ,vatflg varchar2(2) -- 
    ,trmtyp varchar2(9) -- 
    ,dtacod varchar2(12) -- 
    ,sftcod varchar2(6) -- 
    ,staflg varchar2(2) -- 
    ,ver varchar2(6) -- 
    ,begdat date -- 
    ,reltir varchar2(9) -- 
    ,accacr varchar2(51) -- 
    ,rol varchar2(5) -- 
    ,eno varchar2(5) -- 
    ,enddat date -- 
    ,incflg varchar2(2) -- 
    ,reltrn varchar2(60) -- 
    ,acc varchar2(51) -- 
    ,inr varchar2(12) -- 
    ,feetyp varchar2(18) -- 费率类型
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
grant select on ${iol_schema}.isbs_fee to ${iml_schema};
grant select on ${iol_schema}.isbs_fee to ${icl_schema};
grant select on ${iol_schema}.isbs_fee to ${idl_schema};
grant select on ${iol_schema}.isbs_fee to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fee is '费率';
comment on column ${iol_schema}.isbs_fee.grpcod is '';
comment on column ${iol_schema}.isbs_fee.etgextkey is '';
comment on column ${iol_schema}.isbs_fee.cod is '';
comment on column ${iol_schema}.isbs_fee.dscmodflg is '';
comment on column ${iol_schema}.isbs_fee.vatflg is '';
comment on column ${iol_schema}.isbs_fee.trmtyp is '';
comment on column ${iol_schema}.isbs_fee.dtacod is '';
comment on column ${iol_schema}.isbs_fee.sftcod is '';
comment on column ${iol_schema}.isbs_fee.staflg is '';
comment on column ${iol_schema}.isbs_fee.ver is '';
comment on column ${iol_schema}.isbs_fee.begdat is '';
comment on column ${iol_schema}.isbs_fee.reltir is '';
comment on column ${iol_schema}.isbs_fee.accacr is '';
comment on column ${iol_schema}.isbs_fee.rol is '';
comment on column ${iol_schema}.isbs_fee.eno is '';
comment on column ${iol_schema}.isbs_fee.enddat is '';
comment on column ${iol_schema}.isbs_fee.incflg is '';
comment on column ${iol_schema}.isbs_fee.reltrn is '';
comment on column ${iol_schema}.isbs_fee.acc is '';
comment on column ${iol_schema}.isbs_fee.inr is '';
comment on column ${iol_schema}.isbs_fee.feetyp is '费率类型';
comment on column ${iol_schema}.isbs_fee.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fee.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fee.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fee.etl_timestamp is 'ETL处理时间戳';
