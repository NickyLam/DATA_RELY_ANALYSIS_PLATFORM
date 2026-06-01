/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_let
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_let
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_let purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_let(
    inr varchar2(12) -- 出口信用证id号
    ,adlcnd varchar2(4000) -- 附加条件
    ,defdet varchar2(216) -- 延期付款细节
    ,dftat varchar2(162) -- 汇款方式
    ,feetxt varchar2(324) -- 费用分担
    ,insbnk varchar2(1188) -- 给付款/承对/议付行的指示
    ,lcrdoc varchar2(4000) -- 必须的单据
    ,lcrgod varchar2(4000) -- 货物描述
    ,mixdet varchar2(216) -- 混合付款细节
    ,preper varchar2(216) -- 提示期间
    ,shpper varchar2(594) -- 装船时期
    ,strinf varchar2(324) -- 给收单者信息
    ,ver varchar2(6) -- 版本号
    ,adlcndame varchar2(4000) -- 附加条件
    ,lcrgodame varchar2(4000) -- 货物描述
    ,lcrdocame varchar2(4000) -- 修改单据描述
    ,nartxtame varchar2(4000) -- 叙述
    ,addamtcov varchar2(216) -- 增加的保证金
    ,fldmodblk varchar2(4000) -- 修改栏位记录的内容
    ,revnotes varchar2(324) -- 给受益人的信息
    ,revcls varchar2(594) -- 循环条款
    ,avbwthtxt varchar2(216) -- 适用方式的详细信息
    ,insbnkame varchar2(4000) -- 给对方信用的修改信息（paying
    ,contag72 varchar2(4000) -- 报文72场的内容
    ,contag79 varchar2(4000) -- 报文79场的内容
    ,spcben varchar2(4000) -- 
    ,spcrcb varchar2(4000) -- 
    ,spcbename varchar2(4000) -- 
    ,spcrcbame varchar2(4000) -- 
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
grant select on ${iol_schema}.isbs_let to ${iml_schema};
grant select on ${iol_schema}.isbs_let to ${icl_schema};
grant select on ${iol_schema}.isbs_let to ${idl_schema};
grant select on ${iol_schema}.isbs_let to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_let is '出口信用证业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_let.inr is '出口信用证id号';
comment on column ${iol_schema}.isbs_let.adlcnd is '附加条件';
comment on column ${iol_schema}.isbs_let.defdet is '延期付款细节';
comment on column ${iol_schema}.isbs_let.dftat is '汇款方式';
comment on column ${iol_schema}.isbs_let.feetxt is '费用分担';
comment on column ${iol_schema}.isbs_let.insbnk is '给付款/承对/议付行的指示';
comment on column ${iol_schema}.isbs_let.lcrdoc is '必须的单据';
comment on column ${iol_schema}.isbs_let.lcrgod is '货物描述';
comment on column ${iol_schema}.isbs_let.mixdet is '混合付款细节';
comment on column ${iol_schema}.isbs_let.preper is '提示期间';
comment on column ${iol_schema}.isbs_let.shpper is '装船时期';
comment on column ${iol_schema}.isbs_let.strinf is '给收单者信息';
comment on column ${iol_schema}.isbs_let.ver is '版本号';
comment on column ${iol_schema}.isbs_let.adlcndame is '附加条件';
comment on column ${iol_schema}.isbs_let.lcrgodame is '货物描述';
comment on column ${iol_schema}.isbs_let.lcrdocame is '修改单据描述';
comment on column ${iol_schema}.isbs_let.nartxtame is '叙述';
comment on column ${iol_schema}.isbs_let.addamtcov is '增加的保证金';
comment on column ${iol_schema}.isbs_let.fldmodblk is '修改栏位记录的内容';
comment on column ${iol_schema}.isbs_let.revnotes is '给受益人的信息';
comment on column ${iol_schema}.isbs_let.revcls is '循环条款';
comment on column ${iol_schema}.isbs_let.avbwthtxt is '适用方式的详细信息';
comment on column ${iol_schema}.isbs_let.insbnkame is '给对方信用的修改信息（paying';
comment on column ${iol_schema}.isbs_let.contag72 is '报文72场的内容';
comment on column ${iol_schema}.isbs_let.contag79 is '报文79场的内容';
comment on column ${iol_schema}.isbs_let.spcben is '';
comment on column ${iol_schema}.isbs_let.spcrcb is '';
comment on column ${iol_schema}.isbs_let.spcbename is '';
comment on column ${iol_schema}.isbs_let.spcrcbame is '';
comment on column ${iol_schema}.isbs_let.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_let.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_let.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_let.etl_timestamp is 'ETL处理时间戳';
