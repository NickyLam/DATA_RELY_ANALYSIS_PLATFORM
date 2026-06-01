/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_fdm_prod_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl(
    tran_type_cd varchar2(90) -- 交易码
    ,prod_id varchar2(90) -- 产品编号
    ,curr_cd varchar2(15) -- 币种代码
    ,tran_dt varchar2(30) -- 交易日期
    ,enter_acct_dt varchar2(30) -- 入账日期
    ,agt_duty_center_id varchar2(45) -- 协议责任中心编号
    ,tran_duty_center_id varchar2(45) -- 交易责任中心编号
    ,tran_amt number(18,2) -- 交易金额
    ,data_src_cd varchar2(6) -- 数据来源代码
    ,chn_typ_cd varchar2(6) -- 渠道类型代码
    ,global_chn_seq_num varchar2(90) -- 全局渠道流水号
    ,evt_id varchar2(90) -- 事件编号
    ,agt_id varchar2(90) -- 协议编号
    ,agt_bal number(18,2) -- 协议余额
    ,org_id varchar2(45) -- 机构编号
    ,pty_typ_cd varchar2(3) -- 客户类型代码
    ,reverse_flg varchar2(3) -- 是否冲正
    ,reverse_evt_id varchar2(90) -- 冲正事件编号
    ,bal_typ_cd varchar2(3) -- 余额类型代码
    ,acct_categ_cd varchar2(6) -- 会计类别代码
    ,debit_crdt_dir_cd varchar2(3) -- 金额方向
    ,etl_dt_ora varchar2(30) -- 数据日期
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
grant select on ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl to ${iml_schema};
grant select on ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl to ${icl_schema};
grant select on ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl to ${idl_schema};
grant select on ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl is 'FDM交易明细接口表';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.tran_type_cd is '交易码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.prod_id is '产品编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.curr_cd is '币种代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.enter_acct_dt is '入账日期';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.agt_duty_center_id is '协议责任中心编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.tran_duty_center_id is '交易责任中心编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.chn_typ_cd is '渠道类型代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.global_chn_seq_num is '全局渠道流水号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.evt_id is '事件编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.agt_id is '协议编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.agt_bal is '协议余额';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.org_id is '机构编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.pty_typ_cd is '客户类型代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.reverse_flg is '是否冲正';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.reverse_evt_id is '冲正事件编号';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.bal_typ_cd is '余额类型代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.acct_categ_cd is '会计类别代码';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.debit_crdt_dir_cd is '金额方向';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_fdm_prod_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
