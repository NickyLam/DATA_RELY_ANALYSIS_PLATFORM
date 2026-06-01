/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bot
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bot(
    inr varchar2(12) -- 出口托收交易id号
    ,resrej varchar2(1080) -- 拒付原因
    ,docpre varchar2(4000) -- 提示单据
    ,bogdet varchar2(132) -- 出口托收细节
    ,vesselnam varchar2(60) -- 船名
    ,goddes varchar2(495) -- 货物描述
    ,colins varchar2(4000) -- 托收说明
    ,dftins varchar2(594) -- 单据说明
    ,proins varchar2(198) -- 拒付说明
    ,chgtxt varchar2(324) -- 费用文本
    ,narhis varchar2(4000) -- 叙说历史性修改
    ,othins varchar2(594) -- 其他说明
    ,fldmodblk varchar2(4000) -- 修改bod字段列表
    ,cctinsrcv varchar2(324) -- 收到指示
    ,cctinscol varchar2(324) -- 托收指示
    ,colinssnm varchar2(183) -- 放单指示
    ,intins varchar2(495) -- 利息说明
    ,agtaut varchar2(324) -- 代理人当局
    ,contag72 varchar2(4000) -- tag 72内容
    ,contag79 varchar2(4000) -- tag79内容
    ,bogans varchar2(324) -- 422电文的"answer"
    ,bogque varchar2(324) -- 422电文的"query"
    ,setinsbo varchar2(594) -- 付款指示
    ,colinsdef varchar2(4000) -- 默认放单指示
    ,colinsflg varchar2(2) -- 修改放单指示
    ,delins varchar2(198) -- 传送说明
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
grant select on ${iol_schema}.isbs_bot to ${iml_schema};
grant select on ${iol_schema}.isbs_bot to ${icl_schema};
grant select on ${iol_schema}.isbs_bot to ${idl_schema};
grant select on ${iol_schema}.isbs_bot to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bot is '出口托收业务信息(存放长字节内容)';
comment on column ${iol_schema}.isbs_bot.inr is '出口托收交易id号';
comment on column ${iol_schema}.isbs_bot.resrej is '拒付原因';
comment on column ${iol_schema}.isbs_bot.docpre is '提示单据';
comment on column ${iol_schema}.isbs_bot.bogdet is '出口托收细节';
comment on column ${iol_schema}.isbs_bot.vesselnam is '船名';
comment on column ${iol_schema}.isbs_bot.goddes is '货物描述';
comment on column ${iol_schema}.isbs_bot.colins is '托收说明';
comment on column ${iol_schema}.isbs_bot.dftins is '单据说明';
comment on column ${iol_schema}.isbs_bot.proins is '拒付说明';
comment on column ${iol_schema}.isbs_bot.chgtxt is '费用文本';
comment on column ${iol_schema}.isbs_bot.narhis is '叙说历史性修改';
comment on column ${iol_schema}.isbs_bot.othins is '其他说明';
comment on column ${iol_schema}.isbs_bot.fldmodblk is '修改bod字段列表';
comment on column ${iol_schema}.isbs_bot.cctinsrcv is '收到指示';
comment on column ${iol_schema}.isbs_bot.cctinscol is '托收指示';
comment on column ${iol_schema}.isbs_bot.colinssnm is '放单指示';
comment on column ${iol_schema}.isbs_bot.intins is '利息说明';
comment on column ${iol_schema}.isbs_bot.agtaut is '代理人当局';
comment on column ${iol_schema}.isbs_bot.contag72 is 'tag 72内容';
comment on column ${iol_schema}.isbs_bot.contag79 is 'tag79内容';
comment on column ${iol_schema}.isbs_bot.bogans is '422电文的"answer"';
comment on column ${iol_schema}.isbs_bot.bogque is '422电文的"query"';
comment on column ${iol_schema}.isbs_bot.setinsbo is '付款指示';
comment on column ${iol_schema}.isbs_bot.colinsdef is '默认放单指示';
comment on column ${iol_schema}.isbs_bot.colinsflg is '修改放单指示';
comment on column ${iol_schema}.isbs_bot.delins is '传送说明';
comment on column ${iol_schema}.isbs_bot.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bot.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bot.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bot.etl_timestamp is 'ETL处理时间戳';
