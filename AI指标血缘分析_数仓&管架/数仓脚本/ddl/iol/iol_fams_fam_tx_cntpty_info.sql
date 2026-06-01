/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fam_tx_cntpty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fam_tx_cntpty_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fam_tx_cntpty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fam_tx_cntpty_info(
    cdate date -- 日期
    ,core_tran_flow_num varchar2(33) -- 全局流水号
    ,biz_seq_num varchar2(32) -- 系统流水号
    ,tran_num varchar2(32) -- 交易序号
    ,tx_cntpty_acct_num varchar2(50) -- 交易对手账号
    ,tx_cntpty_name varchar2(200) -- 交易对手名称
    ,cntpty_fin_inst_brac_cd varchar2(20) -- 交易对手行号
    ,cntpty_fin_inst_brac_name varchar2(300) -- 交易对手行名
    ,tx_cntpty_dist varchar2(1) -- 对手银行所在行政区划
    ,tx_cntpty_cert_type varchar2(1) -- 交易对手证件类型
    ,tx_cntpty_cert_no varchar2(1) -- 交易对手证件号码
    ,tx_cntpty_cd_type varchar2(1) -- 交易对手行号类型
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
grant select on ${iol_schema}.fams_fam_tx_cntpty_info to ${iml_schema};
grant select on ${iol_schema}.fams_fam_tx_cntpty_info to ${icl_schema};
grant select on ${iol_schema}.fams_fam_tx_cntpty_info to ${idl_schema};
grant select on ${iol_schema}.fams_fam_tx_cntpty_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fam_tx_cntpty_info is '资管交易对手信息';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.cdate is '日期';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.biz_seq_num is '系统流水号';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tran_num is '交易序号';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_acct_num is '交易对手账号';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_name is '交易对手名称';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.cntpty_fin_inst_brac_cd is '交易对手行号';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.cntpty_fin_inst_brac_name is '交易对手行名';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_dist is '对手银行所在行政区划';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_cert_type is '交易对手证件类型';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_cert_no is '交易对手证件号码';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.tx_cntpty_cd_type is '交易对手行号类型';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_fam_tx_cntpty_info.etl_timestamp is 'ETL处理时间戳';
