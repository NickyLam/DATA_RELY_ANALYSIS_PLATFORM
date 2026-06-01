/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dit
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dit(
    inr varchar2(12) -- 
    ,adlcnd varchar2(4000) -- 
    ,defdet varchar2(216) -- 
    ,dftat varchar2(162) -- 
    ,feetxt varchar2(324) -- 
    ,insbnk varchar2(1188) -- 
    ,lcrdoc varchar2(4000) -- 
    ,lcrgod varchar2(4000) -- 
    ,mixdet varchar2(216) -- 
    ,preper varchar2(324) -- 
    ,rmbcha varchar2(324) -- 
    ,shpper varchar2(594) -- 
    ,ver varchar2(6) -- 
    ,adlcndame varchar2(4000) -- 
    ,lcrgodame varchar2(4000) -- 
    ,lcrdocame varchar2(4000) -- 
    ,narhis varchar2(4000) -- 
    ,fldmodblk varchar2(4000) -- 
    ,revnotes varchar2(324) -- 
    ,revcls varchar2(594) -- 
    ,avbwthtxt varchar2(216) -- 
    ,addamtcov varchar2(216) -- 
    ,insbnkame varchar2(4000) -- 
    ,contag72 varchar2(4000) -- 
    ,contag79 varchar2(4000) -- 
    ,preperdef varchar2(216) -- 
    ,preperflg varchar2(2) -- 
    ,decamtstm varchar2(4000) -- 
    ,forins varchar2(216) -- 
    ,insdat varchar2(3450) -- 
    ,othtyp varchar2(2460) -- 
    ,xddstm varchar2(635) -- 
    ,rejamersn varchar2(183) -- 修改理由
    ,rejrsnamehis varchar2(4000) -- 修改理由（历史）
    ,canrsn varchar2(306) -- 闭卷原因
    ,canrsnhis varchar2(4000) -- 闭卷原因（历史）
    ,rejadvrsn varchar2(185) -- 拒绝通知理由
    ,rejadvrsnhis varchar2(4000) -- 拒绝通知理由（历史）
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
grant select on ${iol_schema}.isbs_dit to ${iml_schema};
grant select on ${iol_schema}.isbs_dit to ${icl_schema};
grant select on ${iol_schema}.isbs_dit to ${idl_schema};
grant select on ${iol_schema}.isbs_dit to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dit is '国内证买方信用证业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_dit.inr is '';
comment on column ${iol_schema}.isbs_dit.adlcnd is '';
comment on column ${iol_schema}.isbs_dit.defdet is '';
comment on column ${iol_schema}.isbs_dit.dftat is '';
comment on column ${iol_schema}.isbs_dit.feetxt is '';
comment on column ${iol_schema}.isbs_dit.insbnk is '';
comment on column ${iol_schema}.isbs_dit.lcrdoc is '';
comment on column ${iol_schema}.isbs_dit.lcrgod is '';
comment on column ${iol_schema}.isbs_dit.mixdet is '';
comment on column ${iol_schema}.isbs_dit.preper is '';
comment on column ${iol_schema}.isbs_dit.rmbcha is '';
comment on column ${iol_schema}.isbs_dit.shpper is '';
comment on column ${iol_schema}.isbs_dit.ver is '';
comment on column ${iol_schema}.isbs_dit.adlcndame is '';
comment on column ${iol_schema}.isbs_dit.lcrgodame is '';
comment on column ${iol_schema}.isbs_dit.lcrdocame is '';
comment on column ${iol_schema}.isbs_dit.narhis is '';
comment on column ${iol_schema}.isbs_dit.fldmodblk is '';
comment on column ${iol_schema}.isbs_dit.revnotes is '';
comment on column ${iol_schema}.isbs_dit.revcls is '';
comment on column ${iol_schema}.isbs_dit.avbwthtxt is '';
comment on column ${iol_schema}.isbs_dit.addamtcov is '';
comment on column ${iol_schema}.isbs_dit.insbnkame is '';
comment on column ${iol_schema}.isbs_dit.contag72 is '';
comment on column ${iol_schema}.isbs_dit.contag79 is '';
comment on column ${iol_schema}.isbs_dit.preperdef is '';
comment on column ${iol_schema}.isbs_dit.preperflg is '';
comment on column ${iol_schema}.isbs_dit.decamtstm is '';
comment on column ${iol_schema}.isbs_dit.forins is '';
comment on column ${iol_schema}.isbs_dit.insdat is '';
comment on column ${iol_schema}.isbs_dit.othtyp is '';
comment on column ${iol_schema}.isbs_dit.xddstm is '';
comment on column ${iol_schema}.isbs_dit.rejamersn is '修改理由';
comment on column ${iol_schema}.isbs_dit.rejrsnamehis is '修改理由（历史）';
comment on column ${iol_schema}.isbs_dit.canrsn is '闭卷原因';
comment on column ${iol_schema}.isbs_dit.canrsnhis is '闭卷原因（历史）';
comment on column ${iol_schema}.isbs_dit.rejadvrsn is '拒绝通知理由';
comment on column ${iol_schema}.isbs_dit.rejadvrsnhis is '拒绝通知理由（历史）';
comment on column ${iol_schema}.isbs_dit.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dit.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dit.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dit.etl_timestamp is 'ETL处理时间戳';
