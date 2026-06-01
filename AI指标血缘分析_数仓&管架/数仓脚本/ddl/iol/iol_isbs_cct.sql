/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cct
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cct(
    inr varchar2(12) -- 光票托收id号
    ,resrej varchar2(1080) -- 拒付的原因
    ,docpre varchar2(4000) -- 交来的单据列表
    ,bcgque varchar2(324) -- 查询信息
    ,bcgans varchar2(324) -- 回答信息
    ,strinf varchar2(324) -- 给收单行的信息
    ,intrem varchar2(495) -- 备注
    ,selmt varchar2(5) -- swift报文类型
    ,cctfre varchar2(990) -- 自由文本
    ,coradrblk varchar2(216) -- 汇票受票行地址块
    ,droadrblk varchar2(216) -- 付款行地址块
    ,preadrblk varchar2(216) -- 托收人/收款人地址块
    ,nobadrblk varchar2(216) -- 清算行地址块
    ,dftins varchar2(458) -- 票据说明
    ,chgtxt varchar2(324) -- 费用文本
    ,intins varchar2(458) -- 内部说明
    ,setins varchar2(594) -- 结算说明
    ,narhis varchar2(4000) -- 历史备注信息
    ,inftxt varchar2(366) -- 信息文本
    ,coladrblk varchar2(216) -- 代收行地址块
    ,retson varchar2(1080) -- 退单理由
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
grant select on ${iol_schema}.isbs_cct to ${iml_schema};
grant select on ${iol_schema}.isbs_cct to ${icl_schema};
grant select on ${iol_schema}.isbs_cct to ${idl_schema};
grant select on ${iol_schema}.isbs_cct to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cct is '光票托收(单笔票据)业务信息(存放长字)';
comment on column ${iol_schema}.isbs_cct.inr is '光票托收id号';
comment on column ${iol_schema}.isbs_cct.resrej is '拒付的原因';
comment on column ${iol_schema}.isbs_cct.docpre is '交来的单据列表';
comment on column ${iol_schema}.isbs_cct.bcgque is '查询信息';
comment on column ${iol_schema}.isbs_cct.bcgans is '回答信息';
comment on column ${iol_schema}.isbs_cct.strinf is '给收单行的信息';
comment on column ${iol_schema}.isbs_cct.intrem is '备注';
comment on column ${iol_schema}.isbs_cct.selmt is 'swift报文类型';
comment on column ${iol_schema}.isbs_cct.cctfre is '自由文本';
comment on column ${iol_schema}.isbs_cct.coradrblk is '汇票受票行地址块';
comment on column ${iol_schema}.isbs_cct.droadrblk is '付款行地址块';
comment on column ${iol_schema}.isbs_cct.preadrblk is '托收人/收款人地址块';
comment on column ${iol_schema}.isbs_cct.nobadrblk is '清算行地址块';
comment on column ${iol_schema}.isbs_cct.dftins is '票据说明';
comment on column ${iol_schema}.isbs_cct.chgtxt is '费用文本';
comment on column ${iol_schema}.isbs_cct.intins is '内部说明';
comment on column ${iol_schema}.isbs_cct.setins is '结算说明';
comment on column ${iol_schema}.isbs_cct.narhis is '历史备注信息';
comment on column ${iol_schema}.isbs_cct.inftxt is '信息文本';
comment on column ${iol_schema}.isbs_cct.coladrblk is '代收行地址块';
comment on column ${iol_schema}.isbs_cct.retson is '退单理由';
comment on column ${iol_schema}.isbs_cct.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cct.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cct.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cct.etl_timestamp is 'ETL处理时间戳';
