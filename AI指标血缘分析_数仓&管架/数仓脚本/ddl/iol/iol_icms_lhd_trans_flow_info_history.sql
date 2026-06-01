/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhd_trans_flow_info_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhd_trans_flow_info_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhd_trans_flow_info_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhd_trans_flow_info_history(
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
    ,normalintamt number(24,6) -- 正常利息
    ,normalodpamt number(24,6) -- 正常罚息
    ,normalodiamt number(24,6) -- 正常复利
    ,intpamt number(24,6) -- 逾期利息
    ,odppamt number(24,6) -- 逾期罚息
    ,odipamt number(24,6) -- 逾期复利
    ,batchno varchar2(36) -- 批次号
    ,sendflag varchar2(2) -- 是否上送（1上送成功，null未上送，0上送失败）
    ,compflag varchar2(2) -- 是否代偿（1是，其他为否）
    ,bizdate varchar2(10) -- 数据日期
    ,type varchar2(10) -- 类型
    ,globseqnum varchar2(200) -- 全局流水号
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
grant select on ${iol_schema}.icms_lhd_trans_flow_info_history to ${iml_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info_history to ${icl_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info_history to ${idl_schema};
grant select on ${iol_schema}.icms_lhd_trans_flow_info_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhd_trans_flow_info_history is '信贷供交易流水文件临时表历史表';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.serialno is '流水号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.duebillno is '信贷借据号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.accountdate is '账务日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.transno is '交易流水号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.transtype is '交易类型';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.transamt is '交易金额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.noaccstatus is '非应计状态';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.prioccamt is '本金发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.intoccamt is '利息发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.defintoccamt is '罚息发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.czflag is '冲正标识';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.channel is '渠道';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.transdate is '交易时间戳';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.transorgid is '交易机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.migttype is '交易标志';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.compintoccamt is '复利发生额';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.hxduebillno is '核心借据号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.normalintamt is '正常利息';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.normalodpamt is '正常罚息';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.normalodiamt is '正常复利';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.intpamt is '逾期利息';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.odppamt is '逾期罚息';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.odipamt is '逾期复利';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.batchno is '批次号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.sendflag is '是否上送（1上送成功，null未上送，0上送失败）';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.compflag is '是否代偿（1是，其他为否）';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.bizdate is '数据日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.type is '类型';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.globseqnum is '全局流水号';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhd_trans_flow_info_history.etl_timestamp is 'ETL处理时间戳';
