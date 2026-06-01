/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_nonretail_asset_duebill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_nonretail_asset_duebill
whenever sqlerror continue none;
drop table ${iol_schema}.icms_nonretail_asset_duebill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_nonretail_asset_duebill(
    programno varchar2(64) -- 方案编号
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 
    ,duebillno varchar2(30) -- 借据编号
    ,productid varchar2(32) -- 业务品种
    ,classifyresult varchar2(2) -- 五级分类
    ,businesssum number(24,6) -- 借据金额
    ,balance number(24,6) -- 借据余额
    ,owedamount number(24,6) -- 欠本金额
    ,interestamount number(24,6) -- 欠息金额
    ,penaltyamount number(24,6) -- 罚息
    ,compoundamount number(24,6) -- 复利
    ,putoutdate date -- 起始日
    ,maturity date -- 到期日
    ,overduedays number(22,0) -- 逾期天数
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_nonretail_asset_duebill to ${iml_schema};
grant select on ${iol_schema}.icms_nonretail_asset_duebill to ${icl_schema};
grant select on ${iol_schema}.icms_nonretail_asset_duebill to ${idl_schema};
grant select on ${iol_schema}.icms_nonretail_asset_duebill to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_nonretail_asset_duebill is '非零售问题资产处理借据表';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.programno is '方案编号';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.customerid is '客户编号';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.customername is '';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.duebillno is '借据编号';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.productid is '业务品种';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.businesssum is '借据金额';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.balance is '借据余额';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.owedamount is '欠本金额';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.interestamount is '欠息金额';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.penaltyamount is '罚息';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.compoundamount is '复利';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.putoutdate is '起始日';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.maturity is '到期日';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.overduedays is '逾期天数';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.inputuserid is '登记人';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.updateuserid is '更新人';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.updatedate is '更新日期';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.inputdate is '登记日期';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.start_dt is '开始时间';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.end_dt is '结束时间';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.id_mark is '增删标志';
comment on column ${iol_schema}.icms_nonretail_asset_duebill.etl_timestamp is 'ETL处理时间戳';
