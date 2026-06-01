/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_tbl_acct_trans_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_tbl_acct_trans_flow
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_tbl_acct_trans_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_tbl_acct_trans_flow(
    id varchar2(60) -- 主键
    ,systid varchar2(45) -- 系统代号
    ,trandt varchar2(12) -- 交易日期
    ,bsnssq varchar2(50) -- 全局流水
    ,transq varchar2(96) -- 交易流水
    ,serino varchar2(30) -- 序号
    ,tranbr varchar2(18) -- 交易机构编号
    ,acctbr varchar2(14) -- 账务机构编号
    ,prcscd varchar2(24) -- 交易码
    ,prodcd varchar2(15) -- 解析产品
    ,loanp1 varchar2(24) -- 产品属性1
    ,loanp2 varchar2(24) -- 产品属性2
    ,loanp3 varchar2(24) -- 产品属性3
    ,loanp4 varchar2(24) -- 产品属性4
    ,loanp5 varchar2(24) -- 产品属性5
    ,loanp6 varchar2(24) -- 产品属性6
    ,loanp7 varchar2(24) -- 产品属性7
    ,loanp8 varchar2(24) -- 产品属性8
    ,loanp9 varchar2(24) -- 产品属性9
    ,evetdn varchar2(24) -- 交易方向
    ,trprcd varchar2(15) -- 金额类型
    ,crcycd varchar2(5) -- 币种
    ,tranam varchar2(33) -- 交易金额
    ,custcd varchar2(90) -- 客户号
    ,acctno varchar2(45) -- 协议编号
    ,assis0 varchar2(45) -- 渠道
    ,assis1 varchar2(45) -- 可售产品
    ,assis2 varchar2(45) -- 辅助核算2
    ,assis3 varchar2(45) -- 辅助核算3
    ,assis4 varchar2(45) -- 辅助核算4
    ,assis5 varchar2(45) -- 辅助核算5
    ,assis6 varchar2(45) -- 辅助核算6
    ,assis7 varchar2(45) -- 辅助核算7
    ,assis9 varchar2(45) -- 辅助核算9
    ,datex0 varchar2(12) -- 交易时间
    ,chrex0 varchar2(45) -- 交易用户
    ,chrex1 varchar2(45) -- 授权用户
    ,chrex2 varchar2(48) -- 冲正标志
    ,chrex3 varchar2(96) -- 冲抹原交易流水号
    ,datex1 varchar2(12) -- 冲抹原交易日期
    ,batchno varchar2(12) -- 数据文件批次号
    ,status varchar2(3) -- 数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
    ,erorcd varchar2(2) -- 错误码
    ,erortx varchar2(150) -- 错误信息
    ,loanpa varchar2(24) -- 产品属性10
    ,contract_no varchar2(96) -- 批次号
    ,details_id varchar2(96) -- 明细ID
    ,tglscnt number(22,0) -- 发送核算中台批次
    ,tgls_end_cnt number(22,0) -- 发送核算中台日终批次
    ,end_status varchar2(3) -- 日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
    ,file_name varchar2(150) -- 发送核算中台文件名称
    ,draft_number varchar2(45) -- 票据号码
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
grant select on ${iol_schema}.bdms_tbl_acct_trans_flow to ${iml_schema};
grant select on ${iol_schema}.bdms_tbl_acct_trans_flow to ${icl_schema};
grant select on ${iol_schema}.bdms_tbl_acct_trans_flow to ${idl_schema};
grant select on ${iol_schema}.bdms_tbl_acct_trans_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_tbl_acct_trans_flow is '交易流水中间表';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.id is '主键';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.systid is '系统代号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.trandt is '交易日期';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.bsnssq is '全局流水';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.transq is '交易流水';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.serino is '序号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.tranbr is '交易机构编号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.acctbr is '账务机构编号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.prcscd is '交易码';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.prodcd is '解析产品';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp1 is '产品属性1';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp2 is '产品属性2';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp3 is '产品属性3';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp4 is '产品属性4';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp5 is '产品属性5';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp6 is '产品属性6';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp7 is '产品属性7';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp8 is '产品属性8';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanp9 is '产品属性9';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.evetdn is '交易方向';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.trprcd is '金额类型';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.crcycd is '币种';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.tranam is '交易金额';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.custcd is '客户号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.acctno is '协议编号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis0 is '渠道';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis1 is '可售产品';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis2 is '辅助核算2';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis3 is '辅助核算3';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis4 is '辅助核算4';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis5 is '辅助核算5';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis6 is '辅助核算6';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis7 is '辅助核算7';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.assis9 is '辅助核算9';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.datex0 is '交易时间';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.chrex0 is '交易用户';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.chrex1 is '授权用户';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.chrex2 is '冲正标志';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.chrex3 is '冲抹原交易流水号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.datex1 is '冲抹原交易日期';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.batchno is '数据文件批次号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.status is '数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.erorcd is '错误码';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.erortx is '错误信息';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.loanpa is '产品属性10';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.contract_no is '批次号';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.details_id is '明细ID';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.tglscnt is '发送核算中台批次';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.tgls_end_cnt is '发送核算中台日终批次';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.end_status is '日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.file_name is '发送核算中台文件名称';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_tbl_acct_trans_flow.etl_timestamp is 'ETL处理时间戳';
