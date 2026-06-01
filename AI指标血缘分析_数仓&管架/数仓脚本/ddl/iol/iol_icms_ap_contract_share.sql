/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_contract_share
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_contract_share
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_contract_share purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_contract_share(
    serialno varchar2(64) -- 流水号
    ,fee number(24,6) -- 以物抵债费用金额
    ,programno varchar2(64) -- 方案编号
    ,inputuserid varchar2(64) -- 登记人
    ,duebillno varchar2(64) -- 借据编号
    ,contractno varchar2(64) -- 合同编号
    ,principal number(24,6) -- 以物抵债本金金额
    ,remark varchar2(4000) -- 备注
    ,interest number(24,6) -- 以物抵债利息金额
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,plandetailno varchar2(64) -- 明细编号
    ,inputdate date -- 登记日期
    ,deleteflag varchar2(12) -- 删除标识
    ,inputorgid varchar2(64) -- 登记机构
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
grant select on ${iol_schema}.icms_ap_contract_share to ${iml_schema};
grant select on ${iol_schema}.icms_ap_contract_share to ${icl_schema};
grant select on ${iol_schema}.icms_ap_contract_share to ${idl_schema};
grant select on ${iol_schema}.icms_ap_contract_share to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_contract_share is '合同分摊信息';
comment on column ${iol_schema}.icms_ap_contract_share.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_contract_share.fee is '以物抵债费用金额';
comment on column ${iol_schema}.icms_ap_contract_share.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_contract_share.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_contract_share.duebillno is '借据编号';
comment on column ${iol_schema}.icms_ap_contract_share.contractno is '合同编号';
comment on column ${iol_schema}.icms_ap_contract_share.principal is '以物抵债本金金额';
comment on column ${iol_schema}.icms_ap_contract_share.remark is '备注';
comment on column ${iol_schema}.icms_ap_contract_share.interest is '以物抵债利息金额';
comment on column ${iol_schema}.icms_ap_contract_share.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_contract_share.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_contract_share.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_contract_share.plandetailno is '明细编号';
comment on column ${iol_schema}.icms_ap_contract_share.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_contract_share.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_contract_share.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_contract_share.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_contract_share.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_contract_share.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_contract_share.etl_timestamp is 'ETL处理时间戳';
