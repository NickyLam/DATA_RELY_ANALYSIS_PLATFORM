/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_transfer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_transfer_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_transfer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_transfer_info(
    programno varchar2(64) -- 方案编号
    ,objectno varchar2(30) -- 对象编号
    ,objecttype varchar2(30) -- 对象类型
    ,productid varchar2(32) -- 产品编号
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,classifyresult varchar2(200) -- 贷款五级分类
    ,currency varchar2(3) -- 币种TRI
    ,businesssum number(24,6) -- 放款金额
    ,balance number(24,6) -- 贷款余额
    ,ysintamt number(24,6) -- 应收欠息
    ,yjodiamt number(24,6) -- 应计复息
    ,ysodpamt number(24,6) -- 应收罚息
    ,transfermoney number(24,6) -- 转让金额
    ,settlementaccount varchar2(128) -- 结算账号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人"
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_ap_transfer_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_transfer_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_transfer_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_transfer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_transfer_info is '资产转让债转详情信息表';
comment on column ${iol_schema}.icms_ap_transfer_info.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_transfer_info.objectno is '对象编号';
comment on column ${iol_schema}.icms_ap_transfer_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_ap_transfer_info.productid is '产品编号';
comment on column ${iol_schema}.icms_ap_transfer_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_ap_transfer_info.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_transfer_info.classifyresult is '贷款五级分类';
comment on column ${iol_schema}.icms_ap_transfer_info.currency is '币种TRI';
comment on column ${iol_schema}.icms_ap_transfer_info.businesssum is '放款金额';
comment on column ${iol_schema}.icms_ap_transfer_info.balance is '贷款余额';
comment on column ${iol_schema}.icms_ap_transfer_info.ysintamt is '应收欠息';
comment on column ${iol_schema}.icms_ap_transfer_info.yjodiamt is '应计复息';
comment on column ${iol_schema}.icms_ap_transfer_info.ysodpamt is '应收罚息';
comment on column ${iol_schema}.icms_ap_transfer_info.transfermoney is '转让金额';
comment on column ${iol_schema}.icms_ap_transfer_info.settlementaccount is '结算账号';
comment on column ${iol_schema}.icms_ap_transfer_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_transfer_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_transfer_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_transfer_info.updateuserid is '更新人"';
comment on column ${iol_schema}.icms_ap_transfer_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_transfer_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_transfer_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_transfer_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_transfer_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_transfer_info.etl_timestamp is 'ETL处理时间戳';
