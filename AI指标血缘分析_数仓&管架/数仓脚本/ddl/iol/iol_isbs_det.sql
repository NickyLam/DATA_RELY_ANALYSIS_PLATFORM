/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_det
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_det
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_det purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_det(
    inr varchar2(12) -- 
    ,contag72 varchar2(4000) -- 
    ,contag79 varchar2(4000) -- 
    ,adlcnd varchar2(4000) -- 
    ,defdet varchar2(216) -- 
    ,dftat varchar2(162) -- 
    ,feetxt varchar2(324) -- 
    ,insbnk varchar2(1188) -- 
    ,lcrdoc varchar2(4000) -- 
    ,lcrgod varchar2(4000) -- 
    ,mixdet varchar2(216) -- 
    ,preper varchar2(324) -- 
    ,shpper varchar2(594) -- 
    ,strinf varchar2(324) -- 
    ,ver varchar2(6) -- 
    ,adlcndame varchar2(4000) -- 
    ,lcrgodame varchar2(4000) -- 
    ,lcrdocame varchar2(4000) -- 
    ,nartxtame varchar2(4000) -- 
    ,addamtcov varchar2(216) -- 
    ,fldmodblk varchar2(4000) -- 
    ,revnotes varchar2(324) -- 
    ,revcls varchar2(594) -- 
    ,avbwthtxt varchar2(216) -- 
    ,insbnkame varchar2(4000) -- 
    ,forins varchar2(216) -- 
    ,insdat varchar2(3450) -- 
    ,preperflg varchar2(2) -- 
    ,othtyp varchar2(2460) -- 
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
grant select on ${iol_schema}.isbs_det to ${iml_schema};
grant select on ${iol_schema}.isbs_det to ${icl_schema};
grant select on ${iol_schema}.isbs_det to ${idl_schema};
grant select on ${iol_schema}.isbs_det to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_det is '国内证卖方信用证业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_det.inr is '';
comment on column ${iol_schema}.isbs_det.contag72 is '';
comment on column ${iol_schema}.isbs_det.contag79 is '';
comment on column ${iol_schema}.isbs_det.adlcnd is '';
comment on column ${iol_schema}.isbs_det.defdet is '';
comment on column ${iol_schema}.isbs_det.dftat is '';
comment on column ${iol_schema}.isbs_det.feetxt is '';
comment on column ${iol_schema}.isbs_det.insbnk is '';
comment on column ${iol_schema}.isbs_det.lcrdoc is '';
comment on column ${iol_schema}.isbs_det.lcrgod is '';
comment on column ${iol_schema}.isbs_det.mixdet is '';
comment on column ${iol_schema}.isbs_det.preper is '';
comment on column ${iol_schema}.isbs_det.shpper is '';
comment on column ${iol_schema}.isbs_det.strinf is '';
comment on column ${iol_schema}.isbs_det.ver is '';
comment on column ${iol_schema}.isbs_det.adlcndame is '';
comment on column ${iol_schema}.isbs_det.lcrgodame is '';
comment on column ${iol_schema}.isbs_det.lcrdocame is '';
comment on column ${iol_schema}.isbs_det.nartxtame is '';
comment on column ${iol_schema}.isbs_det.addamtcov is '';
comment on column ${iol_schema}.isbs_det.fldmodblk is '';
comment on column ${iol_schema}.isbs_det.revnotes is '';
comment on column ${iol_schema}.isbs_det.revcls is '';
comment on column ${iol_schema}.isbs_det.avbwthtxt is '';
comment on column ${iol_schema}.isbs_det.insbnkame is '';
comment on column ${iol_schema}.isbs_det.forins is '';
comment on column ${iol_schema}.isbs_det.insdat is '';
comment on column ${iol_schema}.isbs_det.preperflg is '';
comment on column ${iol_schema}.isbs_det.othtyp is '';
comment on column ${iol_schema}.isbs_det.rejamersn is '修改理由';
comment on column ${iol_schema}.isbs_det.rejrsnamehis is '修改理由（历史）';
comment on column ${iol_schema}.isbs_det.canrsn is '闭卷原因';
comment on column ${iol_schema}.isbs_det.canrsnhis is '闭卷原因（历史）';
comment on column ${iol_schema}.isbs_det.rejadvrsn is '拒绝通知理由';
comment on column ${iol_schema}.isbs_det.rejadvrsnhis is '拒绝通知理由（历史）';
comment on column ${iol_schema}.isbs_det.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_det.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_det.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_det.etl_timestamp is 'ETL处理时间戳';
