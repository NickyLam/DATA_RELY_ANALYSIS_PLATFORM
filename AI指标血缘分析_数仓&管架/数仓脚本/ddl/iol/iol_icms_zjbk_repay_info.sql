/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_repay_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_repay_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_repay_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_repay_info(
    serialno varchar2(64) -- 流水号
    ,accountid varchar2(64) -- 授信ID
    ,repayorderid varchar2(64) -- 还款订单号
    ,orderno varchar2(64) -- 还款支付订单号
    ,mchid varchar2(32) -- 商户号
    ,appid varchar2(32) -- 商户应用ID
    ,tradetime varchar2(64) -- 还款发起时间
    ,finishtime varchar2(64) -- 还款完成时间
    ,status varchar2(64) -- 状态
    ,amount varchar2(64) -- 还款总金额
    ,currency varchar2(16) -- 字节币种
    ,repaychannel varchar2(32) -- 字节还款方式
    ,extinfo varchar2(4000) -- 其他信息
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,tradeno varchar2(64) -- 抖音还款订单号
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
grant select on ${iol_schema}.icms_zjbk_repay_info to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_repay_info to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_repay_info to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_repay_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_repay_info is '字节还款通知信息表';
comment on column ${iol_schema}.icms_zjbk_repay_info.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_repay_info.accountid is '授信ID';
comment on column ${iol_schema}.icms_zjbk_repay_info.repayorderid is '还款订单号';
comment on column ${iol_schema}.icms_zjbk_repay_info.orderno is '还款支付订单号';
comment on column ${iol_schema}.icms_zjbk_repay_info.mchid is '商户号';
comment on column ${iol_schema}.icms_zjbk_repay_info.appid is '商户应用ID';
comment on column ${iol_schema}.icms_zjbk_repay_info.tradetime is '还款发起时间';
comment on column ${iol_schema}.icms_zjbk_repay_info.finishtime is '还款完成时间';
comment on column ${iol_schema}.icms_zjbk_repay_info.status is '状态';
comment on column ${iol_schema}.icms_zjbk_repay_info.amount is '还款总金额';
comment on column ${iol_schema}.icms_zjbk_repay_info.currency is '字节币种';
comment on column ${iol_schema}.icms_zjbk_repay_info.repaychannel is '字节还款方式';
comment on column ${iol_schema}.icms_zjbk_repay_info.extinfo is '其他信息';
comment on column ${iol_schema}.icms_zjbk_repay_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zjbk_repay_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zjbk_repay_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zjbk_repay_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_zjbk_repay_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_zjbk_repay_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_zjbk_repay_info.tradeno is '抖音还款订单号';
comment on column ${iol_schema}.icms_zjbk_repay_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_repay_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_repay_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_repay_info.etl_timestamp is 'ETL处理时间戳';
