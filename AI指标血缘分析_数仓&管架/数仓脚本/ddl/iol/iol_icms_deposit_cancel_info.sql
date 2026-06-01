/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_deposit_cancel_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_deposit_cancel_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_deposit_cancel_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_deposit_cancel_info(
    serialno varchar2(32) -- 申请流水号
    ,exchangetime date -- 交易时间
    ,inputorgid varchar2(40) -- 登记机构
    ,updatedate date -- 更新日期
    ,approvestatus varchar2(18) -- 审批状态
    ,migtflag varchar2(80) -- 
    ,exchangestate varchar2(2) -- 交易状态
    ,cusid varchar2(40) -- 客户ID
    ,putoutno varchar2(40) -- 出账流水号
    ,hascancel varchar2(1) -- 是否已撤销Y是N否默认可以为空
    ,inputdate date -- 登记日期
    ,matudt date -- 到期日期票据到期日
    ,inputuserid varchar2(8) -- 登记人
    ,exchangeserialno varchar2(32) -- 交易流水号
    ,initexchangedate date -- 原交易日期
    ,dataid varchar2(40) -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,exchangedate date -- 交易日期
    ,grtetp varchar2(1) -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,businesstype varchar2(40) -- 转出业务类型
    ,cntrtp varchar2(1) -- 协议类型1--承兑汇票协议 2–保函合同
    ,acctno varchar2(40) -- 转出账号
    ,updateorgid varchar2(12) -- 更新机构
    ,grteac varchar2(40) -- 保证金帐号
    ,initexchangeserialno varchar2(32) -- 原交易流水号
    ,objectno varchar2(32) -- 被撤销的保证金申请的流水号
    ,remark varchar2(1000) -- 解止说明
    ,termcd varchar2(3) -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,subaccountam number(18,2) -- 保证金子账号余额
    ,updateuserid varchar2(8) -- 更新人
    ,cusname varchar2(80) -- 客户名称
    ,opertp varchar2(1) -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,subaccount varchar2(40) -- 子户号
    ,contractno varchar2(40) -- 合同流水号
    ,tranam number(18,2) -- 金额
    ,pigeonholedate date -- 归档日期
    ,unfreezeam number(18,2) -- 解止金额
    ,acptno varchar2(40) -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,crcycd varchar2(3) -- 币种
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
grant select on ${iol_schema}.icms_deposit_cancel_info to ${iml_schema};
grant select on ${iol_schema}.icms_deposit_cancel_info to ${icl_schema};
grant select on ${iol_schema}.icms_deposit_cancel_info to ${idl_schema};
grant select on ${iol_schema}.icms_deposit_cancel_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_deposit_cancel_info is '解冻保证金信息';
comment on column ${iol_schema}.icms_deposit_cancel_info.serialno is '申请流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.exchangetime is '交易时间';
comment on column ${iol_schema}.icms_deposit_cancel_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_deposit_cancel_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_deposit_cancel_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_deposit_cancel_info.migtflag is '';
comment on column ${iol_schema}.icms_deposit_cancel_info.exchangestate is '交易状态';
comment on column ${iol_schema}.icms_deposit_cancel_info.cusid is '客户ID';
comment on column ${iol_schema}.icms_deposit_cancel_info.putoutno is '出账流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.hascancel is '是否已撤销Y是N否默认可以为空';
comment on column ${iol_schema}.icms_deposit_cancel_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_deposit_cancel_info.matudt is '到期日期票据到期日';
comment on column ${iol_schema}.icms_deposit_cancel_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_deposit_cancel_info.exchangeserialno is '交易流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.initexchangedate is '原交易日期';
comment on column ${iol_schema}.icms_deposit_cancel_info.dataid is '唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号';
comment on column ${iol_schema}.icms_deposit_cancel_info.exchangedate is '交易日期';
comment on column ${iol_schema}.icms_deposit_cancel_info.grtetp is '保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)';
comment on column ${iol_schema}.icms_deposit_cancel_info.businesstype is '转出业务类型';
comment on column ${iol_schema}.icms_deposit_cancel_info.cntrtp is '协议类型1--承兑汇票协议 2–保函合同';
comment on column ${iol_schema}.icms_deposit_cancel_info.acctno is '转出账号';
comment on column ${iol_schema}.icms_deposit_cancel_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_deposit_cancel_info.grteac is '保证金帐号';
comment on column ${iol_schema}.icms_deposit_cancel_info.initexchangeserialno is '原交易流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.objectno is '被撤销的保证金申请的流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.remark is '解止说明';
comment on column ${iol_schema}.icms_deposit_cancel_info.termcd is '存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年';
comment on column ${iol_schema}.icms_deposit_cancel_info.subaccountam is '保证金子账号余额';
comment on column ${iol_schema}.icms_deposit_cancel_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_deposit_cancel_info.cusname is '客户名称';
comment on column ${iol_schema}.icms_deposit_cancel_info.opertp is '操作类型1--建立保证金对应关系 2–追加保证金';
comment on column ${iol_schema}.icms_deposit_cancel_info.subaccount is '子户号';
comment on column ${iol_schema}.icms_deposit_cancel_info.contractno is '合同流水号';
comment on column ${iol_schema}.icms_deposit_cancel_info.tranam is '金额';
comment on column ${iol_schema}.icms_deposit_cancel_info.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_deposit_cancel_info.unfreezeam is '解止金额';
comment on column ${iol_schema}.icms_deposit_cancel_info.acptno is '票据号码此字段针对承兑（若grtetp为2时此字段不能为空）';
comment on column ${iol_schema}.icms_deposit_cancel_info.crcycd is '币种';
comment on column ${iol_schema}.icms_deposit_cancel_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_deposit_cancel_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_deposit_cancel_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_deposit_cancel_info.etl_timestamp is 'ETL处理时间戳';
