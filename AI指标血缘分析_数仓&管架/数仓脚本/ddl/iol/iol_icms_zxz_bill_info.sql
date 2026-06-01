/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zxz_bill_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zxz_bill_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zxz_bill_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zxz_bill_info(
    packageno varchar2(32) -- 批次包编号
    ,billno varchar2(32) -- 借据号
    ,cla varchar2(2) -- 贷款质量(五级分类)
    ,loanbalance number(24,6) -- 贷款余额
    ,inpoolflag varchar2(2) -- 总行入池标识
    ,cusname varchar2(100) -- 客户名称
    ,billenddate varchar2(10) -- 借据失效日期
    ,businessesflag varchar2(1) -- 客户类型
    ,lastyearbussum varchar2(30) -- 上年末营业收入
    ,loanenddate varchar2(10) -- 贷款到期日
    ,workersnum varchar2(20) -- 企业人数
    ,cusmanager varchar2(20) -- 客户经理
    ,certcode varchar2(60) -- 客户证件号码
    ,loanusetype varchar2(10) -- 贷款用途
    ,indivcomfld varchar2(5) -- 所属行业
    ,mainbrid varchar2(20) -- 机构名称
    ,accountstatus varchar2(2) -- 借据状态
    ,loanstartdate varchar2(10) -- 贷款发放日
    ,comptypedetail varchar2(2) -- 贷款划型细项
    ,loanamount number(16,2) -- 贷款金额
    ,comptype varchar2(2) -- 贷款划型
    ,compsize varchar2(3) -- 企业规模
    ,realityiry number(16,9) -- 贷款利率
    ,zxzflag varchar2(2) -- 支小再状态
    ,totalassets number(16,2) -- 资产总额(万元)
    ,packagename varchar2(300) -- 批次包的名称
    ,assuremeansmain varchar2(2) -- 主担保方式
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
grant select on ${iol_schema}.icms_zxz_bill_info to ${iml_schema};
grant select on ${iol_schema}.icms_zxz_bill_info to ${icl_schema};
grant select on ${iol_schema}.icms_zxz_bill_info to ${idl_schema};
grant select on ${iol_schema}.icms_zxz_bill_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zxz_bill_info is '支小再借据信息表';
comment on column ${iol_schema}.icms_zxz_bill_info.packageno is '批次包编号';
comment on column ${iol_schema}.icms_zxz_bill_info.billno is '借据号';
comment on column ${iol_schema}.icms_zxz_bill_info.cla is '贷款质量(五级分类)';
comment on column ${iol_schema}.icms_zxz_bill_info.loanbalance is '贷款余额';
comment on column ${iol_schema}.icms_zxz_bill_info.inpoolflag is '总行入池标识';
comment on column ${iol_schema}.icms_zxz_bill_info.cusname is '客户名称';
comment on column ${iol_schema}.icms_zxz_bill_info.billenddate is '借据失效日期';
comment on column ${iol_schema}.icms_zxz_bill_info.businessesflag is '客户类型';
comment on column ${iol_schema}.icms_zxz_bill_info.lastyearbussum is '上年末营业收入';
comment on column ${iol_schema}.icms_zxz_bill_info.loanenddate is '贷款到期日';
comment on column ${iol_schema}.icms_zxz_bill_info.workersnum is '企业人数';
comment on column ${iol_schema}.icms_zxz_bill_info.cusmanager is '客户经理';
comment on column ${iol_schema}.icms_zxz_bill_info.certcode is '客户证件号码';
comment on column ${iol_schema}.icms_zxz_bill_info.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_zxz_bill_info.indivcomfld is '所属行业';
comment on column ${iol_schema}.icms_zxz_bill_info.mainbrid is '机构名称';
comment on column ${iol_schema}.icms_zxz_bill_info.accountstatus is '借据状态';
comment on column ${iol_schema}.icms_zxz_bill_info.loanstartdate is '贷款发放日';
comment on column ${iol_schema}.icms_zxz_bill_info.comptypedetail is '贷款划型细项';
comment on column ${iol_schema}.icms_zxz_bill_info.loanamount is '贷款金额';
comment on column ${iol_schema}.icms_zxz_bill_info.comptype is '贷款划型';
comment on column ${iol_schema}.icms_zxz_bill_info.compsize is '企业规模';
comment on column ${iol_schema}.icms_zxz_bill_info.realityiry is '贷款利率';
comment on column ${iol_schema}.icms_zxz_bill_info.zxzflag is '支小再状态';
comment on column ${iol_schema}.icms_zxz_bill_info.totalassets is '资产总额(万元)';
comment on column ${iol_schema}.icms_zxz_bill_info.packagename is '批次包的名称';
comment on column ${iol_schema}.icms_zxz_bill_info.assuremeansmain is '主担保方式';
comment on column ${iol_schema}.icms_zxz_bill_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zxz_bill_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zxz_bill_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zxz_bill_info.etl_timestamp is 'ETL处理时间戳';
