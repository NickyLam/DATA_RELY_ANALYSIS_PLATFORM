/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_cc_contractinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_cc_contractinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_cc_contractinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_contractinfo(
    contractno varchar2(75) -- 合同号
    ,custid varchar2(48) -- 客户号
    ,regioncode varchar2(6) -- 地区号
    ,orgid varchar2(30) -- 机构代码
    ,mforgid varchar2(30) -- 入账机构
    ,custmgr varchar2(30) -- 客户经理
    ,credittype varchar2(45) -- 授信品种
    ,loandirect varchar2(8) -- 贷款投向
    ,currency varchar2(9) -- 币种代码
    ,amt number(16,2) -- 合同金额
    ,balance number(16,2) -- 合同余额
    ,coveragerate number(8,4) -- 保证金比例
    ,assuremoney number(16,2) -- 保证金金额
    ,occurdate varchar2(15) -- 生效日期
    ,duedate varchar2(15) -- 到期日期
    ,guartype varchar2(6) -- 担保方式 质押 3      信用 0      抵押 2      保证 1
    ,mainguartype varchar2(48) -- 主担保方式
    ,createdate varchar2(15) -- 建立日期
    ,updatedate varchar2(15) -- 更新日期
    ,payamt number(16,2) -- 已发放金额
    ,fiveclass varchar2(9) -- 五级分类
    ,balanceout number(16,2) -- 表外余额
    ,balancein number(16,2) -- 表内余额
    ,balance13 number(16,2) -- 欠息金额
    ,squarestate varchar2(6) -- 结清状态 字典：issettle      1-已结清；2-未结清
    ,tenclass varchar2(15) -- 贷款评级
    ,reqno varchar2(48) -- 批复编号
    ,barsign varchar2(2) -- 条线 对公条线 1    中小企业条线 2    个人条线 3
    ,creditaggreement varchar2(48) -- 授信合同编号
    ,datasourceflag varchar2(2) -- 数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷
    ,applycode varchar2(90) -- 授信申请编号
    ,txtcontractno varchar2(150) -- 纸质合同编号
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
grant select on ${iol_schema}.mims_cc_contractinfo to ${iml_schema};
grant select on ${iol_schema}.mims_cc_contractinfo to ${icl_schema};
grant select on ${iol_schema}.mims_cc_contractinfo to ${idl_schema};
grant select on ${iol_schema}.mims_cc_contractinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_cc_contractinfo is '合同信息';
comment on column ${iol_schema}.mims_cc_contractinfo.contractno is '合同号';
comment on column ${iol_schema}.mims_cc_contractinfo.custid is '客户号';
comment on column ${iol_schema}.mims_cc_contractinfo.regioncode is '地区号';
comment on column ${iol_schema}.mims_cc_contractinfo.orgid is '机构代码';
comment on column ${iol_schema}.mims_cc_contractinfo.mforgid is '入账机构';
comment on column ${iol_schema}.mims_cc_contractinfo.custmgr is '客户经理';
comment on column ${iol_schema}.mims_cc_contractinfo.credittype is '授信品种';
comment on column ${iol_schema}.mims_cc_contractinfo.loandirect is '贷款投向';
comment on column ${iol_schema}.mims_cc_contractinfo.currency is '币种代码';
comment on column ${iol_schema}.mims_cc_contractinfo.amt is '合同金额';
comment on column ${iol_schema}.mims_cc_contractinfo.balance is '合同余额';
comment on column ${iol_schema}.mims_cc_contractinfo.coveragerate is '保证金比例';
comment on column ${iol_schema}.mims_cc_contractinfo.assuremoney is '保证金金额';
comment on column ${iol_schema}.mims_cc_contractinfo.occurdate is '生效日期';
comment on column ${iol_schema}.mims_cc_contractinfo.duedate is '到期日期';
comment on column ${iol_schema}.mims_cc_contractinfo.guartype is '担保方式 质押 3      信用 0      抵押 2      保证 1';
comment on column ${iol_schema}.mims_cc_contractinfo.mainguartype is '主担保方式';
comment on column ${iol_schema}.mims_cc_contractinfo.createdate is '建立日期';
comment on column ${iol_schema}.mims_cc_contractinfo.updatedate is '更新日期';
comment on column ${iol_schema}.mims_cc_contractinfo.payamt is '已发放金额';
comment on column ${iol_schema}.mims_cc_contractinfo.fiveclass is '五级分类';
comment on column ${iol_schema}.mims_cc_contractinfo.balanceout is '表外余额';
comment on column ${iol_schema}.mims_cc_contractinfo.balancein is '表内余额';
comment on column ${iol_schema}.mims_cc_contractinfo.balance13 is '欠息金额';
comment on column ${iol_schema}.mims_cc_contractinfo.squarestate is '结清状态 字典：issettle      1-已结清；2-未结清';
comment on column ${iol_schema}.mims_cc_contractinfo.tenclass is '贷款评级';
comment on column ${iol_schema}.mims_cc_contractinfo.reqno is '批复编号';
comment on column ${iol_schema}.mims_cc_contractinfo.barsign is '条线 对公条线 1    中小企业条线 2    个人条线 3';
comment on column ${iol_schema}.mims_cc_contractinfo.creditaggreement is '授信合同编号';
comment on column ${iol_schema}.mims_cc_contractinfo.datasourceflag is '数据来源标志 1-信贷；2-小企业；3-零售；4-新信贷';
comment on column ${iol_schema}.mims_cc_contractinfo.applycode is '授信申请编号';
comment on column ${iol_schema}.mims_cc_contractinfo.txtcontractno is '纸质合同编号';
comment on column ${iol_schema}.mims_cc_contractinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_cc_contractinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_cc_contractinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_cc_contractinfo.etl_timestamp is 'ETL处理时间戳';
