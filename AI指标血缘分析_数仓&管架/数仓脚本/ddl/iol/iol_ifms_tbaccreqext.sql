/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbaccreqext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbaccreqext
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbaccreqext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbaccreqext(
    serial_no varchar2(48) -- 流水号
    ,ex_serial varchar2(48) -- 渠道流水号
    ,cfm_no varchar2(48) -- 确认编号
    ,trans_date number(22,0) -- 交易日期
    ,trans_time number(22,0) -- 交易时间
    ,ta_code varchar2(18) -- ta代码
    ,in_client_no varchar2(30) -- 内部客户号
    ,glblsrlno varchar2(64) -- 全局流水号
    ,cnsmrsysid varchar2(48) -- 系统id
    ,cnltxncd varchar2(96) -- 渠道号
    ,reserve1 varchar2(375) -- 备用字段
    ,reserve2 varchar2(375) -- 备用字段
    ,reserve3 varchar2(375) -- 备用字段
    ,reserve4 varchar2(375) -- 备用字段
    ,reserve5 varchar2(375) -- 备用字段
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
grant select on ${iol_schema}.ifms_tbaccreqext to ${iml_schema};
grant select on ${iol_schema}.ifms_tbaccreqext to ${icl_schema};
grant select on ${iol_schema}.ifms_tbaccreqext to ${idl_schema};
grant select on ${iol_schema}.ifms_tbaccreqext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbaccreqext is '账户请求拓展表';
comment on column ${iol_schema}.ifms_tbaccreqext.serial_no is '流水号';
comment on column ${iol_schema}.ifms_tbaccreqext.ex_serial is '渠道流水号';
comment on column ${iol_schema}.ifms_tbaccreqext.cfm_no is '确认编号';
comment on column ${iol_schema}.ifms_tbaccreqext.trans_date is '交易日期';
comment on column ${iol_schema}.ifms_tbaccreqext.trans_time is '交易时间';
comment on column ${iol_schema}.ifms_tbaccreqext.ta_code is 'ta代码';
comment on column ${iol_schema}.ifms_tbaccreqext.in_client_no is '内部客户号';
comment on column ${iol_schema}.ifms_tbaccreqext.glblsrlno is '全局流水号';
comment on column ${iol_schema}.ifms_tbaccreqext.cnsmrsysid is '系统id';
comment on column ${iol_schema}.ifms_tbaccreqext.cnltxncd is '渠道号';
comment on column ${iol_schema}.ifms_tbaccreqext.reserve1 is '备用字段';
comment on column ${iol_schema}.ifms_tbaccreqext.reserve2 is '备用字段';
comment on column ${iol_schema}.ifms_tbaccreqext.reserve3 is '备用字段';
comment on column ${iol_schema}.ifms_tbaccreqext.reserve4 is '备用字段';
comment on column ${iol_schema}.ifms_tbaccreqext.reserve5 is '备用字段';
comment on column ${iol_schema}.ifms_tbaccreqext.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbaccreqext.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbaccreqext.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbaccreqext.etl_timestamp is 'ETL处理时间戳';
