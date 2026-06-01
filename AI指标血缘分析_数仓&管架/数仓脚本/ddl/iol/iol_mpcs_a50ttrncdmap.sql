/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ttrncdmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ttrncdmap
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ttrncdmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ttrncdmap(
    chnlid varchar2(23) -- 渠道id
    ,transcode varchar2(15) -- 渠道交易码
    ,trncd varchar2(23) -- 交易处理码
    ,msgtype varchar2(6) -- 消息类型
    ,procecode varchar2(9) -- 银联处理码
    ,trnname varchar2(45) -- 交易名称
    ,bdbtrncd varchar2(9) -- 行内处理码
    ,bdttrncd varchar2(9) -- 他行处理码
    ,recordstat varchar2(2) -- 记录状态: 1-有效;0-无效
    ,issndrsk varchar2(2) -- 是否送风控系统
    ,isfallbk varchar2(2) -- 是否禁止降级
    ,isstop varchar2(2) -- 是否禁用
    ,memocd varchar2(15) -- 默认摘要码
    ,memo varchar2(384) -- 摘要码名称
    ,dealtype varchar2(15) -- 自助渠道处理方式
    ,transtp varchar2(15) -- 核心交易类型
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
grant select on ${iol_schema}.mpcs_a50ttrncdmap to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ttrncdmap to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ttrncdmap to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ttrncdmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ttrncdmap is '渠道交易码映射表';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.chnlid is '渠道id';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.transcode is '渠道交易码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.trncd is '交易处理码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.procecode is '银联处理码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.trnname is '交易名称';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.bdbtrncd is '行内处理码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.bdttrncd is '他行处理码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.recordstat is '记录状态: 1-有效;0-无效';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.issndrsk is '是否送风控系统';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.isfallbk is '是否禁止降级';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.isstop is '是否禁用';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.memocd is '默认摘要码';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.memo is '摘要码名称';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.dealtype is '自助渠道处理方式';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.transtp is '核心交易类型';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a50ttrncdmap.etl_timestamp is 'ETL处理时间戳';
