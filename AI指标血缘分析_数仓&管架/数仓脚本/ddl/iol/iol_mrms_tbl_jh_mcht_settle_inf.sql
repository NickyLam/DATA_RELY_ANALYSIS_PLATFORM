/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_jh_mcht_settle_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf(
    agent_cd varchar2(23) -- 代理编号
    ,mcht_no varchar2(23) -- 商户号
    ,settle_mode varchar2(2) -- 商户本金清算模式
    ,settle_type varchar2(6) -- 商户结算方式
    ,settle_bank_no varchar2(60) -- 商户结算帐户开户行
    ,settle_bank_nm varchar2(384) -- 商户结算帐户开户行名称
    ,settle_acct_nm varchar2(384) -- 商户结算帐户户名
    ,settle_acct varchar2(60) -- 商户结算帐户号
    ,acct_type varchar2(3) -- 账户类型
    ,open_acct_area varchar2(90) -- 开户地区
    ,open_acct_addr varchar2(768) -- 开户地址
    ,t0_algo_id varchar2(18) -- t1打款成本算法id
    ,t1_algo_id varchar2(18) -- d0打款成本算法id
    ,rec_upd_ts varchar2(21) -- 记录更新时间
    ,rec_crt_ts varchar2(21) -- 记录创建时间
    ,misc_1 varchar2(384) -- 保留字段1
    ,misc_2 varchar2(384) -- 保留字段2
    ,misc_3 varchar2(384) -- 保留字段3
    ,misc_flag varchar2(45) -- 保留标识1
    ,reserved varchar2(90) -- 保留
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
grant select on ${iol_schema}.mrms_tbl_jh_mcht_settle_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_settle_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_settle_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_settle_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_jh_mcht_settle_inf is '商户清算信息表';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.agent_cd is '代理编号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_mode is '商户本金清算模式';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_type is '商户结算方式';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_bank_no is '商户结算帐户开户行';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_bank_nm is '商户结算帐户开户行名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_acct_nm is '商户结算帐户户名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.settle_acct is '商户结算帐户号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.acct_type is '账户类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.open_acct_area is '开户地区';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.open_acct_addr is '开户地址';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.t0_algo_id is 't1打款成本算法id';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.t1_algo_id is 'd0打款成本算法id';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.rec_upd_ts is '记录更新时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.rec_crt_ts is '记录创建时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.misc_1 is '保留字段1';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.misc_2 is '保留字段2';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.misc_3 is '保留字段3';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.misc_flag is '保留标识1';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.reserved is '保留';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_settle_inf.etl_timestamp is 'ETL处理时间戳';
