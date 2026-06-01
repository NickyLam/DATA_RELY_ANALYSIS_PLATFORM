/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_ent_finance_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_ent_finance_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_ent_finance_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_ent_finance_info(
    datadt varchar2(10) -- 数据日期
    ,entname varchar2(128) -- 企业名称
    ,registernumber varchar2(32) -- 统一社会信用代码
    ,registerdate varchar2(19) -- 企业成立日期
    ,zzm varchar2(64) -- 中征码
    ,industryname varchar2(100) -- 企业的行业
    ,staffnumber varchar2(16) -- 从业人数
    ,ancheyear varchar2(4) -- 元素数据年份
    ,assgro number(20,4) -- 资产总额（元）
    ,liagro number(20,4) -- 负债总额（元）
    ,vendinc number(20,4) -- 营业总收入（元）
    ,maibusinc number(20,4) -- 主营业务收入（元）
    ,progro number(20,4) -- 利润总额（元）
    ,netinc number(20,4) -- 净利润（元）
    ,ratgro number(20,4) -- 纳税总额（元）
    ,totequ number(20,4) -- 所有者权益合计（元）
    ,customerid varchar2(16) -- 我行客户号
    ,reportformtype varchar2(4) -- 财务报表类
    ,reportstartdate varchar2(10) -- 财报起始日期
    ,reportclosingdate varchar2(10) -- 财报截止日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
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
grant select on ${iol_schema}.icms_wyd_ent_finance_info to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_ent_finance_info to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_ent_finance_info to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_ent_finance_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_ent_finance_info is '企业财务信息';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.entname is '企业名称';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.registernumber is '统一社会信用代码';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.registerdate is '企业成立日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.zzm is '中征码';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.industryname is '企业的行业';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.staffnumber is '从业人数';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.ancheyear is '元素数据年份';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.assgro is '资产总额（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.liagro is '负债总额（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.vendinc is '营业总收入（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.maibusinc is '主营业务收入（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.progro is '利润总额（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.netinc is '净利润（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.ratgro is '纳税总额（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.totequ is '所有者权益合计（元）';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.reportformtype is '财务报表类';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.reportstartdate is '财报起始日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.reportclosingdate is '财报截止日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_ent_finance_info.etl_timestamp is 'ETL处理时间戳';
