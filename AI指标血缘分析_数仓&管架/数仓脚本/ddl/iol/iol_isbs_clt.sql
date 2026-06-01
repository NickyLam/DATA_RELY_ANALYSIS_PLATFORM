/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_clt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_clt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_clt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_clt(
    inr varchar2(12) -- 光票托收委托托收id号
    ,resrej varchar2(1080) -- 拒付的原因
    ,bcgque varchar2(324) -- 查询信息
    ,bcgans varchar2(324) -- 回答信息
    ,strinf varchar2(324) -- 给收单行的信息
    ,intrem varchar2(495) -- 备注
    ,selmt varchar2(5) -- swift报文类型
    ,cctfre varchar2(990) -- 自由文本
    ,coradrblk varchar2(216) -- 汇票受票人地址块
    ,droadrblk varchar2(216) -- 付款行地址块
    ,preadrblk varchar2(216) -- 托收人/收款人地址块
    ,nobadrblk varchar2(216) -- 清算行地址块
    ,dftins varchar2(458) -- 单据说明
    ,chgtxt varchar2(324) -- 费用文本
    ,intins varchar2(458) -- 内部说明
    ,setins varchar2(594) -- 结算说明
    ,narhis varchar2(4000) -- 历史备注信息
    ,inftxt varchar2(366) -- 信息文本
    ,coladrblk varchar2(216) -- 代收行地址块
    ,docpre varchar2(752) -- 被提供的文档
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
grant select on ${iol_schema}.isbs_clt to ${iml_schema};
grant select on ${iol_schema}.isbs_clt to ${icl_schema};
grant select on ${iol_schema}.isbs_clt to ${idl_schema};
grant select on ${iol_schema}.isbs_clt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_clt is '光票托收(打包托收)业务信息(存放长字节)';
comment on column ${iol_schema}.isbs_clt.inr is '光票托收委托托收id号';
comment on column ${iol_schema}.isbs_clt.resrej is '拒付的原因';
comment on column ${iol_schema}.isbs_clt.bcgque is '查询信息';
comment on column ${iol_schema}.isbs_clt.bcgans is '回答信息';
comment on column ${iol_schema}.isbs_clt.strinf is '给收单行的信息';
comment on column ${iol_schema}.isbs_clt.intrem is '备注';
comment on column ${iol_schema}.isbs_clt.selmt is 'swift报文类型';
comment on column ${iol_schema}.isbs_clt.cctfre is '自由文本';
comment on column ${iol_schema}.isbs_clt.coradrblk is '汇票受票人地址块';
comment on column ${iol_schema}.isbs_clt.droadrblk is '付款行地址块';
comment on column ${iol_schema}.isbs_clt.preadrblk is '托收人/收款人地址块';
comment on column ${iol_schema}.isbs_clt.nobadrblk is '清算行地址块';
comment on column ${iol_schema}.isbs_clt.dftins is '单据说明';
comment on column ${iol_schema}.isbs_clt.chgtxt is '费用文本';
comment on column ${iol_schema}.isbs_clt.intins is '内部说明';
comment on column ${iol_schema}.isbs_clt.setins is '结算说明';
comment on column ${iol_schema}.isbs_clt.narhis is '历史备注信息';
comment on column ${iol_schema}.isbs_clt.inftxt is '信息文本';
comment on column ${iol_schema}.isbs_clt.coladrblk is '代收行地址块';
comment on column ${iol_schema}.isbs_clt.docpre is '被提供的文档';
comment on column ${iol_schema}.isbs_clt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_clt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_clt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_clt.etl_timestamp is 'ETL处理时间戳';
