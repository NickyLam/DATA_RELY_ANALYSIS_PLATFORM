/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_vi_tbs_account_cptys_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_vi_tbs_account_cptys_info
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_vi_tbs_account_cptys_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vi_tbs_account_cptys_info(
    core_tran_flow_num varchar2(384) -- 全局流水号
    ,biz_seq_num varchar2(15) -- 系统流水号
    ,seq varchar2(30) -- 交易序号
    ,tx_cntpty_acct_num varchar2(96) -- 交易对手账号
    ,tx_cntpty_name varchar2(192) -- 交易对手名称
    ,cntpty_fin_inst_brac_cd varchar2(384) -- 交易对手行号
    ,cntpty_fin_inst_brac_name varchar2(384) -- 交易对手行名
    ,dist varchar2(384) -- 对手银行所在地行政区划
    ,tx_cntpty_cert_type varchar2(384) -- 交易对手证件类型
    ,tx_cntpty_cert_no varchar2(384) -- 交易对手证件号码
    ,cpty_type varchar2(384) -- 交易对手行号类型
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
grant select on ${iol_schema}.ctms_vi_tbs_account_cptys_info to ${iml_schema};
grant select on ${iol_schema}.ctms_vi_tbs_account_cptys_info to ${icl_schema};
grant select on ${iol_schema}.ctms_vi_tbs_account_cptys_info to ${idl_schema};
grant select on ${iol_schema}.ctms_vi_tbs_account_cptys_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_vi_tbs_account_cptys_info is '资金交易对手_本币';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.biz_seq_num is '系统流水号';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.seq is '交易序号';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.tx_cntpty_acct_num is '交易对手账号';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.tx_cntpty_name is '交易对手名称';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.cntpty_fin_inst_brac_cd is '交易对手行号';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.cntpty_fin_inst_brac_name is '交易对手行名';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.dist is '对手银行所在地行政区划';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.tx_cntpty_cert_type is '交易对手证件类型';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.tx_cntpty_cert_no is '交易对手证件号码';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.cpty_type is '交易对手行号类型';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_vi_tbs_account_cptys_info.etl_timestamp is 'ETL处理时间戳';
