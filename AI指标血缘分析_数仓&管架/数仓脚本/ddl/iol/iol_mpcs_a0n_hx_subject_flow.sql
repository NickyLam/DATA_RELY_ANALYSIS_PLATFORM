/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0n_hx_subject_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0n_hx_subject_flow
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0n_hx_subject_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0n_hx_subject_flow(
    sourst varchar2(45) -- 系统代号
    ,bsnssq varchar2(50) -- 全局流水号
    ,sourdt varchar2(12) -- 源系统日期
    ,soursq varchar2(96) -- 源系统流水号
    ,vchrsq varchar2(30) -- 传票序号
    ,itemcd varchar2(45) -- 科目编号
    ,acctbr varchar2(14) -- 账务机构编号
    ,tranbr varchar2(14) -- 交易机构编号
    ,crcycd varchar2(5) -- 币种
    ,prcscd varchar2(24) -- 交易码
    ,tranam number(20,2) -- 交易金额
    ,amntcd varchar2(2) -- 借贷方向
    ,smrytx varchar2(600) -- 摘要
    ,custcd varchar2(45) -- 客户号
    ,assis8 varchar2(45) -- 产品
    ,acctno varchar2(45) -- 协议编号
    ,assis0 varchar2(45) -- 辅助核算0
    ,assis1 varchar2(45) -- 辅助核算1
    ,assis2 varchar2(45) -- 辅助核算2
    ,assis3 varchar2(45) -- 辅助核算3
    ,assis4 varchar2(45) -- 辅助核算4
    ,assis5 varchar2(45) -- 辅助核算5
    ,assis6 varchar2(45) -- 辅助核算6
    ,assis7 varchar2(45) -- 辅助核算7
    ,prducd varchar2(24) -- 辅助核算8
    ,assis9 varchar2(45) -- 辅助核算9
    ,datex0 varchar2(45) -- 交易时间
    ,chrex0 varchar2(45) -- 交易用户
    ,chrex1 varchar2(45) -- 授权用户
    ,chrex3 varchar2(96) -- 冲抹原交易流水号
    ,taxam number(20,2) -- 税额
    ,chrex4 varchar2(45) -- 冲抹标记
    ,cbsflag varchar2(2) -- 是否核心记账  1-是 0-否
    ,inneracct varchar2(48) -- 核心记账内部户
    ,status varchar2(2) -- 核心记账状态 0-未记账  1-记账成功 2-异常
    ,transeq varchar2(96) -- 核心记账交易流水
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
grant select on ${iol_schema}.mpcs_a0n_hx_subject_flow to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_flow to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_flow to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0n_hx_subject_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0n_hx_subject_flow is '微粒贷核算中台会记流水表';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.sourst is '系统代号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.bsnssq is '全局流水号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.sourdt is '源系统日期';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.soursq is '源系统流水号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.vchrsq is '传票序号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.itemcd is '科目编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.acctbr is '账务机构编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.tranbr is '交易机构编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.crcycd is '币种';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.prcscd is '交易码';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.tranam is '交易金额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.amntcd is '借贷方向';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.smrytx is '摘要';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.custcd is '客户号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis8 is '产品';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.acctno is '协议编号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis0 is '辅助核算0';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis1 is '辅助核算1';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis2 is '辅助核算2';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis3 is '辅助核算3';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis4 is '辅助核算4';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis5 is '辅助核算5';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis6 is '辅助核算6';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis7 is '辅助核算7';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.prducd is '辅助核算8';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.assis9 is '辅助核算9';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.datex0 is '交易时间';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.chrex0 is '交易用户';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.chrex1 is '授权用户';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.chrex3 is '冲抹原交易流水号';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.taxam is '税额';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.chrex4 is '冲抹标记';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.cbsflag is '是否核心记账  1-是 0-否';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.inneracct is '核心记账内部户';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.status is '核心记账状态 0-未记账  1-记账成功 2-异常';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.transeq is '核心记账交易流水';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0n_hx_subject_flow.etl_timestamp is 'ETL处理时间戳';
