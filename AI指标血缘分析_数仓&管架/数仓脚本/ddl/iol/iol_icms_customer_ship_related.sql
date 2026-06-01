/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_related
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_related
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_related purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_related(
    serialno varchar2(64) -- 流水号
    ,relationship varchar2(80) -- 关联关系
    ,comoperiationyear number(24,6) -- 合作年限
    ,customerid varchar2(16) -- 客户编号
    ,inputorgid varchar2(32) -- 登记机构
    ,updatedate date -- 更新日期
    ,legalname varchar2(80) -- 法人代表（公司）
    ,updateuserid varchar2(32) -- 更新人
    ,maincustomerid varchar2(32) -- 主客户号
    ,settlenentmode varchar2(200) -- 结算方式
    ,creditinstitutioncode varchar2(18) -- 机构信用代码
    ,certtype varchar2(80) -- 关联方证件类型
    ,customername varchar2(200) -- 关联方姓名
    ,supplyvalue number(24,6) -- 供应（销售）额
    ,loancardno varchar2(32) -- 关联方贷款卡编号
    ,corporgid varchar2(32) -- 法人机构编号
    ,migtflag varchar2(80) -- 
    ,updateorgid varchar2(32) -- 更新机构
    ,production varchar2(200) -- 供应(销售)产品
    ,certid varchar2(60) -- 关联方证件号码
    ,inputuserid varchar2(32) -- 登记人
    ,isaffenterprises varchar2(1) -- 是否关联企业
    ,remark varchar2(500) -- 备注
    ,inputdate date -- 登记日期
    ,investdate date -- 关系建立时间
    ,supplyname varchar2(32) -- 供应（销售）产品
    ,supplycurrency varchar2(3) -- 供应（销售）额币种
    ,supplyprop number(24,8) -- 供应（销售）比例
    ,groupid varchar2(32) -- 所属供应链客户群编号
    ,describe varchar2(400) -- 构成关联方理由
    ,migtoldvalue varchar2(250) -- 备份原字段值
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
grant select on ${iol_schema}.icms_customer_ship_related to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_related to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_related to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_related to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_related is '客户关联方信息';
comment on column ${iol_schema}.icms_customer_ship_related.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_related.relationship is '关联关系';
comment on column ${iol_schema}.icms_customer_ship_related.comoperiationyear is '合作年限';
comment on column ${iol_schema}.icms_customer_ship_related.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_ship_related.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_related.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_related.legalname is '法人代表（公司）';
comment on column ${iol_schema}.icms_customer_ship_related.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_related.maincustomerid is '主客户号';
comment on column ${iol_schema}.icms_customer_ship_related.settlenentmode is '结算方式';
comment on column ${iol_schema}.icms_customer_ship_related.creditinstitutioncode is '机构信用代码';
comment on column ${iol_schema}.icms_customer_ship_related.certtype is '关联方证件类型';
comment on column ${iol_schema}.icms_customer_ship_related.customername is '关联方姓名';
comment on column ${iol_schema}.icms_customer_ship_related.supplyvalue is '供应（销售）额';
comment on column ${iol_schema}.icms_customer_ship_related.loancardno is '关联方贷款卡编号';
comment on column ${iol_schema}.icms_customer_ship_related.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_ship_related.migtflag is '';
comment on column ${iol_schema}.icms_customer_ship_related.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_related.production is '供应(销售)产品';
comment on column ${iol_schema}.icms_customer_ship_related.certid is '关联方证件号码';
comment on column ${iol_schema}.icms_customer_ship_related.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_ship_related.isaffenterprises is '是否关联企业';
comment on column ${iol_schema}.icms_customer_ship_related.remark is '备注';
comment on column ${iol_schema}.icms_customer_ship_related.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_related.investdate is '关系建立时间';
comment on column ${iol_schema}.icms_customer_ship_related.supplyname is '供应（销售）产品';
comment on column ${iol_schema}.icms_customer_ship_related.supplycurrency is '供应（销售）额币种';
comment on column ${iol_schema}.icms_customer_ship_related.supplyprop is '供应（销售）比例';
comment on column ${iol_schema}.icms_customer_ship_related.groupid is '所属供应链客户群编号';
comment on column ${iol_schema}.icms_customer_ship_related.describe is '构成关联方理由';
comment on column ${iol_schema}.icms_customer_ship_related.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_related.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_related.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_related.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_related.etl_timestamp is 'ETL处理时间戳';
