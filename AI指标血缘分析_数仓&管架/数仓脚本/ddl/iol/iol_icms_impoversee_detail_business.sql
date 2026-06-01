/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_impoversee_detail_business
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_impoversee_detail_business
whenever sqlerror continue none;
drop table ${iol_schema}.icms_impoversee_detail_business purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_impoversee_detail_business(
    serialno varchar2(64) -- 流水号
    ,objecttype varchar2(64) -- 申请类型
    ,businessoperateorgid varchar2(64) -- 业务经办机构编号
    ,riskclassify varchar2(64) -- 风险分类
    ,inputorgid varchar2(64) -- 登记机构
    ,putoutsum number(24,6) -- 出账金额
    ,balance number(24,6) -- 当前余额
    ,putoutdate date -- 出账日期
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,operateuserid varchar2(64) -- 业务经办人
    ,updatedate date -- 更新时间
    ,productid varchar2(64) -- 业务品种
    ,duebillserialno varchar2(30) -- 借据编号
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,contractserialno varchar2(64) -- 业务合同编号
    ,putoutmaurity date -- 出账到期日
    ,operateorgid varchar2(64) -- 业务经办机构
    ,impoverseeserialno varchar2(64) -- 监测流水号
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
grant select on ${iol_schema}.icms_impoversee_detail_business to ${iml_schema};
grant select on ${iol_schema}.icms_impoversee_detail_business to ${icl_schema};
grant select on ${iol_schema}.icms_impoversee_detail_business to ${idl_schema};
grant select on ${iol_schema}.icms_impoversee_detail_business to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_impoversee_detail_business is '重点监测客户详情-业务信息';
comment on column ${iol_schema}.icms_impoversee_detail_business.serialno is '流水号';
comment on column ${iol_schema}.icms_impoversee_detail_business.objecttype is '申请类型';
comment on column ${iol_schema}.icms_impoversee_detail_business.businessoperateorgid is '业务经办机构编号';
comment on column ${iol_schema}.icms_impoversee_detail_business.riskclassify is '风险分类';
comment on column ${iol_schema}.icms_impoversee_detail_business.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_impoversee_detail_business.putoutsum is '出账金额';
comment on column ${iol_schema}.icms_impoversee_detail_business.balance is '当前余额';
comment on column ${iol_schema}.icms_impoversee_detail_business.putoutdate is '出账日期';
comment on column ${iol_schema}.icms_impoversee_detail_business.inputdate is '登记时间';
comment on column ${iol_schema}.icms_impoversee_detail_business.updateuserid is '更新人';
comment on column ${iol_schema}.icms_impoversee_detail_business.operateuserid is '业务经办人';
comment on column ${iol_schema}.icms_impoversee_detail_business.updatedate is '更新时间';
comment on column ${iol_schema}.icms_impoversee_detail_business.productid is '业务品种';
comment on column ${iol_schema}.icms_impoversee_detail_business.duebillserialno is '借据编号';
comment on column ${iol_schema}.icms_impoversee_detail_business.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_impoversee_detail_business.inputuserid is '登记人';
comment on column ${iol_schema}.icms_impoversee_detail_business.contractserialno is '业务合同编号';
comment on column ${iol_schema}.icms_impoversee_detail_business.putoutmaurity is '出账到期日';
comment on column ${iol_schema}.icms_impoversee_detail_business.operateorgid is '业务经办机构';
comment on column ${iol_schema}.icms_impoversee_detail_business.impoverseeserialno is '监测流水号';
comment on column ${iol_schema}.icms_impoversee_detail_business.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_impoversee_detail_business.etl_timestamp is 'ETL处理时间戳';
