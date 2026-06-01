/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_ci_cusbasinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_ci_cusbasinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_ci_cusbasinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_cusbasinfo(
    custid varchar2(30) -- 客户编号
    ,custcname varchar2(100) -- 客户名称
    ,custtype varchar2(10) -- 客户类型代码
    ,orgcertcode varchar2(30) -- 组织机构代码
    ,interindustry varchar2(10) -- 所属行业代码
    ,interindustryname varchar2(50) -- 所属行业名称
    ,createyear varchar2(10) -- 成立日期
    ,custscale varchar2(10) -- 企业规模代码
    ,custscalenmae varchar2(30) -- 企业规模名称
    ,emplquantity number(22) -- 职工人数
    ,custmgr varchar2(100) -- 客户经理编号
    ,deptcode varchar2(30) -- 所属机构编号
    ,bloccustid varchar2(30) -- 集团客户编号
    ,blocname varchar2(200) -- 集团客户名称
    ,pcustid varchar2(30) -- 母公司客户编号
    ,modifydate varchar2(10) -- 最后更新日期
    ,balance number(16,2) -- 最新授信余额
    ,sales number(16,2) -- 销售收入 指标Z0155
    ,state varchar2(1) -- 客户状态代码
    ,lntoat number(16,2) -- 总资产
    ,amt number(16,2) -- 余额
    ,accbal number(16,2) -- 日期
    ,riskclass varchar2(10) -- 风险类型
    ,maxovdue number(22) -- 日期
    ,certtype varchar2(10) -- 证件类型
    ,certid varchar2(40) -- 证件号码
    ,countycode varchar2(80) -- 所属国家（地区）
    ,areas varchar2(100) -- 所在省份、直辖市、自治区
    ,finantype varchar2(20) -- 财务报表类型
    ,business1 varchar2(1000) -- 第一大主营业务
    ,business2 varchar2(1000) -- 第二大主营业务
    ,business3 varchar2(1000) -- 第三大主营业务
    ,busimgrsum number(16,2) -- 近三年平均营业收入
    ,comcorptype varchar2(2) -- 所有制类型
    ,inputuser varchar2(100) -- 登记人
    ,inputorg varchar2(100) -- 登记机构
    ,calscale varchar2(10) -- 计算规模
    ,isbloc varchar2(1) -- 单一标示
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,risktype varchar2(2) -- 风险类型
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
grant select on ${iol_schema}.nrrs_ci_cusbasinfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_ci_cusbasinfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_ci_cusbasinfo to ${idl_schema};
grant select on ${iol_schema}.nrrs_ci_cusbasinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_ci_cusbasinfo is '对公客户信息';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custid is '客户编号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custcname is '客户名称';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custtype is '客户类型代码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.orgcertcode is '组织机构代码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.interindustry is '所属行业代码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.interindustryname is '所属行业名称';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.createyear is '成立日期';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custscale is '企业规模代码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custscalenmae is '企业规模名称';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.emplquantity is '职工人数';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.custmgr is '客户经理编号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.deptcode is '所属机构编号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.bloccustid is '集团客户编号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.blocname is '集团客户名称';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.pcustid is '母公司客户编号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.modifydate is '最后更新日期';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.balance is '最新授信余额';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.sales is '销售收入 指标Z0155';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.state is '客户状态代码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.lntoat is '总资产';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.amt is '余额';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.accbal is '日期';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.riskclass is '风险类型';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.maxovdue is '日期';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.certtype is '证件类型';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.certid is '证件号码';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.countycode is '所属国家（地区）';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.areas is '所在省份、直辖市、自治区';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.finantype is '财务报表类型';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.business1 is '第一大主营业务';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.business2 is '第二大主营业务';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.business3 is '第三大主营业务';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.busimgrsum is '近三年平均营业收入';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.comcorptype is '所有制类型';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.inputuser is '登记人';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.inputorg is '登记机构';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.calscale is '计算规模';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.isbloc is '单一标示';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.risktype is '风险类型';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_ci_cusbasinfo.etl_timestamp is 'ETL处理时间戳';
