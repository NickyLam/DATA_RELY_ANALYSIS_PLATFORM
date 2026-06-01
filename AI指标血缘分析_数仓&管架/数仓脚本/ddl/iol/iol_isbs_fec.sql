/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fec
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fec purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fec(
    setflg varchar2(2) -- 
    ,enddat date -- 
    ,ratcur varchar2(5) -- 
    ,tirtyp varchar2(9) -- 
    ,objtyp varchar2(9) -- 
    ,clcdifflg varchar2(2) -- 
    ,settyp varchar2(2) -- 
    ,pertypprv varchar2(9) -- 
    ,permintr3 number(18,3) -- 
    ,ver varchar2(6) -- 
    ,perrattr4 number(14,6) -- 
    ,mincur varchar2(5) -- 
    ,perrattr6 number(14,6) -- 
    ,permin number(3,0) -- 
    ,permaxtr3 number(18,3) -- 
    ,perrattr7 number(14,6) -- 
    ,minfcc varchar2(2) -- 
    ,amtsetall number(18,3) -- 
    ,amtbegtr2 number(18,3) -- 
    ,permaxtr6 number(18,3) -- 
    ,perrattr2 number(14,6) -- 
    ,amtrattr3 number(14,6) -- 
    ,permintr4 number(18,3) -- 
    ,setend varchar2(2) -- 
    ,perbegtr5 number(3,0) -- 
    ,perbegtr4 number(3,0) -- 
    ,ratcal number(14,6) -- 
    ,minamttot number(18,3) -- 
    ,setperflg varchar2(3) -- 
    ,perbegtr3 number(3,0) -- 
    ,begdat date -- 
    ,untamt number(18,3) -- 
    ,permaxtr2 number(18,3) -- 
    ,amtrattr2 number(14,6) -- 
    ,ratfcc varchar2(2) -- 
    ,higamt number(18,3) -- 
    ,perrattr5 number(14,6) -- 
    ,feepri varchar2(2) -- 
    ,lowamt number(18,3) -- 
    ,permintr5 number(18,3) -- 
    ,maxfcc varchar2(2) -- 
    ,maxpercnt number(3,0) -- 
    ,permintr2 number(18,3) -- 
    ,perbegtr2 number(3,0) -- 
    ,setmod varchar2(2) -- 
    ,colltr varchar2(2) -- 
    ,ratirs varchar2(9) -- 
    ,calfcc varchar2(2) -- 
    ,permaxtr4 number(18,3) -- 
    ,calcbs varchar2(9) -- 
    ,setchgflg varchar2(3) -- 
    ,inr varchar2(12) -- 
    ,objinr varchar2(12) -- 
    ,basamt number(18,3) -- 
    ,minamt number(18,3) -- 
    ,feeinr varchar2(12) -- 
    ,amtbegtr3 number(18,3) -- 
    ,maxcur varchar2(5) -- 
    ,amtbegtr4 number(18,3) -- 
    ,pertyp varchar2(9) -- 
    ,permintr6 number(18,3) -- 
    ,permintr7 number(18,3) -- 
    ,perrattr3 number(14,6) -- 
    ,maxpercov number(3,0) -- 
    ,perbegtr7 number(3,0) -- 
    ,setbeg varchar2(2) -- 
    ,ratirsinc varchar2(9) -- 
    ,calrul varchar2(2) -- 
    ,perbegtr6 number(3,0) -- 
    ,permaxtr5 number(18,3) -- 
    ,amtrattr4 number(14,6) -- 
    ,permaxtr7 number(18,3) -- 
    ,maxamt number(18,3) -- 
    ,etgextkey varchar2(12) -- 
    ,minpercnt number(3,0) -- 
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
grant select on ${iol_schema}.isbs_fec to ${iml_schema};
grant select on ${iol_schema}.isbs_fec to ${icl_schema};
grant select on ${iol_schema}.isbs_fec to ${idl_schema};
grant select on ${iol_schema}.isbs_fec to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fec is '费用收取条件与计算规则';
comment on column ${iol_schema}.isbs_fec.setflg is '';
comment on column ${iol_schema}.isbs_fec.enddat is '';
comment on column ${iol_schema}.isbs_fec.ratcur is '';
comment on column ${iol_schema}.isbs_fec.tirtyp is '';
comment on column ${iol_schema}.isbs_fec.objtyp is '';
comment on column ${iol_schema}.isbs_fec.clcdifflg is '';
comment on column ${iol_schema}.isbs_fec.settyp is '';
comment on column ${iol_schema}.isbs_fec.pertypprv is '';
comment on column ${iol_schema}.isbs_fec.permintr3 is '';
comment on column ${iol_schema}.isbs_fec.ver is '';
comment on column ${iol_schema}.isbs_fec.perrattr4 is '';
comment on column ${iol_schema}.isbs_fec.mincur is '';
comment on column ${iol_schema}.isbs_fec.perrattr6 is '';
comment on column ${iol_schema}.isbs_fec.permin is '';
comment on column ${iol_schema}.isbs_fec.permaxtr3 is '';
comment on column ${iol_schema}.isbs_fec.perrattr7 is '';
comment on column ${iol_schema}.isbs_fec.minfcc is '';
comment on column ${iol_schema}.isbs_fec.amtsetall is '';
comment on column ${iol_schema}.isbs_fec.amtbegtr2 is '';
comment on column ${iol_schema}.isbs_fec.permaxtr6 is '';
comment on column ${iol_schema}.isbs_fec.perrattr2 is '';
comment on column ${iol_schema}.isbs_fec.amtrattr3 is '';
comment on column ${iol_schema}.isbs_fec.permintr4 is '';
comment on column ${iol_schema}.isbs_fec.setend is '';
comment on column ${iol_schema}.isbs_fec.perbegtr5 is '';
comment on column ${iol_schema}.isbs_fec.perbegtr4 is '';
comment on column ${iol_schema}.isbs_fec.ratcal is '';
comment on column ${iol_schema}.isbs_fec.minamttot is '';
comment on column ${iol_schema}.isbs_fec.setperflg is '';
comment on column ${iol_schema}.isbs_fec.perbegtr3 is '';
comment on column ${iol_schema}.isbs_fec.begdat is '';
comment on column ${iol_schema}.isbs_fec.untamt is '';
comment on column ${iol_schema}.isbs_fec.permaxtr2 is '';
comment on column ${iol_schema}.isbs_fec.amtrattr2 is '';
comment on column ${iol_schema}.isbs_fec.ratfcc is '';
comment on column ${iol_schema}.isbs_fec.higamt is '';
comment on column ${iol_schema}.isbs_fec.perrattr5 is '';
comment on column ${iol_schema}.isbs_fec.feepri is '';
comment on column ${iol_schema}.isbs_fec.lowamt is '';
comment on column ${iol_schema}.isbs_fec.permintr5 is '';
comment on column ${iol_schema}.isbs_fec.maxfcc is '';
comment on column ${iol_schema}.isbs_fec.maxpercnt is '';
comment on column ${iol_schema}.isbs_fec.permintr2 is '';
comment on column ${iol_schema}.isbs_fec.perbegtr2 is '';
comment on column ${iol_schema}.isbs_fec.setmod is '';
comment on column ${iol_schema}.isbs_fec.colltr is '';
comment on column ${iol_schema}.isbs_fec.ratirs is '';
comment on column ${iol_schema}.isbs_fec.calfcc is '';
comment on column ${iol_schema}.isbs_fec.permaxtr4 is '';
comment on column ${iol_schema}.isbs_fec.calcbs is '';
comment on column ${iol_schema}.isbs_fec.setchgflg is '';
comment on column ${iol_schema}.isbs_fec.inr is '';
comment on column ${iol_schema}.isbs_fec.objinr is '';
comment on column ${iol_schema}.isbs_fec.basamt is '';
comment on column ${iol_schema}.isbs_fec.minamt is '';
comment on column ${iol_schema}.isbs_fec.feeinr is '';
comment on column ${iol_schema}.isbs_fec.amtbegtr3 is '';
comment on column ${iol_schema}.isbs_fec.maxcur is '';
comment on column ${iol_schema}.isbs_fec.amtbegtr4 is '';
comment on column ${iol_schema}.isbs_fec.pertyp is '';
comment on column ${iol_schema}.isbs_fec.permintr6 is '';
comment on column ${iol_schema}.isbs_fec.permintr7 is '';
comment on column ${iol_schema}.isbs_fec.perrattr3 is '';
comment on column ${iol_schema}.isbs_fec.maxpercov is '';
comment on column ${iol_schema}.isbs_fec.perbegtr7 is '';
comment on column ${iol_schema}.isbs_fec.setbeg is '';
comment on column ${iol_schema}.isbs_fec.ratirsinc is '';
comment on column ${iol_schema}.isbs_fec.calrul is '';
comment on column ${iol_schema}.isbs_fec.perbegtr6 is '';
comment on column ${iol_schema}.isbs_fec.permaxtr5 is '';
comment on column ${iol_schema}.isbs_fec.amtrattr4 is '';
comment on column ${iol_schema}.isbs_fec.permaxtr7 is '';
comment on column ${iol_schema}.isbs_fec.maxamt is '';
comment on column ${iol_schema}.isbs_fec.etgextkey is '';
comment on column ${iol_schema}.isbs_fec.minpercnt is '';
comment on column ${iol_schema}.isbs_fec.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fec.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fec.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fec.etl_timestamp is 'ETL处理时间戳';
