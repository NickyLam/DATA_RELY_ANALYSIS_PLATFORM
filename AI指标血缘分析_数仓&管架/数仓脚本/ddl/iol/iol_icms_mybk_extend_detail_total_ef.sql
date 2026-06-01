/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_extend_detail_total_ef
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_extend_detail_total_ef
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_extend_detail_total_ef purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_extend_detail_total_ef(
    contractno varchar2(64) -- 融资平台贷款合约号
    ,settledate varchar2(64) -- 会计日期，格式：yyyy-MM-dd hh:mm:ss
    ,extendcode varchar2(64) -- 0-调整转出，1-调整转入
    ,seqno varchar2(64) -- 调整流水号
    ,termno varchar2(64) -- 期次号
    ,startdate varchar2(64) -- 分期开始日期，格式：yyyy-MM-dd hh:mm:ss
    ,enddate varchar2(64) -- 分期结束日期，格式：yyyy-MM-dd hh:mm:ss
    ,prinamt number(24,6) -- 正常本金金额
    ,ovdprinamt number(24,6) -- 逾期本金金额
    ,intamt number(24,6) -- 正常利息金额
    ,ovdintamt number(24,6) -- 逾期利息金额
    ,ovdprinpnltamt number(24,6) -- 本金罚息金额
    ,ovdintpnltamt number(24,6) -- 利息罚息金额
    ,status varchar2(64) -- 分期状态，正常NORMAL,逾期OVD,结清CLEAR
    ,accruedstatus varchar2(64) -- 应计非应计标识，应计0，非应计1
    ,writeoff varchar2(64) -- 核销标识，已核销为Y，否则为N
    ,bsntype varchar2(64) -- 产品业务类型，具体值合作产品上线后才给出
    ,subiproleid varchar2(64) -- 代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空
    ,contracttype varchar2(64) -- 借据类型
    ,batchdate varchar2(64) -- 批次日期
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
grant select on ${iol_schema}.icms_mybk_extend_detail_total_ef to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_extend_detail_total_ef to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_extend_detail_total_ef to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_extend_detail_total_ef to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_extend_detail_total_ef is '还款计划调整明细文件汇总表';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.contractno is '融资平台贷款合约号';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.settledate is '会计日期，格式：yyyy-MM-dd hh:mm:ss';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.extendcode is '0-调整转出，1-调整转入';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.seqno is '调整流水号';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.startdate is '分期开始日期，格式：yyyy-MM-dd hh:mm:ss';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.enddate is '分期结束日期，格式：yyyy-MM-dd hh:mm:ss';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.prinamt is '正常本金金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.ovdprinamt is '逾期本金金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.intamt is '正常利息金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.ovdintamt is '逾期利息金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.ovdprinpnltamt is '本金罚息金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.ovdintpnltamt is '利息罚息金额';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.status is '分期状态，正常NORMAL,逾期OVD,结清CLEAR';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.bsntype is '产品业务类型，具体值合作产品上线后才给出';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.subiproleid is '代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.contracttype is '借据类型';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.batchdate is '批次日期';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_extend_detail_total_ef.etl_timestamp is 'ETL处理时间戳';
