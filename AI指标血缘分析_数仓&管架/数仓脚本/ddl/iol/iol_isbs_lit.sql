/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_lit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_lit
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_lit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_lit(
    inr varchar2(12) -- 进口信用证id号
    ,adlcnd varchar2(4000) -- 附加条款
    ,defdet varchar2(216) -- 延期付款细节
    ,dftat varchar2(162) -- 票据条款
    ,feetxt varchar2(324) -- 手续费
    ,insbnk varchar2(1188) -- 银行说明
    ,lcrdoc varchar2(4000) -- 票据说明
    ,lcrgod varchar2(4000) -- 货物说明
    ,mixdet varchar2(216) -- 混合付款细节
    ,preper varchar2(216) -- 提示周期
    ,rmbcha varchar2(324) -- 偿付行其他费用
    ,shpper varchar2(594) -- 装船周期
    ,ver varchar2(6) -- 版本号
    ,adlcndame varchar2(4000) -- 附加环境
    ,lcrgodame varchar2(4000) -- 货物描述
    ,lcrdocame varchar2(4000) -- 票据描述
    ,narhis varchar2(4000) -- 叙述历史
    ,fldmodblk varchar2(4000) -- lid中修改过的字段列表
    ,revnotes varchar2(324) -- 给申请人的信息
    ,revcls varchar2(594) -- 循环条款
    ,avbwthtxt varchar2(216) -- 处理方式的信息文本
    ,addamtcov varchar2(216) -- 增加的保证金
    ,insbnkame varchar2(4000) -- 记录修改的情况（给paying, accepting, negotiating bank）
    ,contag72 varchar2(4000) -- 报文72场内容
    ,contag79 varchar2(4000) -- 报文79场内容
    ,preperdef varchar2(216) -- 承兑条款
    ,preperflg varchar2(2) -- 承兑期限修改标志
    ,decamtstm varchar2(4000) -- 金额修改
    ,forins varchar2(216) -- 
    ,insdat varchar2(3450) -- 
    ,othtyp varchar2(2460) -- 
    ,spcben varchar2(4000) -- 
    ,spcrcb varchar2(4000) -- 
    ,spcbename varchar2(4000) -- 
    ,spcrcbame varchar2(4000) -- 
    ,xddstm varchar2(635) -- 信贷担保信息
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
grant select on ${iol_schema}.isbs_lit to ${iml_schema};
grant select on ${iol_schema}.isbs_lit to ${icl_schema};
grant select on ${iol_schema}.isbs_lit to ${idl_schema};
grant select on ${iol_schema}.isbs_lit to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_lit is '进口信用证业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_lit.inr is '进口信用证id号';
comment on column ${iol_schema}.isbs_lit.adlcnd is '附加条款';
comment on column ${iol_schema}.isbs_lit.defdet is '延期付款细节';
comment on column ${iol_schema}.isbs_lit.dftat is '票据条款';
comment on column ${iol_schema}.isbs_lit.feetxt is '手续费';
comment on column ${iol_schema}.isbs_lit.insbnk is '银行说明';
comment on column ${iol_schema}.isbs_lit.lcrdoc is '票据说明';
comment on column ${iol_schema}.isbs_lit.lcrgod is '货物说明';
comment on column ${iol_schema}.isbs_lit.mixdet is '混合付款细节';
comment on column ${iol_schema}.isbs_lit.preper is '提示周期';
comment on column ${iol_schema}.isbs_lit.rmbcha is '偿付行其他费用';
comment on column ${iol_schema}.isbs_lit.shpper is '装船周期';
comment on column ${iol_schema}.isbs_lit.ver is '版本号';
comment on column ${iol_schema}.isbs_lit.adlcndame is '附加环境';
comment on column ${iol_schema}.isbs_lit.lcrgodame is '货物描述';
comment on column ${iol_schema}.isbs_lit.lcrdocame is '票据描述';
comment on column ${iol_schema}.isbs_lit.narhis is '叙述历史';
comment on column ${iol_schema}.isbs_lit.fldmodblk is 'lid中修改过的字段列表';
comment on column ${iol_schema}.isbs_lit.revnotes is '给申请人的信息';
comment on column ${iol_schema}.isbs_lit.revcls is '循环条款';
comment on column ${iol_schema}.isbs_lit.avbwthtxt is '处理方式的信息文本';
comment on column ${iol_schema}.isbs_lit.addamtcov is '增加的保证金';
comment on column ${iol_schema}.isbs_lit.insbnkame is '记录修改的情况（给paying, accepting, negotiating bank）';
comment on column ${iol_schema}.isbs_lit.contag72 is '报文72场内容';
comment on column ${iol_schema}.isbs_lit.contag79 is '报文79场内容';
comment on column ${iol_schema}.isbs_lit.preperdef is '承兑条款';
comment on column ${iol_schema}.isbs_lit.preperflg is '承兑期限修改标志';
comment on column ${iol_schema}.isbs_lit.decamtstm is '金额修改';
comment on column ${iol_schema}.isbs_lit.forins is '';
comment on column ${iol_schema}.isbs_lit.insdat is '';
comment on column ${iol_schema}.isbs_lit.othtyp is '';
comment on column ${iol_schema}.isbs_lit.spcben is '';
comment on column ${iol_schema}.isbs_lit.spcrcb is '';
comment on column ${iol_schema}.isbs_lit.spcbename is '';
comment on column ${iol_schema}.isbs_lit.spcrcbame is '';
comment on column ${iol_schema}.isbs_lit.xddstm is '信贷担保信息';
comment on column ${iol_schema}.isbs_lit.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_lit.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_lit.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_lit.etl_timestamp is 'ETL处理时间戳';
