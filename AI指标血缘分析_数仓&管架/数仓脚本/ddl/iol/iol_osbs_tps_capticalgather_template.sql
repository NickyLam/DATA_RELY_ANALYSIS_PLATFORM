/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_capticalgather_template
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_capticalgather_template
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_capticalgather_template purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_capticalgather_template(
    tgt_capticalgather_no varchar2(32) -- 资金归集编号
    ,tgt_ecifno varchar2(32) -- 统一客户号
    ,tgt_userno varchar2(32) -- 用户顺序号
    ,tgt_transcode varchar2(64) -- 交易编码
    ,tgt_payaccno varchar2(40) -- 转出账号
    ,tgt_payaccname varchar2(128) -- 转出账户名称
    ,tgt_paybankname varchar2(128) -- 付款银行名称
    ,tgt_payacctype varchar2(4) -- 转出账号账户类别
    ,tgt_paybankid varchar2(16) -- 转出账户开户行
    ,tgt_paycurrency varchar2(3) -- 转出币种
    ,tgt_rcvaccno varchar2(40) -- 转入账号
    ,tgt_amount number(15,2) -- 金额
    ,tgt_remark varchar2(128) -- 附言
    ,tgt_fee number(15,2) -- 费用
    ,tgt_use varchar2(64) -- 付款用途
    ,tgt_submittime varchar2(17) -- 提交时间
    ,tgt_singleamtlimit number(15,2) -- 单笔限额
    ,tgt_protocolno varchar2(60) -- 收钱协议号
    ,tgt_rcvbankid varchar2(36) -- 转入行号
    ,tgt_summary varchar2(4) -- 核心摘要码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_tps_capticalgather_template to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_template to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_template to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_capticalgather_template to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_capticalgather_template is '个人资金归集交易信息表';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_capticalgather_no is '资金归集编号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_ecifno is '统一客户号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_transcode is '交易编码';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_payaccno is '转出账号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_payaccname is '转出账户名称';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_paybankname is '付款银行名称';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_payacctype is '转出账号账户类别';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_paybankid is '转出账户开户行';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_paycurrency is '转出币种';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_rcvaccno is '转入账号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_amount is '金额';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_remark is '附言';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_fee is '费用';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_use is '付款用途';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_submittime is '提交时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_singleamtlimit is '单笔限额';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_protocolno is '收钱协议号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_rcvbankid is '转入行号';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.tgt_summary is '核心摘要码';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_capticalgather_template.etl_timestamp is 'ETL处理时间戳';
