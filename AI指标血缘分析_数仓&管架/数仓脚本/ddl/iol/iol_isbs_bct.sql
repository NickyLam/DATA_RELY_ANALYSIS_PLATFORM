/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bct
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bct(
    inr varchar2(12) -- 代收id号
    ,resrej varchar2(2678) -- 拒付/据单的原因
    ,bcgque varchar2(324) -- 查询
    ,bcgans varchar2(324) -- 回答
    ,docpre varchar2(3960) -- 提示单据
    ,bcgdet varchar2(138) -- 代收细节
    ,othins varchar2(495) -- 其他指示
    ,bctfre varchar2(495) -- 自由文本信息
    ,vesselnam varchar2(66) -- 船名
    ,covgod varchar2(270) -- 头寸货物
    ,colins varchar2(495) -- 收货说明
    ,dftins varchar2(495) -- 票据说明
    ,chgtxt varchar2(324) -- 费用文本
    ,intins varchar2(495) -- 利息说明
    ,fldmodblk varchar2(4000) -- 修改域的列表
    ,reladr varchar2(216) -- 放货地址
    ,colinssnm varchar2(183) -- 托收说明
    ,proins varchar2(198) -- 不符点
    ,contag72 varchar2(4000) -- tag72的记录
    ,contag79 varchar2(4000) -- tag79的记录
    ,bcgdetdef varchar2(138) -- 要求说明
    ,bcgdetflg varchar2(2) -- 要求修改的标志
    ,agtaut varchar2(324) -- 420电文的43g
    ,agtinf varchar2(495) -- 420电文的43h
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
grant select on ${iol_schema}.isbs_bct to ${iml_schema};
grant select on ${iol_schema}.isbs_bct to ${icl_schema};
grant select on ${iol_schema}.isbs_bct to ${idl_schema};
grant select on ${iol_schema}.isbs_bct to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bct is '进口代收业务信息(存放长字节内容)';
comment on column ${iol_schema}.isbs_bct.inr is '代收id号';
comment on column ${iol_schema}.isbs_bct.resrej is '拒付/据单的原因';
comment on column ${iol_schema}.isbs_bct.bcgque is '查询';
comment on column ${iol_schema}.isbs_bct.bcgans is '回答';
comment on column ${iol_schema}.isbs_bct.docpre is '提示单据';
comment on column ${iol_schema}.isbs_bct.bcgdet is '代收细节';
comment on column ${iol_schema}.isbs_bct.othins is '其他指示';
comment on column ${iol_schema}.isbs_bct.bctfre is '自由文本信息';
comment on column ${iol_schema}.isbs_bct.vesselnam is '船名';
comment on column ${iol_schema}.isbs_bct.covgod is '头寸货物';
comment on column ${iol_schema}.isbs_bct.colins is '收货说明';
comment on column ${iol_schema}.isbs_bct.dftins is '票据说明';
comment on column ${iol_schema}.isbs_bct.chgtxt is '费用文本';
comment on column ${iol_schema}.isbs_bct.intins is '利息说明';
comment on column ${iol_schema}.isbs_bct.fldmodblk is '修改域的列表';
comment on column ${iol_schema}.isbs_bct.reladr is '放货地址';
comment on column ${iol_schema}.isbs_bct.colinssnm is '托收说明';
comment on column ${iol_schema}.isbs_bct.proins is '不符点';
comment on column ${iol_schema}.isbs_bct.contag72 is 'tag72的记录';
comment on column ${iol_schema}.isbs_bct.contag79 is 'tag79的记录';
comment on column ${iol_schema}.isbs_bct.bcgdetdef is '要求说明';
comment on column ${iol_schema}.isbs_bct.bcgdetflg is '要求修改的标志';
comment on column ${iol_schema}.isbs_bct.agtaut is '420电文的43g';
comment on column ${iol_schema}.isbs_bct.agtinf is '420电文的43h';
comment on column ${iol_schema}.isbs_bct.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bct.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bct.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bct.etl_timestamp is 'ETL处理时间戳';
