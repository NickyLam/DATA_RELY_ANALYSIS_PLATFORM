/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_dpc_draft_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_dpc_draft_status
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_dpc_draft_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_draft_status(
    id varchar2(60) -- 
    ,trans_no varchar2(15) -- 交易编号
    ,trans_name varchar2(225) -- 交易名称
    ,pre_status varchar2(600) -- 前置状态：票据来源_票据状态
    ,store_status varchar2(9) -- 实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中
    ,risk_status varchar2(45) -- 风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决
    ,settle_flag varchar2(5) -- 是否结清： 0 否 1 是
    ,recovery_flag varchar2(15) -- 追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿
    ,reserve varchar2(150) -- 备注
    ,create_by varchar2(24) -- 
    ,create_time varchar2(45) -- 
    ,last_upd_opr varchar2(24) -- 
    ,last_upd_time varchar2(24) -- 
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
grant select on ${iol_schema}.bdms_dpc_draft_status to ${iml_schema};
grant select on ${iol_schema}.bdms_dpc_draft_status to ${icl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_status to ${idl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_dpc_draft_status is '登记中心票据状态表';
comment on column ${iol_schema}.bdms_dpc_draft_status.id is '';
comment on column ${iol_schema}.bdms_dpc_draft_status.trans_no is '交易编号';
comment on column ${iol_schema}.bdms_dpc_draft_status.trans_name is '交易名称';
comment on column ${iol_schema}.bdms_dpc_draft_status.pre_status is '前置状态：票据来源_票据状态';
comment on column ${iol_schema}.bdms_dpc_draft_status.store_status is '实物库存状态： SS00 无效 SS01 未保管 SS02 在库 SS03 已出库 SS05 出库锁定中';
comment on column ${iol_schema}.bdms_dpc_draft_status.risk_status is '风险票据状态： RS00 非风险票据 RS01 挂失止付 RS02 公示催告 RS03 司法冻结 RS05 争议票据 RS06 除权判决';
comment on column ${iol_schema}.bdms_dpc_draft_status.settle_flag is '是否结清： 0 否 1 是';
comment on column ${iol_schema}.bdms_dpc_draft_status.recovery_flag is '追偿标识： 0 未追偿 1 拒付追偿 2 余额不足追偿';
comment on column ${iol_schema}.bdms_dpc_draft_status.reserve is '备注';
comment on column ${iol_schema}.bdms_dpc_draft_status.create_by is '';
comment on column ${iol_schema}.bdms_dpc_draft_status.create_time is '';
comment on column ${iol_schema}.bdms_dpc_draft_status.last_upd_opr is '';
comment on column ${iol_schema}.bdms_dpc_draft_status.last_upd_time is '';
comment on column ${iol_schema}.bdms_dpc_draft_status.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_dpc_draft_status.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_dpc_draft_status.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_dpc_draft_status.etl_timestamp is 'ETL处理时间戳';
