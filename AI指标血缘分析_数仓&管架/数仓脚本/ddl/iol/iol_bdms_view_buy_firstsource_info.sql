/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_view_buy_firstsource_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_view_buy_firstsource_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_view_buy_firstsource_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_view_buy_firstsource_info(
    draftid varchar2(60) -- 票据编号
    ,draftnumber varchar2(45) -- 票据号码
    ,cdrange varchar2(38) -- 子票区间
    ,contractid varchar2(60) -- 买入协议编号
    ,productno varchar2(12) -- 产品号
    ,firstsource varchar2(3) -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
    ,firstsourcecustno varchar2(15) -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
    ,firstcustname varchar2(450) -- 交易对手名称
    ,fristbankno varchar2(18) -- 交易对手开户行联行号或交易对手联行号
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
grant select on ${iol_schema}.bdms_view_buy_firstsource_info to ${iml_schema};
grant select on ${iol_schema}.bdms_view_buy_firstsource_info to ${icl_schema};
grant select on ${iol_schema}.bdms_view_buy_firstsource_info to ${idl_schema};
grant select on ${iol_schema}.bdms_view_buy_firstsource_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_view_buy_firstsource_info is '转贴现买入首笔交易对手信息';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.draftid is '票据编号';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.draftnumber is '票据号码';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.cdrange is '子票区间';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.contractid is '买入协议编号';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.productno is '产品号';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.firstsource is '首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.firstsourcecustno is '交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.firstcustname is '交易对手名称';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.fristbankno is '交易对手开户行联行号或交易对手联行号';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_view_buy_firstsource_info.etl_timestamp is 'ETL处理时间戳';
