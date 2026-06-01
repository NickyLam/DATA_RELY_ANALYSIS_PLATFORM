/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_asset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_asset_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_asset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_asset_info(
    assetno varchar2(64) -- 风险资产编号
    ,submitstatus varchar2(12) -- 提交状态
    ,groupid varchar2(64) -- 集团编号
    ,contractno varchar2(64) -- 合同编号
    ,updatedate date -- 更新日期
    ,fmuserid varchar2(64) -- 当前保全经理编号
    ,approvestatus varchar2(12) -- 审批状态
    ,reorggroupid varchar2(64) -- 重组集团编号
    ,handinreason varchar2(900) -- 移交原因
    ,resourcesystem varchar2(12) -- 来源系统
    ,inputorgid varchar2(64) -- 登记机构
    ,businesssum number(24,6) -- 合同金额
    ,groupname varchar2(200) -- 集团名称
    ,recoverno varchar2(48) -- 恢复流水号
    ,handinorg varchar2(64) -- 移交机构
    ,currency varchar2(3) -- 币种
    ,borrowerno varchar2(64) -- 借款人编号
    ,customertype varchar2(9) -- 客户类型
    ,deleteflag varchar2(2) -- 删除标识
    ,inputuserid varchar2(64) -- 登记人
    ,classifyresult varchar2(12) -- 当前五级分类结果
    ,holdisflag varchar2(6) -- 是否认定问题客户
    ,balance number(24,6) -- 合同余额
    ,begindate date -- 合同生效日期
    ,issendpayment varchar2(12) -- 是否已发送支付令
    ,smuserid varchar2(64) -- 协办项目经理编号
    ,holdno varchar2(48) -- 认定流水号
    ,handoutreason varchar2(900) -- 逆移交原因
    ,customerid varchar2(16) -- 客户编号
    ,businesstype varchar2(64) -- 业务品种
    ,assetinreason varchar2(4000) -- 认定原因
    ,transfertype varchar2(12) -- 移交类型
    ,happendate date -- 业务发生日期
    ,borrowername varchar2(400) -- 借款人名称
    ,customername varchar2(200) -- 客户名称
    ,updateuserid varchar2(64) -- 更新人
    ,customerlevel varchar2(48) -- 客户评级
    ,handinno varchar2(48) -- 移交流水号
    ,isdisflag varchar2(6) -- 是否移交特资部
    ,assetname varchar2(400) -- 资产名称
    ,certid varchar2(60) -- 证件号码
    ,inputdate date -- 登记日期
    ,isoutflag varchar2(6) -- 是否逆移交
    ,fmusername varchar2(400) -- 当前保全经理名称
    ,smusername varchar2(400) -- 协办项目经理名称
    ,reorggroupname varchar2(160) -- 重组集团名称R
    ,disflag varchar2(2) -- 是否分发
    ,allbalance number(24,6) -- 总借据余额
    ,writeoffflag varchar2(36) -- 核销标识
    ,handoutno varchar2(48) -- 逆移交流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,allbusinesssum number(24,6) -- 总授信金额
    ,allbdbusinesssum number(24,6) -- 总借据金额
    ,certtype varchar2(9) -- 证件类型
    ,assetoutreason varchar2(1000) -- 恢复原因
    ,outdate date -- 移出时间
    ,holdoutisflag varchar2(6) -- 是否恢复正常客户
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
grant select on ${iol_schema}.icms_ap_asset_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_asset_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_asset_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_asset_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_asset_info is '风险资产基本信息表';
comment on column ${iol_schema}.icms_ap_asset_info.assetno is '风险资产编号';
comment on column ${iol_schema}.icms_ap_asset_info.submitstatus is '提交状态';
comment on column ${iol_schema}.icms_ap_asset_info.groupid is '集团编号';
comment on column ${iol_schema}.icms_ap_asset_info.contractno is '合同编号';
comment on column ${iol_schema}.icms_ap_asset_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_asset_info.fmuserid is '当前保全经理编号';
comment on column ${iol_schema}.icms_ap_asset_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_asset_info.reorggroupid is '重组集团编号';
comment on column ${iol_schema}.icms_ap_asset_info.handinreason is '移交原因';
comment on column ${iol_schema}.icms_ap_asset_info.resourcesystem is '来源系统';
comment on column ${iol_schema}.icms_ap_asset_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_asset_info.businesssum is '合同金额';
comment on column ${iol_schema}.icms_ap_asset_info.groupname is '集团名称';
comment on column ${iol_schema}.icms_ap_asset_info.recoverno is '恢复流水号';
comment on column ${iol_schema}.icms_ap_asset_info.handinorg is '移交机构';
comment on column ${iol_schema}.icms_ap_asset_info.currency is '币种';
comment on column ${iol_schema}.icms_ap_asset_info.borrowerno is '借款人编号';
comment on column ${iol_schema}.icms_ap_asset_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_ap_asset_info.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_asset_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_asset_info.classifyresult is '当前五级分类结果';
comment on column ${iol_schema}.icms_ap_asset_info.holdisflag is '是否认定问题客户';
comment on column ${iol_schema}.icms_ap_asset_info.balance is '合同余额';
comment on column ${iol_schema}.icms_ap_asset_info.begindate is '合同生效日期';
comment on column ${iol_schema}.icms_ap_asset_info.issendpayment is '是否已发送支付令';
comment on column ${iol_schema}.icms_ap_asset_info.smuserid is '协办项目经理编号';
comment on column ${iol_schema}.icms_ap_asset_info.holdno is '认定流水号';
comment on column ${iol_schema}.icms_ap_asset_info.handoutreason is '逆移交原因';
comment on column ${iol_schema}.icms_ap_asset_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_ap_asset_info.businesstype is '业务品种';
comment on column ${iol_schema}.icms_ap_asset_info.assetinreason is '认定原因';
comment on column ${iol_schema}.icms_ap_asset_info.transfertype is '移交类型';
comment on column ${iol_schema}.icms_ap_asset_info.happendate is '业务发生日期';
comment on column ${iol_schema}.icms_ap_asset_info.borrowername is '借款人名称';
comment on column ${iol_schema}.icms_ap_asset_info.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_asset_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_asset_info.customerlevel is '客户评级';
comment on column ${iol_schema}.icms_ap_asset_info.handinno is '移交流水号';
comment on column ${iol_schema}.icms_ap_asset_info.isdisflag is '是否移交特资部';
comment on column ${iol_schema}.icms_ap_asset_info.assetname is '资产名称';
comment on column ${iol_schema}.icms_ap_asset_info.certid is '证件号码';
comment on column ${iol_schema}.icms_ap_asset_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_asset_info.isoutflag is '是否逆移交';
comment on column ${iol_schema}.icms_ap_asset_info.fmusername is '当前保全经理名称';
comment on column ${iol_schema}.icms_ap_asset_info.smusername is '协办项目经理名称';
comment on column ${iol_schema}.icms_ap_asset_info.reorggroupname is '重组集团名称R';
comment on column ${iol_schema}.icms_ap_asset_info.disflag is '是否分发';
comment on column ${iol_schema}.icms_ap_asset_info.allbalance is '总借据余额';
comment on column ${iol_schema}.icms_ap_asset_info.writeoffflag is '核销标识';
comment on column ${iol_schema}.icms_ap_asset_info.handoutno is '逆移交流水号';
comment on column ${iol_schema}.icms_ap_asset_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_asset_info.allbusinesssum is '总授信金额';
comment on column ${iol_schema}.icms_ap_asset_info.allbdbusinesssum is '总借据金额';
comment on column ${iol_schema}.icms_ap_asset_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_ap_asset_info.assetoutreason is '恢复原因';
comment on column ${iol_schema}.icms_ap_asset_info.outdate is '移出时间';
comment on column ${iol_schema}.icms_ap_asset_info.holdoutisflag is '是否恢复正常客户';
comment on column ${iol_schema}.icms_ap_asset_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_asset_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_asset_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_asset_info.etl_timestamp is 'ETL处理时间戳';
