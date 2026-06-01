/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhd_trans_flow_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhd_trans_flow_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhd_trans_flow_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_trans_flow_info(
    serialno varchar2(64) -- 流水号
    ,duebillno varchar2(64) -- 信贷借据号
    ,accountdate varchar2(10) -- 账务日期
    ,transno varchar2(64) -- 交易流水号
    ,transtype varchar2(10) -- 交易类型
    ,transamt number(24,6) -- 交易金额
    ,noaccstatus varchar2(10) -- 非应计状态
    ,prioccamt number(24,6) -- 本金发生额
    ,intoccamt number(24,6) -- 利息发生额
    ,defintoccamt number(24,6) -- 罚息发生额
    ,czflag varchar2(10) -- 冲正标识
    ,channel varchar2(20) -- 渠道
    ,transdate varchar2(32) -- 交易时间戳
    ,transorgid varchar2(20) -- 交易机构
    ,migttype varchar2(10) -- 交易标志
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,compintoccamt number(24,6) -- 复利发生额
    ,hxduebillno varchar2(30) -- 核心借据号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_lhd_trans_flow_info to ${iml_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info to ${icl_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info to ${idl_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhd_trans_flow_info is '信贷供交易流水文件临时表';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.duebillno is '信贷借据号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.accountdate is '账务日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.transno is '交易流水号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.transtype is '交易类型';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.transamt is '交易金额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.noaccstatus is '非应计状态';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.prioccamt is '本金发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.intoccamt is '利息发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.defintoccamt is '罚息发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.czflag is '冲正标识';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.channel is '渠道';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.transdate is '交易时间戳';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.transorgid is '交易机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.migttype is '交易标志';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.compintoccamt is '复利发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.hxduebillno is '核心借据号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info.etl_timestamp is 'ETL处理时间戳';
