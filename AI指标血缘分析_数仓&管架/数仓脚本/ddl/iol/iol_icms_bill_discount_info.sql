/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bill_discount_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bill_discount_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bill_discount_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bill_discount_info(
    serialno varchar2(32) -- 票据流水号
    ,updateorgid varchar2(12) -- 更新机构
    ,inputdate date -- 登记日期
    ,purpose varchar2(200) -- 用途
    ,acceptorname varchar2(200) -- 承兑人名称
    ,acceptoraccount varchar2(32) -- 承兑人账号
    ,bankname varchar2(200) -- 开户行名称
    ,payeename varchar2(200) -- 收账人名称
    ,billstatus varchar2(10) -- 票据状态
    ,bankaccountno varchar2(32) -- 开户行账号
    ,migtflag varchar2(80) -- 
    ,relativeserialno varchar2(32) -- 关联的在线贴现申请流水号
    ,updateuserid varchar2(8) -- 更新人
    ,billno varchar2(32) -- 票号
    ,writername varchar2(200) -- 出票人名称
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(32) -- 登记机构
    ,billtype varchar2(10) -- 票据种类
    ,maturity date -- 到期日期
    ,inputuserid varchar2(8) -- 登记人
    ,payeeaccount varchar2(32) -- 收账人账号
    ,writeraccount varchar2(32) -- 出票人账号
    ,billsum number(22,4) -- 票面金额
    ,writerdate date -- 出票日期
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
grant select on ${iol_schema}.icms_bill_discount_info to ${iml_schema};
grant select on ${iol_schema}.icms_bill_discount_info to ${icl_schema};
grant select on ${iol_schema}.icms_bill_discount_info to ${idl_schema};
grant select on ${iol_schema}.icms_bill_discount_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bill_discount_info is '在线贴现票据明细信息';
comment on column ${iol_schema}.icms_bill_discount_info.serialno is '票据流水号';
comment on column ${iol_schema}.icms_bill_discount_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_bill_discount_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_bill_discount_info.purpose is '用途';
comment on column ${iol_schema}.icms_bill_discount_info.acceptorname is '承兑人名称';
comment on column ${iol_schema}.icms_bill_discount_info.acceptoraccount is '承兑人账号';
comment on column ${iol_schema}.icms_bill_discount_info.bankname is '开户行名称';
comment on column ${iol_schema}.icms_bill_discount_info.payeename is '收账人名称';
comment on column ${iol_schema}.icms_bill_discount_info.billstatus is '票据状态';
comment on column ${iol_schema}.icms_bill_discount_info.bankaccountno is '开户行账号';
comment on column ${iol_schema}.icms_bill_discount_info.migtflag is '';
comment on column ${iol_schema}.icms_bill_discount_info.relativeserialno is '关联的在线贴现申请流水号';
comment on column ${iol_schema}.icms_bill_discount_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_bill_discount_info.billno is '票号';
comment on column ${iol_schema}.icms_bill_discount_info.writername is '出票人名称';
comment on column ${iol_schema}.icms_bill_discount_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_bill_discount_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_bill_discount_info.billtype is '票据种类';
comment on column ${iol_schema}.icms_bill_discount_info.maturity is '到期日期';
comment on column ${iol_schema}.icms_bill_discount_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_bill_discount_info.payeeaccount is '收账人账号';
comment on column ${iol_schema}.icms_bill_discount_info.writeraccount is '出票人账号';
comment on column ${iol_schema}.icms_bill_discount_info.billsum is '票面金额';
comment on column ${iol_schema}.icms_bill_discount_info.writerdate is '出票日期';
comment on column ${iol_schema}.icms_bill_discount_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bill_discount_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bill_discount_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bill_discount_info.etl_timestamp is 'ETL处理时间戳';
