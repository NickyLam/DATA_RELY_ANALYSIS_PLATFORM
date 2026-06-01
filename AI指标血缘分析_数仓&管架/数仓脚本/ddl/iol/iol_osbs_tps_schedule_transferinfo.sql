/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_schedule_transferinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_schedule_transferinfo
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_schedule_transferinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_schedule_transferinfo(
    tst_schedule_no varchar2(32) -- 计划编号
    ,tst_ecifno varchar2(32) -- 全行统一客户号
    ,tst_userno varchar2(32) -- 用户顺序号
    ,tst_transcode varchar2(64) -- 交易码
    ,tst_payaccno varchar2(32) -- 付款账号
    ,tst_payaccname varchar2(64) -- 付款账户名称
    ,tst_payerdeptid varchar2(64) -- 付款方行号
    ,tst_payacctype varchar2(4) -- 付款账户类型
    ,tst_paycurrency varchar2(3) -- 转出币种
    ,tst_rcvaccno varchar2(32) -- 收款账号
    ,tst_rcvaccname varchar2(200) -- 收款账号名称
    ,tst_rcvacctype varchar2(4) -- 收款账户类型
    ,tst_amount number(15,2) -- 转出金额
    ,tst_remark varchar2(128) -- 附言
    ,tst_fee number(15,2) -- 费用
    ,tst_isnormal varchar2(1) -- 是否加急
    ,tst_rcvcurrency varchar2(3) -- 收款人币种
    ,tst_rcvbankid varchar2(16) -- 收款人银行代码
    ,tst_rcvbankname varchar2(64) -- 收款人银行名称
    ,tst_provincecode varchar2(16) -- 收款人省份
    ,tst_provincename varchar2(64) -- 收款人省份名称
    ,tst_citycode varchar2(16) -- 收款人城市代码
    ,tst_cityname varchar2(128) -- 收款人城市名称
    ,tst_rcvbankbranch varchar2(20) -- 收款人网点
    ,tst_rcvbankbranchname varchar2(255) -- 收款人网点名称
    ,tst_clearingnode varchar2(12) -- 收款人清算行号
    ,tst_rcvmobile varchar2(16) -- 收款人手机号码
    ,tst_rcvsms varchar2(120) -- SMS
    ,tst_notemsg varchar2(128) -- 摘要
    ,tst_finalfee number(15,2) -- 最终手续费
    ,tst_discount varchar2(16) -- 折扣
    ,tst_notifyrcv varchar2(1) -- 是否通知收款人
    ,tst_savercv varchar2(1) -- 是否保存收款人
    ,tst_ciftype varchar2(1) -- 账户类型
    ,tst_rcvaccnickname varchar2(200) -- 收款人昵称
    ,tst_mobileno varchar2(15) -- 转账手机号码
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
grant select on ${iol_schema}.osbs_tps_schedule_transferinfo to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_schedule_transferinfo to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_schedule_transferinfo to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_schedule_transferinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_schedule_transferinfo is '个人预约交易信息表';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_schedule_no is '计划编号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_transcode is '交易码';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_payaccno is '付款账号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_payaccname is '付款账户名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_payerdeptid is '付款方行号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_payacctype is '付款账户类型';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_paycurrency is '转出币种';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvaccno is '收款账号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvaccname is '收款账号名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvacctype is '收款账户类型';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_amount is '转出金额';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_remark is '附言';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_fee is '费用';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_isnormal is '是否加急';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvcurrency is '收款人币种';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvbankid is '收款人银行代码';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvbankname is '收款人银行名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_provincecode is '收款人省份';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_provincename is '收款人省份名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_citycode is '收款人城市代码';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_cityname is '收款人城市名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvbankbranch is '收款人网点';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvbankbranchname is '收款人网点名称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_clearingnode is '收款人清算行号';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvmobile is '收款人手机号码';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvsms is 'SMS';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_notemsg is '摘要';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_finalfee is '最终手续费';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_discount is '折扣';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_notifyrcv is '是否通知收款人';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_savercv is '是否保存收款人';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_ciftype is '账户类型';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_rcvaccnickname is '收款人昵称';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.tst_mobileno is '转账手机号码';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_schedule_transferinfo.etl_timestamp is 'ETL处理时间戳';
