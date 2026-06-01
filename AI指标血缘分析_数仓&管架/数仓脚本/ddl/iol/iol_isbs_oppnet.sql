/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_oppnet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_oppnet
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_oppnet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_oppnet(
    inr varchar2(12) -- 主键inr
    ,gltyp varchar2(12) -- 接口表
    ,glinr varchar2(12) -- 接口表的inr
    ,gldate varchar2(12) -- 记账日期
    ,trninr varchar2(12) -- trn表的inr
    ,core_tran_flow_num varchar2(50) -- 全局流水号
    ,biz_seq_num varchar2(50) -- 系统流水号
    ,biz_seq_no varchar2(3) -- 交易序号
    ,biz_ccy varchar2(5) -- 币种
    ,biz_amt number(18,3) -- 金额
    ,pty_extkey varchar2(36) -- 分录账号的客户号
    ,pty_name varchar2(120) -- 分录账号的名称
    ,pty_acct_num varchar2(75) -- 分录账号
    ,pty_acct_no varchar2(8) -- 分录账号序号
    ,tran_type varchar2(2) -- 借贷方向
    ,tx_cntpty_acct_num varchar2(75) -- 交易对手账号
    ,tx_cntpty_name varchar2(120) -- 交易对手名称
    ,cntpty_fin_inst_brac_cd varchar2(75) -- 交易对手行号
    ,cntpty_fin_inst_brac_name varchar2(120) -- 交易对手行名
    ,dist varchar2(60) -- 对手银行所在地行政区划
    ,tx_cntpty_cert_type varchar2(6) -- 交易对手证件类型
    ,tx_cntpty_cert_type_txt varchar2(120) -- 交易对手证件类型中文描述
    ,tx_cntpty_cert_no varchar2(48) -- 交易对手证件号码
    ,cd_typ varchar2(2) -- 交易对手行号类型
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
grant select on ${iol_schema}.isbs_oppnet to ${iml_schema};
grant select on ${iol_schema}.isbs_oppnet to ${icl_schema};
grant select on ${iol_schema}.isbs_oppnet to ${idl_schema};
grant select on ${iol_schema}.isbs_oppnet to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_oppnet is '对手方信息表';
comment on column ${iol_schema}.isbs_oppnet.inr is '主键inr';
comment on column ${iol_schema}.isbs_oppnet.gltyp is '接口表';
comment on column ${iol_schema}.isbs_oppnet.glinr is '接口表的inr';
comment on column ${iol_schema}.isbs_oppnet.gldate is '记账日期';
comment on column ${iol_schema}.isbs_oppnet.trninr is 'trn表的inr';
comment on column ${iol_schema}.isbs_oppnet.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.isbs_oppnet.biz_seq_num is '系统流水号';
comment on column ${iol_schema}.isbs_oppnet.biz_seq_no is '交易序号';
comment on column ${iol_schema}.isbs_oppnet.biz_ccy is '币种';
comment on column ${iol_schema}.isbs_oppnet.biz_amt is '金额';
comment on column ${iol_schema}.isbs_oppnet.pty_extkey is '分录账号的客户号';
comment on column ${iol_schema}.isbs_oppnet.pty_name is '分录账号的名称';
comment on column ${iol_schema}.isbs_oppnet.pty_acct_num is '分录账号';
comment on column ${iol_schema}.isbs_oppnet.pty_acct_no is '分录账号序号';
comment on column ${iol_schema}.isbs_oppnet.tran_type is '借贷方向';
comment on column ${iol_schema}.isbs_oppnet.tx_cntpty_acct_num is '交易对手账号';
comment on column ${iol_schema}.isbs_oppnet.tx_cntpty_name is '交易对手名称';
comment on column ${iol_schema}.isbs_oppnet.cntpty_fin_inst_brac_cd is '交易对手行号';
comment on column ${iol_schema}.isbs_oppnet.cntpty_fin_inst_brac_name is '交易对手行名';
comment on column ${iol_schema}.isbs_oppnet.dist is '对手银行所在地行政区划';
comment on column ${iol_schema}.isbs_oppnet.tx_cntpty_cert_type is '交易对手证件类型';
comment on column ${iol_schema}.isbs_oppnet.tx_cntpty_cert_type_txt is '交易对手证件类型中文描述';
comment on column ${iol_schema}.isbs_oppnet.tx_cntpty_cert_no is '交易对手证件号码';
comment on column ${iol_schema}.isbs_oppnet.cd_typ is '交易对手行号类型';
comment on column ${iol_schema}.isbs_oppnet.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_oppnet.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_oppnet.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_oppnet.etl_timestamp is 'ETL处理时间戳';
