/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_busfill_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_busfill_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_busfill_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_busfill_info(
    tx_seq_num varchar2(33) -- 业务流水号(交易订单号)-原交易
    ,oritrandate date -- 原交易日期
    ,oritrantime date -- 原交易时间
    ,core_tran_flow_num varchar2(33) -- 全局流水号
    ,tx_org_num varchar2(12) -- 操作机构编号
    ,tx_teller_num varchar2(8) -- 操作柜员编号
    ,maindate date -- 操作日期-yyyyMMdd
    ,maintime date -- 操作时间-yyyyMMdd hhmmss
    ,note1 varchar2(512) -- 备用1
    ,note2 varchar2(512) -- 备用2
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
grant select on ${iol_schema}.nibs_ib_log_busfill_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_busfill_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_busfill_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_busfill_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_busfill_info is '补录信息表';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.tx_seq_num is '业务流水号(交易订单号)-原交易';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.oritrandate is '原交易日期';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.oritrantime is '原交易时间';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.tx_org_num is '操作机构编号';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.tx_teller_num is '操作柜员编号';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.maindate is '操作日期-yyyyMMdd';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.maintime is '操作时间-yyyyMMdd hhmmss';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_log_busfill_info.etl_timestamp is 'ETL处理时间戳';
