/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fxd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fxd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fxd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fxd(
    posrtndat date -- 
    ,ctycod varchar2(9) -- 
    ,acc varchar2(32) -- 
    ,apvnum varchar2(45) -- 
    ,setdat date -- 
    ,quoref varchar2(24) -- 
    ,branchinr varchar2(12) -- 
    ,bgnref varchar2(45) -- 
    ,ver varchar2(6) -- 
    ,midrat number(12,6) -- 
    ,ownref varchar2(24) -- 
    ,dsp varchar2(3) -- 
    ,zjtyp varchar2(3) -- 
    ,inr varchar2(12) -- 
    ,rat number(16,10) -- 
    ,clsdat date -- 
    ,setdatfrm date -- 
    ,txcod varchar2(9) -- 
    ,bchkeyinr varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,trnmod varchar2(5) -- 
    ,usr varchar2(12) -- 
    ,acc2 varchar2(32) -- 
    ,trdout varchar2(5) -- 
    ,setdatto date -- 
    ,cnfdat date -- 
    ,trnman varchar2(3) -- 
    ,valdat date -- 
    ,dsp2 varchar2(3) -- 
    ,opndat date -- 
    ,fudref varchar2(24) -- 
    ,fxtyp varchar2(3) -- 
    ,trdint varchar2(5) -- 
    ,ownusr varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_fxd to ${iml_schema};
grant select on ${iol_schema}.isbs_fxd to ${icl_schema};
grant select on ${iol_schema}.isbs_fxd to ${idl_schema};
grant select on ${iol_schema}.isbs_fxd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fxd is '外汇买卖及平盘业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_fxd.posrtndat is '';
comment on column ${iol_schema}.isbs_fxd.ctycod is '';
comment on column ${iol_schema}.isbs_fxd.acc is '';
comment on column ${iol_schema}.isbs_fxd.apvnum is '';
comment on column ${iol_schema}.isbs_fxd.setdat is '';
comment on column ${iol_schema}.isbs_fxd.quoref is '';
comment on column ${iol_schema}.isbs_fxd.branchinr is '';
comment on column ${iol_schema}.isbs_fxd.bgnref is '';
comment on column ${iol_schema}.isbs_fxd.ver is '';
comment on column ${iol_schema}.isbs_fxd.midrat is '';
comment on column ${iol_schema}.isbs_fxd.ownref is '';
comment on column ${iol_schema}.isbs_fxd.dsp is '';
comment on column ${iol_schema}.isbs_fxd.zjtyp is '';
comment on column ${iol_schema}.isbs_fxd.inr is '';
comment on column ${iol_schema}.isbs_fxd.rat is '';
comment on column ${iol_schema}.isbs_fxd.clsdat is '';
comment on column ${iol_schema}.isbs_fxd.setdatfrm is '';
comment on column ${iol_schema}.isbs_fxd.txcod is '';
comment on column ${iol_schema}.isbs_fxd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_fxd.nam is '';
comment on column ${iol_schema}.isbs_fxd.trnmod is '';
comment on column ${iol_schema}.isbs_fxd.usr is '';
comment on column ${iol_schema}.isbs_fxd.acc2 is '';
comment on column ${iol_schema}.isbs_fxd.trdout is '';
comment on column ${iol_schema}.isbs_fxd.setdatto is '';
comment on column ${iol_schema}.isbs_fxd.cnfdat is '';
comment on column ${iol_schema}.isbs_fxd.trnman is '';
comment on column ${iol_schema}.isbs_fxd.valdat is '';
comment on column ${iol_schema}.isbs_fxd.dsp2 is '';
comment on column ${iol_schema}.isbs_fxd.opndat is '';
comment on column ${iol_schema}.isbs_fxd.fudref is '';
comment on column ${iol_schema}.isbs_fxd.fxtyp is '';
comment on column ${iol_schema}.isbs_fxd.trdint is '';
comment on column ${iol_schema}.isbs_fxd.ownusr is '';
comment on column ${iol_schema}.isbs_fxd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fxd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fxd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fxd.etl_timestamp is 'ETL处理时间戳';
