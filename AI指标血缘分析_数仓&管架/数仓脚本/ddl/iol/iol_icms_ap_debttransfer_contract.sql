/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_debttransfer_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_debttransfer_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_debttransfer_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_debttransfer_contract(
    debttransferno varchar2(64) -- 记录编号
    ,tmsp varchar2(64) -- 时间戳
    ,fileno varchar2(64) -- 影像平台编号
    ,guarantyid varchar2(64) -- 抵债资产编号
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,buyer varchar2(1000) -- 买受人
    ,inputdate varchar2(64) -- 登记日期
    ,deleteflag varchar2(12) -- 删除标志
    ,planno varchar2(64) -- 处置内容编号
    ,remark varchar2(2000) -- 备注
    ,guarantyname varchar2(1000) -- 抵债资产名称
    ,inputorgid varchar2(64) -- 登记机构
    ,contractno varchar2(400) -- 协议编号
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate varchar2(36) -- 更新日期
    ,evalvalue number(24,6) -- 评估价值
    ,guarantysum number(24,6) -- 抵债金额
    ,signdate varchar2(64) -- 转让协议签订日期
    ,transferprice number(24,6) -- 转让价格
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
grant select on ${iol_schema}.icms_ap_debttransfer_contract to ${iml_schema};
grant select on ${iol_schema}.icms_ap_debttransfer_contract to ${icl_schema};
grant select on ${iol_schema}.icms_ap_debttransfer_contract to ${idl_schema};
grant select on ${iol_schema}.icms_ap_debttransfer_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_debttransfer_contract is '抵债资产转让协议表';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.debttransferno is '记录编号';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.guarantyid is '抵债资产编号';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.buyer is '买受人';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.planno is '处置内容编号';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.remark is '备注';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.guarantyname is '抵债资产名称';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.contractno is '协议编号';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.evalvalue is '评估价值';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.guarantysum is '抵债金额';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.signdate is '转让协议签订日期';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.transferprice is '转让价格';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_debttransfer_contract.etl_timestamp is 'ETL处理时间戳';
