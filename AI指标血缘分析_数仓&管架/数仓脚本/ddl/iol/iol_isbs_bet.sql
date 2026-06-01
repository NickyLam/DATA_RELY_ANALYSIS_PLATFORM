/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bet
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bet(
    inr varchar2(12) -- 出口单据inr
    ,docdis varchar2(4000) -- 不符点
    ,docins varchar2(270) -- 拒付原因
    ,prsdoc varchar2(4000) -- 提交单据
    ,disdoc varchar2(162) -- 处理单据
    ,benins varchar2(990) -- 说明
    ,matper varchar2(99) -- 效期
    ,intdis varchar2(1980) -- 内部差异
    ,comcon varchar2(1980) -- 注释与结论
    ,fldmodblk varchar2(4000) -- 修改域的列表
    ,chaadd varchar2(324) -- 费用增加
    ,chaded varchar2(324) -- 费用减少
    ,nartxt77a varchar2(1080) -- tag 77内容
    ,contag72 varchar2(4000) -- tag72内容
    ,contag79 varchar2(4000) -- tag79内容
    ,docdisflg varchar2(2) -- 不符点修改标志
    ,docdisdef varchar2(4000) -- 不符点内容
    ,setinsbe varchar2(1980) -- 收费说明
    ,benref varchar2(255) -- 发票号
    ,roggod varchar2(2460) -- 货物证明
    ,notpty varchar2(540) -- 通知方
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
grant select on ${iol_schema}.isbs_bet to ${iml_schema};
grant select on ${iol_schema}.isbs_bet to ${icl_schema};
grant select on ${iol_schema}.isbs_bet to ${idl_schema};
grant select on ${iol_schema}.isbs_bet to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bet is '出口信用证下单据信息(存放长字节内容)';
comment on column ${iol_schema}.isbs_bet.inr is '出口单据inr';
comment on column ${iol_schema}.isbs_bet.docdis is '不符点';
comment on column ${iol_schema}.isbs_bet.docins is '拒付原因';
comment on column ${iol_schema}.isbs_bet.prsdoc is '提交单据';
comment on column ${iol_schema}.isbs_bet.disdoc is '处理单据';
comment on column ${iol_schema}.isbs_bet.benins is '说明';
comment on column ${iol_schema}.isbs_bet.matper is '效期';
comment on column ${iol_schema}.isbs_bet.intdis is '内部差异';
comment on column ${iol_schema}.isbs_bet.comcon is '注释与结论';
comment on column ${iol_schema}.isbs_bet.fldmodblk is '修改域的列表';
comment on column ${iol_schema}.isbs_bet.chaadd is '费用增加';
comment on column ${iol_schema}.isbs_bet.chaded is '费用减少';
comment on column ${iol_schema}.isbs_bet.nartxt77a is 'tag 77内容';
comment on column ${iol_schema}.isbs_bet.contag72 is 'tag72内容';
comment on column ${iol_schema}.isbs_bet.contag79 is 'tag79内容';
comment on column ${iol_schema}.isbs_bet.docdisflg is '不符点修改标志';
comment on column ${iol_schema}.isbs_bet.docdisdef is '不符点内容';
comment on column ${iol_schema}.isbs_bet.setinsbe is '收费说明';
comment on column ${iol_schema}.isbs_bet.benref is '发票号';
comment on column ${iol_schema}.isbs_bet.roggod is '货物证明';
comment on column ${iol_schema}.isbs_bet.notpty is '通知方';
comment on column ${iol_schema}.isbs_bet.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bet.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bet.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bet.etl_timestamp is 'ETL处理时间戳';
